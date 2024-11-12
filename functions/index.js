/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */
const v2 = require("firebase-functions/v2");
const vertexAIApi = require("@google-cloud/vertexai");
const admin = require('firebase-admin');

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

if (!admin.apps.length) {
  admin.initializeApp();
}

const project = 'proj-atc';
const location = 'us-central1';
const textModel = 'gemini-1.5-flash';
const visionModel = 'gemini-1.0-pro-vision';

const vertexAI = new vertexAIApi.VertexAI({ project: project, location: location });
const generativeVisionModel = vertexAI.getGenerativeModel({
  model: visionModel,
});
const generativeModelPreview = vertexAI.preview.getGenerativeModel({
  model: textModel,
});

const getGenerationConfig = (targetLang) => ({
  temperature: 1,
  topP: 0.95,
  topK: 64,
  maxOutputTokens: 8192,
  responseMimeType: "application/json",
  responseSchema: {
    type: "object",
    properties: {
      [targetLang]: {
        type: "string",
        description: `The translated text in ${targetLang} language`
      }
    },
    required: [targetLang]
  },
});


// use onDocumentWritten here to prepare to "edit message" feature later
exports.onChatWritten = v2.firestore.onDocumentWritten("/public/{messageId}", async (event) => {
  const document = event.data.after.data();
  const message = document["message"];
  console.log(`message: ${message}`);

  // no message? do nothing
  if (message == undefined) {
    return;
  }
  const curTranslated = document["translated"];

  // check if message is translated
  if (curTranslated != undefined) {
    // message is translated before, 
    // check the original message
    const original = curTranslated["original"];

    console.log('Original: ', original);
    // message is same as original, meaning it's already translated. Do nothing
    if (message == original) {
      return;
    }
  }

  const result = await generativeModelPreview.generateContent({
    contents: [{ role: "user", parts: [{ text: `translate this text to English: ${message}` }] }],
    generationConfig: getGenerationConfig("en")
  });
  const response = result.response;
  console.log('Response:', JSON.stringify(response));

  const jsonTranslated = response.candidates[0].content.parts[0].text;
  console.log('translated json: ', jsonTranslated);
  // parse this json to get translated text out
  const translated = JSON.parse(jsonTranslated);
  console.log('final result: ', translated.en);

  // write to message
  const data = event.data.after.data();
  return event.data.after.ref.set({
    'translated': {
      'original': message,
      'en': translated.en
    }
  }, { merge: true });
})


exports.translateMessage = v2.https.onCall(async (request) => {
  try {
    const { messageId, message, targetLanguage } = request.data;

    // Input validation
    if (!messageId || !message || !targetLanguage) {
      throw new Error('Missing required parameters: messageId, message, or targetLanguage');
    }

    // Get current document data to check cache
    const docRef = admin.firestore().collection('public').doc(messageId);
    const docSnap = await docRef.get();
    const docData = docSnap.data();

    // Check if translation already exists
    if (docData?.translated?.[targetLanguage]) {
      // Check if the original message matches
      if (docData.translated.original === message) {
        console.log('Using cached translation');
        return {
          success: true,
          translatedText: docData.translated[targetLanguage],
          fromCache: true
        };
      }
    }

    // If no cache or original message changed, generate new translation
    const result = await generativeModelPreview.generateContent({
      contents: [{ role: "user", parts: [{ text: `translate this text to ${targetLanguage}: ${message}` }] }],
      generationConfig: getGenerationConfig(targetLanguage)
    });

    const response = result.response;
    const jsonTranslated = response.candidates[0].content.parts[0].text;

    // Parse the translated text
    const translated = JSON.parse(jsonTranslated);
    const translatedText = translated[targetLanguage];

    // Update Firestore with the new translation
    await docRef.set({
      'translated': {
        'original': message,
        [targetLanguage]: translatedText
      }
    }, { merge: true });

    return {
      success: true,
      translatedText: translatedText,
      fromCache: false
    };

  } catch (error) {
    console.error('Error details:', error);
    throw new Error(`Translation failed: ${error.message}`);
  }
});
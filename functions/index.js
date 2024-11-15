const v2 = require("firebase-functions/v2");
const vertexAIApi = require("@google-cloud/vertexai");
const admin = require("firebase-admin");

admin.initializeApp();

const project = 'proj-atc';
const location = 'us-central1';
const textModel = 'gemini-1.5-flash';
const visionModel = 'gemini-1.0-pro-vision';

const vertexAI = new vertexAIApi.VertexAI({ project: project, location: location });

const generativeModelPreview = vertexAI.preview.getGenerativeModel({
  model: textModel,
});

// trigger when the chat data on public collection change to translate the message
exports.onChatWritten_001 = v2.firestore.onDocumentWritten("/public/{messageId}", async (event) => {
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

  //get all languages list to translate the message
  const db = admin.firestore();
  const languagesCollection = db.collection("languages");
  const languages = await languagesCollection.get();
  const languageCodes = languages.docs.map((e) => e.data().code)

  var translated = {}

  if (languageCodes.length > 0) {
    const generationConfig = {
      temperature: 1,
      topP: 0.95,
      topK: 64,
      maxOutputTokens: 8192,
      responseMimeType: "application/json",
      responseSchema: {
        type: "object",
        properties: languageCodes.reduce((acc, lang) => {
          acc[lang] = { type: "string" };
          return acc;
        }, {}),
        required: languageCodes
      },
    };

    const chatSession = generativeModelPreview.startChat({
      generationConfig: generationConfig
    });

    const result = await chatSession.sendMessage(`translate this text [${languageCodes.join(", ")}]: ${message}`);
    const response = result.response;
    console.log('Response:', JSON.stringify(response));

    const jsonTranslated = response.candidates[0].content.parts[0].text;
    console.log('translated json: ', jsonTranslated);
    // parse this json to get translated text out
    translated = JSON.parse(jsonTranslated);
    console.log('final result: ', translated);

  }

  // write to message
  return event.data.after.ref.set({
    'translated': {
      'original': message,
      ...translated,
    }
  }, { merge: true });
})
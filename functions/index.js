/* eslint-disable indent */
/* eslint-disable max-len */
const v2 = require("firebase-functions/v2");
const vertexAIApi = require("@google-cloud/vertexai");
const admin = require("firebase-admin");

admin.initializeApp();

const project = "flutter-dev-search";
const location = "us-central1";
const textModel = "gemini-1.5-flash";
// const visionModel = "gemini-1.0-pro-vision";

const vertexAI = new vertexAIApi.VertexAI({project: project, location: location});

const generativeModelPreview = vertexAI.preview.getGenerativeModel({
  model: textModel,
});

// trigger when the chat data on public collection change to translate the message
exports.myOnChatWritten = v2.firestore.onDocumentWritten("/public/{messageId}", async (event) => {
  const document = event.data.after.data();
  const message = document["message"];

  console.log(`message: ${message}`);

  // no message? do nothing
  if (message == undefined) {
    return;
  }

  const curTranslations = document["translations"];

  // check if message is translated
  if (curTranslations != undefined && curTranslations.length > 0) {
    // message is translated before,
    // check the original message
    const original = document["original"];

    console.log("Original: ", original);
    // message is same as original, meaning it's already translated. Do nothing
    if (message == original) {
      return;
    }
  }

  // get all languages list to translate the message
  const db = admin.firestore();
  const languagesCollection = db.collection("languages");
  const languagesSnapshot = await languagesCollection.get();
  const languages = languagesSnapshot.docs.map((e) => e.data().language);
  // const languageCodes = ["en", "vi", "japen", "vietnamese", "việt nam", "vi_VN", "japennese", "english"];
  if (languages.length == 0) {
    return;
  }
  let translated = [];

  if (languages.length > 0) {
    const generationConfig = {
      temperature: 1,
      topP: 0.95,
      topK: 64,
      maxOutputTokens: 8192,
      responseMimeType: "application/json",
      responseSchema: {
        type: "array",
        items: {
          type: "object",
          properties: {
            language_names: {
              type: "array",
              items: {
                type: "string",
              },
              minItems: 1,
            },
            translation: {
              type: "string",
            },
            code: {
              type: "string",
            },
          },
          required: ["language_names", "translation", "code"],
        },
      },
    };

    const chatSession = generativeModelPreview.startChat({
      generationConfig: generationConfig,
    });

    const result = await chatSession.sendMessage(`
          Translate '${message}' to the following languages: [${languages.join(",")}].
Don't correct any spelling in that list of languages, keep them original.
      Ignore languages that match the language of the original text.
      If any specified language is not supported, set the 'translation' field to 'unsupported'.
      Group related languages/language codes/country codes/country names... into a list.
      In the response, set that list as the value of the "languages" field and set language code as value of "code" field.
      Response example for translating "Hi" to [en, vi, japen, việt nam]:
      [{"language_names": [vi, việt nam], "code": "vi", "translation":"Xin chào"},
  {"language_names": [japen], "code": "ja", "translation":"こんにちは"},]
        `);
    const response = result.response;
    console.log("Response:", JSON.stringify(response));

    const jsonTranslated = response.candidates[0].content.parts[0].text;
    console.log("translated json: ", jsonTranslated);
    // parse this json to get translated text out
    try {
      translated = Array.from(JSON.parse(jsonTranslated));
    } catch (e) {
      console.log("Error: ", e); // if error, maybe show the original json
    }

    console.log("final result: ", translated);
    console.log("translated LENGTH: ", translated.length);
  }

  // write to message
  return event.data.after.ref.set({
    "original": message,
    "translations": translated,
  }, {merge: true});
});
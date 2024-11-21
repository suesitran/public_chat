/* eslint-disable quotes */
/* eslint-disable spaced-comment */
/* eslint-disable linebreak-style */
/* eslint-disable max-len */
const v2 = require("firebase-functions/v2");
const vertexAIApi = require("@google-cloud/vertexai");
const admin = require("firebase-admin");

admin.initializeApp();

const project = "flutter-dev-search";
const location = "asia-northeast1";
const textModel = "gemini-1.5-flash";
// const visionModel = "gemini-1.0-pro-vision";

const vertexAI = new vertexAIApi.VertexAI({
  project: project,
  location: location,
});

const generativeModelPreview = vertexAI.preview.getGenerativeModel({
  model: textModel,
});

// trigger when the chat data on public collection change to translate the message
exports.onChatWritten = v2.firestore.onDocumentWritten("/public/{messageId}", {
  timeoutSeconds: 540,
  memory: "1GB",
}, async (event) => {
  try {
    console.log("Function triggered with data:", event.data);

    const document = event.data.after.data();
    if (!document) {
      console.log("No document data");
      return;
    }

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

      console.log("Original: ", original);
      // message is same as original, meaning it's already translated. Do nothing
      if (message == original) {
        return;
      }
    }

    //get all languages list to translate the message
    const db = admin.firestore();
    const languagesCollection = db.collection("languages");
    const languages = await languagesCollection.get();
    const languageCodes = languages.docs.map((e) => e.data().language);

    let translated = [];

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
            languages: {
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
          required: ["languages", "translation", "code"],
        },
      },
    };

    const chatSession = generativeModelPreview.startChat({
      generationConfig: generationConfig,
    });
    //"languages" named by English not native
    const result = await chatSession.sendMessage(`
      Translate '${message}' to the following languages: ${languageCodes.toString()}.
      Ignore languages that match the language of the original message (excluding them in the response).
      If any specified language is not supported, set the 'translation' field to null.
      Group related languages/language codes/country codes/country names in ${languageCodes.toString()} into a list.
      In the response, set that list as the value of the 'languages' field and unify them using the language code in the 'code' field.
      For example, 'vi', 'vietnam', 'vietnamese','vi_VN' are the same, so group them into a list: [vi, vietnam, vietnamese, vi_VN] and unify them using the code 'vi'.

      Response example:
      [
  {"languages": [vi, vietnam, vietnamese, vi_VN], "code": "vi", "translation":"Xin chào"},
  ]
      `);
    const response = result.response;
    console.log("Response:", JSON.stringify(response));

    const jsonTranslated = response.candidates[0].content.parts[0].text;
    console.log("translated json: ", jsonTranslated);
    // parse this json to get translated text out
    try {
      translated = Array.from(JSON.parse(jsonTranslated));
    } catch (e) {
      console.log("Error: ", e);
    }

    console.log("final result: ", translated);
    console.log("translated LENGTH: ", translated.length);

    // write to message
    return event.data.after.ref.set({
      translated: {
        original: message,
        ...translated,
      },
    }, {merge: true});
  } catch (error) {
    console.error("Error executing function:", error);
    throw error; // show error in logs
  }
});

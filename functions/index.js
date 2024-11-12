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
const fs = require('fs');
const path = require('path');

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started
admin.initializeApp();
const db = admin.firestore();

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

//get all supports language
async function getSupportedLanguages() {
    const languagesCol = db.collection('support_languages');
    const languageSnapshot = await languagesCol.get();
    const languageList = languageSnapshot.docs.map(doc => doc.data().code);
    return languageList;
}

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

    const supportedLanguages = await getSupportedLanguages();
    const properties = supportedLanguages.reduce((acc, lang) => {
        acc[lang] = { type: "string" };
        return acc;
    }, {});

    const chatSession = generativeModelPreview.startChat({
        generationConfig: {
            temperature: 1,
            topP: 0.95,
            topK: 64,
            maxOutputTokens: 8192,
            responseMimeType: "application/json",
            responseSchema: {
                type: "object",
                properties: properties,
                required: supportedLanguages,
            },
        }
    });
    let translations = {};
    try {
        const result = await chatSession.sendMessage(`translate this text to multiple languages: ${message}`);
        const response = result.response;
        console.log('Response:', JSON.stringify(response));

        const jsonTranslated = response.candidates[0].content.parts[0].text;
        console.log('Translated JSON:', jsonTranslated);

        translations = JSON.parse(jsonTranslated);

    } catch (e) {
        console.log(e);
    }
    // write to message
    const data = event.data.after.data();
    return event.data.after.ref.set({
        'translated': {
            'original': message,
            ...translations
        }
    }, { merge: true });
})

importLanguages();

async function importLanguages() {
    try {
        const dataPath = path.join(__dirname, 'language_data.json');
        const rawData = fs.readFileSync(dataPath);
        const languages = JSON.parse(rawData);
        const batch = db.batch();
        languages.forEach((language) => {
            const docRef = db.collection('support_languages').doc(language.code);
            batch.set(docRef, language);
        });

        await batch.commit();
    } catch (error) {
        console.error('Error importing languages:', error);
    }
}

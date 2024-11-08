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
const {supportedLanguages} = require('./languageConfig');

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

const project = 'phi-public-chat';
const location = 'us-central1';
const textModel = 'gemini-1.5-flash';
const visionModel = 'gemini-1.0-pro-vision';

const vertexAI = new vertexAIApi.VertexAI({project: project, location: location});

const generativeVisionModel = vertexAI.getGenerativeModel({
    model: visionModel,
});

const generativeModelPreview = vertexAI.preview.getGenerativeModel({
    model: textModel,
});

const generationConfig = {
    temperature: 1,
    topP: 0.95,
    topK: 64,
    maxOutputTokens: 8192,
    responseMimeType: "application/json",
    responseSchema: {
        type: "object",
        properties: {
            translations: {
                type: "object",
                properties: Object.fromEntries(
                    Object.keys(supportedLanguages).map(lang => [
                        lang,
                        {type: "string"}
                    ])
                ),
                required: Object.keys(supportedLanguages)
            }
        },
        required: ["translations"]
    },
};

exports.getSupportedLanguages = v2.https.onCall(async (data, context) => {
    try {
        return Object.entries(supportedLanguages).map(([_, details]) => ({
            ...details
        }));
    } catch (error) {
        console.error('Error getting supported languages:', error);
        throw new v2.https.HttpsError('internal', 'Failed to get supported languages');
    }
});

// use onDocumentWritten here to prepare to "edit message" feature later
exports.onChatWritten = v2.firestore.onDocumentWritten("/public/{messageId}", async (event) => {
    const document = event.data.after.data();
    const message = document["message"];
    console.log(`message: ${message}`);

    if (message === undefined) {
        return;
    }

    const curTranslated = document["translated"];

    if (curTranslated !== undefined) {
        const original = curTranslated["original"];
        console.log('Original: ', original);
        if (message === original) {
            return;
        }
    }

    const chatSession = generativeModelPreview.startChat({
        generationConfig: generationConfig
    });

    // Create prompt with supportedLanguages
    const languageList = Object.values(supportedLanguages)
        .map(lang => `${lang.name} (${lang.code})`)
        .join(", ");

    const prompt = `Translate this text to all following languages: ${languageList}
    Original text: "${message}"
    Please return the translations in JSON format with language codes as keys.`;

    const result = await chatSession.sendMessage(prompt);
    const response = result.response;
    console.log('Response:', JSON.stringify(response));

    const jsonTranslated = response.candidates[0].content.parts[0].text;
    console.log('translated json: ', jsonTranslated);

    const translated = JSON.parse(jsonTranslated);
    console.log('final result: ', translated.translations);

    return event.data.after.ref.set({
        'translated': {
            'original': message,
            ...translated.translations
        }
    }, {merge: true});
})
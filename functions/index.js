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

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

const project = 'proj-atc';
const location = 'us-central1';
const textModel =  'gemini-1.0-pro';
const visionModel = 'gemini-1.0-pro-vision';

const vertexAI = new vertexAIApi.VertexAI({project: project, location: location});

const generativeVisionModel = vertexAI.getGenerativeModel({
    model: visionModel,
});

const generativeModelPreview = vertexAI.preview.getGenerativeModel({
    model: textModel,
});

exports.onChatWritten = v2.firestore.onDocumentWritten("/public/{messageId}",async (event) => {
    const document = event.data.after.data();
    const message = document["message"];
    console.log('message: ', message);

    const request = {
        contents: [
            {
                "role": "user",
                parts: [
                    {
                        text: `translate this text to English: ${message}`
                    }
                ]
            }
        ]
    }
    const result = await generativeModelPreview.generateContent(request);
    const response = result.response;
    console.log('Response:', JSON.stringify(response));
})
/* eslint-disable indent */
/* eslint-disable max-len */
const v2 = require("firebase-functions/v2");
const vertexAIApi = require("@google-cloud/vertexai");
const admin = require("firebase-admin");

admin.initializeApp();

const project = "flutter-dev-search";
const location = "us-central1";
const textModel = "gemini-1.5-flash";

const vertexAI = new vertexAIApi.VertexAI({project: project, location: location});

const generativeModelPreview = vertexAI.preview.getGenerativeModel({
    model: textModel,
});

// Trigger when the chat data on public collection changes to translate the message
exports.myOnChatWritten = v2.firestore.onDocumentWritten("/public/{messageId}", async (event) => {
    const document = event.data.after.data();
    const message = document["message"];
    const messageId = event.params.messageId;
    console.log(`Processing message: ${messageId}, content: ${message}`);

    if (message == undefined) {
        return;
    }

    const curTranslations = document["translations_nostream"];

    // check if message is translated
    if (curTranslations != undefined) {
        // message is translated before,
        // check the original message
        const original = document["original"];

        console.log("Original: ", original);
        // message is same as original, meaning it's already translated. Do nothing
        if (message == original) {
        return;
        }
    }

    const db = admin.firestore();
    const languagesCollection = db.collection("languages");
    const languagesSnapshot = await languagesCollection.get();
    if (languagesSnapshot.empty) {
        return;
    }
    const languages = languagesSnapshot.docs.map((e) => e.data().language_list);
    const languagesString = languages.map((langArray) => `[${langArray.join(", ")}]`).join(", ");
    console.log(languagesString);
    const translationsCollection = db.collection("public").doc(messageId).collection("translations");

    // Clear existing chunks in sub-collection before starting
    const existingChunks = await translationsCollection.get();
    const batch = db.batch();
    existingChunks.forEach((doc) => batch.delete(doc.ref));
    await batch.commit();

    const generationConfig = {
        temperature: 1,
        topP: 0.95,
        topK: 64,
        maxOutputTokens: 8192,
        responseMimeType: "text/plain",
    };

    const chatSession = generativeModelPreview.startChat({
        generationConfig: generationConfig,
    });

    const result = await chatSession.sendMessageStream(`
    Translate '${message}' into the following lists of languages: ${languagesString}.
    Response in html format.
    For example, if translating 'Hi' with the list: [en, việt nam], [en, japen, vi] the response would be:
    [en, việt nam]<b>en</b> hi<br><b>việt nam</b> Xin chào.
    [en, japen, vi]<b>en</b> hi<br><b>japen</b> こんにちは<br><b>vi</b> Xin chào.
   `);

    // Process streaming response and write each chunk to Firestore
    let chunkIndex = 0;
    let textTotal = "";
    for await (const chunk of result.stream) {
        const text = chunk.candidates[0].content.parts[0].text;
        textTotal += text;
        chunkIndex++;
        const chunkData = {
            index: chunkIndex,
            text: text,
        };
        await translationsCollection.doc(`chunk_${chunkIndex}`).set(chunkData);
        console.log(`${chunkIndex}:`, text);
    }
    return event.data.after.ref.set({
        "original": message,
        "translations_nostream": textTotal,
    }, {merge: true},
    );
});

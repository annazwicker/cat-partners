/**
 * Import function triggers from their respective submodules:
 *
 * import {onCall} from "firebase-functions/v2/https";
 * import {onDocumentWritten} from "firebase-functions/v2/firestore";
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

import * as functions from "firebase-functions";
import * as admin from "firebase-admin";


exports.checkHealth = functions.https.onCall(async (data, context) => {
    return "The function is online";
});

exports.sendNotification = functions.https.onCall(async (data, context) => {
    const title = data.title;
    const body = data.body;
    const image = data.image;
    const token = data.token;
});
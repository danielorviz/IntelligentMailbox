/**
 * Import function triggers from their respective submodules:
 *
 * import {onCall} from "firebase-functions/v2/https";
 * import {onDocumentWritten} from "firebase-functions/v2/firestore";
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

//import {onRequest} from "firebase-functions/v2/https";
import * as logger from "firebase-functions/logger";

// Start writing functions
// https://firebase.google.com/docs/functions/typescript

//import * as functions from 'firebase-functions/v2';
const {onValueCreated} = require("firebase-functions/v2/database");

const admin = require("firebase-admin");
admin.initializeApp();


export const sendNotification = onValueCreated('/notifications/{idbuzon}/{idnotificacion}', async (event: any) => {
    const idbuzon = event.params.idbuzon;
    const notificacion = event.data.val(); // Obtener los datos de la notificación

    logger.log('Notificación recibida para buzón:', idbuzon);
    logger.log('Contenido de la notificación:', notificacion);
	
	const snapshot = await admin.database().ref('mailbox').child(idbuzon).child('name').once('value');
	const mailboxName = snapshot.val();
    const message = {
      notification: {
        title: `Nueva notificación en el buzón ${mailboxName}`,
        body: notificacion.mensaje,
      },
      topic: idbuzon,
    };

    try {
      const response = await admin.messaging().send(message);
      logger.log(`Notificación enviada al tema ${idbuzon}:`, response);
    } catch (error) {
      logger.error(`Error al enviar la notificación:`, error);
    }
  });
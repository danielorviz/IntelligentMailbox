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
const {onValueCreated, onValueWritten} = require("firebase-functions/v2/database");

const admin = require("firebase-admin");
admin.initializeApp();



export const sendNotification = onValueCreated('/notifications/{idbuzon}/{idnotificacion}', async (event: any) => {
    const idbuzon = event.params.idbuzon;
    const notificacion = event.data.val(); // Obtener los datos de la notificación

    logger.log('Notificación recibida para buzón:', idbuzon);
    logger.log('Contenido de la notificación:', notificacion);
	
	if(notificacion.type == 1 && !notificacion.isKey){
		const typeInfoUuid = notificacion.typeInfo.split(".;.")[0];
		admin.database().ref('mailbox').child(idbuzon).child('authorizedPackages').child(typeInfoUuid).child('received').set(true);
	}

	const nameSnapshot = await admin.database().ref('mailbox').child(idbuzon).child('name').once('value');
	const mailboxName = nameSnapshot.val();
	
	const languageSnapshot = await admin.database().ref('mailbox').child(idbuzon).child('language').once('value');
	const mailboxLanguage = languageSnapshot.val();
	
	const langTranslations = mailboxLanguage == "es" ? translationsEs : translationsEn;
	const newNotification = langTranslations["newNotification"];
	const bodyMessage = langTranslations[notificacion.mensaje] + ( (notificacion.type ==1 || notificacion.type == 0) ? notificacion.typeInfo.split(".;.")[1] : "");
    const message = {
      notification: {
        title: `${newNotification} ${mailboxName}`,
        body: bodyMessage,
      },
      topic: idbuzon,
    };

    try {
      const response = await admin.messaging().send(message);
      logger.log(`${newNotification} ${idbuzon}:`, response);
    } catch (error) {
      logger.error(`Error al enviar la notificación:`, error);
    }
  });
  
  export const updateOpenDoor = onValueWritten('/mailbox/{idbuzon}/instructions/open', async (event: any) => {
    const idbuzon = event.params.idbuzon;
    
	await new Promise((resolve) => setTimeout(resolve, 5000));
	
	await admin.database().ref('mailbox').child(idbuzon).child('instructions/open').set(false);
	
   
  });
  
const translationsEs: Record<string, string> = {
  newNotification: "Nueva notificación en el buzón ",
  packageNotRecognize: "Paquete no reconocido",
  packageRecived: "Paquete autorizado recibido",
  keyNFCAccess: "Acceso por llave NFC",
  newLetter: "Nueva carta recibida",
  mailboxFull: "Buzón lleno",
  mailboxOpened: "Apertura del buzón",
  mailboxOpenFailed: "Intento apertura buzón fallido",
  mailboxConnected: "Buzón conectado",
  doorOpened: "La puerta está abierta",
  packageNotRecognizeMessage: "Se ha intentado abrir la puerta",
  packageRecivedMessage: "Puerta abierta con el paquete",
  keyNFCAccessMessage: "Puerta abierta con llave NFC",
  newLetterMessage: "Ha recibido un nuevo correo",
  mailboxFullMessage: "Es posible que el buzón esté lleno o se haya atascado un correo",
  mailboxOpenedMessage: "Puerta abierta con la clave",
  mailboxOpenFailedMessage: "Se ha intentado abrir la puerta",
  mailboxConnectedMessage: "Buzón conectado a red wifi"
};

const translationsEn: Record<string, string> = {
  newNotification: "New notification in the mailbox",
  packageNotRecognize: "Package not recognized",
  packageRecived: "Authorized package received",
  keyNFCAccess: "NFC key access",
  newLetter: "New letter received",
  mailboxFull: "Mailbox full",
  mailboxOpened: "Mailbox opened",
  mailboxOpenFailed: "Mailbox opening attempt failed",
  mailboxConnected: "Mailbox connected",
  doorOpened: "The door is open",
  packageNotRecognizeMessage: "An attempt was made to open the door",
  packageRecivedMessage: "Door opened with the package",
  keyNFCAccessMessage: "Door opened with NFC key",
  newLetterMessage: "You have received new mail",
  mailboxFullMessage: "The mailbox might be full or mail has gotten stuck",
  mailboxOpenedMessage: "Door opened with the key",
  mailboxOpenFailedMessage: "An attempt was made to open the door",
  mailboxConnectedMessage: "Mailbox connected to Wi-Fi network"
};


#define NOTIFICACION_APERTURA_CORRECTA "mailboxOpened"
#define NOTIFICACION_APERTURA_INCORRECTA "mailboxOpenFailed"
#define NOTIFICACION_CONEXION_CORRECTA "mailboxConnected"
#define NOTIFICACION_PUERTA_ABIERTA "doorOpened"

#define NOTIFICACION_INTENTO_ENTREGA_PAQUETE "packageNotRecognize"
#define NOTIFICACION_PAQUETE_RECIBIDO "packageRecived"
#define NOTIFICACION_ACCESO_LLAVE_NFC "keyNFCAccess"
#define NOTIFICACION_CARTA_RECIBIDA "newLetter"
#define NOTIFICACION_BUZON_LLENO "mailboxFull"

#define TYPE_KEY 0
#define TYPE_PACKAGE 1
#define TYPE_LETTER  2
#define TYPE_MAILBOX 3
#define TYPE_KEY_FAILED 4
#define TYPE_PACKAGE_FAILED 5
#define TYPE_SEPARATOR ".;."

String ARDUINO_ID ="test-1";
const char* WIFI_MANAGER_PASSW ="123456789";

String MAILBOX_PATH="/mailbox/"+ARDUINO_ID;
String NOTIFICATION_PATH = "notifications/";

String TASK_OFFSET="offsetTask";
String TASK_AUTH_KEYS="authKeysTask";

String TASK_INS_OPEN="insOpenTask";


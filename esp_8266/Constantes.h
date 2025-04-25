
#define NOTIFICACION_APERTURA_CORRECTA "Apertura del buzon"
#define NOTIFICACION_APERTURA_INCORRECTA "Intento apertura buzon fallido"
#define NOTIFICACION_CONEXION_CORRECTA "Buzón conectado a red WiFi"
#define NOTIFICACION_PUERTA_ABIERTA "La puerta está abierta"

#define NOTIFICACION_INTENTO_ENTREGA_PAQUETE "Paquete no reconocido"
#define NOTIFICACION_PAQUETE_RECIBIDO "Paquete autorizado recibido"
#define NOTIFICACION_ACCESO_LLAVE_NFC "Acceso por llave NFC"
#define NOTIFICACION_CARTA_RECIBIDA "Nueva carta recibida"
#define NOTIFICACION_BUZON_LLENO "Buzón lleno"

#define TYPE_KEY 0
#define TYPE_PACKAGE 1
#define TYPE_LETTER  2
#define TYPE_MAILBOX 3
#define TYPE_SEPARATOR ".;."

String ARDUINO_ID ="ardboxmail-7854";
String MAILBOX_PATH="/mailbox/"+ARDUINO_ID;
String NOTIFICATION_PATH = "notifications/";

String TASK_OFFSET="offsetTask";
String TASK_AUTH_KEYS="authKeysTask";

String TASK_INS_OPEN="insOpenTask";
const char* WIFI_MANAGER_SSID ="ardboxmail-7854_1";
const char* WIFI_MANAGER_PASSW ="123456789";

// CONSTANTES DE MENSAJES
#define NOTIFICACION_APERTURA_CORRECTA "Apertura del buzon"
#define NOTIFICACION_APERTURA_INCORRECTA "Intento apertura buzon fallido"
#define NOTIFICACION_CONEXION_CORRECTA "Módulo 1 conectado"
#define NOTIFICACION_PUERTA_ABIERTA "La puerta está abierta"


String ARDUINO_ID ="ardboxmail-7854";
String MAILBOX_PATH="/mailbox/"+ARDUINO_ID;
String NOTIFICATION_PATH = "notifications/";

const char* WIFI_MANAGER_SSID ="ardboxmail-7854_1";
const char* WIFI_MANAGER_PASSW ="123456789";

// VARIABLES RELACIONADAS CON EL TECLADO
const byte nfilas = 4;
const byte ncolumnas = 4;
char teclas[nfilas][ncolumnas] = {
 {'1','4','7','*'},
 {'2','5','8','0'},
 {'3','6','9','#'},
 {'A','B','C','D'}
};
byte pcolumnas[nfilas] = {22,23,24,25};  // Filas
byte pfilas[ncolumnas] = {26,27,28,29}; //Columnas
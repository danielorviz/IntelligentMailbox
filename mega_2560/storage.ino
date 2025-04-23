#include <EEPROM.h>;
#define USER_SIZE 100   
#define PASSWORD_SIZE 100 

void writeFirebaseUser(String user) {
  clearFirebaseUser();
  for (int i = 0; i < USER_SIZE; i++) {
    if (i < user.length()) {
      EEPROM.write(i, user[i]);
    } else {
      EEPROM.write(i, '\0');
    }
  }
}
void writeFirebasePassword(String password) {
  clearFirebasePassword();
  for (int i = 0; i < PASSWORD_SIZE; i++) {
    if (i < password.length()) {
      EEPROM.write(USER_SIZE + i, password[i]);
    } else {
      EEPROM.write(USER_SIZE + i, '\0');
    }
  }
}

String readFirebaseUser() {
  String readUser = "";
  for (int i = 0; i < USER_SIZE; i++) {
    char c = char(EEPROM.read(i));
    if (c != '\0') { 
      readUser += c;
    }
  }
  Serial.println("Usuario: " + readUser);
  if(readUser == ""){
    return "break;";
  }
  return readUser;
}

char* readFirebasePass() {
  static char readPassword[PASSWORD_SIZE + 1]; // +1 para el carácter nulo
  int index = 0;

  // Leer los caracteres desde EEPROM
  for (int i = 0; i < PASSWORD_SIZE; i++) {
    char c = char(EEPROM.read(USER_SIZE + i));
    if (c != '\0') {
      readPassword[index++] = c; // Añade el carácter si no es nulo
    }
  }

  readPassword[index] = '\0'; // Termina la cadena con un carácter nulo

  Serial.print("Contraseña: ");
  Serial.println(readPassword);

  // Devuelve una cadena "break;" si la contraseña está vacía
  if (index == 0) {
    strcpy(readPassword, "break;");
  }

  return readPassword;
}


void clearFirebaseUser(){
  for (int i = 0; i < USER_SIZE; i++) {
    if(i == 0){
      EEPROM.write(i, '\0');
    }
    EEPROM.write(i, 0);
  }
}

void clearFirebasePassword(){
  for (int i = 0; i < PASSWORD_SIZE; i++) {
    if(i == 0){
      EEPROM.write(USER_SIZE + i, '\0');
    }
    EEPROM.write(USER_SIZE + i, 0);
  }
}
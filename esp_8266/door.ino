#include "AuthorizedKey.h"
#include <vector>

// Variables de teclado
std::vector<AuthorizedKey> authorizedKeys;

void initAuthorizedKeys(JsonObject data) {
  clearAuthorizedKeys();
  for (JsonPair kv : data) {
    String id = String(kv.key().c_str());
    JsonObject keyData = kv.value().as<JsonObject>();

    AuthorizedKey k = AuthorizedKey(id, keyData);
    Serial.println(id);
    Serial.println(k.getValue());
    authorizedKeys.push_back(k);
  }
}

void clearAuthorizedKeys() {
  authorizedKeys.clear();
}
bool existsById(String id) {
  for (auto& key : authorizedKeys) {
    if (key.getId() == id) {
      return true;
    }
  }
  return false;
}
int checkKeyboardAccess(String clave) {
  for (int i = 0; i < authorizedKeys.size(); i++) {
    AuthorizedKey& key = authorizedKeys[i];

    if (key.isPermanent() && key.getValue().equals(clave)) {
      //Serial.println("key valida:" + key.getValue());
      return i;
    } else if (!key.isPermanent() && key.getValue() == clave && key.checkDateInRange(timeClient.getEpochTime())) {
      //Serial.println("key invalida:" + key.getValue());
      return i;
    }
  }
  return -1;
}
void handleKeyEvent(String id, JsonObject data) {
  bool exists = existsById(id);
  Serial.println(exists);
  if (exists && data.isNull()) {
    Serial.println(F("eliminando"));
    removeKeyById(id);
  }else if(exists && !data.isNull()){
    Serial.println(F("actualizando"));
    updateKey(id,data);
  }else if (!exists && !data.isNull()){
    Serial.println(F("creando"));
    createKey(id, data);
  }
}
void updateKey(String id, JsonObject data) {
  for (int i = 0; i < authorizedKeys.size(); i++) {
    AuthorizedKey& key = authorizedKeys[i];
    if (key.getId() == id) {
      if (data.containsKey("value")) {
        key.setValue(data["value"].as<String>());
      }
      if (data.containsKey("finishDate")) {
        key.setFinishDate(data["finishDate"].as<unsigned long>());
      }
      if (data.containsKey("initDate")) {
        key.setInitDate(data["initDate"].as<unsigned long>());
      }
      if (data.containsKey("permanent")) {
        key.setPermanent(data["permanent"].as<bool>());
      }
      if (data.containsKey("name")) {
        key.setName(data["name"].as<String>());
      }
      return;
    }
  }
}
void createKey(String& id, JsonObject& data) {
    AuthorizedKey k = AuthorizedKey(id, data);
    //Serial.println(k.getValue());
    authorizedKeys.push_back(k);
}
void removeKeyById(String id) {
  for (auto it = authorizedKeys.begin(); it != authorizedKeys.end(); ) {
    if (it->getId() == id) {
      it = authorizedKeys.erase(it);
      //Serial.println("Clave eliminada: " + id);
      return;
    } else {
      ++it;
    }
  }
}
String getAuthKeyName(int validKeyIndex){
  if(validKeyIndex>= 0 && validKeyIndex < authorizedKeys.size()){
    return authorizedKeys[validKeyIndex].getName();
  }
  return "";
}

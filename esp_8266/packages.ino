#include "AuthorizedPackage.h"
#include <vector>

std::vector<AuthorizedPackage> authorizedPackages;


void clearAuthorizedPackages() {
  authorizedPackages.clear();
}

void initAuthorizedPackages(JsonObject data) {
  clearAuthorizedPackages();

  for (JsonPair kv : data) {
    JsonObject keyData = kv.value().as<JsonObject>();
    String id = String(kv.key().c_str());
    AuthorizedPackage k = AuthorizedPackage(id, keyData);
    authorizedPackages.push_back(k);
    //Serial.println(k.getValue());
  }
}
void handlePackageEvent(String id, JsonObject data) {
  bool exists = existsPackageById(id);
  Serial.println(exists);
  if (exists && data.isNull()) {
    Serial.println(F("eliminando paquete"));
    removePackageById(id);
  } else if (exists && !data.isNull()) {
    Serial.println(F("actualizando paquete"));
    updatePackage(id, data);
  } else if (!exists && !data.isNull()) {
    Serial.println(F("creando paquete"));
    createPackage(id, data);
  }
}

bool existsPackageById(String id) {
  for (auto& package : authorizedPackages) {
    if (package.getId() == id) {
      return true;
    }
  }
  return false;
}

int checkPackageAccess(String code) {
  for (int i = 0; i < authorizedPackages.size(); i++) {
    AuthorizedPackage& key = authorizedPackages[i];

    if (!key.isReceived() && key.getValue().equals(code)) {
      //Serial.println("Package valida:" + key.getValue());
      return i;
    } 
  }
  return -1;
}

void updatePackage(String id, JsonObject data) {
  for (int i = 0; i < authorizedPackages.size(); i++) {
    AuthorizedPackage& package = authorizedPackages[i];
    if (package.getId() == id) {
      if (data.containsKey("value")) {
        package.setValue(data["value"].as<String>());
      }
      if (data.containsKey("finishDate")) {
        package.setFinishDate(data["finishDate"].as<unsigned long>());
      }
      if (data.containsKey("initDate")) {
        package.setInitDate(data["initDate"].as<unsigned long>());
      }
      if (data.containsKey("permanent")) {
        package.setIsKey(data["permanent"].as<bool>());
      }
      if (data.containsKey("name")) {
        package.setName(data["name"].as<String>());
      }
      return;
    }
  }
}
void createPackage(String& id, JsonObject& data) {
  AuthorizedPackage k = AuthorizedPackage(id, data);
  //Serial.println(k.getValue());
  authorizedPackages.push_back(k);
}
void removePackageById(String id) {
  for (auto it = authorizedPackages.begin(); it != authorizedPackages.end();) {
    if (it->getId() == id) {
      it = authorizedPackages.erase(it);
      //Serial.println("Paquete eliminado: " + id);
      return;
    } else {
      ++it;
    }
  }
}

String getPackageKeyId(int validPackageIndex){
  if(validPackageIndex>= 0 && validPackageIndex < authorizedPackages.size()){
    String result = authorizedPackages[validPackageIndex].getId();
    result.concat(TYPE_SEPARATOR);
    result.concat(authorizedPackages[validPackageIndex].getName());
    return result;
  }
  return "";
}
bool getPackageIsKey(int validPackageIndex){
  if(validPackageIndex>= 0 && validPackageIndex < authorizedPackages.size()){
    return authorizedPackages[validPackageIndex].isKey();
  }
  return false;
}
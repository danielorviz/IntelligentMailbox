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

    AuthorizedPackage k = AuthorizedPackage(keyData);
    authorizedPackages.push_back(k);
    Serial.println(k.getValue());
  }
}
void updatePackage(String id, JsonObject data) {
  for (int i = 0; i < authorizedPackages.size(); i++) { 
    AuthorizedPackage& key = authorizedPackages[i];
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
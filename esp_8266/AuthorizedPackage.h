#ifndef AUTHORIZEDPACKAGE_H
#define AUTHORIZEDPACKAGE_H
#include <ArduinoJson.h>

class AuthorizedPackage {

private:
  String id_;
  String name_;
  String value_;
  bool isKey_;
  bool isReceived_;

public:

  AuthorizedPackage();

  AuthorizedPackage(String& idSt, JsonObject& json);

  String getId();

  String getName();

  String getValue();

  bool isKey();

  bool isReceived();

  // Setters
  void setId(const String& id);
  void setName(const String& name);
  void setValue(const String& value);
  void setIsKey(bool isKey);
  void setIsReceived(bool isReceived);
};

AuthorizedPackage::AuthorizedPackage() {}
AuthorizedPackage::AuthorizedPackage(String& idSt, JsonObject& json) {
  id_ = idSt;
  name_ = json["name"].as<String>();
  value_ = json["value"].as<String>();
  isKey_ = json["isKey"].as<bool>();
  isReceived_ = json["received"].as<bool>();
}

String AuthorizedPackage::getId() {
  return (id_);
}

String AuthorizedPackage::getName() {
  return (name_);
}

String AuthorizedPackage::getValue() {
  return (value_);
}

bool AuthorizedPackage::isKey() {
  return (isKey_);
}

bool AuthorizedPackage::isReceived() {
  return (isReceived_);
}

void AuthorizedPackage::setName(const String& name) {
  name_ = name;
}

void AuthorizedPackage::setValue(const String& value) {
  value_ = value;
}

void AuthorizedPackage::setIsKey(bool isKey) {
  isKey_ = isKey;
}

void AuthorizedPackage::setIsReceived(bool isReceived) {
  isReceived_ = isReceived;
}
#endif
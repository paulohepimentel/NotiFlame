#ifndef __ESP32_MQTT_H__
#define __ESP32_MQTT_H__
#include <MQTT.h>
#include <CloudIoTCore.h>

#include "ESP32-IOT.h"
#include "ESP32-BLE.h"

//! Initialize the Genuino WiFi SSL client library / RTC
MQTTClient *mqttClient;

//! Clout IoT configuration
CloudIoTCoreDevice *device;
unsigned long iss = 0;
String jwt;

//! Function that generates a new token
String getJwt() {
  iss = time(nullptr);
  Serial.println("Refreshing JWT");
  jwt = device->createJWT(iss, jwt_exp_secs);
  return jwt;
}

//! MQTT functions
void messageReceived(String &topic, String &payload) {
  Serial.println("incoming: " + topic + " - " + payload);
}

void messageReceivedUpdateLed(String &topic, String &payload) {
  Serial.println("incoming: " + topic + " - " + payload);
  int ledonpos=payload.indexOf("ledon");
  if (ledonpos != -1) {
    // If yes, switch ON the ESP32 internal led
    Serial.println("LED Ativado");
    digitalWrite(LED_BUILTIN, HIGH);
  } else {
    // If no, switch off the ESP32 internal led
    Serial.println("LED Desativado");
    digitalWrite(LED_BUILTIN, LOW);
  }
}

void publishTelemetry(String data) {
  mqttClient->publish(device->getEventsTopic(), data);
}
//! Helper that just sends default sensor
void publishState(String data) {
  mqttClient->publish(device->getStateTopic(), data);
}

void mqttConnect() {
  Serial.print("Conectando via MQTT...");
  while (!mqttClient->connect(device->getClientId().c_str(), "unused", getJwt().c_str(), false)) {
    Serial.println(mqttClient->lastError());
    Serial.println(mqttClient->returnCode());
    delay(1000);
  }
  Serial.println("Conectado via MQTT!");
  mqttClient->subscribe(device->getConfigTopic());
  mqttClient->subscribe(device->getCommandsTopic());
  publishState("Conectado");
}

void startMQTT() {
  mqttClient->begin("mqtt.googleapis.com", 8883, *netClient);
  mqttClient->onMessage(messageReceivedUpdateLed);
}

// Orchestrates various methods from preceeding code.
void connect() {
  Serial.println("Verificando conexão Wi-Fi");
  while (WiFi.status() != WL_CONNECTED) {
    Serial.print(".");
    delay(1000);
  }
  mqttConnect();
}

//! Start Cloud
void setupCloudIoT() {
  device = new CloudIoTCoreDevice(project_id, location, registry_id, device_id, private_key_str);
  setupWifi();
  netClient = new WiFiClientSecure();
  mqttClient = new MQTTClient(512);
  if(WiFi.status() == WL_CONNECTED){
    startMQTT();
  }
}
#endif //__ESP32_MQTT_H__

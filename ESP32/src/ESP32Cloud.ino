#include "ESP32-MQTT.h"

//! Pinagem dos sensores
#define fogo 19
#define gas 27 //4
#define alarme 23

#define gasSensibilidade 1000
static bool detectouFogo;
static bool detectouGas;
static bool detectouAlgo;

#define EEPROM_SIZE 50

int iChamas, iGas, iAlarme;
bool ConnectedBLE = false;
unsigned long lastMillis = 0;

void setup() {
  pinMode(fogo,INPUT);
  pinMode(gas,INPUT);
  pinMode(alarme,OUTPUT);

  Serial.begin(115200);
  iChamas = 0;
  iGas = 0;
  iAlarme = 0;

  pinMode(LED_BUILTIN, OUTPUT);
  
  // initialize EEPROM with predefined size
  EEPROM.begin(EEPROM_SIZE);

  setupCloudIoT();
  ConnectedBLE = false;
}

void loop() {
  
  if(appFogo == true){
    int FogoSensor = digitalRead(fogo);
    if (FogoSensor == 0){
      detectouFogo = true;
      iChamas = iChamas + 1;
      Serial.println("O sensor de chamas detectou alguma coisa!");
    }
  }
  
  if(appGas == true){
    int GasSensor = analogRead(gas);
    Serial.print("Sensor de Gás: ");
    Serial.println(GasSensor);
    if (GasSensor > gasSensibilidade){
      detectouGas = true;
      iGas = iGas + 1;
      Serial.println("O sensor de gás detectou alguma coisa!");
    }
  }
  
  if(appAlarme == true){
    if((detectouFogo == true) || (detectouGas == true)){
      detectouAlgo = true;
      iAlarme = iChamas + iGas;
      Serial.println("Alarme!");
      digitalWrite(alarme, HIGH);
      delay(500);
    }
  }
  //-------------------------------------------------------------------

  mqttClient->loop();
  delay(50);  // <- fixes some issues with WiFi stability
  if (!mqttClient->connected()) {
    Serial.println("Iniciando o serviço de Cloud");
    connect();
  } else if (!ConnectedBLE){  
    Serial.println("Iniciando o serviço Bluetooth");
    setupBlue();
    ConnectedBLE = true;
  }

  // publish a message roughly every second.
  delay(1000);
  if (millis() - lastMillis > 5000) {
    lastMillis = millis();

    if(detectouFogo == true || detectouGas == true){
      String payload =
        String("{\"chamas\":") + (iChamas) +
        String(",\"gas\":") + (iGas) +
        String(",\"modulo\":") + (iAlarme) +
        String("}");
      Serial.println(payload);
      publishTelemetry(payload);

      detectouFogo = false;
      detectouGas = false;
      detectouAlgo = false;
    }
  }
  // Alarme é disparado!
  digitalWrite(alarme, LOW);
  delay(500);
}
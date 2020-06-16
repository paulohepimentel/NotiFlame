#include <BLEDevice.h>
#include <BLEServer.h>
#include <BLEUtils.h>
#include <BLE2902.h>

#include <WiFi.h>
#include <WiFiClientSecure.h>

#include <EEPROM.h>

#define SERVICE_UUID "37f64eb3-c25f-449b-ba34-a5f5387fdb6d"
#define CHARACTERISTIC_UUID_R "560d029d-57a1-4ccc-8868-9e4b4ef41da6"
#define CHARACTERISTIC_UUID_S "db433ed3-1e84-49d9-b287-487440e7137c"

const int LED_BUILTIN = 2;

//? ------------------------------ CONFIGURAÇÃO WIFI ------------------------------ //
//! Wifi newtork details
WiFiClientSecure *netClient;

static String ssid = "";
static String password = "";

void setupBlue();

void writeString(char add,String data){
  
  int _size = data.length();
  int i;
  for(i=0;i<_size;i++){
    EEPROM.write(add+i,data[i]);
  }
  EEPROM.write(add+_size,'\0');   //Add termination null character for String Data
  EEPROM.commit();
}
 
String read_String(char add){
  int i;
  char data[100]; //Max 100 Bytes
  int len=0;
  unsigned char k;
  k=EEPROM.read(add);
  while(k != '\0' && len<500)   //Read until null character
  {    
    k=EEPROM.read(add+len);
    data[len]=k;
    len++;
  }
  data[len]='\0';
  return String(data);
}


//! Wi-Fi - Split Name and Password
String getValue(String data, char separator, int index){
  int found = 0;
  int strIndex[] = {0, -1};
  int maxIndex = data.length()-1;

  for(int i=0; (i<=maxIndex && found<=index); i++){
    if(data.charAt(i)==separator || i==maxIndex){
      found++;
      strIndex[0] = strIndex[1]+1;
      strIndex[1] = (i==maxIndex) ? i+1 : i;
    }
  }
  return found>index ? data.substring(strIndex[0], strIndex[1]) : "";
}

//! Wi-Fi Start
void setupWifi() {
  Serial.println("A ESP32 está se conectando ao Wi-Fi");
  WiFi.mode(WIFI_STA);

  ssid = read_String(0);
  password = read_String(15);

  if(ssid != ""){
    Serial.print("Nome da rede: ");
    Serial.println(ssid);
    Serial.print("Senha do Wi-Fi: ");
    Serial.println(password);
  
    WiFi.begin(ssid.c_str(), password.c_str());
    int i = 0;
    while (WiFi.status() != WL_CONNECTED) {
      delay(1000);
      i++;
      if(i == 10){
        Serial.println("Nenhuma credencial na memória!");
        Serial.println("Iniciando BLE no lugar do WIFI");
        setupBlue();
      }
    }

    configTime(0, 0, "pool.ntp.org", "time.nist.gov");
    while (time(nullptr) < 1510644967) {
      delay(10);
    }
  }
  else{
    Serial.print("Nenhuma credencial na memória!");
  }
}



//? ---------------------------- CONFIGURAÇÃO BLUETOOTH --------------------------- //
BLECharacteristic *charSend;
BLEServer *server;
BLEService *service;
bool deviceConnectedBLE = false;

// Estado do sensor (Ligado ou Desligado)
static bool appFogo = false;
static bool appGas = false;
static bool appAlarme = false;

//! Método que recebe eventos do App
class RCallbacks: public BLECharacteristicCallbacks {
  void onWrite(BLECharacteristic *charReceive) {
    std::string value = charReceive->getValue();
    if(value.length() > 0){
      for (int i = 0; i < value.length(); i++){
        //! Estado Sensor de Chama
        if (value[0] == 11){
          digitalWrite(LED_BUILTIN, HIGH);
          appFogo = true; //Sensor ligado
          Serial.print("Status App Fogo: ");
          Serial.println(appFogo);
        }
        else if (value[0] == 10){
          digitalWrite(LED_BUILTIN, LOW);
          appFogo = false; //Sensor desligado
          Serial.print("Status App Fogo: ");
          Serial.println(appFogo);
        }

        //! Estado Sensor de Gas
        else if (value[0] == 21){
          digitalWrite(LED_BUILTIN, HIGH);
          appGas = true;
          Serial.print("Status App Gas: ");
          Serial.println(appGas);
        }
        else if (value[0] == 20){
          digitalWrite(LED_BUILTIN, LOW);
          appGas = false;
          Serial.print("Status App Gas: ");
          Serial.println(appGas);
        }      
        
        //! Estado Alarme
        else if (value[0] == 31){
          digitalWrite(LED_BUILTIN, HIGH);
          appAlarme = true;
          Serial.print("Status App Alarme: ");
          Serial.println(appAlarme);
        }
        else if (value[0] == 30){
          digitalWrite(LED_BUILTIN, LOW);
          appAlarme = false;
          Serial.print("Status App Alarme: ");
          Serial.println(appAlarme);
        }
          
        //! Wi-Fi Setting
        else if(value.length() > 0){
          Serial.println("Credenciais Wi-Fi atualizadas!");
          String nome = getValue(value.c_str(), ',', 0);
          String senha = getValue(value.c_str(), ',', 1);
          ssid = nome.c_str();
          password = senha.c_str();
  
          writeString(0, ssid); 
          writeString(15, password);
        }
      }
      Serial.println("Nome da rede na memoria flash");
      Serial.println("Senha da rede na memoria flash");
          
      Serial.print("Nome da rede Wi-Fi: ");
      Serial.println(read_String(0));
      Serial.print("Senha do Wi-Fi: ");
      Serial.println(read_String(15));
    }
  }
};

//! Método callback para receber os eventos da conexão de dispositivos
class ServerCallbacks: public BLEServerCallbacks {
  void onConnect(BLEServer* pServer) {
    deviceConnectedBLE = true;
  };
  void onDisconnect(BLEServer* pServer) {
    deviceConnectedBLE = false;
  }
};

//! Start Bluetooth
void setupBlue(){

  Serial.println("Iniciando o BLE");
  // BLE Device Creation
  BLEDevice::init("Módulo NotiFlame");
  
  // BLE Server Creation
  server = BLEDevice::createServer();
  server->setCallbacks(new ServerCallbacks());
  
  // BLE Service Creation
  service = server->createService(SERVICE_UUID);  
  
  // Creation of BLE Characteristic -> SEND
  charSend = service->createCharacteristic(CHARACTERISTIC_UUID_S, BLECharacteristic::PROPERTY_NOTIFY);
  charSend->addDescriptor(new BLE2902());
  
  // Creation of BLE Characteristic -> RECEIVE
  BLECharacteristic *charReceive= service->createCharacteristic(CHARACTERISTIC_UUID_R, BLECharacteristic::PROPERTY_WRITE);
  charReceive->setCallbacks(new RCallbacks());
  service->start();
  server->getAdvertising()->start();
}

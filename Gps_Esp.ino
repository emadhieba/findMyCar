


#include <Arduino.h>
#if defined(ESP32)
#include <WiFi.h>
#include <FirebaseESP32.h>
#elif defined(ESP8266)
#include <ESP8266WiFi.h>
#include <FirebaseESP8266.h>
#elif defined(ARDUINO_RASPBERRY_PI_PICO_W)
#include <WiFi.h>
#include <FirebaseESP8266.h>
#endif
#include <TinyGPS++.h>

#include <addons/TokenHelper.h>


#include <addons/RTDBHelper.h>


#define RXD2 16
#define TXD2 17
HardwareSerial neogps(1);

TinyGPSPlus gps;

float Lat=0.0;
float Lon=0.0;

int day=0;int month=0;int year=0;


#define WIFI_SSID "Omar"
#define WIFI_PASSWORD "10203040"



#define API_KEY "AIzaSyDGZZWTkgVv_86R-CeWiBFOuJ23B8C3KZA"


#define DATABASE_URL "findmycar-375219-default-rtdb.asia-southeast1.firebasedatabase.app" 
#define USER_EMAIL "emadheba975@gmail.com"
#define USER_PASSWORD "432178965"

FirebaseData fbdo;

FirebaseAuth auth;
FirebaseConfig config;

unsigned long sendDataPrevMillis = 0;

unsigned long count = 0;

void setup()
{

  Serial.begin(115200);
 
  neogps.begin(9600, SERIAL_8N1, RXD2, TXD2);
  
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Connecting to Wi-Fi");
  while (WiFi.status() != WL_CONNECTED)
  {
    Serial.print(".");
    delay(300);
  }
  Serial.println();
  Serial.print("Connected with IP: ");
  Serial.println(WiFi.localIP());
  Serial.println();

  Serial.printf("Firebase Client v%s\n\n", FIREBASE_CLIENT_VERSION);

  config.api_key = API_KEY;

  auth.user.email = USER_EMAIL;
  auth.user.password = USER_PASSWORD;

  config.database_url = DATABASE_URL;

  config.token_status_callback = tokenStatusCallback; 



  Firebase.begin(&config, &auth);

 
  Firebase.reconnectWiFi(true);

  Firebase.setDoubleDigits(5);

 
}

void loop()
{
    boolean newData = false;
  for (unsigned long start = millis(); millis() - start < 1000;)
  {
    while (neogps.available())
    {
      if (gps.encode(neogps.read()))
      {
        newData = true;
      }
    }
  }

  if(newData == true)
  {
    if (gps.location.isValid() == 1)
    {
      Lat= gps.location.lat();
       Serial.print("Location :  ");
      Serial.print("Lat is :");
      Serial.print(Lat);
      Lon=gps.location.lng();
      Serial.print("Long  is :");
      Serial.println(Lon);
    }
    else
    {

      Serial.println("Location INVALID");
    }
  if (gps.date.isValid())
  {
    month=gps.date.month();
    day=gps.date.day();
    year=gps.date.year();
    Serial.print(month);
    Serial.print(F("/"));
    Serial.print(day);
    Serial.print(F("/"));
    Serial.print(year);
  }
  else
  {
    Serial.print(F("INVALID"));
  }
  }


  if (Firebase.ready() && (millis() - sendDataPrevMillis > 15000 || sendDataPrevMillis == 0))
  {
    sendDataPrevMillis = millis();
    
      Serial.printf("Set Lat... %s\n", Firebase.setFloat(fbdo, F("/GPS/Lat"), Lat) ? "ok" : fbdo.errorReason().c_str());
      Serial.printf("Set Long... %s\n", Firebase.setFloat(fbdo, F("/GPS/Long"), Lon) ? "ok" : fbdo.errorReason().c_str());
      Serial.printf("Set month... %s\n", Firebase.setInt(fbdo, F("/GPS/month"), month) ? "ok" : fbdo.errorReason().c_str());
      Serial.printf("Set day... %s\n", Firebase.setInt(fbdo, F("/GPS/day"), day) ? "ok" : fbdo.errorReason().c_str());
      Serial.printf("Set year... %s\n", Firebase.setInt(fbdo, F("/GPS/year"), year) ? "ok" : fbdo.errorReason().c_str());
    
    FirebaseJson json;

    if (count == 0)
    {
      json.set("value/round/" + String(count), F("cool!"));
      json.set(F("vaue/ts/.sv"), F("timestamp"));
      Serial.printf("Set json... %s\n", Firebase.set(fbdo, F("/GPS/json"), json) ? "ok" : fbdo.errorReason().c_str());
    }
    else
    {
      json.add(String(count), "smart!");
      Serial.printf("Update node... %s\n", Firebase.updateNode(fbdo, F("/GPS/json/value/round"), json) ? "ok" : fbdo.errorReason().c_str());
    }

    Serial.println();

    count++;
  }
}


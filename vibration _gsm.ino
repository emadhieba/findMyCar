#include <SoftwareSerial.h>


//vibration sensor decleration
int buzzer = 8;
int vibration=7;
int vib_read;
int y_led=9;


//gsm decleration
#define rxPin 2
#define txPin 3
SoftwareSerial sim800L(rxPin,txPin); 
String buff;



void setup() {
  //vibration sensor and buuzer and led setup
  pinMode(vibration,INPUT);
  pinMode(buzzer,OUTPUT);
  pinMode(y_led,OUTPUT);
pinMode(A0,INPUT);

  //buad rates
  Serial.begin(9600); 
  sim800L.begin(9600);


  //gsm initializing
  Serial.println("Initializing...");
  
  sim800L.println("AT");
  waitForResponse();

  sim800L.println("ATE1");
  waitForResponse();

  sim800L.println("AT+CMGF=1");
  waitForResponse();

  sim800L.println("AT+CNMI=1,2,0,0,0");
  waitForResponse();

  
}

void loop() {
          
  //vibration sensor part with buzzer and led
if (digitalRead(A0)==HIGH){ 
 vib_read = is_vibration();
 if(vib_read == 1){
  tone(buzzer,1000);
  digitalWrite(y_led,HIGH);    
      send_sms(); 
  delay (10000);
  digitalWrite(y_led,LOW);
  }
 else {
    noTone(buzzer);

    }


}
}
  //reading vibration sensor
int is_vibration(){
  int temp=digitalRead(vibration);
  return temp;
}


  //gsm waiting  
void waitForResponse(){
  delay(1000);
  while(sim800L.available()){
    Serial.println(sim800L.readString());
  }
  sim800L.read();
}


//gsm send message
void send_sms(){
  sim800L.print("AT+CMGS=\"+201018401198\"\r");
  waitForResponse();
  
  sim800L.print("ALARM: your car in Danger now");   //message content 
  sim800L.write(0x1A);
  waitForResponse();
}


//making call from gsm
void make_call(){
  sim800L.println("ATD+201018401198;");
  waitForResponse();
}

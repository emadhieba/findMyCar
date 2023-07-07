#include <SoftwareSerial.h>


//vibration sensor decleration
int buzzer = 8;
int vibration=7;
int vib_read;
int y_led=9;
int flag =0;

//gsm decleration
#define rxPin 2
#define txPin 3

#define W 11

SoftwareSerial sim800L(rxPin,txPin); 
String buff;



void setup() {
  //vibration sensor and buuzer and led setup
  pinMode(vibration,INPUT);
  pinMode(buzzer,OUTPUT);
  pinMode(y_led,OUTPUT);
  pinMode(4,INPUT);
   pinMode(W,OUTPUT);
  
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
  
flag = digitalRead(4);

  //vibration sensor part with buzzer and led
 if (flag==0){
  digitalWrite(W,HIGH);
 vib_read = is_vibration();
 if(vib_read == 1){
  tone(buzzer,600);
  digitalWrite(y_led,HIGH);
     
      send_sms(); 
  delay (3000);
  digitalWrite(y_led,LOW);
  
  noTone(buzzer);
  }
 else {
    noTone(buzzer);

    }
    
 }
 Serial.println(flag);
    
digitalWrite(W,0);

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
  sim800L.print("AT+CMGS=\"+201094508999\"\r");
  waitForResponse();
  
  sim800L.print("ALARM: your car in Danger now");   //message content 
  sim800L.write(0x1A);
  
  waitForResponse();
  Serial.println("sent");
}


//making call from gsm
void make_call(){
  sim800L.println("ATD+201018401198;");
  waitForResponse();
}

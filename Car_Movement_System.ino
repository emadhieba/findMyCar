#include <Adafruit_Fingerprint.h>
// Define Pins
#define f 4

#define L A0  // Left Line Sensor
#define C A1  // Left Line Sensor
#define R A2  // Right Line Sensor

#define ENA 9  // PWM Speed Control for Left Motors
#define ENB 10  // PWM Speed Control for Right Motors
#define IN1 5  // Left Motor Control direction forword
#define IN2 6  // Left Motor Control direction backword
#define IN3 7  // Right Motor Control direction forword
#define IN4 8  // Right Motor Control direction backword

#if (defined(__AVR__) || defined(ESP8266)) && !defined(__AVR_ATmega2560__)
// For UNO and others without hardware serial, we must use software serial...
// pin #2 is IN from sensor (GREEN wire)
// pin #3 is OUT from arduino  (WHITE wire)
// Set up the serial port to use softwareserial..

SoftwareSerial mySerial(2, 3);
int x =0;
#else
// On Leonardo/M0/etc, others with hardware serial, use hardware serial!
// #0 is green wire, #1 is white
#define mySerial Serial1

#endif


#define trigger 12
#define echo 13

#define servo 11


int obstacle;
int distance_R;
int distance_L;

int avoid=25;

int lVal; 
int cVal;
int rVal;
 
Adafruit_Fingerprint finger = Adafruit_Fingerprint(&mySerial);

void setup()
{
  Serial.begin(9600);
  while (!Serial);  // For Yun/Leo/Micro/Zero/...
  delay(100);
  Serial.println("\n\nAdafruit finger detect test");
  // Set Motor Control Pins as Output
  pinMode(ENA, OUTPUT);
  pinMode(ENB, OUTPUT);
  pinMode(IN1, OUTPUT);
  pinMode(IN2, OUTPUT);
  pinMode(IN3, OUTPUT);
  pinMode(IN4, OUTPUT); 

  pinMode(f, OUTPUT); 

  
  // Set Line Sensor Pins as Input
  pinMode(L, INPUT);
  pinMode(C, INPUT);
  pinMode(R, INPUT);
  pinMode(echo, INPUT );
  pinMode(trigger, OUTPUT); 
  //servo pin
  pinMode(servo, OUTPUT);


  //check the rotation before beggining
 for (int angle = 70; angle <= 140; angle += 5)  {
   servoPulse(servo, angle); Serial.println("look left"); }
 for (int angle = 140; angle >= 0; angle -= 5)  {
   servoPulse(servo, angle); Serial.println("look right"); }
 for (int angle = 0; angle <= 70; angle += 5)  {
   servoPulse(servo, angle); Serial.println("center"); }


   obstacle = Ultrasonic();

  /////////////////////////////////////////////////////////////////////////////////////////
  // set the data rate for the sensor serial port
  finger.begin(57600);
  delay(5);
  if (finger.verifyPassword()) {
    Serial.println("Found fingerprint sensor!");
  } else {
    Serial.println("Did not find fingerprint sensor :(");
    while (1) { delay(1); }
  }

  Serial.println(F("Reading sensor parameters"));
  finger.getParameters();
  Serial.print(F("Status: 0x")); Serial.println(finger.status_reg, HEX);
  Serial.print(F("Sys ID: 0x")); Serial.println(finger.system_id, HEX);
  Serial.print(F("Capacity: ")); Serial.println(finger.capacity);
  Serial.print(F("Security level: ")); Serial.println(finger.security_level);
  Serial.print(F("Device address: ")); Serial.println(finger.device_addr, HEX);
  Serial.print(F("Packet len: ")); Serial.println(finger.packet_len);
  Serial.print(F("Baud rate: ")); Serial.println(finger.baud_rate);

  finger.getTemplateCount();

  if (finger.templateCount == 0) {
    Serial.print("Sensor doesn't contain any fingerprint data. Please run the 'enroll' example.");
  }
  else {
    Serial.println("Waiting for valid finger...");
      Serial.print("Sensor contains "); Serial.print(finger.templateCount); Serial.println(" templates");
  }
}

void loop()                     // run over and over again
{
while(x==0) 
{  getFingerprintID();

  delay(50);            //don't ned to run this at full speed.
}
digitalWrite(f,1);
while(1){
  
  obstacle = Ultrasonic();
  lVal= digitalRead(L);
  cVal= digitalRead(C);
  rVal= digitalRead(R);
  
  printMysensors();
  
 /* int sum=0;
  for (int i=0; i<20; i++){
  sum = sum + Ultrasonic();
  }
  obstacle = sum/20; */

  
  digitalWrite(f,1);
  if (obstacle > avoid) {
      if (cVal && lVal && rVal){  //if not on any road stops 
           Stop();
          // digitalWrite(f,LOW);
      }else if (cVal == HIGH){ // while it is on the road by its central sensor continue on moving
           Move_F();
      } 
      else if (lVal == HIGH){ // if the left sensor indicates the road then center the car
            Move_R();
            }
       else if (rVal == HIGH){ // if the right sensor indicates a road then center the car
            Move_L();
              } 
       else {
            Stop();
            delay(200);
            Move_F();
            delay(50);
            
          }

    } else {
      Check_side();
      
      }
          delay(10);
    
          
          }

  
}


  void Move_F(){
          digitalWrite(f,HIGH);
          digitalWrite(IN1, HIGH);
          digitalWrite(IN2, LOW);
          digitalWrite(IN3, HIGH);
          digitalWrite(IN4, LOW);
          analogWrite(ENA, 200);
          analogWrite(ENB, 200);
          Serial.println("F");
    }
    void Move_R(){
        digitalWrite(f,HIGH);
        digitalWrite(IN3, HIGH);
        digitalWrite(IN4, LOW);
        digitalWrite(IN1, LOW);
        digitalWrite(IN2, HIGH);
        analogWrite(ENA, 110);
        analogWrite(ENB, 180); 
        Serial.println("R");
    }
    void Move_L(){
        digitalWrite(f,HIGH);
        digitalWrite(IN3, LOW);
        digitalWrite(IN4, HIGH);
        digitalWrite(IN1, HIGH);
        digitalWrite(IN2, LOW);
        analogWrite(ENA, 180);
        analogWrite(ENB, 110);
        Serial.println("L");
        }
     void Stop(){
      analogWrite(ENA, 0);
      analogWrite(ENB, 0);
      Serial.println("S");
      }

      void printMysensors(){
        Serial.print("Left:  ");
        Serial.println(lVal);

        Serial.print("center:  ");
        Serial.println(cVal);
       
        Serial.print("right:  ");
        Serial.println(rVal);
         
        Serial.print("nearest onstacle:  ");
        Serial.println(obstacle);

    /*    Serial.print("right way:  ");
        Serial.println(distance_R);

        Serial.print("left way :  ");
        Serial.println(distance_L);  */
        
        }
      

      void compareDistance(){
    if(distance_L < distance_R){
  Move_L();
  delay(1200);
  Move_F();
  delay(700);
  Move_R();
  delay(1200);
  Move_F();
  delay(700);
  Move_R();
  delay(200);
  Move_F();
  delay(400);
  obstacle = Ultrasonic();
  }
  else{
  Move_R();
  delay(1200);
  Move_F();
  delay(700);
  Move_L();
  delay(1200);
  Move_F();
  delay(700);  
  Move_L();
  delay(200);
  Move_F();
  delay(400);
  obstacle = Ultrasonic();
  
  }
}

void Check_side(){
    Stop();
    delay(100);
 for (int angle = 70; angle <= 140; angle += 5)  {
   servoPulse(servo, angle);  }
    delay(800);
    distance_L = Ultrasonic();
    Serial.print("Distance Left=");Serial.println(distance_L);
    delay(100);
  for (int angle = 140; angle >= 0; angle -= 5)  {
   servoPulse(servo, angle);  }
    delay(800);
    distance_R = Ultrasonic();
    Serial.print("Distance Right=");Serial.println(distance_R);
    delay(100);
 for (int angle = 0; angle <= 70; angle += 5)  {
   servoPulse(servo, angle);  }
    delay(300);
    compareDistance();
}

long Ultrasonic(){
  digitalWrite(trigger, LOW);
  delayMicroseconds(2);
  digitalWrite(trigger, HIGH);
  delayMicroseconds(10);
  long duration = pulseIn (echo, HIGH);
  return duration * 0.034 / 2;
}

void servoPulse (int pin, int angle){
int pwm = (angle*11) + 500;      // Convert angle to microseconds
 digitalWrite(pin, HIGH);
 delayMicroseconds(pwm);
 digitalWrite(pin, LOW);
 delay(50); // Refresh cycle of servo
}
uint8_t getFingerprintID() {
  uint8_t p = finger.getImage();
  switch (p) {
    case FINGERPRINT_OK:
      Serial.println("Image taken");
      break;
    case FINGERPRINT_NOFINGER:
      Serial.println("No finger detected");
      return p;
    case FINGERPRINT_PACKETRECIEVEERR:
      Serial.println("Communication error");
      return p;
    case FINGERPRINT_IMAGEFAIL:
      Serial.println("Imaging error");
      return p;
    default:
      Serial.println("Unknown error");
      return p;
  }

  // OK success!

  p = finger.image2Tz();
  switch (p) {
    case FINGERPRINT_OK:
      Serial.println("Image converted");
      break;
    case FINGERPRINT_IMAGEMESS:
      Serial.println("Image too messy");
      return p;
    case FINGERPRINT_PACKETRECIEVEERR:
      Serial.println("Communication error");
      return p;
    case FINGERPRINT_FEATUREFAIL:
      Serial.println("Could not find fingerprint features");
      return p;
    case FINGERPRINT_INVALIDIMAGE:
      Serial.println("Could not find fingerprint features");
      return p;
    default:
      Serial.println("Unknown error");
      return p;
  }

  // OK converted!
  p = finger.fingerSearch();
  if (p == FINGERPRINT_OK) {
    Serial.println("Found a print match!");
    x = 1; 
  } else if (p == FINGERPRINT_PACKETRECIEVEERR) {
    Serial.println("Communication error");
    return p;
  } else if (p == FINGERPRINT_NOTFOUND) {
    Serial.println("Did not find a match");
    return p;
  } else {
    Serial.println("Unknown error");
    return p;
  }

  // found a match!
  Serial.print("Found ID #"); Serial.print(finger.fingerID);
  Serial.print(" with confidence of "); Serial.println(finger.confidence);

  return finger.fingerID;
}

// returns -1 if failed, otherwise returns ID #
int getFingerprintIDez() {
  uint8_t p = finger.getImage();
  if (p != FINGERPRINT_OK)  return -1;

  p = finger.image2Tz();
  if (p != FINGERPRINT_OK)  return -1;

  p = finger.fingerFastSearch();
  if (p != FINGERPRINT_OK)  return -1;

  // found a match!
  Serial.print("Found ID #"); Serial.print(finger.fingerID);
  Serial.print(" with confidence of "); Serial.println(finger.confidence);
  Serial.print ("\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\");
  Serial.print (finger.fingerID);
  return finger.fingerID;
}

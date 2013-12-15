#include <NewPing.h>

#define echoPin 7 // Echo Pin
#define trigPin 8 // Trigger Pin
#define LEDPin 13 // Onboard LED

int sensors[2]; //number of sensors
int inByte; //stores receiving serial

int maximumRange = 200; // Maximum range needed
long distVal;  //stores distance 
int LDRin = A0;

NewPing sonar(trigPin, echoPin, maximumRange); // NewPing setup of pins and maximum distance

boolean inSight = false;  //check if something is in front of distance sensor
boolean onGround = false;  //check whether the object is on the ground or not

int led = 9;
int brightness = 0;    // how bright the LED is
int brightness2 = 0;

int fadeAmount = 15;    // how many points to fade the LED by
int fadeAmount2 = 1;


void setup() {
 Serial.begin (9600);
 
 sensors[0] = 0;
 sensors[1] = 0;
 inByte = 0;
 pinMode(trigPin, OUTPUT);
 pinMode(echoPin, INPUT);
 pinMode(LDRin, INPUT);
 pinMode(led, OUTPUT);
 startComm();
}

void loop() {
 
 if (Serial.available() > 0) { 
  
 //LDR------------------------------------------------------------
  int LDRval = analogRead(LDRin);  
  
  int brightVal = map(LDRval, 120, 405, 0, 100); // Map distance to the range 0 - 255
  brightVal = constrain(brightVal, 0, 100); // Limit to desired range
  
  //Serial.print("brightness: ");  Serial.println(brightVal);  Serial.println(" ");
  
  if (brightVal < 15) {
   onGround = true;
 // Serial.println("I'm on ground!");
  } else {
   onGround = false; 
 // Serial.println("Someone picked me up!");
  }
 //LDR------------------------------------------------------------ 


 //distSensor-----------------------------------------------------
 
  unsigned int uS = sonar.ping(); // Send ping, get ping time in microseconds (uS).
 // Serial.print("Ping: ");
 // Serial.print(sonar.convert_cm(uS)); // Convert ping time to distance and print result (0 = outside set distance range, no ping echo)
 // Serial.println("cm");
 
  distVal = (sonar.convert_cm(uS));
  //Serial.println(distance);
  
  int distance = map(distVal, 0, 40, 0, 255); // Map distance to the range 0 - 255
  distance = constrain(distance, 0, 255); // Limit to desired range
  //Serial.write(distance); // sends data to serial port as "bytes"
  delay(5);
 
 //distSensor-----------------------------------------------------
 
 //FadeLED--------------------------------------------------------


 if (distance < 50) {
   inSight = true;
 } else {
   inSight = false;
 }
 
 if(inSight && !onGround) {  // if the object is closer than 10cm & lift from ground
   analogWrite(led, brightness); 
   brightness = brightness + fadeAmount;
   
   if (brightness == 0 || brightness == 255) {
      fadeAmount = -fadeAmount ; 
   }
 }
 
if(!inSight) { // if the object is out of range
   analogWrite(led, brightness2); 
   brightness2 = brightness2 + fadeAmount2;
   
   if (brightness2 == 0 || brightness2 == 10) {
      fadeAmount2 = -fadeAmount2; 
   }
 }
 
 //FadeLED--------------------------------------------------------
 
 

    sensors[0] = distance;
    sensors[1] = brightVal;

    Serial.print(sensors[0]);
    Serial.print(",");
    Serial.println(sensors[1]);          

 
 
 //Delay 50ms before next reading.
 delay(50);
 }
}

void startComm() {
  while (Serial.available() <= 0) {  //wait for processing to send signal
    Serial.println("0,0"); // resets serial
    delay(300);            // wait 300 until next read
  }
}


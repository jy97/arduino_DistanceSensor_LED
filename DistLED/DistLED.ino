/*
 HC-SR04 Ping distance sensor:
 VCC to arduino 5v 
 GND to arduino GND
 Echo to Arduino pin 7 
 Trig to Arduino pin 8
 
 This sketch originates from Virtualmix: http://goo.gl/kJ8Gl
 Has been modified by Winkle ink here: http://winkleink.blogspot.com.au/2012/05/arduino-hc-sr04-ultrasonic-distance.html
 And modified further by ScottC here: http://arduinobasics.blogspot.com/
 on 10 Nov 2012.
 */

#include <NewPing.h>

#define echoPin 7 // Echo Pin
#define trigPin 8 // Trigger Pin
#define LEDPin 13 // Onboard LED

int maximumRange = 50; // Maximum range needed
int minimumRange = 0; // Minimum range needed
long distance;

NewPing sonar(trigPin, echoPin, maximumRange); // NewPing setup of pins and maximum distance.

boolean inSight = false;

int led = 9;
int brightness = 0;    // how bright the LED is
int brightness2 = 0;
int brightIntensity = 0;
int fadeAmount = 5;    // how many points to fade the LED by



void setup() {
 Serial.begin (9600);
 pinMode(trigPin, OUTPUT);
 pinMode(echoPin, INPUT);
 pinMode(led, OUTPUT);
}

void loop() {
  
 //distSensor-----------------------------------------------------
 
  unsigned int uS = sonar.ping(); // Send ping, get ping time in microseconds (uS).
  Serial.print("Ping: ");
  Serial.print(sonar.convert_cm(uS)); // Convert ping time to distance and print result (0 = outside set distance range, no ping echo)
  Serial.println("cm");
 
  distance = sonar.convert_cm(uS);
 
 //distSensor-----------------------------------------------------
 
 //FadeLED--------------------------------------------------------


 if (distance < 10) {
   inSight = true;
 } else {
   inSight = false;
 }
 
 if(inSight) {  
   analogWrite(led, brightness); 
   brightness = brightness + fadeAmount;
   
   if (brightness == 0 || brightness == 255) {
      fadeAmount = -fadeAmount ; 
   }
 }
 
if(inSight == false) { 
   analogWrite(led, brightness2); 
   brightness2 = brightness2 + fadeAmount;
   
   if (brightness2 == 0 || brightness2 == 40) {
      fadeAmount = -fadeAmount ; 
   }
 }
 
 //FadeLED--------------------------------------------------------
 
 //Delay 50ms before next reading.
 delay(50);
}

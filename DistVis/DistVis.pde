import processing.serial.*;

Serial myPort;  // define serial port
int distSensor = 0;
int LDR = 0;

void setup() {
  // List all the available serial ports
  size(400, 400);
  //println(Serial.list());

  myPort = new Serial(this, Serial.list()[4], 9600); // open serial port
                                                     // set speed to 9600baud
  myPort.bufferUntil('\n');          //serial buffer
}

void draw() {
  
 // while (myPort.available() > 0) {
  //  int inByte = myPort.read();
   // println(inByte);
   // noFill();
    
    background(LDR);
    
    noStroke();
   // background(inByte);
    fill(255-distSensor);
    ellipse(width/2, height/2, distSensor, distSensor);
 // }
}
  
  void serialEvent(Serial myPort) {
  
  String myString = new String(myPort.readBytesUntil('\n'));  //read serial
  myString = trim(myString); //get rid of spaces etc.
 
  int sensors[] = int(split(myString, ',')); // read multiple sensors, cut serial by comma
 
  if (sensors.length > 1) {
    distSensor = sensors[0];
    LDR = sensors[1];
  }
}

import processing.serial.*;
Serial myPort;  // define serial port

int distSensor = 0;
int LDR = 0;

void setup() {
  background(255);
  size(400, 400);
  //println(Serial.list());  // List all the available serial ports

  myPort = new Serial(this, Serial.list()[4], 9600); // open serial port
                                                     // set speed to 9600baud
  myPort.bufferUntil('\n');          //serial buffer
}

void draw() {
  
      
    noStroke();
    fill(255-distSensor);
    ellipse(width/2, height/2, distSensor, distSensor);
    
    if (LDR < 15) {
     println("on the ground");
    } else {
     println("picked up");
    }
}
  
void serialEvent(Serial myPort) {
  String myString = new String(myPort.readBytesUntil('\n'));  //read serial
  myString = trim(myString); //get rid of spaces etc.
 
  int sensors[] = int(split(myString, ',')); // read multiple sensors, cut serial by comma
 
  if (sensors.length > 1) {
    distSensor = sensors[0];
    LDR = sensors[1];
  }
  
  myPort.write("A");
}

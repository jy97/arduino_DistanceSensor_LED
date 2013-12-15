import processing.serial.*;
Serial myPort;  // define serial port

int dist = 0;
int LDR = 0;

void setup() {
  colorMode(HSB, 255, 255, 255);
  background(255);
  size(800, 800);
  //println(Serial.list());  // List all the available serial ports

  myPort = new Serial(this, Serial.list()[4], 9600); // open serial port
                                                     // set speed to 9600baud
  myPort.bufferUntil('\n');          //serial buffer
}

void draw() {
    
  ellipseMode(CORNER);
    noStroke();
    fill(LDR, dist, dist);
    
      translate(width/2, height/2);
      rotate(radians(frameCount));
    
    
    ellipse(LDR, LDR, dist, dist);

    if (LDR < 15) {
     println("I'm on the ground");
    } else {
     println("Someone picked me up");
    }
}
  
void serialEvent(Serial myPort) {
  String myString = new String(myPort.readBytesUntil('\n'));  //read serial
  myString = trim(myString); //get rid of spaces etc.
 
  int sensors[] = int(split(myString, ',')); // read multiple sensors, cut serial by comma
 
  if (sensors.length > 1) {
    dist = sensors[0];
    LDR = sensors[1];
  }
  
  myPort.write("A");
}

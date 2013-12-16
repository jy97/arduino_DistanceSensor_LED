import processing.serial.*;
Serial myPort;  // define serial port

float dist = 0;
int LDR = 0;

boolean onGround = true;

void setup() {
  colorMode(HSB, 255, 255, 255, 255);
  background(255);
  smooth();
  size(700, 700);
  //println(Serial.list());  // List all the available serial ports

  myPort = new Serial(this, Serial.list()[4], 9600); // open serial port
                                                     // set speed to 9600baud
  myPort.bufferUntil('\n');          //serial buffer
}

void draw() {
  
println(LDR);  



  if(!onGround) {
    ellipseMode(CORNER);
    noStroke();
    fill(dist, LDR, dist, LDR);
    
      translate(width/2, height/2);
      rotate(radians(frameCount));
 
    ellipse(LDR, dist, dist, dist); 
  }

    if (LDR < 20) {
     onGround = true;
    // println("I'm on the ground");
    } else {
     onGround = false;
    // println("Someone picked me up");
    }
}
  
void serialEvent(Serial myPort) {
  String myString = new String(myPort.readBytesUntil('\n'));  //read serial
  myString = trim(myString); //get rid of spaces etc.
 
  int sensors[] = int(split(myString, ',')); // read multiple sensors, cut serial by comma
 
  if (sensors.length > 1) {
    dist = map(sensors[0], 0, 255, 50, 255);
    LDR = sensors[1];
  }
  
  myPort.write("A");
}

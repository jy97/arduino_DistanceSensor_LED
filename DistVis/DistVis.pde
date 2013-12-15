import processing.serial.*;

Serial myPort;  // The serial port

void setup() {
  // List all the available serial ports
  size(400, 400);
  println(Serial.list());
  // I know that the first port in the serial list on my mac
  // is always my  Keyspan adaptor, so I open Serial.list()[0].
  // Open whatever port is the one you're using.
  myPort = new Serial(this, Serial.list()[4], 9600);
}

void draw() {
  while (myPort.available() > 0) {
    int inByte = myPort.read();
    println(inByte);
    
    noStroke();
   // background(inByte);
    fill(255-inByte);
    ellipse(width/2, height/2, inByte, inByte);
  }
}

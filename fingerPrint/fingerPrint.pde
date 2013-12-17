
import processing.serial.*;
Serial myPort;  // define serial port
String portString;

int numOfShapes = 60; // Number of squares to display on screen 
int shapeSpeed = 2; // Speed at which the shapes move to new position
 // 2 = Fastest, Larger numbers are slower

//Global Variables 
Square[] mySquares = new Square[numOfShapes];
int shapeSize;

float dist = 0;
float LDR = 0;

String[] imFiles={ "fp1.png", "fp2.png", "fp3.png" };
PImage[] im= new PImage[3];



void setup() {

 size(displayWidth,400);
   background(255);
   smooth();
  
  /* Calculate the size of the squares and initialise the Squares array */
 shapeSize = (width/numOfShapes); 
 for(int i = 0; i<numOfShapes; i++){
 mySquares[i]=new Square(int(shapeSize*i),height-40);
 }
  

 for(int i=0; i<3; i++){
    im[i]= loadImage(imFiles[i]);
 }  
  
 myPort = new Serial(this, Serial.list()[4], 9600); // open serial port / set speed to 9600baud
 myPort.bufferUntil('\n'); //serial buffer
  
}

void draw() {
 noStroke();
 background(255); //Make the background BLACK
 delay(50); //Delay used to refresh screen
 drawSquares(); //Draw the pattern of squares
 //println(dist);

   if(LDR > 30) {
    imageMode(CENTER);
    image(im[(int)random(2)],width/2, height/2,100,150);
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
  

  if(dist == 50.0 || dist == 255.0) {
    dist = height - shapeSize; 
  }
  
  if(dist < 66.0) {
    dist = 0;
  }
  
  myPort.write("A");
}
  
  
  /* ---------------------drawSquares ---------------------------*/
void drawSquares(){
 int oldY, newY, targetY, redVal, blueVal;
 
 /* Set the Y position of the 1st square based on 
 sensor value received */
 mySquares[0].setY((height-shapeSize)-(int)dist);
 
 /* Update the position and colour of each of the squares */
 for(int i = numOfShapes-1; i>0; i--){
 /* Use the previous square's position as a target */
 targetY=mySquares[i-1].getY();
 oldY=mySquares[i].getY();
 
 if(abs(oldY-targetY)<2){
 newY=targetY; //This helps to line them up
 }else{
 //calculate the new position of the square
 newY=oldY-((oldY-targetY)/shapeSpeed);
 }
 //Set the new position of the square
 mySquares[i].setY(newY);
 
 /*Calculate the colour of the square based on its
 position on the screen */
 blueVal = int(map(newY,0,height,0,255));
 redVal = 255-blueVal;
 fill(redVal,0,blueVal);
 
 /* Draw the square on the screen */
 rect(mySquares[i].getX(), mySquares[i].getY(),shapeSize,shapeSize-10);
 fill(redVal, 255, blueVal);
 text(dist,mySquares[1].getX(), mySquares[2].getY()+10);
 }
}

boolean sketchFullScreen() {
 return true;
}

/* ---------------------CLASS: Square ---------------------------*/
class Square{
 int xPosition, yPosition;
 
 Square(int xPos, int yPos){
 xPosition = xPos;
 yPosition = yPos;
 }
 
 int getX(){
 return xPosition;
 }
 
 int getY(){
 return yPosition;
 }
 
 void setY(int yPos){
 yPosition = yPos;
 }
}
  
  
  
  



PFont f;
String[] arString = new String[3];
float a,x,hr,vr;
int numWords = 100;
int position = 0;
int linePosition = 0;
float xOffset, yOffset = 0;
float yBottom = 200;
float yJump = 25;
WordImage[] phraseWords = new WordImage[numWords];
WordImage[] staticWords = new WordImage[numWords];
Button[] buttonArray = new Button[2];
String lines[] = new String[100];
StringDict dctBible;
  
//Setup occurs once when the program starts.
void setup() {
  size(640, 500);
  x = width*0.25;
  // Create the font
  f = createFont("Serif", 24);
  textFont(f);
  frameRate(20);
  
  buttonArray[0] = new Button(300,150,50,20, color(200,155,155));
  buttonArray[1] = new Button(500,150,50,20, color(155,155,155));
  buttonArray[0].display();
  buttonArray[1].display();
  
  //loads each line of the file into a string array.
  lines = loadStrings("Phrase.txt");
  
  readWords(linePosition);

  xOffset = 0;
  yOffset = 0;
}

void draw() {
  //Draw occurs once every frame.
  background(102);
  textAlign(RIGHT);
  fill(0);
  
  //Loop through each word in the array for each frame.
  for (int i=0; i<phraseWords.length; i++) {
    if (phraseWords[i] != null) {
       if (phraseWords[i].bMoving) {
         //If the word is in the process of moving
          float xPos = textWidth(phraseWords[i].strWord) + xOffset + 10;
          phraseWords[i].wx = phraseWords[i].wx - (phraseWords[i].wx - xPos)/4;
          phraseWords[i].wy = phraseWords[i].wy + 8;
          if (phraseWords[i].wy > yBottom - yOffset) {
           //In the correct verticle position so move to final place. 
           phraseWords[i].stopAtBottom();          }
       }
       else if (phraseWords[i].bStopped) {
         //If the word is stopped make sure the color is et properly
         phraseWords[i].cWord = phraseWords[i].cStop;
       }
       //Display the word.
       phraseWords[i].display();
    }
 }
 //Display the button in the proper array position.
 buttonArray[0].display();
 buttonArray[1].display();
}

void loadDictionary() {
  int i;
  for (i = 0; i<lines.length; i++) {
    String lWords[] = splitTokens(lines[i]);
    dctBible.set(lWords[0],lines[i]); 
  }  
}

//Loads the words from the identified line into the global object arrays
//phraseWords(mixed up order) and staticWords(correct order).
void readWords(int iLine) {
  //Read In From File.
  if (iLine > lines.length-1) {
    //If end of the line then restart. 
    iLine = 0;
    linePosition = 0; 
  }
  
  String words[] = splitTokens(lines[iLine]);
  String swords[] = splitTokens(lines[iLine]);
  println("Words" + words.length);
  
  //Randomize order of words.
  String mixedUpWords[] = mixUpArray(words);
  numWords = words.length;  
  
  //Instantiate each word in a random order.
  for (int i=0; i<numWords; i++) {
   phraseWords[i] = new WordImage(mixedUpWords[i], 100 + random(0,10)*i, 200 + random(0,200), 1,1);
   println("start");
   println(i);
   //Display each word on the screen.
   phraseWords[i].start(); 
  }
  
  //Instantiate each word in the proper order.
  for (int i=0; i<numWords; i++) {
   staticWords[i] = new WordImage(swords[i], 100 + random(0,10)*i, 200 + random(0,200), 1,1);
  }
  position = 0;
}

void mouseReleased() {
  //Called everytime the mouse button is released.
  //Checks to see if mouse is over the word.
  float wordHeight = textAscent() + textDescent(); 
  
  println(mouseX);
  println(mouseY);
  println();
  //Checks each word in the array to see if mouse is over.
  for (int i=0; i<numWords; i++) {
   if (phraseWords[i].isMouseOver()) 
    {
      println(phraseWords[i].strWord);
      println(staticWords[position].strWord);
      if (phraseWords[i].strWord.equals(staticWords[position].strWord)) {
        //If the words are equal then the proper one is chosen.
        phraseWords[i].moveToBottom();
        position++;
      }
      else {
        phraseWords[i].cWord = color(200,155,155);
      }
    }
  }
  //Checks to see if mouse is over reset button.
  if (buttonArray[0].isMouseOver()) {
    buttonArray[0].rectColor = color(100,155,155);
    resetScreen();
  }
  //Check to see if mouse is over help button.
  if (buttonArray[1].isMouseOver()) {
    help(); 
  }
}

void mouseMoved() {
  //Called whenever mouse is moved.
   for (int i=0; i<phraseWords.length; i++) {
     if (phraseWords[i] != null) {
     if (phraseWords[i].isMouseOver()) {
       //Change color of word.
       if (phraseWords[i].bStopped) {
         phraseWords[i].cWord = phraseWords[i].cStop;
       }
       else {phraseWords[i].cWord = phraseWords[i].cOver;
       }
     }
     else {
      // return word to original color.
      if (!phraseWords[i].bStopped) {
        phraseWords[i].cWord = phraseWords[i].cOut;
      }
     }
     }
   }
}

//Clears the screen and writes new verse.
void resetScreen() {
  emptyArray();
  xOffset = 0;
  yOffset = 0;
  linePosition++;
  readWords(linePosition);
}

//Highlights the next word.
void help() {
  for (int i=0; i<numWords; i++) {
      if (phraseWords[i].strWord.equals(staticWords[position].strWord)) {
        //If the words are equal then highlight it.
        phraseWords[i].cWord = color(200,155,155);
        break;
     }
  }
}

//Removes the words from the array.
void emptyArray() {
  int i=0;
  while(i<phraseWords.length) {
    if (phraseWords[i] != null) {
      phraseWords[i].wx = 2000;
      phraseWords[i].wy = 2000;
      phraseWords[i].cWord = color(0,0,0);
      //phraseWords[i].display();
      println("empty array" + i);
      phraseWords[i] = null;
      staticWords[i] = null;
    }
    i++;
  }
}

//Rearranges the words in the array.
String[] mixUpArray(String[] words) {
  String[] usedWords = words;
  String[] returnWords = new String[words.length];
  int i= 0;
  while(i<words.length) {
   int index = (int) random(words.length);
   if (usedWords[index] != "") {
    returnWords[i] = usedWords[index];
    usedWords[index] = "";
    i++; 
    println(i);
   }
  }
  return returnWords;
}

//****************************************//
//WordImage Class
class WordImage
{
  String strWord;
  float wx;
  float wy;
  int xDirection;
  int yDirection; 
  color cWord = color(255, 255, 255);
  color cOver = color(155,155,200);
  color cStop = color(255, 255, 0);
  color cOut = color(255, 255, 255);
  boolean bMove = true;
  boolean bMoving = false;
  boolean bStopped = false;
  
  WordImage(String word, float fx, float fy, int xDir, int yDir)  {
   strWord = word; 
   wx = fx;
   wy = fy;
   xDirection = xDir;
   yDirection = yDir;
  }
  
  //Move the word.
  void move(float xDif, float yDif) {
    if (bMove) {
      if (wx > width - textWidth(strWord) || wx <= 0) {
       xDirection = xDirection * -1;
      }
      if (wy > height || wy < 0) {
       yDirection = yDirection * -1;
      }
      wx += xDif * xDirection;
      wy += yDif * yDirection; 
    }
  }
  
  void start() {
   bMove = false;
   print(strWord);
   if ((xOffset + textWidth(strWord) + 10) > width) {
    yOffset += yJump;
    xOffset = 0; 
   }
   wx = textWidth(strWord) + xOffset + 10;
   xOffset = wx;
   wy = yJump + yOffset;  
  }
  
  void moveToBottom() {
    //Moves to the bottom of the screen.
    //Checks to see if off screen and moves the resulting
    //yValue to down one line.
    bMoving = true;
    if ((xOffset + textWidth(strWord) + 10) > width) {
      yOffset += yJump;
      xOffset = 0; 
     }
     //Change the color of the word.
     cWord = color(255,255,0);
  }
  
  void stopAtBottom(){
    //Position to the proper location.
    bStopped = true;
    bMoving = false;
    wx = textWidth(strWord) + xOffset + 10;
    xOffset = wx;
    wy = yBottom + yOffset; 
  }
  
  void display() {
    fill(cWord);
    text(strWord, wx, wy);
  }
  
  boolean isMouseOver() {
    
    float wordHeight = textAscent() + textDescent();
    boolean xCorrect = false;
    boolean yCorrect = false;
    if ((mouseX > wx - textWidth(strWord) ) && (mouseX < wx)) {
      xCorrect = true;
    }
    if (abs(mouseY - wy) < wordHeight * .6) {
      yCorrect = true;
    }
    if (xCorrect && yCorrect) {
          return true;
        }
    else
        {
          return false;
        }
  }
}
//END WordImage Class
//****************************************//

//****************************************//
//Button Class
class Button 
{
 int rectX;
 int rectY; 
 int rectHeight;
 int rectWidth;
 color rectColor;
  
  Button(int rx, int ry, int rw, int rh, color rc) {
   rectX = rx;
   rectY = ry;
   rectHeight = rh;
   rectWidth = rw;
   rectColor = rc; 
  }
  
   void display() {
    fill(rectColor);
    rect(rectX, rectY, rectWidth, rectHeight, 10);
  }
    
  boolean isMouseOver()  {
  if (mouseX >= rectX && mouseX <= rectX+rectWidth && 
      mouseY >= rectY && mouseY <= rectY+rectHeight) 
      {
    return true;
    } 
  else {
    return false;
  }
 }
}
//END of Button Class
//****************************************//



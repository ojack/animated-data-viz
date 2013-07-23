import org.gicentre.utils.spatial.*;

 Animal []test;
Animal []whale;
Animal []seaLion;
Animal []humpbackWhale;
Animal []blueWhale2;
Animal []salmonShark;
Animal []salmonShark2;
Animal []salmonShark3;
Animal []turtle;
Animal []turtle2;
Animal []makoShark;
Animal []makoShark2;
Animal []elephantSeal;
Animal []elephantSeal2;
Animal []elephantSeal3;
Animal []albatross;


  float speed;
  PVector origin;
  WebMercator proj;
  PVector tlCorner,brCorner, tlCornerLEFT, brCornerLEFT;;
  float date;
   float offset = 720;
   //float offset = 1440;
  float yoffset = 0;
  float mapRatio = 1;
  float mapWidth = 1200;//x2
  int numCycles = 0;
  //Trail appearance parameters
  int trailLength = 400;//x2
  int alphaVal = 15;
  int frontFade = 30;//x2
  int backFade = 200;//x2
  float frontStep, backStep;
  
  PImage backgroundMap;  
  String [] monthsShort = {"JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"};
PFont font;

  void setup(){
    noStroke(); 

// The font must be located in the sketch's 
// "data" directory to load successfully
font = loadFont("BentonSans-Regular-16.vlw"); 
textFont(font, 24); 
textAlign(CENTER);
  frontStep = (100-alphaVal)/frontFade;
  backStep = alphaVal/backFade;
 //  noLoop();
   date = 0;
   //speed = 0.1;//ACTUAL SEPEED
   speed = 0.05;//HIGH-RES SPEED
  
  // speed = 0.2;//for testing purposes
 size(1920, 1080); 
 
    proj = new WebMercator();
     backgroundMap =  loadImage("v3crop.png");
      tlCorner = proj.transformCoords(new PVector(-179.9, 63.56812));
 brCorner = proj.transformCoords(new PVector( -92.26, 4.2)); 
   brCornerLEFT = proj.transformCoords(new PVector( 179.9,4.2)); 
   tlCornerLEFT = proj.transformCoords(new PVector(143.833008, 63.56812));

  //  background(0); 

 whale = readDataFile("blueWhaleXQ.txt");
test = readDataFile("blueWhaleYsQCLEAN.txt");//CLEAN
 seaLion = readDataFile("seaLionXQ.txt");
blueWhale2 = readDataFile("blueWhaleZQCLEAN.txt");
 salmonShark = readDataFile("salmonSharkYQCLEAN.txt");
 salmonShark2 = readDataFile("salmonSharkXQ.txt");
  salmonShark3 = readDataFile("salmonSharkZQ.txt");
 turtle = readDataFile("turtleYQ.txt");
   turtle2 = readDataFile("turtleZQCLEAN.txt");//CLEAN!!!
    makoShark = readDataFile("makoSharkXQ.txt");
     makoShark2 = readDataFile("makoSharkYQCLEAN.txt");
      elephantSeal = readDataFile("elephantSealXQ.txt");
       elephantSeal2 = readDataFile("elephantSealYQ.txt");
      elephantSeal3 = readDataFile("elephantSealZQCLEAN.txt");
  }
  
void draw(){
   smooth();
   fill(0); 
  // rect(0, 0, width, height);
     image(backgroundMap,0,0,width,height);  
   date+=speed;
   if(date > 365) {
    date -= 365;
    numCycles++;
  }
  updateTrails();
  //drawCalendar();
   drawMap();
  int dateRound = int(date);
 // drawDate();
   if(numCycles > 0){
   // if(date > 180){
   //saveFrame("longtrail5NoZoom"+numCycles+"-"+dateRound+"-#####.png");
   }

  }
  
  void updateTrails(){
updateAnimal(whale);
updateAnimal(test);
updateAnimal(seaLion);
//updateAnimal(humpbackWhale);
updateAnimal(salmonShark);
updateAnimal(salmonShark2);
updateAnimal(salmonShark3);
 updateAnimal(makoShark);
updateAnimal(makoShark2);
  updateAnimal(turtle);
   updateAnimal(turtle2);
 updateAnimal(elephantSeal);
updateAnimal(elephantSeal2);
      updateAnimal(elephantSeal3);
// updateAnimal(albatross);
  }
  
 void drawMap(){
 drawTrails(whale, color(#4bdefe));
drawTrails(test, color(#4bdefe));
drawTrails(seaLion, color(#ffcf4d));
//drawTrails(humpbackWhale, color(#d4d4d4));
drawTrails(salmonShark, color(#FF0000));
drawTrails(salmonShark2, color(#FF0000));
drawTrails(salmonShark3, color(#FF0000));
drawTrails(makoShark, color(#6666ff));
drawTrails(makoShark2, color(#6666ff));
  drawTrails(turtle, color(#83fb9a));
   drawTrails(turtle2, color(#83fb9a));
 drawTrails(elephantSeal, color(#ee7bff));
drawTrails(elephantSeal2, color(#ee7bff));
      drawTrails(elephantSeal3, color(#ee7bff));
// drawTrails(albatross, color(#ffffff));*/
 }
  
 void drawCalendar(){
      textFont(font, 16); 
textAlign(CENTER);
    fill(0, 180);
    int sideMargin = 41;
    int fromTop = 828;
    int rectWidth = 840;
    int rectHeight = 2;
    noStroke();
      rect(sideMargin-10, fromTop-4, rectWidth+40, rectHeight+35);
  stroke(180);
  rect(sideMargin, fromTop,  rectWidth, 1);
    fill(255);
   float calendarX = map(date, 0, 365, 0, rectWidth);
  noStroke();
  for (int i = 0; i < 12; i++){
    fill(180, 100);
     float dateLoc = map(i, 0, 12, 0, rectWidth);
    rect(dateLoc+sideMargin, fromTop-2, 2, 4);
    fill(255);
   text(monthsShort[i], dateLoc+sideMargin+rectWidth/24, fromTop + 30);
  rect(sideMargin+calendarX, fromTop-2, 20, 8);
  }
 }
  
  void drawDate(){
    fill(40);
    text(date, 150, height - 40);
  }
  
  void updateAnimal(Animal[] tracks){
    for (int i = 0; i < tracks.length; i++){
       PVector next;
       if(tracks[i].containsDate(date)){
         next = tracks[i].getLocation(date);
       } else {
         next = new PVector(0, 0);
       }
       tracks[i].updateTrail(next.x, next.y);///EXTRANEOUS CALLBACKS
    }
  }
  
  void drawTrails(Animal[] tracks, color clr){
     for (int i = 0; i < tracks.length; i++){
   //  tracks[i].showPoints();
     tracks[i].drawTrail(clr);
     //tracks[i].showCurrentPoint();
    //  }
    //  }
    }
  }
  
  ///functionL readDataFile
  Animal[] readDataFile (String file){
    String lines[] = loadStrings(file);
   Animal[] newAnimal = new Animal[lines.length];
   // newAnimal[0].loadPoints(lines[0]);
   for (int i=0; i < lines.length; i++) {

      newAnimal[i] = new Animal(lines[i]);
    }
    return newAnimal;
  };
  
  
 /*
 *
 CLASSES
 *
 */

  
 


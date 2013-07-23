 
  /*
  WayPoint class
  */
 
 class WayPoint{
    //properties
    PVector location;
    float time;
    
    //constructor
    WayPoint(float lon, float lat, float _time){
//print("lon:"+lon);
      PVector test = new PVector(lon, lat);
     /* if(lon < -180){
        test.x = -180;
        println("longitude coordinate out of bounds!");
      }*/
location = geoToScreen(test);
    // location = geoToScreen(test);
     //  ellipse(location.x, location.y, 10, 10);
//print(" new Waypoint  screenX =  "+ location.x + "  projected = "+ proj.transformCoords(test).x + "original= "+ lon);
      time = _time;
    }
    
    void drawPoint(){
    //  fill(0);
      ellipse(location.x, location.y, 5, 5);
    }
    
   PVector geoToScreen(PVector test){
      PVector original, geo;
      original = new PVector(test.x, test.y);
      float boundsOffset = 0;
      if(test.x < -180) {
        boundsOffset =(test.x + 180*2);
       original.x = (-179);
      test.x = boundsOffset;
       PVector mercator = proj.transformCoords(test);
       geo = proj.transformCoords(original);
    //   println("geo.x: "+geo.x+ "original.x: " + original.x + " boundsOffset:" + boundsOffset + " mercator: " + mercator.x + " test.x " + test.x +" tlcorner.x : "+tlCorner.x + "brCorner.x " +brCorner.x); 
   PVector overflowVector = new PVector(map(mercator.x,tlCornerLEFT.x,brCornerLEFT.x,0, width-mapWidth),
                     map(mercator.y,tlCornerLEFT.y,brCornerLEFT.y,0,height) +yoffset);
       //  ellipse(overflowVector.x, overflowVector.y, 10, 10);
         return overflowVector;
    }
       geo = proj.transformCoords(original);
          return new PVector(map(geo.x,tlCorner.x,brCorner.x,0,mapWidth)+offset+boundsOffset,
                     map(geo.y,tlCorner.y,brCorner.y,0,height) +yoffset);
    }
 }

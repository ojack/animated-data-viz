 class Animal{

    float startDate; 
    float endDate; 
    boolean newYear; //0 if track does not go through new years, 1 if it does
   ArrayList path;
   PVector [] trail;
    int numPoints;
    WayPoint previous;
    WayPoint next;
    int currIndex;
    String trackingNumber;
    
    
    //constructor
    Animal(String _tracks){

     path = new ArrayList();
     float lowestPoint = loadPoints(_tracks);
     startDate = 0;
     endDate = 0;
       if (numPoints > 1) {
         startDate = ((WayPoint) path.get(0)).time;
          endDate = ((WayPoint) path.get(numPoints-1)).time;
          if (endDate > startDate) {
             newYear = false;
            previous = (WayPoint) path.get(0);
      next = (WayPoint) path.get(1);
         } else {
         previous = (WayPoint) path.get(currIndex-1);
      next = (WayPoint) path.get(currIndex);
      newYear = true; 
     }
     println("  Start Date: " + startDate + " End Date: " + endDate + "new year? " + newYear);
     trail = new PVector[trailLength];
     for(int i = 0; i< trailLength; i++){
       trail[i] = new PVector(0,0);
     }
     
       } else { 
         println("Failed to load! bummmmmmmmmmmmmerrrrr. try again, you're great");
       }
    

    }
    
    
    
    //methods
    
    void drawTrail(color clr){
    float frontAlpha = alphaVal-frontStep;
    float backAlpha = 0.1;
   
    for (int i = (trail.length-1); i > (trail.length-backFade); i--) {
     //  fill(clr, backAlpha);
    // int backAlpha = map(
     fill(clr,12);
        ellipse(trail[i].x, trail[i].y, 3, 3);
        backAlpha += backStep;
    }
     fill(clr, alphaVal);
      for(int i = (trail.length-backFade); i > frontFade; i--){
       
         ellipse(trail[i].x, trail[i].y, 3, 3);
      }
      
        for(int i = (frontFade); i > 4; i--){
         frontAlpha += frontStep;
        fill(clr, frontAlpha);
         ellipse(trail[i].x, trail[i].y, 3, 3);
      }
      fill(clr, 120);
      ellipse(trail[4].x, trail[4].y, 3, 3);
        fill(clr, 140);
      ellipse(trail[3].x, trail[3].y, 3, 3);
        fill(clr, 180);
      ellipse(trail[2].x, trail[2].y, 3, 3);
       fill(clr, 230);
      ellipse(trail[1].x, trail[1].y, 3, 3);
      fill(clr, 255);
      ellipse(trail[0].x, trail[0].y, 3, 3);
    
   
    }
    
    void showCurrentPoint(){
      text(trackingNumber, trail[0].x, trail[0].y);
    }
    
    
    void updateTrail(float lon, float lat){
          PVector[] newTrail = new PVector[trailLength];
      arrayCopy(trail, 0, newTrail, 1, trailLength-1);
        newTrail[0] = new PVector(lon, lat);
        trail = newTrail;
    }
    
    
    boolean containsDate(float date){
      if(!newYear){
        if ((date >= startDate) && (date <= endDate)){
          return true;
        } 
      } else {
        if ((date >= startDate) || (date <= endDate)){
          return true;
        }
        
      }
      return false;
        
    }   
      
    void showPoints(){
      for(int i = 0; i< numPoints; i++){
     text(((WayPoint) path.get(i)).time, ((WayPoint) path.get(i)).location.x, ((WayPoint) path.get(i)).location.y);
      ellipse(((WayPoint) path.get(i)).location.x, ((WayPoint) path.get(i)).location.y, 0.5, 0.5);
      }
    }
    
float loadPoints(String tokens){
     // (tokens);
     float lowestDate = 366;
      String[] data = splitTokens(tokens);
      if (data.length > 2){
        trackingNumber = new String(data[0]+" "+data[1]);
      for (int i = 2; i < data.length; i++){
        String[] singlePoint = splitTokens(data[i], ",");  
        if(singlePoint.length > 2){
         String[] lon = match(singlePoint[0], "(-?[0-9]?[0-9]?[0-9].[0-9][0-9]?[0-9]?)");
         String[] lat = match(singlePoint[1], "(-?[0-9]?[0-9]?[0-9].[0-9][0-9]?[0-9]?)");
      if (lon != null) {
      if (lat != null){ 
        float date = float(singlePoint[2]);
         path.add(new WayPoint(float(lon[0]), float(lat[0]), date));
         if (date < lowestDate) {
           lowestDate = date;
           currIndex = path.size()-1;
         }
     } else {
       println("NO LAT MATCH!: "+ singlePoint[1]);
     }
        } else {
       println("NO LON MATCH!: "+ singlePoint[0]);
     }
      }
      numPoints = path.size();
    }
      }
    return lowestDate;
    }
    
    //Only call when currTime is within range
PVector updateIndex(float currTime){
     while(currTime >= next.time){
             if (next.time < previous.time){
               if (currTime < (next.time + 365)){
               return orderedLocation(currTime, previous, next, true);
               } else {
                  stepForward();
               }
             }
           
          stepForward();
           
           }
           //  print(" current time = " + currTime + " next time = "+ next.time + "previous time = " + previous.time);
          return orderedLocation(currTime, previous, next, false);
      }
      
      
     /* void findLocation(currTime){
        
      }*/
      
 boolean withinNewYear(float currTime){
   //println("TESTING WHETHER WITHIN NEW YEAR. current is: " + currTime + " prev is " + previous.time + "  next is" + next.time);
   if((currTime > previous.time) && (currTime <= 365)){
   return true;
   }
   if ((currTime > 0) && (currTime < next.time)){
     return true;
   }
   return false;
   
 }
 
 void stepForward(){
   if(currIndex < (numPoints-1)){
        previous = next;
             next = (WayPoint) path.get(currIndex+1);
             currIndex++;
   } else {
     currIndex = 0;
     previous = (WayPoint) path.get(0);
     next = (WayPoint) path.get(1);
   }
 }
  
    //returns 0,0 if out of range
    PVector getLocation(float currTime){
       PVector previousV = new PVector(0, 0);
      PVector nextV = new PVector(0, 0);
        float prevTime = 0;
        float nextTime = 0;
        if(!containsDate(currTime)) {
          previous = (WayPoint) path.get(0);
          next = (WayPoint) path.get(1);
          return previousV;
        }
        if(next.time < previous.time){
          if(withinNewYear(currTime)) {
        //    print("WITHINNNNN!");
            return orderedLocation(currTime, previous, next, true);
          } else {
           stepForward();
          }
        }
         return updateIndex(currTime);
    }
    
    
    PVector orderedLocation(float currTime, WayPoint prevW, WayPoint nextW, boolean newYear){
       PVector previousV = prevW.location;
        PVector nextV = nextW.location;
        float prevTime = prevW.time;
        float nextTime = nextW.time;
        if(newYear){
          nextTime = 365 + nextW.time;
          if(currTime < prevW.time) currTime+=365;
        } else {
          if((currTime < prevW.time)||(currTime > nextW.time))
          return (new PVector(0,0));
        }
        PVector direction = PVector.sub(nextV, previousV);  
        direction.normalize();   
        float d = PVector.dist(nextV, previousV);
        direction.mult(d*((currTime-prevTime)/(nextTime-prevTime)));
       return PVector.add(direction, previousV);
    }
  }

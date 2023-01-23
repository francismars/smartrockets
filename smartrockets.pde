import java.util.*;
import java.util.concurrent.*;

public static final int INITIALROCKETS = 500;
public static final int TIMELIMIT = 900;
public static int INITIALFRAMERATE = 60;
public static boolean DEFAULTFASTRENDER = false;
public static final float INITIALMUTATION = 0.05;
public static final float INITIALANOMALIES = 0.05;

public static final float XSIZE = 400;
public static final float YSIZE = 600;
public static final int CANVASX = 600;
public static final int CANVASY = 610;

public static final float TARGETCENTERX = 200;
public static final float TARGETCENTERY = 50;
public static final float TARGETRADIUS = 50;
public static final float ROCKETINITIALX = 200;
public static final float ROCKETINITIALY = 500;

public static final float LOGOIMAGEX = XSIZE+15;
public static final float LOGOIMAGEY = 0+25;
public static final float LOGOIMAGEXSIZE = 170;
public static final float LOGOIMAGEYSIZE = 32;
public static final float STATEPANELX = XSIZE+15;
public static final float STATEPANELY = 0+125;
public static final float STATEPANELXSIZE = 100;
public static final float STATEPANELYSIZE = 75;
public static final float GENERATIONINFOX = XSIZE+15;
public static final float GENERATIONINFOY = 180;
public static final float GENERATIONINFOXSIZE = 100;
public static final float GENERATIONINFOYSIZE = 25;
public static final float SHOWFPSX = XSIZE+15;
public static final float SHOWFPSY = 205;
public static final float SHOWFPSXSIZE = 60;
public static final float SHOWFPSYSIZE = 25;
public static float LEVELBUTTONX = XSIZE+27;
public static float LEVELBUTTONY = 0+335;
public static float LEVELBUTTONXSIZE = 55;
public static float LEVELBUTTONYSIZE = 20;
public static float FASTRENDERBUTTONX = XSIZE+27;
public static float FASTRENDERBUTTONY = 365;
public static float FASTRENDERBUTTONXSIZE = 117;
public static float FASTRENDERBUTTONYSIZE = 20;
public static float ANOMALIESBUTTONX = XSIZE+27;
public static float ANOMALIESBUTTONY = 395;
public static float ANOMALIESBUTTONXSIZE = 134;
public static float ANOMALIESBUTTONYSIZE = 20;
public static float MUTATIONBUTTONX = XSIZE+27;
public static float MUTATIONBUTTONY = 425;
public static float MUTATIONBUTTONXSIZE = 143;
public static float MUTATIONBUTTONYSIZE = 20;
public static float ROCKETSNUMBERBUTTONX = XSIZE+27;
public static float ROCKETSNUMBERBUTTONY = 455;
public static float ROCKETSNUMBERBUTTONXSIZE = 105;
public static float ROCKETSNUMBERBUTTONYSIZE = 20;
public static float HEURISTICBUTTONX = XSIZE+27;
public static float HEURISTICBUTTONY = 485;
public static float HEURISTICBUTTONXSIZE = 148;
public static float HEURISTICBUTTONYSIZE = 20;
public static final float DRAWPATHINFOX = XSIZE+27;
public static final float DRAWPATHINFOY = 515;
public static final float DRAWPATHINFOXSIZE = 108;
public static final float DRAWPATHINFOYSIZE = 20;
public static final float RESETBUTTONX = XSIZE+27;
public static final float RESETBUTTONY = 0+575;
public static final float RESETBUTTONXSIZE = 46;
public static final float RESETBUTTONYSIZE = 20;
public static float SPEEDBUTTONX = XSIZE+145;
public static float SPEEDBUTTONY = 0+575;
public static float SPEEDBUTTONXSIZE = 28;
public static float SPEEDBUTTONYSIZE = 20;

private boolean fastRender;
private int maxCores;
private int chunkSize;
private Thread[] threadsList;
private Rocket[] rockets;
private ArrayList<Obstacle> Obstacles;
private Target target;
private boolean targetMoved;
private boolean obsMoved;
private boolean obsDrawing;
private int obsMovedid;
private float mouseDistX;
private float mouseDistY;
private int generationCounter;
private Obstacle drawingObstacle; 
private int initialClickX;
private int initialClickY;
private int frameCycle;
private boolean drawingPath;
private boolean heuristicASTAR;
private int rocketsNumber;
private String speedText;
private Semaphore mutexFitness;
private int levelDisp;

private float mutationPercentage;
private float anomaliesPercentage;

PImage backgroundImage;
PImage targetImage;
PImage rocketImage;
PImage rocketTailImage;
PImage logoImage;
PFont fontType;

public void settings() {
  size(CANVASX,CANVASY, P3D);
}

public void setup() {
  fontType = createFont("LoRes9OTNarrow-Regular.ttf", 13);
  textFont(fontType);
  fastRender=DEFAULTFASTRENDER;
  mutationPercentage=INITIALMUTATION;
  anomaliesPercentage=INITIALANOMALIES;
  rocketsNumber=INITIALROCKETS;
  levelDisp = 1;
  initilizeRockets();
  initializeObstacles();
  initializeTarget();
  targetMoved = false;
  obsDrawing = false;
  obsMoved = false;
  obsMovedid = -1;
  mouseDistX = 0;
  mouseDistY = 0;
  generationCounter=0;
  frameCycle=0;
  drawingPath=false;
  heuristicASTAR=false;
  backgroundImage = loadImage("./art/background.png");
  targetImage = loadImage("./art/moon.png");
  rocketImage = loadImage("./art/rocket.png");
  rocketTailImage = loadImage("./art/rocketTail.png");
  logoImage = loadImage("./art/logo.png"); 
  speedText ="1X";
  mutexFitness = new Semaphore(1);
  maxCores = Runtime.getRuntime().availableProcessors();
  threadsList = new Thread[maxCores];
  frameRate(INITIALFRAMERATE);
}

public void initializeTarget(){
  if (levelDisp==1 || levelDisp==0 || levelDisp==2){
    target = new Target(TARGETCENTERX, TARGETCENTERY, TARGETRADIUS);
  }
  if (levelDisp==3){
    target = new Target(325, 325, TARGETRADIUS);
  }
  if (levelDisp==4){
    target = new Target(200, 200, TARGETRADIUS);
  }
}

public void initializeObstacles(){
  Obstacles = new ArrayList<Obstacle>();
  if (levelDisp==0){ 
  }
  if (levelDisp==1){
    Obstacle obstacle1 = new Obstacle(new PVector(0, 200), new PVector(250, 15));
    Obstacles.add(obstacle1);
    Obstacle obstacle2 = new Obstacle(new PVector(150, 375), new PVector(250, 15));
    Obstacles.add(obstacle2);
  }
  if (levelDisp==2){
    Obstacle obstacle1 = new Obstacle(new PVector(0, 300), new PVector(300, 15));
    Obstacles.add(obstacle1);
    Obstacle obstacle2 = new Obstacle(new PVector(100, 200), new PVector(300, 15));
    Obstacles.add(obstacle2);
    Obstacle obstacle3 = new Obstacle(new PVector(100, 400), new PVector(300, 15));
    Obstacles.add(obstacle3);
  }  
  if (levelDisp==3){
    Obstacle obstacle1 = new Obstacle(new PVector(100, 400), new PVector(300, 15));
    Obstacles.add(obstacle1);
    Obstacle obstacle2 = new Obstacle(new PVector(100, 100), new PVector(15, 315));
    Obstacles.add(obstacle2);
  }  
  if (levelDisp==4){
    Obstacle obstacle1 = new Obstacle(new PVector(100, 400), new PVector(300, 15));
    Obstacles.add(obstacle1);
    Obstacle obstacle2 = new Obstacle(new PVector(100, 100), new PVector(15, 315));
    Obstacles.add(obstacle2);
    Obstacle obstacle3 = new Obstacle(new PVector(100, 100), new PVector(200, 15));
    Obstacles.add(obstacle3);
    Obstacle obstacle4 = new Obstacle(new PVector(285, 100), new PVector(15, 200));
    Obstacles.add(obstacle4);
  }
}

public void initilizeRockets() {
  rockets = new Rocket[rocketsNumber];
  generationCounter=0;
  for (int i = 0; i < rocketsNumber; i++) {
    Rocket rocket = new Rocket(ROCKETINITIALX, ROCKETINITIALY);
    rockets[i] = rocket;
  }
  frameCycle=0;
}
  
 
public void draw() {
  if (frameCycle<TIMELIMIT){
    background(150);    
    stroke(255,255,255);
    image(backgroundImage, 0, 0, XSIZE, YSIZE);
    for (Obstacle obstacle : Obstacles) {      
      obstacle.run();
    }    
    if (drawingPath){
      ArrayList<HashMap<ArrayList<Node>, Float>> AStarPaths = new ArrayList<HashMap<ArrayList<Node>, Float>>();
      chunkSize = rocketsNumber/maxCores;
      for (int i = 0; i<maxCores; i++)  {
        int startI = i * chunkSize;
        int endI = (i < maxCores - 1) ? (i+1) * chunkSize : rocketsNumber;     
        threadsList[i] = new Thread( () -> {
          for(int j=startI; j<endI; j++) {
            ArrayList<Integer> start = new ArrayList<Integer>();
            start.add(0,int(rockets[j].getPosition().x));
            start.add(1,int(rockets[j].getPosition().y));
            ArrayList<Integer> goal = new ArrayList<Integer>();
            goal.add(0,int(target.getX()));
            goal.add(1,int(target.getY()));
            AStarPaths.add(rockets[j].A_Star(start, goal));
          }
        });
        threadsList[i].start();
      }
      for (Thread t : threadsList) {
        try {
          t.join();   
        } catch (InterruptedException e) {
          e.printStackTrace();
        }
      }
      for (HashMap<ArrayList<Node>, Float> AStarPathTemp : AStarPaths){
        for (ArrayList<Node> nodeListTemp : AStarPathTemp.keySet()) {
          for (Node nodeTemp : nodeListTemp) {
            stroke(255,0,0);
            point(nodeTemp.x,nodeTemp.y);
          }
        }
      }
    }
    target.run();
    if (fastRender){
      for (int j = frameCycle; j<TIMELIMIT;j++){
        for (int i = 0; i<rocketsNumber; i++)  {
          rockets[i].run();
        }    
      }
      frameCycle=TIMELIMIT;
      for (int i = 0; i<rocketsNumber; i++)  {
        rockets[i].render();
      }
    }
    else if (!fastRender){    
      for (int i = 0; i<rocketsNumber; i++)  {
        rockets[i].run();
      }
    }
    if (obsDrawing){
      rectMode(CORNERS);
      drawingObstacle.run();
      rectMode(CORNER);
    }
  } 
  else if (frameCycle>=TIMELIMIT){
    handleReproduction();
    frameCycle=0;
  }
  drawGUI(); 
  if (!targetMoved && !obsMoved && !obsDrawing){
    frameCycle++;
  }
}

public void handleReproduction(){
  HashMap<Integer, PVector> rocketsFitness = new HashMap<Integer, PVector>();
  ArrayList<PVector> smallestFitness = new ArrayList<PVector>();
  smallestFitness.add(0, new PVector (999999, 999999));
  smallestFitness.add(1, new PVector (999999, 999999));
  ArrayList<Integer> smallestFitnessIDS = new ArrayList<Integer>();
  smallestFitnessIDS.add(0,-1);
  smallestFitnessIDS.add(1,-1);
  chunkSize = rocketsNumber/maxCores;
  for (int i = 0; i<maxCores; i++)  {
    int startI = i * chunkSize;
    int endI = (i < maxCores - 1) ? (i+1) * chunkSize : rocketsNumber;     
    threadsList[i] = new Thread( () -> {
      for(int j=startI; j<endI; j++) {
        try{
          PVector fitness = rockets[j].calculateFitness();
          mutexFitness.acquire();
          rocketsFitness.put(j, fitness);
          mutexFitness.release();
        } catch(InterruptedException e) {
          e.printStackTrace();
        }
    
      }
    });
    threadsList[i].start();
  }
  for (Thread t : threadsList) {
    try {
      t.join();   
    } catch (InterruptedException e) {
      e.printStackTrace();
    }
  }       
  for(int j = 0; j< rocketsNumber; j++){
    if (rocketsFitness.get(j).x<=smallestFitness.get(0).x){
      if (rocketsFitness.get(j).y<=smallestFitness.get(0).y){
        smallestFitness.set(0, rocketsFitness.get(j));
        smallestFitnessIDS.set(0, j);
      }
    }  
  }  
  for(int i = 0; i< rocketsNumber; i++){
    if (rocketsFitness.get(i).x<=smallestFitness.get(1).x && rocketsFitness.get(i).x>=smallestFitness.get(0).x && i!=smallestFitnessIDS.get(0)){
      if (rocketsFitness.get(i).y<=smallestFitness.get(1).y){
        smallestFitness.set(1, rocketsFitness.get(i));
        smallestFitnessIDS.set(1, i);
      }
    }
  }
  ArrayList<PVector> fatherChromosome = new ArrayList<PVector>();
  fatherChromosome = rockets[smallestFitnessIDS.get(0)].rocketDNA.getChromosome();
  ArrayList<PVector> motherChromosome = new ArrayList<PVector>();
  motherChromosome = rockets[smallestFitnessIDS.get(1)].rocketDNA.getChromosome();
  for(int i = 0; i< rocketsNumber; i++){ 
    rockets[i].resetPosition();
    rockets[i].rocketDNA.newGeneration(fatherChromosome, motherChromosome);
    if ((rockets[i].rocketDNA.getChromosome()).size()==0){ print("rocket vazio :",i);}
  }
  generationCounter++;
}

public void takePic(){
    if (frameCount%2==0){
      saveFrame("/recording/"+(100000+frameCount)+".png");  
    }  
}

public void drawGUI(){
  // Draw GUI Canvas
  strokeWeight(3);
  stroke(132, 207, 202);
  line(XSIZE, 0, XSIZE, CANVASY);
  noStroke();
  fill(0,0,0);
  rect(XSIZE, 0, CANVASX-XSIZE, CANVASY);
  // Draw Logo
  image(logoImage, LOGOIMAGEX, LOGOIMAGEY, LOGOIMAGEXSIZE, LOGOIMAGEYSIZE);
  // Draw Time Elapsed Bar
  fill(132, 207, 202);
  rect(0, YSIZE, XSIZE, 10);
  fill(249, 219, 96);
  float auxCalc = (TIMELIMIT/XSIZE);
  float percentageleft = (TIMELIMIT-frameCycle)/auxCalc;
  rect(0, YSIZE, percentageleft, 10);     
  // Draw State Pannel
  int totalRun=0;
  int totalWall=0;
  int totalTarget=0;
  for(int i = 0; i< rocketsNumber; i++){ 
    if (rockets[i].state==RUNNING){totalRun++;}
    if (rockets[i].state==WALL){totalWall++;}
    if (rockets[i].state==TARGET){totalTarget++;}
    }
  fill(132, 207, 202);
  text("RUNNING: "+totalRun, STATEPANELX+12, STATEPANELY+17);
  text("CRASHED: "+totalWall, STATEPANELX+12, STATEPANELY+17+15);
  text("TARGET: "+totalTarget, STATEPANELX+13, STATEPANELY+17+30);
  strokeWeight(1);
  stroke(132, 207, 202);
  line(STATEPANELX+13, STATEPANELY+55, STATEPANELX+110, STATEPANELY+55);
  // Draw Generation Pannel
  noFill();
  noStroke();
  rect(GENERATIONINFOX, GENERATIONINFOY, GENERATIONINFOXSIZE, GENERATIONINFOYSIZE);
  fill(132, 207, 202);
  text("GENERATION: "+generationCounter, GENERATIONINFOX+12, GENERATIONINFOY+17);
  strokeWeight(1);
  stroke(132, 207, 202);
  line(GENERATIONINFOX+13, GENERATIONINFOY+25, GENERATIONINFOX+70, GENERATIONINFOY+25);
  // SHOW FPS
  noFill();
  noStroke();
  rect(SHOWFPSX, SHOWFPSY, SHOWFPSXSIZE, SHOWFPSYSIZE);
  fill(132, 207, 202);
  text("FPS: "+ (int)frameRate, SHOWFPSX+12, SHOWFPSY+17);
  // Draw Level Button
  fill(0);
  strokeWeight(1);
  stroke(132, 207, 202);
  rect(LEVELBUTTONX, LEVELBUTTONY, LEVELBUTTONXSIZE, LEVELBUTTONYSIZE,7);
  fill(132, 207, 202);  
  text("LEVEL: "+levelDisp, LEVELBUTTONX+5, LEVELBUTTONY+14);
  // Draw Fast Render Button
  fill(0);
  strokeWeight(1);
  stroke(132, 207, 202);
  rect(FASTRENDERBUTTONX, FASTRENDERBUTTONY, FASTRENDERBUTTONXSIZE, FASTRENDERBUTTONYSIZE,7);
  fill(132, 207, 202);  
  text("FAST RENDER: "+(fastRender?"ON":"OFF"), FASTRENDERBUTTONX+5, FASTRENDERBUTTONY+14); 
  // Draw Anomalies Button
  fill(0);
  strokeWeight(1);
  stroke(132, 207, 202);
  rect(ANOMALIESBUTTONX, ANOMALIESBUTTONY, ANOMALIESBUTTONXSIZE, ANOMALIESBUTTONYSIZE,7);
  fill(132, 207, 202);  
  text("ANOMALY RATE: "+anomaliesPercentage, ANOMALIESBUTTONX+5, ANOMALIESBUTTONY+14);
  // Draw Mutation Button
  fill(0);
  strokeWeight(1);
  stroke(132, 207, 202);
  rect(MUTATIONBUTTONX, MUTATIONBUTTONY, MUTATIONBUTTONXSIZE, MUTATIONBUTTONYSIZE,7);
  fill(132, 207, 202); 
  text("MUTATION RATE: "+mutationPercentage, MUTATIONBUTTONX+5, MUTATIONBUTTONY+14);
  // Draw Rockets Number Button
  fill(0);
  strokeWeight(1);
  stroke(132, 207, 202);
  rect(ROCKETSNUMBERBUTTONX, ROCKETSNUMBERBUTTONY, ROCKETSNUMBERBUTTONXSIZE, ROCKETSNUMBERBUTTONYSIZE,7);
  fill(132, 207, 202); 
  text("ROCKETS: "+rocketsNumber, ROCKETSNUMBERBUTTONX+5, ROCKETSNUMBERBUTTONY+14);
  // Draw Heuristics Button
  fill(0);
  strokeWeight(1);
  stroke(132, 207, 202);
  rect(HEURISTICBUTTONX, HEURISTICBUTTONY, HEURISTICBUTTONXSIZE, HEURISTICBUTTONYSIZE, 7);
  fill(132, 207, 202); 
  text("HEURISTIC: "+(heuristicASTAR? "PATH" : "EUCLIDEAN"), HEURISTICBUTTONX+5, HEURISTICBUTTONY+14);
  // Draw Path Button
  fill(0);
  strokeWeight(1);
  stroke(132, 207, 202);
  rect(DRAWPATHINFOX, DRAWPATHINFOY, DRAWPATHINFOXSIZE, DRAWPATHINFOYSIZE, 7);
  fill(132, 207, 202); 
  text("DRAW PATH: "+(drawingPath? "YES" : "NO"), DRAWPATHINFOX+5, DRAWPATHINFOY+14);  
  // Draw Reset Button
  noStroke();
  fill(249, 219, 96);
  rect(RESETBUTTONX, RESETBUTTONY, RESETBUTTONXSIZE, RESETBUTTONYSIZE, 7);
  fill(0);
  text("RESET", RESETBUTTONX+5, RESETBUTTONY+14);
  // Draw Speed Button
  noStroke();
  fill(132, 207, 202); 
  rect(SPEEDBUTTONX, SPEEDBUTTONY, SPEEDBUTTONXSIZE, SPEEDBUTTONYSIZE, 7);
  fill(0);
  text(speedText, SPEEDBUTTONX+5, SPEEDBUTTONY+14);
}

public void mousePressed() {
  if (mouseButton == RIGHT){
    for (int i=0;i<Obstacles.size();i++) {
      Obstacle obstacle = Obstacles.get(i);
      if ((mouseX > obstacle.getObPoint().x) && (mouseX < obstacle.getObPoint().x+(obstacle.getObSize().x))) {
        if ((mouseY > obstacle.getObPoint().y) && (mouseY < obstacle.getObPoint().y+(obstacle.getObSize().y))) {
          Obstacles.remove(i);
        } 
      }
    }
  } 
  else if (mouseButton == LEFT){
    if (mouseX > XSIZE) {
      if ((mouseX > RESETBUTTONX) && (mouseX < RESETBUTTONX+RESETBUTTONXSIZE)) {
        if ((mouseY > RESETBUTTONY) && (mouseY < RESETBUTTONY+RESETBUTTONYSIZE)) {
          initilizeRockets();
        }
      }
      if ((mouseX > DRAWPATHINFOX) && (mouseX < DRAWPATHINFOX+DRAWPATHINFOXSIZE)) {
        if ((mouseY > DRAWPATHINFOY) && (mouseY < DRAWPATHINFOY+DRAWPATHINFOYSIZE)) {
          drawingPath=!drawingPath;
        }
      }
      if ((mouseX > FASTRENDERBUTTONX) && (mouseX < FASTRENDERBUTTONX+FASTRENDERBUTTONXSIZE)) {
        if ((mouseY > FASTRENDERBUTTONY) && (mouseY < FASTRENDERBUTTONY+FASTRENDERBUTTONYSIZE)) {
          fastRender=!fastRender;
        }
      }
      if ((mouseX > HEURISTICBUTTONX) && (mouseX < HEURISTICBUTTONX+HEURISTICBUTTONXSIZE)) {
        if ((mouseY > HEURISTICBUTTONY) && (mouseY < HEURISTICBUTTONY+HEURISTICBUTTONYSIZE)) {
          heuristicASTAR=!heuristicASTAR;
        }
      }
      if ((mouseX > LEVELBUTTONX) && (mouseX < LEVELBUTTONX+LEVELBUTTONXSIZE)) {
        if ((mouseY > LEVELBUTTONY) && (mouseY < LEVELBUTTONY+LEVELBUTTONYSIZE)) {
          switch(levelDisp){
            case 0: levelDisp=1; break;
            case 1: levelDisp=2; break;
            case 2: levelDisp=3; break;
            case 3: levelDisp=4; break;
            case 4: levelDisp=0; break;
            default: levelDisp=1; break;
          }
          initializeObstacles();
          initializeTarget();
        }
      }
      if ((mouseX > SPEEDBUTTONX) && (mouseX < SPEEDBUTTONX+SPEEDBUTTONXSIZE)) {
        if ((mouseY > SPEEDBUTTONY) && (mouseY < SPEEDBUTTONY+SPEEDBUTTONYSIZE)) {
          switch(speedText){
            case "1X": speedText="2X";frameRate(120); break;
            case "2X": speedText="3X";frameRate(180); break;
            case "3X": speedText="1X";frameRate(60); break;
            default: speedText="1X"; break;
          }
        }
      }
      if ((mouseX > MUTATIONBUTTONX) && (mouseX < MUTATIONBUTTONX+MUTATIONBUTTONXSIZE)) {
        if ((mouseY > MUTATIONBUTTONY) && (mouseY < MUTATIONBUTTONY+MUTATIONBUTTONYSIZE)) {
          switch(String.valueOf(mutationPercentage)){
            case "0.0": mutationPercentage=0.01; break;
            case "0.01": mutationPercentage=0.05; break;
            case "0.05": mutationPercentage=0.1; break;
            case "0.1": mutationPercentage=0.0; break;
            default: mutationPercentage=0.05; break;
          }
        }
      }
      if ((mouseX > ANOMALIESBUTTONX) && (mouseX < ANOMALIESBUTTONX+ANOMALIESBUTTONXSIZE)) {
        if ((mouseY > ANOMALIESBUTTONY) && (mouseY < ANOMALIESBUTTONY+ANOMALIESBUTTONYSIZE)) {
          switch(String.valueOf(anomaliesPercentage)){
            case "0.0": anomaliesPercentage=0.01; break;
            case "0.01": anomaliesPercentage=0.05; break;
            case "0.05": anomaliesPercentage=0.1; break;
            case "0.1": anomaliesPercentage=0.0; break;
            default: anomaliesPercentage=0.05; break;
          }
        }
      }
      if ((mouseX > ROCKETSNUMBERBUTTONX) && (mouseX < ROCKETSNUMBERBUTTONX+ROCKETSNUMBERBUTTONXSIZE)) {
        if ((mouseY > ROCKETSNUMBERBUTTONY) && (mouseY < ROCKETSNUMBERBUTTONY+ROCKETSNUMBERBUTTONYSIZE)) {
          switch(rocketsNumber){
            case 2: rocketsNumber=10; break;
            case 10: rocketsNumber=25; break;
            case 25: rocketsNumber=50; break;
            case 50: rocketsNumber=100; break;
            case 100: rocketsNumber=250; break;
            case 250: rocketsNumber=500; break;
            case 500: rocketsNumber=1000; break;
            case 1000: rocketsNumber=2; break;
            default: rocketsNumber=2;
          }
          initilizeRockets();
        }
      }
    }
    else if (mouseX <= XSIZE){
      if (mouseY <= YSIZE){
        if (!obsMoved && !obsDrawing && !obsMoved){
          if (dist(mouseX, mouseY, target.getX(), target.getY()) < CIRCLERADIUS/2){
            targetMoved=true;
            mouseDistX= mouseX - target.getX();
            mouseDistY= mouseY - target.getY();
          }
          else{ // IF target not moved, maybe move object
            for (int i=0;i<Obstacles.size();i++) {
              Obstacle obstacle = Obstacles.get(i);
              if ((mouseX > obstacle.getObPoint().x) && (mouseX < obstacle.getObPoint().x+obstacle.getObSize().x)) {
                if ((mouseY > obstacle.getObPoint().y) && (mouseY < obstacle.getObPoint().y+obstacle.getObSize().y)) {
                  obsMoved=true;
                  obsMovedid=i;
                  mouseDistX= mouseX - obstacle.getObPoint().x;
                  mouseDistY= mouseY - obstacle.getObPoint().y;
                }
              }
            }
            if (obsMoved==false){ // IF obstacle not moved, create obstacle
              initialClickX = mouseX;
              initialClickY = mouseY;
              drawingObstacle = new Obstacle(new PVector(initialClickX, initialClickY), new PVector(mouseX, mouseY));
              obsDrawing = true;
            }
          }   
        }
      }
    }
  }
}

public void mouseDragged() {
  if (obsDrawing){
    drawingObstacle = new Obstacle(new PVector(initialClickX, initialClickY), new PVector(mouseX, mouseY));
  }
  else if(obsMoved){
    if (obsMovedid==-1){
      for (int i=0;i<Obstacles.size();i++) {         
        Obstacle obstacle = Obstacles.get(i);
        if ((mouseX > obstacle.getObPoint().x) && (mouseX < obstacle.getObPoint().x+obstacle.getObSize().x)) {
          if ((mouseY > obstacle.getObPoint().y) && (mouseY < obstacle.getObPoint().y+obstacle.getObSize().y)) {
            obsMovedid=i;
          }
        }
      } 
    } else if (obsMovedid!=-1){
      Obstacle obstacle = Obstacles.get(obsMovedid);
      obstacle.setX(mouseX-mouseDistX);
      obstacle.setY(mouseY-mouseDistY);
    }
  }          
  else if (targetMoved){
    target.setX(mouseX-mouseDistX);
    target.setY(mouseY-mouseDistY);     
  }
}


public void mouseReleased() {
  if (obsDrawing){
    PVector ObstacleXY = new PVector(Float.MAX_VALUE,Float.MAX_VALUE);
    float distanceY = Float.MAX_VALUE;
    float distanceX = Float.MAX_VALUE;
    if (mouseX>initialClickX){      
      if (mouseY>initialClickY){
        distanceY = mouseY-initialClickY;
        distanceX = mouseX-initialClickX;
        ObstacleXY = new PVector(initialClickX, initialClickY);
      }
      else if (mouseY<=initialClickY){
        distanceY = initialClickY-mouseY;
        distanceX = mouseX-initialClickX;
        ObstacleXY = new PVector(initialClickX, mouseY);
      }   
    }
    else if (mouseX<=initialClickX){
      if (mouseY>initialClickY){
        distanceX = initialClickX-mouseX;
        distanceY = mouseY-initialClickY;
        ObstacleXY = new PVector(mouseX, initialClickY);
      }
      else if (mouseY<=initialClickY){
        distanceX = initialClickX-mouseX;
        distanceY = initialClickY-mouseY;
        ObstacleXY = new PVector(mouseX, mouseY);
      }
    }
    if (distanceY!=Float.MAX_VALUE && distanceX!=Float.MAX_VALUE && Math.abs(distanceY)>5 && Math.abs(distanceX)>5){
      Obstacle newObstacle = new Obstacle(ObstacleXY, new PVector(distanceX, distanceY));
      Obstacles.add(newObstacle);  
    }
    obsDrawing=false;
  }
  else if (targetMoved){    
    targetMoved=false;
    mouseDistX=0;
    mouseDistY=0;
  }
  else if (obsMoved){
    obsMoved=false;
    obsMovedid=-1;
    mouseDistX=0;
    mouseDistY=0;
  }
}

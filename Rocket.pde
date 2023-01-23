import java.util.*;

public static final int MAXSPEED = 2;
public static final float MAXFORCE = 0.25;
public static final float R = 20.0;

public static final float CIRCLERADIUS = 50;

public static final int RUNNING = 0;
public static final int WALL = -1;
public static final int TARGET = 1;


class Rocket {
  private PVector position;
  private PVector velocity;
  private PVector acceleration;  
  private int currentInstruction;
  private float r;
  private float maxforce;
  private float maxspeed;
  private int state;
  private DNA rocketDNA;
  private float initalPosX;
  private float initalPosY;
  private long timeTaken;

  public Rocket(float x, float y) {
    state = RUNNING;
    initalPosX = x;
    initalPosY = y;
    rocketDNA = new DNA();
    acceleration = new PVector(0, 0);
    velocity = new PVector(0, 0);
    position = new PVector(x, y);
    r = R;
    maxspeed = MAXSPEED;
    maxforce = MAXFORCE;
    currentInstruction = 0;
    timeTaken = 99999;
  }
  
  public PVector getPosition(){
    return position;
  }
  public void run() {
    if (!targetMoved && !obsMoved && !obsDrawing){
      if (rocketDNA.getChromosomeLength()>0 && state == RUNNING){      
        this.update();
        checkTarget();
        borders();   
        checkObstacle();
      }      
    }
    if (!fastRender){
      render();
    }
    
  }
  
  // Method to update position
  public void update() {
    if (state == RUNNING){
      if (frameCount%1==0){
        if (currentInstruction<this.rocketDNA.getChromosomeLength()){
          applyForce(this.rocketDNA.getAllele(currentInstruction));
          currentInstruction++;
        }
        else{
          println("Instructions Array is Over");
        }
      } 
    }
      
  }
  
  public void render() {
    float theta = velocity.heading() + radians(90);
    pushMatrix();
    translate(position.x, position.y);
    rotate(theta);
    float rocketTailsize = (state==WALL) ? 0 : state==TARGET? 0 : r/4*(velocity.mag());
    if (state==WALL){
      float alphaValue = 50;
      tint(255,alphaValue);   
    }
    image(rocketTailImage, -rocketTailsize/2, +rocketTailsize/2, rocketTailsize, rocketTailsize);
    image(rocketImage, -r/2, -r/2, r, r);   
    noTint();   
    popMatrix();    
  }  
    
  public void resetPosition(){
    position = new PVector(initalPosX, initalPosY);
    currentInstruction = 0;
    acceleration = new PVector(0, 0);
    velocity = new PVector(0, 0);
    timeTaken = 99999;
    state = RUNNING;
  }
  
  public void applyForce(PVector force) {
    acceleration.add(force);
    acceleration.limit(maxforce);
    velocity.add(acceleration);
    velocity.limit(maxspeed);
    position.add(velocity);
    acceleration.mult(0);
  }
  
  public void borders() {
    if((position.x <= (r/4)) || (position.y <= (r/4)) || (position.x >= XSIZE-(r/4)) || (position.y >= YSIZE-(r/4))){
      state = WALL;
    }
  }
     
  public void checkTarget() {
    if (dist(position.x, position.y, target.getX(), target.getY()) < CIRCLERADIUS/2){
      state = TARGET;
      timeTaken = this.currentInstruction;
    }
  }     
  
  public void checkObstacle() {
    for (Obstacle obstacle : Obstacles) {
      if ((position.x+r/4 > obstacle.getObPoint().x) && (position.x-r/4 < obstacle.getObPoint().x+(obstacle.getObSize().x))) {
        if ((position.y+r/4 > obstacle.getObPoint().y) && (position.y-r/4 < obstacle.getObPoint().y+(obstacle.getObSize().y))) {
          state = WALL;
        }      
      }
    }
  }  
  
  public PVector calculateFitness(){
    PVector finalResult = new PVector(99999, 99999);
    if (state==TARGET){
      finalResult = new PVector(CIRCLERADIUS/3, timeTaken);    
    }
    else if (state!=TARGET){
      if (!heuristicASTAR){      
        float d=dist(position.x, position.y, target.getX(), target.getY());
        finalResult = new PVector(d, timeTaken);
      }
      else if (heuristicASTAR){
        HashMap<ArrayList<Node>, Float> AStarPath = new HashMap<ArrayList<Node>, Float>();
        ArrayList<Integer> start = new ArrayList<Integer>();
        start.add(0,int(position.x));
        start.add(1,int(position.y));
        ArrayList<Integer> goal = new ArrayList<Integer>();
        goal.add(0,int(target.getX()));
        goal.add(1,int(target.getY()));
        AStarPath = A_Star(start, goal);
        PVector fitnessToReturn = new PVector();
        for (float distance : AStarPath.values()) {
          fitnessToReturn = new PVector(distance, timeTaken);
        }    
        finalResult = fitnessToReturn;
      }    
    }
    return finalResult;
  }
  
  public HashMap<ArrayList<Node>, Float> A_Star(ArrayList<Integer> start, ArrayList<Integer> goal){
    PriorityQueue<Node> openSet = new PriorityQueue<Node>();
    Node[][] nodeList = new Node[(int)XSIZE+1][(int)YSIZE+1];    
    for (int xI=0;xI<=XSIZE;xI++) for (int yI=0;yI<=YSIZE;yI++){      
      nodeList[xI][yI] = new Node(xI,yI,Float.MAX_VALUE,Float.MAX_VALUE);
      for (Obstacle obstacle : Obstacles) {
        if ((xI > obstacle.getObPoint().x) && (xI < obstacle.getObPoint().x+(obstacle.getObSize().x)) &&
        (yI > obstacle.getObPoint().y) && (yI < obstacle.getObPoint().y+(obstacle.getObSize().y))) {
          nodeList[xI][yI].fScore=-1;
          nodeList[xI][yI].gScore=-1;
        }               
      }
    }
    float goalX = goal.get(0);
    float goalY = goal.get(1);
    int startX = start.get(0);
    int startY = start.get(1);
    nodeList[startX][startY].gScore=0;
    nodeList[startX][startY].fScore=dist(startX,startY,goalX,goalY);
    openSet.add(new Node(startX,startY,dist(startX,startY,goalX,goalY),0));
    while(openSet.size()>0){
      Node current = openSet.remove();
      current.openSet=false;
      current.closedSet=true;
      int currentX = current.x;
      int currentY = current.y;
      if (currentX == goalX && currentY == goalY){
        return reconstruct_path(current);
      }    
      for(int xI2=(-1);xI2<=1;xI2++) for (int yI2=(-1);yI2<=1;yI2++){
        if (xI2!=0 || yI2!=0){
          if ((((currentX)+xI2)>0) && (((currentX)+xI2)<XSIZE) &&
          (((currentY)+yI2)>0) && (((currentY)+yI2)<YSIZE)){
            Node neighbor = nodeList[((currentX)+xI2)][((currentY)+yI2)];
            if(neighbor.gScore!=-1 && neighbor.closedSet==false) {
              float tentative_gScore = current.gScore+dist(neighbor.x,neighbor.y,currentX,currentY);
              if (tentative_gScore < neighbor.gScore){                  
                neighbor.cameFrom = current;
                neighbor.gScore = tentative_gScore;
                neighbor.fScore = tentative_gScore+dist(neighbor.x,neighbor.y,goalX,goalY);
                if (!neighbor.openSet){
                  openSet.add(neighbor);
                  neighbor.openSet=true;
                }
              }
            }
          }
        }
      }
    }
    return new HashMap<ArrayList<Node>, Float>();
  }
  
  public HashMap<ArrayList<Node>, Float> reconstruct_path(Node current){
    ArrayList<Node> total_path = new ArrayList<Node>();
    float totalDistance = 0;
    total_path.add(0, current);
    while (current.cameFrom!=null){
      current = current.cameFrom;
      total_path.add(0, current);
      if (current.cameFrom!=null){
        totalDistance+=dist(current.x,current.y,current.cameFrom.x,current.cameFrom.y);
      }
    }     
    HashMap<ArrayList<Node>, Float> temp = new HashMap<ArrayList<Node>, Float>();
    temp.put(total_path,totalDistance);
    return temp;
  }
    
  
  
}

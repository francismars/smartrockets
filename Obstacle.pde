class Obstacle{
  
  private PVector obPoint;
  private PVector obSize;
  
  public Obstacle(PVector Vector1, PVector Vector2){
    obPoint = Vector1;
    obSize = Vector2;
  }
  
  public PVector getObPoint(){
    return obPoint;
  }
  public PVector getObSize(){
    return obSize;
  }
  
  public void setX(float x){
    obPoint.x = x;
  }
  public void setY(float y){
    obPoint.y = y;
  }
  
  public void run() {
    render();
  }
  
  public void render() { 
    hint(DISABLE_OPTIMIZED_STROKE);
    fill(132, 207, 202);
    noStroke();
    rect(obPoint.x, obPoint.y, obSize.x, obSize.y);
    hint(ENABLE_OPTIMIZED_STROKE);
  }
  
}

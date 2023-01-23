class Target{
  private float targetX;
  private float targetY;
  private float targetSize;
  
  public Target(float x, float y, float size) {
    targetX = x;
    targetY = y;
    targetSize = size;
  }
  
  public float getX(){
    return targetX;
  }
  public float getY(){
    return targetY;
  }
  
  public void setX(float x){
    targetX = x;
  }
  public void setY(float y){
    targetY = y;
  }
  
  void run() {
    render();
  }
  
  void render() {  
    image(targetImage, targetX-(targetSize/2), targetY-(targetSize/2), targetSize, targetSize);
    tint(0, frameCount%100>=50? 50-(frameCount%50) : frameCount%50);
    image(targetImage, targetX-(targetSize/2), targetY-(targetSize/2), targetSize, targetSize);
    noTint();
  }
}

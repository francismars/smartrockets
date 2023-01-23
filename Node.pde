public class Node implements Comparable {
  int x;
  int y;
  float gScore;
  float fScore;
  Node cameFrom=null;
  boolean openSet=false;
  boolean closedSet=false;
  
  Node(int x, int y, float fScore, float gScore) {
    this.x=x;
    this.y=y;
    this.fScore=fScore;
    this.gScore=gScore;
  }
  
  //Comparator for the Queue
  @Override
    public int compareTo(Object o) {
    Node n=(Node) o;
    return this.fScore-n.fScore>0?1:-1;
  }
  
  //For debugging
  @Override
    public String toString() {
      return x+" "+y+" "+g+" | + +";
    }
}

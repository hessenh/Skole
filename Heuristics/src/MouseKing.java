
import java.util.Vector;

/*
	See problem description in MouseKingState.java
*/

public class MouseKing extends AStar{
  
  public MouseKing(Node i, Node g) {
    initialnode = i;
    goalnode = g;
  }

  public static void main(String[] args) {
    
    int initarray[] = {1,1};
    int goalarray[] = {5,1};		

    MouseKingState initsta = new MouseKingState(initarray);
    MouseKingState goalsta = new MouseKingState(goalarray);

    Node in = new Node(initsta, 0);
    Node go = new Node(goalsta, 0);
    
    MouseKing a = new MouseKing(in, go);
    a.solve();
  }
}



import java.util.Vector;

public abstract class AStar {	

  public Node initialnode;  // Start node
  public Node goalnode;     // Desired goal node
  public Node n;            // Node retrieved from OPEN
  public Node tempNode;     // Temporary node

  public Vector<Node> OPEN;       // Vector with Node elements
  public Vector<Node> CLOSED;     //
  public Vector<Node> M;          //

  private long startTime;   // Timing variables
  private long endTime;     //

  private int low;          // Used when selecting a node to retrive from OPEN 
  private int lowIndex;     // 

  private int number;       // Temporary integer storage
  
  public void solve() {

    startTime = System.currentTimeMillis();

    // Initializing the initial node
    initialnode.f = initialnode.h = initialnode.estimate(goalnode);
    initialnode.g = 0;
    
    // Instantiating OPEN, CLOSED and M
    OPEN = new Vector<Node>();
    CLOSED = new Vector<Node>();
    M = new Vector<Node>();

    // Placing initial node on OPEN
    OPEN.add(0, initialnode);

    // After finishing the initial phase, we enter the main loop 
	 // of the A* algorithm
    while (true) {

      // Check if OPEN is empty, exit if this is the case
      if (OPEN.size() == 0) {
		  System.out.println("Failure to solve problem:");
		  System.out.println("  OPEN is empty, exiting...");
		  return;
      }
      
      // Check if too much time has been used...
      if (CLOSED.size() == 8000) System.out.println("\nFinding a solution is taking longer than expected...");
      if (CLOSED.size() == 15000) {
		  System.out.println("Failure to solve problem:");
		  System.out.println("  No solution found within time limit...");
		  return;
      }

      // Locate next node to retrieve from OPEN, based on lowest heuristic
      lowIndex = 0;
      low = OPEN.elementAt(0).f; //low = ((Node)OPEN.elementAt(0)).f;
      for (int i = 0; i < OPEN.size(); i++) {
		  number = OPEN.elementAt(i).f; //number = ((Node)OPEN.elementAt(i)).f;
		  if (number < low) {
			 lowIndex = i;
			 low = number;
		  }
      }
      
      // Move selected node from OPEN to n
      n = OPEN.elementAt(lowIndex); //n = (Node) OPEN.elementAt(lowIndex);
      OPEN.removeElement(n);

      // Successful exit if n proves to be the goal node
      if (n.equals(goalnode)) {
		  endTime = System.currentTimeMillis();
		  printStatistics(n);
		  return;
      }

      // Retrieve all possible successors of n
      M = n.successors();

      // Compute f-, g- and h-value for every remaining successor
      for (int i = 0; i < M.size(); i++) {
		  Node s = M.elementAt(i); //Node s = ((Node)M.elementAt(i));
		  s.g = n.g + s.cost;
		  s.h = s.estimate(goalnode);
		  s.f = s.g + s.h;
      }

      // Establishing arcs from n to each member of M
      for (int i = 0; i < M.size(); i++) {
		  tempNode = (Node)M.elementAt(i);
		  tempNode.ancestor = n;
      }

      // Augmenting OPEN with suitable nodes from M
      for (int i = 0; i < M.size(); i++) {

		  // Determine if current node on M can be found on CLOSED
		  boolean onCLOSED = isOnVector(M.elementAt(i), CLOSED); //boolean onCLOSED = isOnVector((Node)M.elementAt(i), CLOSED);
		  
		  // Insert node into OPEN if it's not already on CLOSED
		  if (!(onCLOSED)) 
			 OPEN.add(0, M.elementAt(i)); //OPEN.insertElementAt(M.elementAt(i), 0);
      }

      // Insert n into CLOSED
      CLOSED.add(0, n); //CLOSED.insertElementAt(n, 0);
    }
  }
  
  // Determines whether or not node n can be found on vector v
  //
  public boolean isOnVector(Node n, Vector v) {
    for (int i = 0; i < v.size(); i++) {
      if (n.equals(v.elementAt(i))) { //if (n.equals((Node)v.elementAt(i))) {
		  return true;
      }
    }
    return false;
  }

  // Dumps final statistics to stdout
  //
  public void printStatistics(Node n) {
    System.out.println("Cost of solution: " + n.f);
    System.out.println("Number of CLOSED nodes: " + CLOSED.size());
    System.out.println("Number of still OPEN nodes: " + OPEN.size());
    System.out.println("Time (ms): " + (endTime - startTime));

    System.out.println("\nSolution path:\n");
    printTrail(n);
  }    

  public void printTrail(Node n) {
    if (n.ancestor != null) {
      printTrail(n.ancestor);
      System.out.println(n.toString());
    }
    else System.out.println(n.toString());
  }

} // END class AStar

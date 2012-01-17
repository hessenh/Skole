import java.util.Vector;

public abstract class IDAStar {	

  public Node initialnode;       // Start node
  public Node goalnode;          // Desired goal node
  public Node n;                 // Node retrieved from OPEN
  public Node tempNode;          // Temporary node

  public Vector<Node> OPEN;            // Node containers
  public Vector<Node> CLOSED;          //
  public Vector<Node> M;               //
  public Vector<Node> VISIT;           //

  private long startTime;        // Timing variables
  private long endTime;          //

  private int low;               // Used when selecting new cut-off value 
  private int number;            // 

  private int cutOff;            // Cut-off value

  public void solve() {

    startTime = System.currentTimeMillis();

    // Initializing the initial node
    initialnode.f = initialnode.h = initialnode.estimate(goalnode);
    initialnode.g = 0;
    cutOff = initialnode.h;
    
    // Instantiating OPEN, CLOSED and M
    OPEN = new Vector<Node>();
    CLOSED = new Vector<Node>();
    M = new Vector<Node>();
    VISIT = new Vector<Node>();

    // Placing initial node on OPEN
    OPEN.insertElementAt(initialnode, 0);

    // After finishing the initial phase, 
	 // we enter the main loop of the A* algorithm
    while (true) {
      while (OPEN.size() != 0) {

		  // Retrive next node from OPEN, call this node n
		  n = OPEN.elementAt(0); //n = (Node) OPEN.elementAt(0);
	
		  if (n.f <= cutOff)
			 CLOSED.add(0, n); //CLOSED.insertElementAt(n, 0);

		  OPEN.removeElement(n);
	
		  // Successful exit if n proves to be the goal node
		  if (n.equals(goalnode)) {
			 endTime = System.currentTimeMillis();
			 printStatistics(n);
			 return;
		  }

		  if (n.f <= cutOff) {
	  
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
				tempNode = M.elementAt(i); //tempNode = (Node)M.elementAt(i);
				tempNode.ancestor = n;
			 }
	  
			 // Augmenting OPEN with nodes from M
			 for (int i = 0; i < M.size(); i++) 
				OPEN.add(0, M.elementAt(i)); //OPEN.insertElementAt(M.elementAt(i), 0);
	  

		  } else {
			 VISIT.add(0, n); //VISIT.insertElementAt(n, 0);
		  }
      } // END while (OPEN.size() != 0)

      // No more nodes left to visit
      if (VISIT.size() == 0) {
		  System.out.println("Failure! Can't solve problem, exiting...");
		  return;
      }

      // Set new cut-off value to lowest f-value of nodes that are yet to
      // be expanded
      low = VISIT.elementAt(0).f; //low = ((Node)VISIT.elementAt(0)).f;
      for (int i = 0; i < VISIT.size(); i++) {
		  number = ((Node)VISIT.elementAt(i)).f;
		  if (number < low)
			 low = number;
      }

      // Set new cut-off value
      cutOff = low;

      // Move nodes from VISIT to OPEN
      for (int i = 0; i < VISIT.size(); i++) 
		  OPEN.add(0, VISIT.elementAt(i)); //OPEN.insertElementAt(VISIT.elementAt(i), 0);

      VISIT.removeAllElements();

    } // END while (true)

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

} // End class IDAStar

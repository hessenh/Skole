// This class defines a general node for use within the A*-algorithm.
// It relies on the existence of a specialized State class which 
// should provide details on the particular problem to be solved.
//
// Note that class variables are kept public, and should thus be
// accessed directly and not through class methods.
import java.util.Vector;

public class Node {
  public State state;     // Contains state information
  public int f;           // Value of heuristic evaluation function (f = g + h)
  public int g;           // Accumulated cost
  public int h;           // Estimate of remaining cost
  public int cost;        // Cost of this particular node
  public Node ancestor;   // Reference to the node's immediate parent

  // Constructor
  public Node(State s, int cost) {
    this.state = s;
    this.cost = cost;
  }

  // Equality check; uses the equality check of the State class
  public boolean equals(Node n) {
    if (state.equals(n.state)) {
      return true;
    } else {
      return false;
    }
  }

  // Convert node to string
  public String toString() {
    return "State=" + state.toString() + ", f=" + f + ", g=" + g + ", h=" + h;
  }

  // Check for ancestors
  public boolean hasAncestor() {
    if (ancestor != null) {
      return true;
    } else {
      return false;
    }
  }

  // Successors
  public Vector<Node> successors () {
	 Vector<Node> nodes = new Vector<Node>();
	 Vector<State> states = state.successors();
	 for (int i = 0; i < states.size(); i++) {
		// Note: for a more general implementation, the uniform costs
		//       should be replace by an operator specific cost
		nodes.add(0, new Node(states.elementAt(i), 1));
	 }
	 return nodes;
  }

  public int estimate(Node goalnode) {
	 return state.estimate(goalnode.state);
  }

} // End class Node


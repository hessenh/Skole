// General State Class; abstract

import java.util.Vector;

public abstract class State {

  public abstract boolean equals(State state);
  public abstract String toString();
  public abstract int estimate(State goal);
  public abstract Vector<State> successors();

}  // End class State

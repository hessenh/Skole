// State function for MouseKing.


/*

The Mouse King Problem.


  (1,5)    (5,5)  
   -----------
   | | | | | | 
   -----------
   | | |X| | | 
   -----------
   | | |X| | | 
   -----------
   | | |X| | | 
   -----------
   |M| |X| |C| 
   -----------
  (1,1)    (5,1)




There is a 5X5 board.
At (1,1) there is a mouse M which kan move as a king on a chess board.
The target is a cheese C at (5,1).


There is however a barrier  at (3,1-4) which the mouse cannot go
through, but the mouse heuristics is to ignore this.

*/

import java.util.Vector;

public class MouseKingState extends State {
  public int[] value;

  public MouseKingState(int[] v) {
    value = v;
  }
  
  public boolean equals(State state) {
	 MouseKingState s = (MouseKingState)state;
    if ((value[0] == s.value[0]) & (value[1] == s.value[1])) {
      return true;
    } else {
      return false;
    }
  }

  public String toString() {
	 String str = "(" + value[0] + ", " + value[1] + ")";
    return str;
  }

  public Vector<State> successors() {
	 Vector<State> m = new Vector<State>();

	 int x = value[0];
	 int y = value[1];

    for(int u = x-1; u <= x+1; u++) {
      for(int v = y-1; v <= y+1; v++) {
		  if (((x != u) | (y != v)) &
				(u >= 1) & (u <= 5) &
				(v >= 1) & (v <= 5)) {
			 if (!((u == 3) & (v <= 4))) {
				int n[] = {u, v};
				m.add(0, new MouseKingState(n)); // insert at first position
			 }
		  }
      }
    }

	 return m;
  }

  public int estimate(State goal) {
	 MouseKingState goalstate = (MouseKingState)goal;
	 int[] goalarray = goalstate.value;
	 int dx = Math.abs(goalarray[0] - value[0]); // TA-001003
	 int dy = Math.abs(goalarray[1] - value[1]); //
	 return Math.max(dx, dy);
  }

} // End class MouseKingState

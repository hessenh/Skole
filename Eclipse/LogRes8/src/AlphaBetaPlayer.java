
//   ****************** class MinMaxPlayer *****************
//   This is it, this is where you have to do all the
//   modifications. Or you could of course copy this class to
//   a new file and create a new class based on this.
//
//   It is very possible to have two different computer
//   players plaing each other.
//
//   If you make new classes for the new players, you will have
//   to do some simple changes in method keyReleased(KeyEvent) in class
//   CP.
//
//   Method makeMove is called when it is this players turn.
//   When the makeMove is called, the current GameState to be
//   evaluated is already stored in the variable gamestate.
//   This happens in the superclass Player.

public class AlphaBetaPlayer extends Player {

   int plydepth = 2;  // Always looks two moves ahead
   int evals;         // Calculates a stat that are never used

    // Just calls super, passing along the information
   public AlphaBetaPlayer(CP control,String name){
      super(control,name);
   }



    // Called by computationthread
    // calls the createTree method and returns the
    // result to control.
   public void makeMove(){
      evals = 0;
      ValuedMove m = createTree(gamestate,0,gamestate.playerturn);

      // evals are now equal to number of calls to createTree
     
      // make the move
      control.makeMove(m);
   }



    // Here's the parsing of the tree.
    // Simple simple MinMax with no modifications at all.
    // Implementing Alpha-Beta should change this method
    //
    // It's using depthfirst, which is easier to modify to Alpha-Beta
    //
    // 'state' is the current GameState. 'd' is the currenth depth
    // and 'you' is to keep track of whom the evaluation is for.
   public ValuedMove createTree(GameState state, int d, int you){
      evals++;

      // Two values... wich one will be used is determined
      // at the end..
      ValuedMove min=new ValuedMove(new Move(0,0,state.playerturn),10000);
      ValuedMove max=new ValuedMove(new Move(0,0,state.playerturn),-10000);


      // Check wether this is an endstate, that is if we've
      // reached maximum depth or only one player is left alive
      // If we are at the end, evaluate node
      if ((d==2*plydepth)||(state.alive()<=1)) {
	  max.val=evaluate(state,you);  //Do the actual evaluation
	  return max;  //Could've used min or any other variable..
	  // the sharp person will observe that we always return the
	  // move ddx=0 and ddy=0. See below why...
      }


      //We're not at an endnode, traverse tree, depth first

      for (int ddx=-1;ddx<=1;ddx++){
         for (int ddy=-1;ddy<=1;ddy++){
	     // control.createState creates a new state based on
	     // a given state and a move. This new state uses
	     // new PlayerState objects so that there will be no
	     // problem modifying older ones.
            ValuedMove v=createTree(control.createState(state,new Move(ddx,ddy,state.playerturn)),d+1,you);
	    
	    // Keep track of best and worst so far
	    // this is also where the actual move is filled in to the 
	    // variables.
            if (v.val>max.val) {max.val=v.val; max.ddx=ddx; max.ddy=ddy;}
            if (v.val<min.val) {min.val=v.val; min.ddx=ddx; min.ddy=ddy;}
         }
      }

      // We asume we choose the best for us
      if (state.playerturn==you) return max;

      // And that anyone else choose what is bad for us..
      return min;
   }

 
    // The actual evaluation of a state.
    // This is where the logic goes, and this is what has to
    // be changed if you want to make a smarter player (without
    // changing search tree function).
   public int evaluate(GameState state,int you){
	
	//Get your own state..
	PlayerState youp=(PlayerState)state.playerstates.elementAt(you);
	
	//For simplicity and asuming we only run a twoplayer game,
	//let's get the other players state into a variable
	int other=you+1;
	while (other>=2) other -=2;
	PlayerState otherp=(PlayerState)state.playerstates.elementAt(other);
	

	// Check if anyone killed in this state, and if so you?
	if (state.alive()<=1){
	    if (youp.condition>=0) return 2000;  //You're alive and someone else died!
	    if (youp.condition==-2) return -3000;  //I WON'T run off!
	    return -2000;                 //You're still dead!
	}
	

	// Don't wanna run to fast towards end of pit,
	// so check if it's possible to stop
	int driftx=youp.x+youp.dx*plydepth;
	int drifty=youp.y+youp.dy*plydepth;
	if ((driftx>19+plydepth) || (driftx<0-plydepth) ||
	    (drifty>19+plydepth) || (drifty<0-plydepth)){
	    return -1000;    //Dangerously high speed!!
	}
	

	//Rest of evaluation is up to YOU!!!
	return 0;
    }
}











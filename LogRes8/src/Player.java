
//   ************** class Player *****************
//   An abstract class with only one abstract method:
//   void makeMove()
//   When implemented, this method is responsible for the
//   class making a call to
//   control.makeMove(Move)
//   This should happen after evaluation of the GameState
//   object stored in variable gamestate.
//
//   The rest of the class prepares the object by
//   storing the current state in gamestate and starting
//   a separate computation thread.
//
//   The reason for starting an extra thread for the computation
//   is to lower the priority of this thread. This should in
//   theory make threads updating UI have relatively higher priority and
//   thus make the feel of the game a little better when playing.
//   Doesn't seem to work with Netscape though :-(
//
//   Another possibilty here is to start actual computation
//   when waiting for input from user...  but this would
//   require a bit more though programming.
//
//   You don't need to change anything here!

public abstract class Player extends Object implements Runnable{

    protected CP control;     // Controls everything: GUI, game, etc. 
    protected GameState gamestate;  //Current gamestate.. evaluate this and make a move

    private Thread tr;    //The computation thread
    private String name;  //Name of the player

    // Constructor tells who's in charge, and the name of the player.
    // Control is always the applet here..
    public Player(CP control,String name){
	this.control=control;
	this.name=name;
    }
    
    // Called from control whenever this player is 
    // should make it's turn. Creates the computation thread
   public void yourMove(GameState gamestate){
      this.gamestate = gamestate;
      tr = new Thread(this);
      tr.start();
   }

    // Sets priority of the computation thread
    // and calls the abstract method makeMove.
    public void run(){
	try {
	    tr.setPriority((Thread.NORM_PRIORITY+Thread.MIN_PRIORITY)/2);
	}
	catch (Exception e){
	}
	makeMove();
    }


    // This must be implemented by subclass.
    // Responsible for a making the class call 
    // control.makeMove(Move)
   public abstract void makeMove();

    // Just return the name of the player
   public String getName(){
      return this.name;
   }

}











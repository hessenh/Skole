import java.util.Vector;

//    ************* class GameState *****************
//    Keeps information about the state of the Game
//    Several instances of this class can have information
//    about different states.
//
//    Note that no copies are made in this class of the
//    PlayerStates inserted. This has to be done elsewhere.
//
//    It has a vector containing PlayerState objects
//    and an int containg which player has next move.
//
//    One useful methos is alive(), which returns the
//    number of players till in the game.
//
//    No modifications need to be done here..

public class GameState extends Object{

    public Vector playerstates;
    public int playerturn;

    public GameState(Vector playerstates,int playerturn){
	this.playerstates=playerstates;
	this.playerturn=playerturn;
    }
    

    //   **************** method alive *************
    //   returns the number of players that are still
    //   alive (PlayerState.condtion >= 0) in the game.
    //

    public int alive(){
	int a=0;
	for (int p=0;p<playerstates.size();p++)
	    if (((PlayerState)playerstates.elementAt(p)).condition>=0) a++;
	return a;
    }
}




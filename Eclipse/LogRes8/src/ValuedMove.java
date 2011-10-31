//  This class is an extended Move class. It adds one variable keeping
//  track of the evaluation of the move.
//
 
public class ValuedMove extends Move {
    public int val;
    ValuedMove(Move m,int val){
	super(m.ddx,m.ddy,m.player);
	this.val=val;
    }
}












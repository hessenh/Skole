
//   **************** class Move ****************
//   Keeps the information about a move made by a player:
//   - change in speed vector
//   - which player made the move
//
//   You don't need modfying this class..

class Move extends Object {

    int ddx;  //x vector change
    int ddy;  //y vector change
    int player;  //player making the move

    public Move(int ddx,int ddy,int player){
	this.ddx=ddx;
	this.ddy=ddy;
	this.player=player;
    }
}



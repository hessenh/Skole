
//    ************* class PlayerState *****************
//    Keeps information about the state of each player:
//    - x and y postion 
//    - speed vector
//    - player condition: 0 and higher is alive, -1 and
//      below is dead for some reason
//
//    All variables are public and easy accesible.
//
//    No modifications are needed here!

public class PlayerState extends Object{
    public int x;  //x position
    public int y;  //y position
    public int dx; //x vector
    public int dy; //y vector
    public int condition;   //0 is alive and kicking, -1 stopped by an enemy, -2 run into pit border

    public PlayerState(int x,int y,int dx,int dy,int condition){
	this.x=x;
	this.y=y;
	this.dx=dx;
	this.dy=dy;
	this.condition=condition;
    }
}

import java.awt.*;
import java.awt.event.*;

//   ****************** class HumanPlayer *******************
//   Derives from class Player and implements functions needed
//   for a human to play the game.
//
//   It takes input using both numerical keyboard and some of the
//   other keys for occasions where the numerical keyboard
//   doesn't work. The following shows how each keypress changes
//   the speed vector:
//
//     q/7=[-1,-1]  w/8=[ 0,-1]  e/9=[+1,-1]
//     a/4=[-1, 0]  s/5=[ 0, 0]  d/6=[+1, 0]
//     z/1=[-1,+1]  x/2=[ 0,+1]  c/3=[+1,+1]
//
//   You don't have to modify anything here.

public class HumanPlayer extends Player implements KeyListener{

   int mover=-1;

   public HumanPlayer(CP control,String name){
      super(control,name);
   }


    // Called by superclass...
    // Here the method does not call control.makeMove(Move)
    // but rather makes the object a receiver of keyboard
    // input.
   public synchronized void makeMove(){
      control.addKeyListener(this);
      control.arena.addKeyListener(this);
      mover=gamestate.playerturn;
   }


    // These two are not used...
   public void keyTyped(KeyEvent e) {
   }

   public void keyPressed(KeyEvent e) {
   }


    // When a key is pressed and later released, this
    // method is called. It transform the keypress into
    // a move.
   public synchronized void keyReleased(KeyEvent e) {
      if (mover!=-1) {
         int m=mover;

         int ddx=0;
         int ddy=0;
         char c=e.getKeyChar();
	 
         if ((c=='7')||(c=='8')||(c=='9')) ddy = -1;
         if ((c=='7')||(c=='4')||(c=='1')) ddx = -1;
         if ((c=='1')||(c=='2')||(c=='3')) ddy = +1;
         if ((c=='3')||(c=='6')||(c=='9')) ddx = +1;

         if ((c=='q')||(c=='w')||(c=='e')) ddy = -1;
         if ((c=='q')||(c=='a')||(c=='z')) ddx = -1;
         if ((c=='z')||(c=='x')||(c=='c')) ddy = +1;
         if ((c=='e')||(c=='d')||(c=='c')) ddx = +1;

	 if ((ddx==0)&&(ddy==0)&&(c!='s')&&(c!='5')) return;

         mover=-1;
         control.removeKeyListener(this);
         control.arena.removeKeyListener(this);

         control.makeMove(new Move(ddx,ddy,m));
      }
   }
}






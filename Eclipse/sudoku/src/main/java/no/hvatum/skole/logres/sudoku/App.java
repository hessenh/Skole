package no.hvatum.skole.logres.sudoku;

import java.util.List;

import no.hvatum.skole.logres.sudoku.constraints.BoxConstraint;
import no.hvatum.skole.logres.sudoku.constraints.ColumnConstraint;
import no.hvatum.skole.logres.sudoku.constraints.IsEmptyConstraint;
import no.hvatum.skole.logres.sudoku.constraints.RowConstraint;

/**
 * Hello world!
 *
 */
public class App 
{
    public static void main( String[] args )
    {
//        new GUI().setVisible(true);
        SodokuBoard sb = new SodokuBoard();
        sb.addConstraint(new IsEmptyConstraint());
        sb.addConstraint(new BoxConstraint());
        sb.addConstraint(new RowConstraint());
        sb.addConstraint(new ColumnConstraint());
        
        sb.doMove(3,0,1);      
        sb.doMove(2,0,3);
        sb.doMove(4,0,5);
        sb.doMove(8,0,7);
        
        sb.doMove(2,1,0);
        sb.doMove(4,1,1);
        sb.doMove(6,1,3);
        sb.doMove(1,1,7);
        sb.doMove(7,1,8);
        
        sb.doMove(7,2,2);
        sb.doMove(1,2,5);
        sb.doMove(4,2,6);

        sb.doMove(4,3,0);
        sb.doMove(2,3,2);
        sb.doMove(6,3,7);
        sb.doMove(9,3,8);

        sb.doMove(9,5,0);
        sb.doMove(1,5,1);
        sb.doMove(7,5,6);
        sb.doMove(8,5,8);
        
        sb.doMove(5,6,2);
        sb.doMove(1,6,3);
        sb.doMove(6,6,6);
        
        sb.doMove(8,7,0);
        sb.doMove(6,7,1);
        sb.doMove(5,7,5);
        sb.doMove(7,7,7);
        sb.doMove(2,7,8);
        
        sb.doMove(9,8,1);
        sb.doMove(4,8,3);
        sb.doMove(6,8,5);
        sb.doMove(3,8,7);
        
        List<Integer> l = sb.allowedMoves(3, 2);
        for (int i : l) {
        	System.out.println(i);
        }
        sb.printBoard();
        sb.solve();
        sb.printBoard();
        l = sb.allowedMoves(8, 2);
        for (int i : l) {
        	System.out.println(i);
        }
        
    }
}

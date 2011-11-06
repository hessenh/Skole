package no.hvatum.skole.logres.sudoku;

import java.io.IOException;
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
        new GUI().setVisible(true);
//        SudokuBoard sb;
//		try {
//			sb = new SudokuBoard("G:/sudoku/sudoku_normal.sudoku");
//			sb.addDefaultConstraints();
//			
//			sb.printBoard();
//			long time = System.currentTimeMillis();
//			sb.solve();
//			long difference = System.currentTimeMillis() - time;
//			sb.printBoard();
//			System.out.println("Time used: " + difference + " msec");
//		} catch (IOException e) {
//			e.printStackTrace();
//		}
//        
    }
}

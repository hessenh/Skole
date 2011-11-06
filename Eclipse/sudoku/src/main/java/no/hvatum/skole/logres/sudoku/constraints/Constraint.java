package no.hvatum.skole.logres.sudoku.constraints;

import no.hvatum.skole.logres.sudoku.SudokuConstants;

public interface Constraint extends SudokuConstants {
public abstract boolean isAllowed(int move, int row, int column, int[][] board);
}

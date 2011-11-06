package no.hvatum.skole.logres.sudoku.constraints;

public class IsEmptyConstraint implements Constraint {

	public boolean isAllowed(int move, int row, int column, int[][] board) {
		return board[row][column] == EMPTY;
	}

}

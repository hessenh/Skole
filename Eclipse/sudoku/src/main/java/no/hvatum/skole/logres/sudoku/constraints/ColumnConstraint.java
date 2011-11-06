package no.hvatum.skole.logres.sudoku.constraints;

public class ColumnConstraint implements Constraint {

	private int[] number;

	public ColumnConstraint() {
		number = new int[10];
		reset();
	}

	private void reset() {
		for (int i = 0; i < 10; i++) {
			number[i] = 0;
		}
	}

	public boolean isAllowed(int move, int row, int column, int[][] board) {
		reset();
		number[move]++;
		for (int i = 0; i < 9; i++) {
			if (board[i][column] != EMPTY) {
				number[board[i][column]]++;
				if (number[board[i][column]] > 1) {
					return false;
				}
			}
		}
		return true;
	}

}

package no.hvatum.skole.logres.sudoku.constraints;

public class BoxConstraint implements Constraint {

	private int[] number;

	public BoxConstraint() {
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
		int r = (row / 3) * 3;
		int c = (column / 3) * 3;
		for (int i = r; i < r + 3; i++) {
			for (int j = c; j < c + 3; j++) {
				if (board[i][j] != EMPTY) {
					number[board[i][j]]++;
					if (number[board[i][j]] > 1) {
						return false;
					}
				}
			}
		}
		return true;
	}
}

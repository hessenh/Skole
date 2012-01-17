package no.hvatum.skole.logres.sudoku.constraints;

/**
 * Logikken er kliss lik, men litt enklere en BoxConstraint, se den først
 * @author Stian
 *
 */
public class RowConstraint implements Constraint{
	private int[] number;

	public RowConstraint() {
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
			if (board[row][i] != EMPTY) {
				number[board[row][i]]++;
				if (number[board[row][i]] > 1) {
					return false;
				}
			}
		}
		return true;
	}

}

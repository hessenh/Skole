package no.hvatum.skole.logres.sudoku.constraints;

/**
 * Denne regelen passer p� at vi bare skriver til tomme ruter
 * @author Stian
 *
 */
public class IsEmptyConstraint implements Constraint {

	/**
	 * Vi må sjekke at ruten vi prøver å skrive til, faktisk er tom, hvis ikke kan vi ikke skrive til den.
	 */
	public boolean isAllowed(int move, int row, int column, int[][] board) {
		return board[row][column] == EMPTY;
	}

}

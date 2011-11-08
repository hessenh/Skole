package no.hvatum.skole.logres.sudoku.constraints;

/**
 * Denne klassen definerer reglen om at det ikke er lov til å ha flere av samme
 * tall innad i en 3x3-rute i Sudoku. Logikken er å ha et array med en plass for
 * hvert siffer, og inkrementere plassholderen for hver gang vi kommer over
 * dette sifferet i domenet. Hvis arrayet inneholder tall større en 1, har vi flere forekomster av samme siffer, og vi gjør et ulovelig trekk.
 * 
 * @author Stian
 * 
 */
public class BoxConstraint implements Constraint {

	// En array med plass til alle sifferene i
	private int[] number = new int[10];

	/**
	 * Vi initialiserer klassen med å nullstille den
	 */
	public BoxConstraint() {
		reset();
	}

	/**
	 * Nullstill ved å tømme siffer-telleren
	 */
	private void reset() {
		for (int i = 0; i < 10; i++) {
			number[i] = 0;
		}
	}

	/**
	 * Vi sjekker om et steg er lov ved å telle alle de forskjellige ikke-tomme
	 * forekomstene i arrayet.
	 */
	public boolean isAllowed(int move, int row, int column, int[][] board) {
		reset();
		// Vi må ikke glemme å telle trekket vi skal til å gjøre
		number[move]++;
		int r = (row / 3) * 3;
		int c = (column / 3) * 3;
		for (int i = r; i < r + 3; i++) {
			for (int j = c; j < c + 3; j++) {
				if (board[i][j] != EMPTY) {
					// Vi fant en ikke-tom rute, inkrementer den teller
					number[board[i][j]]++;
					if (number[board[i][j]] > 1) {
						// Flere enn en forekomst! Krise, vi returnerer false
						return false;
					}
				}
			}
		}
		// Alt så bra ut
		return true;
	}
}

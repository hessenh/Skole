package no.hvatum.skole.logres.sudoku.constraints;

import no.hvatum.skole.logres.sudoku.SudokuConstants;

/**
 * Dette interfacet deklarerer metoden for "er trekket lovelig", som implementeres av alle constraints (regler for hva som er gyldig)
 * @author Stian
 *
 */
public interface Constraint extends SudokuConstants {
	
	/**
	 * Metoden skal sjekke om det er lov til å putte tallet "move" på rad "row" og kolonne "column" på brett "board", uten å bryte den implementerte reglen.
	 * @param move
	 * @param row
	 * @param column
	 * @param board
	 * @return
	 */
	public abstract boolean isAllowed(int move, int row, int column,
			int[][] board);
}

package no.hvatum.skole.logres.sudoku;

/**
 * Denne klassen representerer et felt på brettet, og vi kunne like gjerne brukt en int[] med lengde 2. Jeg gjør det på denne måten fordi det blir litt ryddigere, synes jeg.
 * @author Stian
 *
 */
public class BoardPoint {
	public int row = 0;
	public int column = 0;

	/**
	 * Bruker row og column, istedet for X og Y, da Java og matte ikke er enige om hva som kommer først...
	 * @param row
	 * @param column
	 */
	public BoardPoint(int row, int column) {
		setPoint(row, column);
	}

	public void setPoint(int row, int column) {
		this.row = row;
		this.column = column;
	}

	/**
	 * Sjekk at dette ikke er "det ikke-eksiterende punktet", (-1 -1)
	 * @return
	 */
	public boolean isValidPoint() {
		return row != -1 && column != -1;
	}
}

package no.hvatum.skole.logres.sudoku;

public class BoardPoint {
	public int row = 0;
	public int column = 0;

	public BoardPoint(int row, int column) {
		setPoint(row, column);
	}

	public void setPoint(int row, int column) {
		this.row = row;
		this.column = column;
	}

	public boolean isValidPoint() {
		return row != -1 && column != -1;
	}
}

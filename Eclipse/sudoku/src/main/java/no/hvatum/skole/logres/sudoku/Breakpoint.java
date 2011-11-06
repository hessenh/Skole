package no.hvatum.skole.logres.sudoku;

public class Breakpoint implements SudokuConstants {
	private int moveNum;
	private int[][] board;

	public Breakpoint(int[][] board, int moveNum) {
		this.board = board;
		this.moveNum = moveNum;
	}
	
	
	public int[][] getBoard() {
		int[][] tmpBoard = new int[board.length][];
		for (int i = 0; i < board.length; i++) {
			tmpBoard[i] = new int[board[i].length];
			for (int j = 0; j < board.length; j++) {
				tmpBoard[i][j] = board[i][j];
			}
		}
		return tmpBoard;
	}


	public boolean isBoardEqual(int[][] gameBoard) {
		for (int i = 0; i < board.length; i++) {
			for (int j = 0; j < board.length; j++) {
				if (gameBoard[i][j] != board[i][j]) {
					return false;
				}
			}
		}
		return true;
	}


	public int getMoveNum() {
		return moveNum;
	}
}

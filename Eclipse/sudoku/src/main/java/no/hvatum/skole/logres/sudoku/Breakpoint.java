package no.hvatum.skole.logres.sudoku;

/**
 * Tiltenkt bruk:
 * Denne klassen representerer en node i treet, hvor tilstanden til brettet,
 * samt hvilket valg vi skal ta når noden blir poppet. Noden blir generert hver
 * gang sudoku-løse-algoritmen blir usikker på hvilket valg som er lurt. Den
 * gjør det ene, og lager en node på neste. Hvis det finnes enda flere valg,
 * lages disse når denne noden poppes.
 * 
 * @author Stian Hvatum
 * 
 */
public class Breakpoint implements SudokuConstants {
	private int moveNum;
	private int[][] board;

	/**
	 * Vi tar vare på en kopi av brettet, samt hvilket valg vi skal gjøre.
	 * @param board
	 * @param moveNum
	 */
	public Breakpoint(int[][] board, int moveNum) {
		this.board = board;
		this.moveNum = moveNum;
	}

	/**
	 * Gi ut en kopi av brettet. Må gjøres slik, hvis ikke vil endringer i "kopien" endre originalen. Javas skjulte pekeraritmetikk...
	 * @return
	 */
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

	/**
	 * Sjekk om to spilltilstander er like.
	 * @param gameBoard
	 * @return
	 */
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

	/**
	 * Hvilket valg var det vi skulle gjøre?
	 * @return
	 */
	public int getMoveNum() {
		return moveNum;
	}
}

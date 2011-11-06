package no.hvatum.skole.logres.sudoku;

import java.util.ArrayList;
import java.util.List;

import no.hvatum.skole.logres.sudoku.constraints.Constraint;

public class SodokuBoard implements SudokuConstants {

	int[][] board = new int[9][];;
	private List<Constraint> constraints = new ArrayList<Constraint>();

	public SodokuBoard() {
		for (int i = 0; i < 9; i++) {
			board[i] = new int[9];
			for (int j = 0; j < 9; j++) {
				board[i][j] = EMPTY;
			}
		}
	}

	public void addConstraint(Constraint constraint) {
		constraints.add(constraint);
	}

	public void removeConstraint(Constraint constraint) {
		constraints.remove(constraint);
	}

	public boolean allowedMove(int move, int row, int column) {
		for (Constraint constraint : constraints) {
			if (!constraint.isAllowed(move, row, column, board)) {
				return false;
			}
		}
		return true;
	}

	public void doMove(int move, int row, int column) {
		board[row][column] = move;
	}

	public List<Integer> allowedMoves(int row, int column) {
		ArrayList<Integer> moves = new ArrayList<Integer>();
		for (int move = 1; move < 10; move++) {
			if (allowedMove(move, row, column)) {
				moves.add(move);
			}
		}
		return moves;
	}

	public BoardPoint leastChoises() {
		BoardPoint least = new BoardPoint(-1, -1);
		int counter = Integer.MAX_VALUE;
		for (int i = 0; i < 9; i++) {
			for (int j = 0; j < 9; j++) {
				int size = allowedMoves(i, j).size();
				if (size < counter && size > 0) {
					counter = size;
					least.setPoint(i, j);
				}
			}
		}
		if (counter > 1) {
			System.out.println("Flere valg!!! Gjetting forekommer!");
		}
		return least;
	}

	@Override
	public String toString() {
		return board.toString();
	}

	public void printBoard() {
		for (int i = 0; i < 9; i++) {
			if (i % 3 == 0) {
				System.out.println("-------------");
			}
			for (int j = 0; j < 9; j++) {
				if (j % 3 == 0) {
					System.out.print('|');
				}
				if (board[i][j] != 0) {
					System.out.print(board[i][j]);
				} else {
					System.out.print('*');
				}
				if (j == 8) {
					System.out.print('|');
				}
			}
			System.out.print('\n');
		}
		System.out.println("-------------");
	}

	public void solve() {
		System.out.println("Solving...");
		System.out.println("Initial filling: " + (getFillPercentage() * 100) + "%");
		BoardPoint bp = leastChoises();
		while (bp.isValidPoint()) {
			List<Integer> moves = allowedMoves(bp.row, bp.column);
			doMove(moves.get(0), bp.row, bp.column);
			System.out.println("Putting " + moves.get(0) + " at " +  bp.row + ", " + bp.column);
			System.out.println((getFillPercentage() * 100) + "%");
			bp = leastChoises();
		}
	}

	private float getFillPercentage() {
		float count = 0f;
		for (int i = 0; i < 9; i++) {
			for (int j = 0; j < 9; j++) {
				if (board[i][j] != 0) {
					count++;
				}
			}
		}
		return count / 81f;
	}
}

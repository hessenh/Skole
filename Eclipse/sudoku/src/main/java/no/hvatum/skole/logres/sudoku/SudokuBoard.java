package no.hvatum.skole.logres.sudoku;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;

import no.hvatum.skole.logres.sudoku.constraints.BoxConstraint;
import no.hvatum.skole.logres.sudoku.constraints.ColumnConstraint;
import no.hvatum.skole.logres.sudoku.constraints.Constraint;
import no.hvatum.skole.logres.sudoku.constraints.IsEmptyConstraint;
import no.hvatum.skole.logres.sudoku.constraints.RowConstraint;

public class SudokuBoard implements SudokuConstants {

	int[][] board = new int[9][];;
	private List<Constraint> constraints = new ArrayList<Constraint>();
	private LinkedList<Breakpoint> breakpoints = new LinkedList<Breakpoint>();
	private int verbose = 9;

	public SudokuBoard() {
		for (int i = 0; i < 9; i++) {
			board[i] = new int[9];
			for (int j = 0; j < 9; j++) {
				board[i][j] = EMPTY;
			}
		}
	}

	public SudokuBoard(File file) throws IOException {
		this();
			BufferedReader reader = new BufferedReader(new FileReader(file));
			int row = -1;
			while (reader.ready()) {
				row++;
				int column = 0;
				for (String number : reader.readLine().split("\t")) {
					board[row][column++] = getNumber(number);
				}
			}
	}

	public SudokuBoard(String string) throws IOException {
		this(new File(string));
	}

	private int getNumber(String number) {
		try {
			return Integer.parseInt(number.trim());
		} catch (Exception e) {
			return EMPTY;
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
		boolean done = false;
		do {
		verbose("Solving...", 2);
		verbose("Initial filling: " + (getFillPercentage() * 100)
				+ "%", 3);
		BoardPoint bp = leastChoises();
		while (bp.isValidPoint()) {
			List<Integer> moves = allowedMoves(bp.row, bp.column);
			int moveNum = 0;
			if (moves.size() > 1) {
				verbose("More options available", 5);
				if (isCurrentBreakpoint()) {
					moveNum = popCurrentBreakpoint().getMoveNum();
					verbose("At old breakpoint, trying next possible option", 4);
				} else {
					verbose("Trying first option", 4);
				}
				if ((moveNum + 1) < moves.size()) {
					verbose("Adding breakpoint for next option", 4);
					addBreakpoint(moveNum + 1);
				}
			}
			doMove(moves.get(moveNum), bp.row, bp.column);
			verbose("Putting " + moves.get(moveNum) + " at "
					+ bp.row + ", " + bp.column, 7);
			verbose((getFillPercentage() * 100) + "%", 7);
			bp = leastChoises();
		}
		if (getFillPercentage() != 1f) {
			revertToLastBreakpoint();
		} else {
			done = true;
		}
		} while (!done );
	}

	private void verbose(String string, int level) {
		if (verbose >= level) {
			System.out.println(string);
		}
	}

	private void revertToLastBreakpoint() {
		this.board = getCurrentBreakpoint().getBoard();
	}

	private Breakpoint popCurrentBreakpoint() {
		return breakpoints.removeLast();
	}

	private boolean isCurrentBreakpoint() {
		if (breakpoints.size() > 0) {
			return getCurrentBreakpoint().isBoardEqual(board);
		} else {
			return false;
		}
	}

	private void addBreakpoint(int moveNum) {
		breakpoints.add(new Breakpoint(getBoard(), moveNum));
	}

	private Breakpoint getCurrentBreakpoint() {
		return breakpoints.getLast();
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

	public void addDefaultConstraints() {
		addConstraint(new IsEmptyConstraint());
		addConstraint(new BoxConstraint());
		addConstraint(new RowConstraint());
		addConstraint(new ColumnConstraint());
	}
}

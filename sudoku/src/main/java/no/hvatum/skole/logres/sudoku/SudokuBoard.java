package no.hvatum.skole.logres.sudoku;

import java.io.BufferedReader;
import java.io.File;
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

	// Indre representasjon av brett, normalt 9x9
	int[][] board = new int[9][];;

	// Alle constraints vi legger på spillet.
	private List<Constraint> constraints = new ArrayList<Constraint>();

	// Her er LIFO-køen for nodene våre, se Breakpoint-klassen for mer info.
	private LinkedList<Breakpoint> breakpoints = new LinkedList<Breakpoint>();

	// Hvor mye skal vi prate til konsollet?
	private int verbosity = 9;

	/**
	 * Instansiering betyr i enkel grad å initialisere et tomt brett.
	 */
	public SudokuBoard() {
		for (int i = 0; i < 9; i++) {
			board[i] = new int[9];
			for (int j = 0; j < 9; j++) {
				board[i][j] = EMPTY;
			}
		}
	}

	/**
	 * Eventuelt lese inn fra fil. Filformatet er enkelt nok kopi av
	 * Sudoku-oppgaver fra http://www.menneske.no/sudoku/ kopiert inn via
	 * Notepad.
	 * 
	 * @param file
	 * @throws IOException
	 */
	public SudokuBoard(File file) throws IOException {
		this();
		BufferedReader reader = new BufferedReader(new FileReader(file));
		int row = -1;
		while (reader.ready()) {
			row++;
			int column = 0;
			// For hver linje, splitt på TAB, og parse tallene.
			for (String number : reader.readLine().split("\t")) {
				board[row][column++] = getNumber(number);
			}
		}
	}

	/**
	 * Lese inn fra fil, bare vi filnavn istedet for File-handle
	 * 
	 * @param string
	 * @throws IOException
	 */
	public SudokuBoard(String string) throws IOException {
		this(new File(string));
	}

	/**
	 * Parse et nummer, hvis noe går galt,returner EMPTY. Brukes for å parse
	 * tekstfiler med brett i. Alle ukjente ruter er tomme.
	 * 
	 * @param number
	 * @return
	 */
	private int getNumber(String number) {
		try {
			return Integer.parseInt(number.trim());
		} catch (Exception e) {
			// Ja, alle mellomrom gir exception. Dårlig kode, men så er dette en
			// skoleøving, og ikke produksjonskode...
			return EMPTY;
		}
	}

	/**
	 * Putt en constraint i lista over alle constraints
	 * 
	 * @param constraint
	 */
	public void addConstraint(Constraint constraint) {
		constraints.add(constraint);
	}

	/**
	 * Fjern en constraint fra lista over alle constraints
	 * 
	 * @param constraint
	 */
	public void removeConstraint(Constraint constraint) {
		constraints.remove(constraint);
	}

	/**
	 * Sjekker om et valg tall har lov til å stå på valgt plassering
	 * @param move Tall som skal inn på plassering
	 * @param row Rad vi ønsker å gjøre trekket på
	 * @param column Kolonne vi ønsker å gjøre trekket på
	 * @return Er trekket lovelig
	 */
	public boolean allowedMove(int move, int row, int column) {
		for (Constraint constraint : constraints) {
			if (!constraint.isAllowed(move, row, column, board)) {
				return false;
			}
		}
		return true;
	}

	/**
	 * Gjør et trekk, uavhengi av om det er lov eller ikke.
	 * @param move Tall som skal inn på plassering
	 * @param row Rad vi ønsker å gjøre trekket på
	 * @param column Kolonne vi ønsker å gjøre trekket på
	 */
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

	/**
	 * Prøv å finne ut hvilken rute som har ferrest mulig trekk > 0, slik at vi kan fylle ut denne som neste trekk.
	 * @return
	 */
	public BoardPoint leastChoises() {
		// Vi startet med "det ikke-eksiterende punktet"
		BoardPoint least = new BoardPoint(-1, -1);
		
		// Og antall trekk er sykt mange
		int counter = Integer.MAX_VALUE;
		
		// Så ser vi om noen ruter har ferre, men flere enn 0 trekk
		for (int i = 0; i < 9; i++) {
			for (int j = 0; j < 9; j++) {
				// Hvor mange trekk er lov her da?
				int size = allowedMoves(i, j).size();
				if (size < counter && size > 0) {
					// Oj, treff. Sett telleren til antall, og ta vare på punktet.
					counter = size;
					least.setPoint(i, j);
				}
			}
		}
		// Returner punktet som har ferrest lovlige trekk over 0.
		return least;
	}

	/**
	 * Print ut brettet i konsoll, slik at det ser nogenlunde bra ut.
	 */
	public void printBoard() {
		for (int i = 0; i < 9; i++) {
			if (i % 3 == 0) {
				System.out.println("-------------------");
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
		System.out.println("-------------------");
	}

	
	/**
	 * Her kommer selve magien. Denne metoden løser Sudoku!
	 */
	public void solve() {
		// Er vi ferdige? Nei, ikke enda.
		boolean done = false;
		do {
			// Alle verbose() er snakking
			verbose("Solving...", 2);
			verbose("Initial filling: " + (getFillPercentage() * 100) + "%", 3);
			
			// Hvilket punkt har ferrest mulige valg, for der ønsker vi å begynne
			BoardPoint bp = leastChoises();
			
			// Så lenge vi har et reelt punkt, kjør på
			while (bp.isValidPoint()) {
				// Finn alle lovlige valg
				List<Integer> moves = allowedMoves(bp.row, bp.column);
				// Foreløpig ønsker vi å gjøre det første valget (0-indeksert)
				int moveNum = 0;
				
				// Hvis det er flere mulige valg, må vi passe på
				if (moves.size() > 1) {
					verbose("More options available", 5);
					// Er vi i en tilstand vi har lagret breakpoint på tidligere?
					if (isCurrentBreakpoint()) {
						// Hvis ja, må vi hente ut valget vi lagret at vi skulle gjøre, og fjern breakpointet
						moveNum = popCurrentBreakpoint().getMoveNum();
						verbose("At old breakpoint, trying next possible option",
								4);
					} else {
						verbose("Trying first option", 4);
					}
					// Finnes det flere valg etter det valget vi gjør nå?
					if ((moveNum + 1) < moves.size()) {
						verbose("Adding breakpoint for next option", 4);
						// I så fall, lagre denne tilstanden og det valget som en node i treet.
						addBreakpoint(moveNum + 1);
					}
				}
				
				// Hvis ikke det var flere mulige valg, gjør første valg, ellers gjør vi det vi kom fram til inne i forrige IF
				doMove(moves.get(moveNum), bp.row, bp.column);
				verbose("Putting " + moves.get(moveNum) + " at " + bp.row
						+ ", " + bp.column, 7);
				verbose((getFillPercentage() * 100) + "%", 7);
				
				// Finn neste punkt
				bp = leastChoises();
			}
			// Der var det ikke flere lovlige trekk igjen, er vi ferdige
			if (getFillPercentage() != 1f) {
				// Vi var vist ikke ferdig, vi må et hakk opp i parsetreet vår, pop stacken og prøv en anne sti
				revertToLastBreakpoint();
			} else {
				// Vi var vist ferdige
				done = true;
			}
		} while (!done);
		// Og har var vi helt ferdige med brettet
	}

	/**
	 * Metode for å kontrollere utskrift hit og dit
	 * @param string Hva som skal skrives ut
	 * @param level Ved hvilket verbosity-nivå det skal skrives ut
	 */
	private void verbose(String string, int level) {
		if (verbosity >= level) {
			System.out.println(string);
		}
	}

	/**
	 * Sett tilstanden tilbake til siste sjekkpunkt/node
	 */
	private void revertToLastBreakpoint() {
		this.board = getCurrentBreakpoint().getBoard();
	}

	/**
	 * Hent og fjern siste element(tilstand) fra stacken
	 * @return
	 */
	private Breakpoint popCurrentBreakpoint() {
		return breakpoints.removeLast();
	}

	/**
	 * Er vi i tilstanden til dette sjekkpunktet?
	 * @return
	 */
	private boolean isCurrentBreakpoint() {
		// Finnes det i det hele tatt noe sjekkpunkt?
		if (breakpoints.size() > 0) {
			// I så fall, er brettet likt som her?
			return getCurrentBreakpoint().isBoardEqual(board);
		} else {
			// Det var ingen sjekkpunkt i stacken, da er vi ikke på et sjekkpunkt
			return false;
		}
	}

	/**
	 * Putt et sjekkpunkt på stacken
	 * @param moveNum
	 */
	private void addBreakpoint(int moveNum) {
		breakpoints.add(new Breakpoint(getBoard(), moveNum));
	}

	/**
	 * Hent ut siste sjekkpunkt, uten å fjerne det fra stacken
	 * @return
	 */
	private Breakpoint getCurrentBreakpoint() {
		return breakpoints.getLast();
	}

	/**
	 * Er vi ferdige snart? Denne metoden sjekker hvor stor fyllgrad vi har på Sudoku-brettet vårt.
	 * @return
	 */
	private float getFillPercentage() {
		float count = 0f;
		for (int i = 0; i < board.length; i++) {
			for (int j = 0; j < board[i].length; j++) {
				if (board[i][j] != EMPTY) {
					// Tell hver ikke-tomme rute
					count++;
				}
			}
		}
		// Og del på 
		return count / (float)(board.length * board.length);
	}

	/**
	 * Lag en kopi av brettet
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
	 * Legg til standard-regler på sudoku-brettet.
	 */
	public void addDefaultConstraints() {
		addConstraint(new IsEmptyConstraint());
		addConstraint(new BoxConstraint());
		addConstraint(new RowConstraint());
		addConstraint(new ColumnConstraint());
	}

	/**
	 * Hvor mye skal vi bable til konsollet?
	 * @param value
	 */
	public void setVerbosity(int value) {
		verbosity = value;
	}
}

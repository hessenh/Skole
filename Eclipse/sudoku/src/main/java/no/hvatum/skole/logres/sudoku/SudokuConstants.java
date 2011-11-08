package no.hvatum.skole.logres.sudoku;

/**
 * Det er kjekt å ha noen "globale" konstanter, uten å ha de flytendes i en statisk klasse. Alle "Sudoku"-klasser implementerer dette interfacet, og får tak på konstanten(e).
 * @author Stian
 *
 */
public interface SudokuConstants {
	// En tom rute (0 brukes ikke til noe annet, og er et av flere logiske valg)
	static final int EMPTY = 0;
}

package no.hvatum.skole.logres.sudoku.console;

import java.awt.Color;
import java.io.PrintStream;

import javax.swing.BoxLayout;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTextArea;
import javax.swing.SwingUtilities;

/**
 * En klasse jeg skrev til et annet prosjekt jeg hadde, for å kopiere konsollteksten automagisk inn i en text-area.
 */
public class Console extends JPanel {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private final PrintStream originalOut;
	private final PrintStream streamOut;
	private final JTextArea jta;

	private JScrollPane jsp;
	private PrintStream originalErr;
	private PrintStream streamErr;

	public Console() {
		this("Docnet Console");
	}
	
	public Console(String title) {

		originalOut = System.out;
		originalErr = System.err;;
		streamOut = new PrintStream(new ConsoleStream(originalOut, this), true);
		streamErr = new PrintStream(new ConsoleStream(originalErr, this, true), true);
		System.setOut(streamOut);
		System.setErr(streamErr);
		setLayout(new BoxLayout(this, BoxLayout.X_AXIS));
		jta = new JTextArea();
		jta.setBackground(Color.black);
		jta.setForeground(Color.gray);
		jta.setEditable(false);

		jsp = new JScrollPane(jta);
		jsp.setAutoscrolls(true);
		add(jsp);
	}

	public void write(final String line) {
		SwingUtilities.invokeLater(new Runnable() {
			
			public void run() {
				jta.append(line);
				jsp.getVerticalScrollBar().setValue(jsp.getVerticalScrollBar().getMaximum());
			}
		});
	}

	
}

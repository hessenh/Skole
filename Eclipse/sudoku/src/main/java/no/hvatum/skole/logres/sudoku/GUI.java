package no.hvatum.skole.logres.sudoku;

import javax.swing.JFrame;

public class GUI {
	private JFrame frame;

	public GUI() {
		this.frame = new JFrame("Sudoku - Logres øving 9 - hvatum - mtdt");
	}
	
	public void setVisible(boolean visible) {
		frame.setVisible(visible);
	}
}

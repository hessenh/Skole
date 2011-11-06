package no.hvatum.skole.logres.sudoku;

import java.awt.BorderLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.File;
import java.io.IOException;

import javax.swing.JButton;
import javax.swing.JFileChooser;
import javax.swing.JFrame;
import javax.swing.JPanel;
import javax.swing.filechooser.FileFilter;

import no.hvatum.skole.logres.sudoku.console.Console;
import java.awt.GridBagLayout;
import java.awt.GridBagConstraints;
import java.awt.Insets;

public class GUI {
	private JFrame frame;

	public GUI() {
		this.frame = new JFrame("Sudoku - Logres �ving 9 - hvatum - mtdt");
		final JFileChooser chooser = new JFileChooser();
		chooser.setFileFilter(new FileFilter() {

			@Override
			public String getDescription() {
				return "Sudoku-brett";
			}

			@Override
			public boolean accept(File f) {
				return f.isDirectory() || f.getName().endsWith(".sudoku");
			}
		});
		GridBagLayout gridBagLayout = new GridBagLayout();
		gridBagLayout.columnWidths = new int[] { 131, 0 };
		gridBagLayout.rowHeights = new int[] { 34, 33, 0 };
		gridBagLayout.columnWeights = new double[] { 1.0, Double.MIN_VALUE };
		gridBagLayout.rowWeights = new double[] { 1.0, 0.0, Double.MIN_VALUE };
		frame.getContentPane().setLayout(gridBagLayout);
		JPanel console = new Console();
		GridBagConstraints gbc_console = new GridBagConstraints();
		gbc_console.fill = GridBagConstraints.BOTH;
		gbc_console.insets = new Insets(0, 0, 5, 0);
		gbc_console.gridx = 0;
		gbc_console.gridy = 0;
		frame.getContentPane().add(console, gbc_console);

		JPanel panel = new JPanel();
		GridBagConstraints gbc_panel = new GridBagConstraints();
		gbc_panel.anchor = GridBagConstraints.NORTHWEST;
		gbc_panel.gridx = 0;
		gbc_panel.gridy = 1;
		frame.getContentPane().add(panel, gbc_panel);

		JButton btnNewButton = new JButton("Hent Sudoku-brett");
		btnNewButton.addActionListener(new ActionListener() {

			public void actionPerformed(ActionEvent e) {
				chooser.setVisible(true);
				int action = chooser.showOpenDialog(frame);
				if (action == JFileChooser.APPROVE_OPTION) {
					setSudokuFile(chooser.getSelectedFile());
				}
			}
		});
		panel.add(btnNewButton);
		frame.pack();
		frame.setLocationRelativeTo(null);
		frame.setBounds(0, 0, 800, 600);

	}

	protected void setSudokuFile(final File selectedFile) {
		new Thread(new Runnable() {

			public void run() {

				SudokuBoard sb;
				try {
					sb = new SudokuBoard(selectedFile);
					sb.addDefaultConstraints();
					sb.printBoard();
					long time = System.currentTimeMillis();
					sb.solve();
					long difference = System.currentTimeMillis() - time;
					sb.printBoard();
					System.out.println("Time used: " + difference + " msec");

				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}).start();

	}

	public void setVisible(boolean visible) {
		frame.setVisible(visible);
	}
}
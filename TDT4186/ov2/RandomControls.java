import java.awt.GridBagConstraints;
import java.awt.GridBagLayout;
import java.awt.Insets;

import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JSpinner;
import javax.swing.event.ChangeEvent;
import javax.swing.event.ChangeListener;
import javax.swing.JCheckBox;
import java.awt.event.ActionListener;
import java.awt.event.ActionEvent;
import javax.swing.JSlider;

/**
 * 
 * @author hvatum
 *
 */

public class RandomControls extends JFrame {
	
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	public RandomControls() {
		setDefaultCloseOperation( JFrame.DO_NOTHING_ON_CLOSE );
		GridBagLayout gridBagLayout = new GridBagLayout();
		gridBagLayout.columnWidths = new int[]{0, 0, 100, 100, 0};
		gridBagLayout.rowHeights = new int[]{0, 0, 0, 0, 0, 0, 0, 0};
		gridBagLayout.columnWeights = new double[]{0.0, 0.0, 1.0, 1.0, Double.MIN_VALUE};
		gridBagLayout.rowWeights = new double[]{0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Double.MIN_VALUE};
		getContentPane().setLayout(gridBagLayout);
		
		final JCheckBox chckbxIsrandom = new JCheckBox("IsRandom");
		chckbxIsrandom.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				Globals.random = chckbxIsrandom.isSelected();
			}
		});
		GridBagConstraints gbc_chckbxIsrandom = new GridBagConstraints();
		gbc_chckbxIsrandom.insets = new Insets(0, 0, 5, 5);
		gbc_chckbxIsrandom.gridx = 1;
		gbc_chckbxIsrandom.gridy = 0;
		getContentPane().add(chckbxIsrandom, gbc_chckbxIsrandom);
		
		JLabel lblMin = new JLabel("Min");
		GridBagConstraints gbc_lblMin = new GridBagConstraints();
		gbc_lblMin.fill = GridBagConstraints.HORIZONTAL;
		gbc_lblMin.insets = new Insets(0, 0, 5, 5);
		gbc_lblMin.gridx = 2;
		gbc_lblMin.gridy = 1;
		getContentPane().add(lblMin, gbc_lblMin);
		
		JLabel lblMax = new JLabel("Max");
		GridBagConstraints gbc_lblMax = new GridBagConstraints();
		gbc_lblMax.fill = GridBagConstraints.HORIZONTAL;
		gbc_lblMax.insets = new Insets(0, 0, 5, 0);
		gbc_lblMax.gridx = 3;
		gbc_lblMax.gridy = 1;
		getContentPane().add(lblMax, gbc_lblMax);
		
		JLabel lblDoorman = new JLabel("Doorman");
		GridBagConstraints gbc_lblDoorman = new GridBagConstraints();
		gbc_lblDoorman.insets = new Insets(0, 0, 5, 5);
		gbc_lblDoorman.gridx = 1;
		gbc_lblDoorman.gridy = 2;
		getContentPane().add(lblDoorman, gbc_lblDoorman);
		
			 final JSpinner spinnerDMin = new JSpinner();
			 spinnerDMin.setValue(Globals.randMinDoorman);
		spinnerDMin.addChangeListener(new ChangeListener() {
			public void stateChanged(ChangeEvent arg0) {
				Globals.randMinDoorman = (Integer) spinnerDMin.getValue();
			}
		});
		GridBagConstraints gbc_spinnerDMin = new GridBagConstraints();
		gbc_spinnerDMin.fill = GridBagConstraints.HORIZONTAL;
		gbc_spinnerDMin.insets = new Insets(0, 0, 5, 5);
		gbc_spinnerDMin.gridx = 2;
		gbc_spinnerDMin.gridy = 2;
		getContentPane().add(spinnerDMin, gbc_spinnerDMin);
		
		final JSpinner spinnerDMax = new JSpinner();
		spinnerDMax.setValue(Globals.randMaxDoorman);
		GridBagConstraints gbc_spinnerDMax = new GridBagConstraints();
		gbc_spinnerDMax.fill = GridBagConstraints.HORIZONTAL;
		spinnerDMax.addChangeListener(new ChangeListener() {
			public void stateChanged(ChangeEvent arg0) {
				Globals.randMaxDoorman = (Integer) spinnerDMax.getValue();
			}
		});
		gbc_spinnerDMax.insets = new Insets(0, 0, 5, 0);
		gbc_spinnerDMax.gridx = 3;
		gbc_spinnerDMax.gridy = 2;
		getContentPane().add(spinnerDMax, gbc_spinnerDMax);
		
		JLabel lblNewLabel = new JLabel("Barber sleep");
		GridBagConstraints gbc_lblNewLabel = new GridBagConstraints();
		gbc_lblNewLabel.insets = new Insets(0, 0, 5, 5);
		gbc_lblNewLabel.gridx = 1;
		gbc_lblNewLabel.gridy = 3;
		getContentPane().add(lblNewLabel, gbc_lblNewLabel);
		
		final JSpinner spinnerBSMin = new JSpinner();
		GridBagConstraints gbc_spinnerBSMin = new GridBagConstraints();
		gbc_spinnerBSMin.fill = GridBagConstraints.HORIZONTAL;
		gbc_spinnerBSMin.insets = new Insets(0, 0, 5, 5);
		gbc_spinnerBSMin.gridx = 2;
		gbc_spinnerBSMin.gridy = 3;
		getContentPane().add(spinnerBSMin, gbc_spinnerBSMin);
		spinnerBSMin.setValue(Globals.randMinBarberSleep);
		spinnerBSMin.addChangeListener(new ChangeListener() {
			public void stateChanged(ChangeEvent arg0) {
				Globals.randMinBarberSleep = (Integer) spinnerBSMin.getValue();
			}
		});
		
		final JSpinner spinnerBSMax = new JSpinner();
		GridBagConstraints gbc_spinnerBSMax = new GridBagConstraints();
		gbc_spinnerBSMax.fill = GridBagConstraints.HORIZONTAL;
		gbc_spinnerBSMax.insets = new Insets(0, 0, 5, 0);
		gbc_spinnerBSMax.gridx = 3;
		gbc_spinnerBSMax.gridy = 3;
		getContentPane().add(spinnerBSMax, gbc_spinnerBSMax);
		spinnerBSMax.setValue(Globals.randMaxBarberSleep);
		spinnerBSMax.addChangeListener(new ChangeListener() {
			public void stateChanged(ChangeEvent arg0) {
				Globals.randMaxBarberSleep = (Integer) spinnerBSMax.getValue();
			}
		});
		
		JLabel lblBarberWork = new JLabel("Barber work");
		GridBagConstraints gbc_lblBarberWork = new GridBagConstraints();
		gbc_lblBarberWork.insets = new Insets(0, 0, 5, 5);
		gbc_lblBarberWork.gridx = 1;
		gbc_lblBarberWork.gridy = 4;
		getContentPane().add(lblBarberWork, gbc_lblBarberWork);
		
		
		final JSpinner spinnerBWMin = new JSpinner();
		GridBagConstraints gbc_spinnerBWMin = new GridBagConstraints();
		gbc_spinnerBWMin.fill = GridBagConstraints.HORIZONTAL;
		gbc_spinnerBWMin.insets = new Insets(0, 0, 5, 5);
		gbc_spinnerBWMin.gridx = 2;
		gbc_spinnerBWMin.gridy = 4;
		getContentPane().add(spinnerBWMin, gbc_spinnerBWMin);
		spinnerBWMin.setValue(Globals.randMinBarberWork);
		spinnerBWMin.addChangeListener(new ChangeListener() {
			public void stateChanged(ChangeEvent arg0) {
				Globals.randMinBarberWork = (Integer) spinnerBWMin.getValue();
			}
		});
		
		final JSpinner spinnerBWMax = new JSpinner();
		GridBagConstraints gbc_spinnerBWMax = new GridBagConstraints();
		gbc_spinnerBWMax.insets = new Insets(0, 0, 5, 0);
		gbc_spinnerBWMax.fill = GridBagConstraints.HORIZONTAL;
		gbc_spinnerBWMax.gridx = 3;
		gbc_spinnerBWMax.gridy = 4;
		getContentPane().add(spinnerBWMax, gbc_spinnerBWMax);
		spinnerBWMax.setValue(Globals.randMaxBarberWork);
		
		JLabel label = new JLabel("Payment");
		GridBagConstraints gbc_label = new GridBagConstraints();
		gbc_label.insets = new Insets(0, 0, 5, 5);
		gbc_label.gridx = 1;
		gbc_label.gridy = 5;
		getContentPane().add(label, gbc_label);
		
		final JSpinner spinnerPMin = new JSpinner();
		GridBagConstraints gbc_spinnerPMin = new GridBagConstraints();
		gbc_spinnerPMin.fill = GridBagConstraints.HORIZONTAL;
		gbc_spinnerPMin.insets = new Insets(0, 0, 5, 5);
		gbc_spinnerPMin.gridx = 2;
		gbc_spinnerPMin.gridy = 5;
		getContentPane().add(spinnerPMin, gbc_spinnerPMin);
		spinnerPMin.addChangeListener(new ChangeListener() {
			public void stateChanged(ChangeEvent arg0) {
				Globals.randMinPayment = (Integer) spinnerPMin.getValue();
			}
		});
		
		final JSpinner spinnerPMax = new JSpinner();
		GridBagConstraints gbc_spinnerPMax = new GridBagConstraints();
		gbc_spinnerPMax.fill = GridBagConstraints.HORIZONTAL;
		gbc_spinnerPMax.insets = new Insets(0, 0, 5, 0);
		gbc_spinnerPMax.gridx = 3;
		gbc_spinnerPMax.gridy = 5;
		getContentPane().add(spinnerPMax, gbc_spinnerPMax);
		spinnerPMax.addChangeListener(new ChangeListener() {
			public void stateChanged(ChangeEvent arg0) {
				Globals.randMaxPayment = (Integer) spinnerPMax.getValue();
			}
		});
		
		JLabel lblPayment = new JLabel("Payment");
		GridBagConstraints gbc_lblPayment = new GridBagConstraints();
		gbc_lblPayment.insets = new Insets(0, 0, 0, 5);
		gbc_lblPayment.gridx = 1;
		gbc_lblPayment.gridy = 6;
		getContentPane().add(lblPayment, gbc_lblPayment);
		
		final JSlider sliderPayment = new JSlider(0, 10000);
		GridBagConstraints gbc_sliderPayment = new GridBagConstraints();
		gbc_sliderPayment.gridwidth = 2;
		gbc_sliderPayment.gridx = 2;
		gbc_sliderPayment.gridy = 6;
		getContentPane().add(sliderPayment, gbc_sliderPayment);
		sliderPayment.addChangeListener(new ChangeListener() {
			public void stateChanged(ChangeEvent arg0) {
				Globals.paymentTime = (Integer) sliderPayment.getValue();
				System.out.println("Payment time " + Globals.paymentTime);
			}
		});
		
		pack();
	}

}

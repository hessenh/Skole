/**
 * Class containing three globally available variables modified by the GUI and
 * used by the Barber and Doorman threads.
 * 
 * Edited by hvatum for ex.2 TDT4186
 */
public class Globals implements Constants {

	public static final int PRICE = 100;

	public static boolean random = false;

	/** The number of milliseconds a barber sleeps between each work period */
	public static int barberSleep = (MAX_BARBER_SLEEP + MIN_BARBER_SLEEP) / 2;
	/** The number of milliseconds it takes a barber to cut a customer's hair */
	public static int barberWork = (MAX_BARBER_WORK + MIN_BARBER_WORK) / 2;
	/** The number of milliseconds between each time a new customer arrives */
	public static int doormanSleep = (MAX_DOORMAN_SLEEP + MIN_DOORMAN_SLEEP) / 2;

	protected static int randMinDoorman = MIN_DOORMAN_SLEEP;

	protected static int randMaxDoorman = MAX_DOORMAN_SLEEP;

	protected static Integer randMinBarberSleep = MIN_BARBER_SLEEP;

	protected static Integer randMaxBarberSleep = MAX_BARBER_SLEEP;

	protected static Integer randMinBarberWork = MIN_BARBER_WORK;

	protected static Integer randMaxBarberWork = MAX_BARBER_WORK;

	protected static int paymentTime = 1000;

	protected static Integer randMinPayment;

	protected static Integer randMaxPayment;

	public static long getBarberSleep() {
		if (random) {
			return randMinBarberSleep+(int)(Math.random()*(randMaxBarberSleep-randMinBarberSleep+1));
		} else {
			return barberSleep;
		}
	}

	public static long getBarberWork() {
		if (random) {
			return randMinBarberWork+(int)(Math.random()*(randMaxBarberWork-randMinBarberWork+1));
		} else {
			return barberWork;
		}
	}

	public static long getDoormanSleep() {
		if (random) {
			return randMinDoorman+(int)(Math.random()*(randMaxDoorman-randMinDoorman+1));
		} else {
			return doormanSleep;
		}
	}

	public static long getPaymentTime() {
		return paymentTime ;
	}
}

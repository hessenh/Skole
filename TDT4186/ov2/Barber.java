import java.util.NoSuchElementException;

/**
 * This class implements the barber's part of the Barbershop thread
 * synchronization example.
 * 
 * Implemented by hvatum
 */
public class Barber implements Runnable {
	private boolean stop = true;
	private CustomerQueue queue;
	private Gui gui;
	private int pos;
	private Thread thread;
	private Cashier cashier;
	private int count;

	/**
	 * Creates a new barber.
	 * 
	 * @param queue
	 *            The customer queue.
	 * @param gui
	 *            The GUI.
	 * @param pos
	 *            The position of this barber's chair
	 */
	public Barber(CustomerQueue queue, Gui gui, int pos) {
		this.queue = queue;
		this.gui = gui;
		this.pos = pos;
		cashier = Cashier.getInstance();
	}

	/**
	 * Starts the barber running as a separate thread.
	 */
	public void startThread() {
		stop = false;
		thread = new Thread(this);
		thread.start();
	}

	/**
	 * Stops the barber thread.
	 */
	public void stopThread() {
		this.stop = true;
		thread.interrupt();
		synchronized (queue) {
			return;
		}
	}

	@Override
	public void run() {
		gui.println("Barberer " + pos + " arrived at work, looking for customers!");
		try {
			while (!stop) {
				gui.barberIsSleeping(pos);
				gui.println("Barberer " + pos + " is day-dreaming");
				Thread.sleep(Globals.getBarberSleep());
				gui.barberIsAwake(pos);
				gui.println("Barberer " + pos + " is waiting for customers");
				synchronized (queue) {
					while (!queue.hasCustomers()) queue.wait();
					try {
						int loungePos = queue.getNextCustomerPos();
						Customer customer = queue.removeCustomer();
						gui.emptyLoungeChair(loungePos);
						gui.fillBarberChair(pos, customer);
						queue.notify();
					} catch (NoSuchElementException e) {
						gui.println("This line should not be printed!");
					}
				}
				gui.println("Barberer " + pos + " working");
				Thread.sleep(Globals.getBarberWork());
				count++; // Customer served
				gui.emptyBarberChair(pos);
				cashier.depositMoney(Globals.PRICE, pos);
			}
		} catch (InterruptedException e) {
			System.out.println("Thread " + Thread.currentThread().getName() + " stopped");
			return;
		}
	}
	// Add more methods as needed

	public int getNumServed() {
		return count;
	}
}

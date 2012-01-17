/**
 * This class implements the doorman's part of the Barbershop thread
 * synchronization example.
 * 
 * Implemented by hvatum
 */
public class Doorman implements Runnable {
	private CustomerQueue queue;
	private Gui gui;
	private boolean stop = true;
	private Thread thread;

	/**
	 * Creates a new doorman.
	 * 
	 * @param queue
	 *            The customer queue.
	 * @param gui
	 *            A reference to the GUI interface.
	 */
	public Doorman(CustomerQueue queue, Gui gui) {
		this.queue = queue;
		this.gui = gui;
	}

	/**
	 * Starts the doorman running as a separate thread.
	 */
	public void startThread() {
		stop = false;
		thread = new Thread(this);
		thread.start();
	}

	/**
	 * Stops the doorman thread.
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
		gui.println("Doorman arrived at work, looking for victims!");
		try {
			while (!stop) {
				synchronized (queue) {
					try {
						while (!queue.hasMoreSpace()) queue.wait();
						queue.addCustomer(new Customer());
						gui.println("New customer!");
						queue.notify();
					} catch (IndexOutOfBoundsException e) {
						gui.println("This line should not be printed!");
					}
				}
				Thread.sleep(Globals.getDoormanSleep());
			}
		} catch (InterruptedException e) {
			System.out.println("Thread " + Thread.currentThread().getName() + " stopped");
			return;
		}
	}

	// Add more methods as needed
}

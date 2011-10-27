import java.util.NoSuchElementException;

/**
 * This class implements a queue of customers as a circular buffer.
 * 
 * Implemented by hvatum
 */
public class CustomerQueue {
	private Gui gui;
	private Customer[] array;
	private int queueStart;
	private int nextPos;

	/**
	 * Creates a new customer queue.
	 * 
	 * @param queueLength
	 *            The maximum length of the queue.
	 * @param gui
	 *            A reference to the GUI interface.
	 */
	public CustomerQueue(int queueLength, Gui gui) {
		this.array = new Customer[queueLength];
		this.gui = gui;
		this.queueStart = 0;
		this.nextPos = 0;
	}

	public synchronized void addCustomer(Customer customer) {
		if (hasMoreSpace()) {
			array[nextPos % array.length] = customer;
			gui.fillLoungeChair(nextPos++ % array.length, customer);
		} else {
			throw new IndexOutOfBoundsException("Køen er full!");
		}
	}
	
	public synchronized Customer removeCustomer() {
		if (hasCustomers()) {
			Customer customer = array[queueStart % array.length];
			gui.emptyLoungeChair(queueStart % array.length);
			array[queueStart++ % array.length] = null;
			return customer;
		} else {
			throw new NoSuchElementException("Kundekøen er tom!");
		}
	}

	public boolean hasCustomers() {
		return array[queueStart % array.length] != null;
	}

	public boolean hasMoreSpace() {
		return (nextPos - queueStart) < array.length;
	}

	public int getNextCustomerPos() {
		return queueStart % array.length;
	}
}


public class Cashier {

	private static Cashier instance;
	private int total;
	private int totalDeposits;
	private Gui gui;
	
	public static void init(Gui gui) {
		instance = new Cashier(gui);
	}
	
	private Cashier(Gui gui) {
		this.gui = gui;
		total = 0;
		totalDeposits = 0;
	}
	
	public synchronized void depositMoney(int money, int barberer) {
		gui.println("Customer at barberer " + barberer + " goes to cashier");
		try {
			Thread.sleep(Globals.getPaymentTime());
		} catch (InterruptedException e) {
			e.printStackTrace();
		}
		total += money;
		gui.println("Customer at barberer " + barberer + " deposits " + money);
		totalDeposits++;
		gui.println("Total money is " + total + ", total deposits is " + totalDeposits);
	}
	
	public String getTodaysTotal() {
		return "Total served was " + totalDeposits + ", with an incomme of " + total;
	}
	
	public static Cashier getInstance() {
		return instance;
	}
}

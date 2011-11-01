public class IO {
	private long maxCpuTime;
	private Queue ioQueue;
	private Statistics statistics;

	/** The amount of memory in the memory device */
	private long memorySize;
	/** The amount of free memory in the memory device */
	private long freeMemory;
	private Process currentProcess;

	private final EventQueue eventQueue;
	private final Gui gui;

	public IO(Queue ioQueue, Statistics statistics,
			EventQueue eventQueue, Gui gui) {
		this.ioQueue = ioQueue;
		this.statistics = statistics;
		this.eventQueue = eventQueue;
		this.gui = gui;
	}

	public void timePassed(long timePassed) {
		statistics.ioQueueLengthTime += ioQueue.getQueueLength() * timePassed;
		if (ioQueue.getQueueLength() > statistics.ioQueueLargestLength) {
			statistics.ioQueueLargestLength = ioQueue.getQueueLength();
		}
	}

	public void insertProcess(Process p, long clock) {
		ioQueue.insert(p);
		p.addedToIoQueue();
		statistics.insertsIOQueue++;
		if (currentProcess == null) {
			gui.setIoActive(p);
			currentProcess = (Process) ioQueue.removeNext();
			doIo(clock);
		}
	}

	public void doIo(long clock) {
		if (currentProcess != null) {
			long ioTimeNeeded = currentProcess.doIO();
			eventQueue.insertEvent(new Event(Simulator.END_IO, clock
					+ ioTimeNeeded));
			statistics.ioOps++;
			statistics.ioTimeSpent += ioTimeNeeded;
		}
	}

	public Process getCompletedProcess() {
		Process completed = currentProcess;
		if (ioQueue.getQueueLength() > 0) {
		currentProcess = (Process) ioQueue.removeNext();
		} else {
			currentProcess = null;
		}
		gui.setIoActive(currentProcess);
		return completed;
	}
}

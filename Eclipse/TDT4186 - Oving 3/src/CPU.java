public class CPU {
	private long maxCpuTime;
	private Queue cpuQueue;
	private Statistics statistics;

	/** The amount of memory in the memory device */
	private long memorySize;
	/** The amount of free memory in the memory device */
	private long freeMemory;
	private Process currentProcess;

	private final EventQueue eventQueue;
	private final Gui gui;

	public CPU(Queue cpuQueue, long maxCpuTime, Statistics statistics,
			EventQueue eventQueue, Gui gui) {
		this.cpuQueue = cpuQueue;
		this.maxCpuTime = maxCpuTime;
		this.statistics = statistics;
		this.eventQueue = eventQueue;
		this.gui = gui;
	}

	public void timePassed(long timePassed) {
		statistics.cpuQueueLengthTime += cpuQueue.getQueueLength() * timePassed;
		if (cpuQueue.getQueueLength() > statistics.cpuQueueLargestLength) {
			statistics.cpuQueueLargestLength = cpuQueue.getQueueLength();
		}
	}

	public void insertProcess(Process p, long clock) {
		cpuQueue.insert(p);
		p.addedToReadyQueue();
		statistics.insertsCPUQueue++;
		if (currentProcess == null && cpuQueue.getQueueLength() == 1) {
			eventQueue.insertEvent(new Event(Simulator.SWITCH_PROCESS, clock));
		}
	}

	public void work(long clock) {
		if (currentProcess != null) {
			long timeNeeded = currentProcess.getCpuNeeded();
			long nextIO = currentProcess.getCPUTimeToNextIO();
			if (timeNeeded > maxCpuTime && nextIO > maxCpuTime) {
				currentProcess.giveCpuTime(maxCpuTime);
				eventQueue.insertEvent(new Event(Simulator.SWITCH_PROCESS, clock + maxCpuTime));
				statistics.cpuTimeSpent += maxCpuTime;
				statistics.processShifts++;
			} else if (timeNeeded > nextIO && nextIO <= maxCpuTime) { // we must check if process need IO before it is finsihed
				currentProcess.giveCpuTime(nextIO);
				eventQueue.insertEvent(new Event(Simulator.IO_REQUEST, clock + nextIO));
				eventQueue.insertEvent(new Event(Simulator.SWITCH_PROCESS, clock + nextIO + 1));
				statistics.cpuTimeSpent += nextIO;
			} else if (timeNeeded <= maxCpuTime) {
				currentProcess.giveCpuTime(timeNeeded);
				eventQueue.insertEvent(new Event(Simulator.END_PROCESS, clock + timeNeeded));
				eventQueue.insertEvent(new Event(Simulator.SWITCH_PROCESS, clock + timeNeeded + 1));
				statistics.cpuTimeSpent += timeNeeded;
			}
		}
	}

	public Process endCurrentProcess() {
		Process endedProcess = null;
		if (currentProcess != null && currentProcess.getCpuNeeded() <= 0) {
			endedProcess = currentProcess;
			currentProcess = null;
		} else {
			System.err.println("BUG!");
		}
		gui.setCpuActive(null);
		return endedProcess;
	}

	public void switchProcess() {
		if (cpuQueue.getQueueLength() > 0) {
			if (currentProcess != null) {
				cpuQueue.insert(currentProcess);
			}
			currentProcess = (Process) cpuQueue.removeNext();
			gui.setCpuActive(currentProcess);
		}
	}

	public long getMaximumCpuTime() {
		return maxCpuTime;
	}

	public Process fetchCurrentProcess() {
		Process fetched = currentProcess;
		currentProcess = null;
		gui.setCpuActive(null);
		return fetched;
	}
}

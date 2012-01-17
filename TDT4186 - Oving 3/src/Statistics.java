/**
 * This class contains a lot of public variables that can be updated
 * by other classes during a simulation, to collect information about
 * the run.
 */
public class Statistics
{
	/** The number of processes that have exited the system */
	public long nofCompletedProcesses = 0;
	/** The number of processes that have entered the system */
	public long nofCreatedProcesses = 0;
	/** The total time that all completed processes have spent waiting for memory */
	public long totalTimeSpentWaitingForMemory = 0;
	/** The time-weighted length of the memory queue, divide this number by the total time to get average queue length */
	public long memoryQueueLengthTime = 0;
	/** The largest memory queue length that has occured */
	public long memoryQueueLargestLength = 0;
	
	/** The largest memory queue length that has occured */
	public long cpuQueueLargestLength = 0;
	/** The time-weighted length of the memory queue, divide this number by the total time to get average queue length */
	public long cpuQueueLengthTime = 0;
	
	public long cpuTimeSpent = 0;
	public long ioTimeSpent = 0;
	
	public int processShifts = 0;
	public long ioQueueLengthTime;
	public int ioQueueLargestLength;
	public int ioOps;
	public int insertsCPUQueue;
	public int insertsIOQueue;
	public long totalTimeSpentWaitingForCpu;
	public long totalTimeSpentWaitingForIO;
    
	/**
	 * Prints out a report summarizing all collected data about the simulation.
	 * @param simulationLength	The number of milliseconds that the simulation covered.
	 */
	public void printReport(long simulationLength) {
		System.out.println();
		System.out.println("Simulation statistics:");
		System.out.println();
		System.out.println("Number of completed processes:\t\t\t\t\t\t"+nofCompletedProcesses);
		System.out.println("Number of created processes:\t\t\t\t\t\t"+nofCreatedProcesses);
		System.out.println("Number of (forced) process switches:\t\t\t\t\t"+processShifts);
		System.out.println("Number of processed I/O operations:\t\t\t\t\t"+ioOps);
		System.out.println("Average throughput (processes per second):\t\t\t\t"+((float)nofCompletedProcesses*1000)/simulationLength);
		System.out.println();
		System.out.println("Total CPU time spent processing:\t\t\t\t\t"+cpuTimeSpent+" ms");
		System.out.println("Fraction of CPU time spent processing:\t\t\t\t\t"+fraction(cpuTimeSpent,simulationLength));
		System.out.println("Total CPU time spent waiting:\t\t\t\t\t\t"+(simulationLength-cpuTimeSpent+" ms"));
		System.out.println("Fraction of CPU time spent waiting:\t\t\t\t\t"+fraction((simulationLength-cpuTimeSpent), simulationLength));
		System.out.println();
		System.out.println("Largest occuring memory queue length:\t\t\t\t\t"+memoryQueueLargestLength);
		System.out.println("Average memory queue length:\t\t\t\t\t\t"+(float)memoryQueueLengthTime/simulationLength);
		System.out.println("Largest occuring cpu queue length:\t\t\t\t\t"+cpuQueueLargestLength);
		System.out.println("Average CPU queue length:\t\t\t\t\t\t"+(float)cpuQueueLengthTime/simulationLength);
		System.out.println("Largest occuring I/O queue length:\t\t\t\t\t"+ioQueueLargestLength);
		System.out.println("Average I/O queue length:\t\t\t\t\t\t"+(float)ioQueueLengthTime/simulationLength);
		if(nofCompletedProcesses > 0) {
			System.out.println("Average # of times a process has been placed in memory queue:\t\t"+1);
			System.out.println("Average # of times a process has been placed in cpu queue:\t\t"+((float)insertsCPUQueue/nofCreatedProcesses));
			System.out.println("Average # of times a process has been placed in I/O queue:\t\t"+((float)insertsIOQueue/nofCreatedProcesses));
			System.out.println();
			System.out.println("Average time spent in system per process:\t\t\t\t"+
					simulationLength/nofCompletedProcesses+" ms");
			System.out.println("Average time spent waiting for memory per process:\t\t\t"+
				totalTimeSpentWaitingForMemory/nofCompletedProcesses+" ms");
			System.out.println("Average time spent waiting for cpu per process:\t\t\t\t"+
					totalTimeSpentWaitingForCpu/nofCompletedProcesses+" ms");
			System.out.println("Average time spent processing per process:\t\t\t\t"+
					cpuTimeSpent/nofCreatedProcesses+" ms");
			System.out.println("Average time spent waiting for I/O per process:\t\t\t\t"+
					totalTimeSpentWaitingForCpu/nofCompletedProcesses+" ms");
			System.out.println("Average time spent in I/O per process:\t\t\t\t\t"+
					ioTimeSpent/nofCompletedProcesses+" ms");
		}
	}

	private String fraction(float numerator, float denominatior) {
		return String.format("%f%s", (float)(((float)numerator*100)/(float)denominatior), "%");
	}
}


public class EightPuzzleManhattanState extends EightPuzzleState {
	public EightPuzzleManhattanState(int[][] current) {
		super(current);
	}

	private EightPuzzleManhattanState(int[][] current, boolean verbose) {
		super(current, verbose);
	}

	@Override
	public int estimate(State goal) {
		if (goal instanceof EightPuzzleState) {
			int estimate = 0;
			for (int i = 0; i < current.length; i++) {
				for (int j = 0; j < current[i].length; j++) {
					if (current[i][j] != 0) {
					SimplePoint other = findPosOf(((EightPuzzleState) goal).current, current[i][j]);
					estimate += new SimplePoint(j, i).manhattanDistance(other);
					}
				}
			}
			return estimate;
		} else {
			return Integer.MAX_VALUE;
		}
	}

	@Override
	protected EightPuzzleState createNew(SimplePoint posOfEmpty, SimplePoint neighbour) {
		return new EightPuzzleManhattanState(swap(current, posOfEmpty, neighbour), isVerbose());
	}
}

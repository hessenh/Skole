
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
			for (int y = 0; y < current.length; y++) {
				for (int x = 0; x < current[y].length; x++) {
					if (current[y][x] != 0) {
					SimplePoint other = findPosOf(((EightPuzzleState) goal).current, current[y][x]);
					estimate += new SimplePoint(x, y).manhattanDistance(other);
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

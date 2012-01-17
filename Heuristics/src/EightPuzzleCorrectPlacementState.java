
public class EightPuzzleCorrectPlacementState extends EightPuzzleState {
	private static final int[][] END = EightPuzzle.GOAL_ARRAY;

	public EightPuzzleCorrectPlacementState(int[][] current) {
		super(current);
	}

	private EightPuzzleCorrectPlacementState(int[][] current, boolean verbose) {
		super(current, verbose);
	}

	@Override
	public int estimate(State goal) {
		if (goal instanceof EightPuzzleState) {
			int estimate = 0;
			for (int i = 0; i < current.length; i++) {
				for (int j = 0; j < current[i].length; j++) {
					if (current[i][j] != END[i][j]) {
						estimate++;
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
		return new EightPuzzleCorrectPlacementState(swap(current, posOfEmpty, neighbour), isVerbose());
	}
}

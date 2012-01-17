public class EightPuzzleManhattanConstantState extends EightPuzzleState {
	public EightPuzzleManhattanConstantState(int[][] current) {
		super(current);
	}

	private EightPuzzleManhattanConstantState(int[][] current, boolean verbose) {
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
						estimate += new SimplePoint(j, i).manhattanDistance(other) * 1.25;
					}
				}
			}
			return estimate;
		} else {
			return Integer.MAX_VALUE;
		}
	}

	@Override
	protected EightPuzzleState createNew(SimplePoint posOfEmpty,
			SimplePoint neighbour) {
		return new EightPuzzleManhattanConstantState(swap(current, posOfEmpty,
				neighbour), isVerbose());
	}
}

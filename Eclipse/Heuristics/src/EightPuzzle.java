import java.util.ArrayList;
import java.util.List;

public class EightPuzzle extends IDAStar {
	static final int[][] GOAL_ARRAY = new int[][] { { 1, 2, 3 }, { 8, 0, 4 }, { 7, 6, 5 } };
	static final State GOAL = new EightPuzzleManhattanState(GOAL_ARRAY);

	public EightPuzzle(Node start) {
		initialnode = start;
		goalnode = new Node(GOAL, 1);
	}

	public static void main(String[] args) {

		int initarray1[][] = { { 2, 8, 3 }, { 1, 6, 4 }, { 7, 0, 5 } };
		int initarray2[][] = { { 5, 4, 0 }, { 6, 1, 7 }, { 8, 3, 2 } };
		int initarray3[][] = { { 5, 6, 7 }, { 4, 0, 8 }, { 3, 2, 1 } };

		List<EightPuzzleState> work = new ArrayList<EightPuzzleState>();

		work.add(new EightPuzzleCorrectPlacementState(initarray1));
		work.add(new EightPuzzleManhattanState(initarray1));
		work.add(new EightPuzzleManhattanImprovedState(initarray1));

//		work.add(new EightPuzzleCorrectPlacementState(initarray2));
		work.add(new EightPuzzleManhattanState(initarray2));
		work.add(new EightPuzzleManhattanImprovedState(initarray2));

//		work.add(new EightPuzzleCorrectPlacementState(initarray3));
		work.add(new EightPuzzleManhattanState(initarray3));
		work.add(new EightPuzzleManhattanImprovedState(initarray3));

		for (EightPuzzleState state : work) {
//			state.setVerbose(true);
			Node start = new Node(state, 1);
			EightPuzzle a = new EightPuzzle(start);
			System.out.println(state.getClass().getSimpleName() + ": " + state.estimate(GOAL));
			a.solve();
			System.out.println();
			System.out.println();
		}
	}
}

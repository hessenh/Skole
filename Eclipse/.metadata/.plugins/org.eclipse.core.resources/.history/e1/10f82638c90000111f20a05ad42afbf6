import java.util.List;
import java.util.NoSuchElementException;
import java.util.Vector;

public abstract class EightPuzzleState extends State {
	protected int[][] current;
	private boolean verbose;

	public EightPuzzleState(int[][] current, boolean verbose) {
		this(current);
		setVerbose(verbose);
	}

	public void setVerbose(boolean verbose) {
		this.verbose = verbose;
	}

	public EightPuzzleState(int[][] current) {
		this.current = current;
	}

	@Override
	public boolean equals(State state) {
		if (state instanceof EightPuzzleState) {
			int[][] otherState = ((EightPuzzleState) state).current;
			if (otherState.length != current.length) {
				return false;
			}
			for (int i = 0; i < current.length; i++) {
				if (otherState[i].length != current[i].length) {
					return false;
				}
				for (int j = 0; j < current.length; j++) {
					if (otherState[i][j] != current[i][j]) {
						return false;
					}
				}
			}
			return true;
		} else {
			return false;
		}
	}

	@Override
	public String toString() {
		StringBuilder sb = new StringBuilder();
		sb.append('{');
		for (int i = 0; i < current.length; i++) {
			sb.append('{');
			for (int j = 0; j < current[i].length; j++) {
				sb.append(current[i][j]).append(' ');
			}
			sb.append('}');
		}
		sb.append('}');
		return sb.toString();
	}

	public static SimplePoint findPosOf(int[][] array, int needle) {
		for (int y = 0; y < array.length; y++) {
			for (int x = 0; x < array[y].length; x++) {
				if (array[y][x] == needle) {
					return new SimplePoint(x, y);
				}
			}
		}
		throw new NoSuchElementException();
	}

	@Override
	public Vector<State> successors() {
		Vector<State> successors = new Vector<State>();
		SimplePoint posOfEmpty = findPosOf(current, 0);
		List<SimplePoint> neighbours = posOfEmpty.getNeighbours();
		for (SimplePoint neighbour : neighbours) {
			successors.add(createNew(posOfEmpty, neighbour));
		}
		if (verbose) {
			System.out.println("New Iteration: ");
			System.out.println(neighbours);
			System.out.println(this);
			System.out.println(successors);
			System.out.println();
		}
		return successors;
	}

	protected abstract EightPuzzleState createNew(SimplePoint posOfEmpty, SimplePoint neighbour);

	protected boolean isVerbose() {
		return verbose;
	}

	protected int[][] swap(int[][] array, SimplePoint p1, SimplePoint p2) {
		int[][] clone = clone(array);
		int temp = clone[p1.y][p1.x];
		clone[p1.y][p1.x] = clone[p2.y][p2.x];
		clone[p2.y][p2.x] = temp;
		return clone;
	}

	private int[][] clone(int[][] array) {
		int[][] clone = new int[array.length][];
		for (int i = 0; i < array.length; i++) {
			clone[i] = new int[array[i].length];
			for (int j = 0; j < array[i].length; j++) {
				clone[i][j] = array[i][j];
			}
		}
		return clone;
	}
}

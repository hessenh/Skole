import java.util.ArrayList;
import java.util.List;

public class SimplePoint {

	public static int mapSize = 3;

	int x;
	int y;

	public SimplePoint(int x, int y) {
		this.x = x;
		this.y = y;
	}

	public static int manhattanDistance(SimplePoint thisOne, SimplePoint other) {
		return Math.abs(thisOne.x - other.x) + Math.abs(thisOne.y - other.y);
	}

	public int manhattanDistance(SimplePoint other) {
		return manhattanDistance(this, other);
	}

	public List<SimplePoint> getNeighbours() {

		int[] xPoints;
		if (x > 0 && x < (mapSize - 1)) {
			xPoints = new int[] { x - 1, x + 1 };
		} else if (x == (mapSize - 1)) {
			xPoints = new int[] { x - 1 };
		} else if (x == 0) {
			xPoints = new int[] { 1 };
		} else {
			xPoints = new int[] {};
		}

		int[] yPoints;
		if (y > 0 && y < (mapSize - 1)) {
			yPoints = new int[] { y - 1, y + 1 };
		} else if (y == (mapSize - 1)) {
			yPoints = new int[] { y - 1 };
		} else if (y == 0) {
			yPoints = new int[] { 1 };
		} else {
			yPoints = new int[] {};
		}
		ArrayList<SimplePoint> neighbours = new ArrayList<SimplePoint>();
		for (int x : xPoints) {
			neighbours.add(new SimplePoint(x, y));
		}
		for (int y : yPoints) {
			neighbours.add(new SimplePoint(x, y));
		}
		return neighbours;
	}

	@Override
	public boolean equals(Object obj) {
		if (obj instanceof SimplePoint) {
			SimplePoint other = (SimplePoint) obj;
			return other.x == x && other.y == y;
		} else {
			return super.equals(obj);
		}
	}

	@Override
	public String toString() {
		return "(" + x + "," + y + ")";
	}
}

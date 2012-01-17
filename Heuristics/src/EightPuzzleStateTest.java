import static org.junit.Assert.assertEquals;

import org.junit.Test;


public class EightPuzzleStateTest {


	@Test
	public void testEstimate() {
		int initarray[][] = { { 2, 8, 3 }, { 1, 6, 4 }, { 7, 0, 5 } };
		EightPuzzleState eps = new EightPuzzleManhattanState(initarray);
		assertEquals(5, eps.estimate(EightPuzzle.GOAL));
	}
}

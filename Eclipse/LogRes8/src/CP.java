import java.util.Vector;
import java.applet.*;
import java.awt.*;
import java.awt.event.*;
import java.lang.Thread;

//   First of all, I (the programmer) is not very proficient
//   with Java. Therefore the use of the language is not very
//   good. But that is beside the point of this exercise.
//
//   Since this is multithreaded, strange behaviour
//   might occur on occasions.
//   
//   The idea of the game belongs to Tore Amble.
//
//   This file contains the main applet, which also doubles as the
//   main game controller, and a subclass of Canvas used for the
//   actual GUI. At the end is a small class used for markers in
//   the matrix.
//
//   In this file, you only have to look at one method in class CP,
//   and use two other methods.

//   ****************** class CP *********************
//   Contains the main game controlls. Most of the GUI stuff
//   is moved to the ArenaCanvas class.
// 
//   The only thing that may need to be changed here during
//   this excercise, is the KeyPressed(KeyEvent) method. That
//   is where the player objects are created. If you create
//   a new class for the AlphaBeta algorithm, you need to
//   instantiate it inside this method.
//   It should be self-explaining when looking at it.
//
//   One of the methods you will have to call is the
//   makeMove(Move) method. When this is called with a correct
//   move the main GameState will be updated. Control will be
//   passed on to the next player.
//
//   The other method is createState(GameState,Move). This method
//   takes an old GameState and a Move and returns a new GameState.
//   This new GameState is totally independent of the old GameState
//   object. The original GameState object is not altered.

public class CP extends Applet implements KeyListener {

	// For simplicity we define some basic
	public static final int arenaWidth = 20; // Arena width
	public static final int arenaHeight = 20; // Arena height

	protected static final int initialXPosHuman = 10;
	protected static final int initialYPosHuman = 0;
	protected static final int initialXPosMinMax = 10;
	protected static final int initialYPosMinMax = 19;

	public ArenaCanvas arena; // This can be used by Player classes

	protected boolean game = false;
	protected Vector players; // actually playercontrollers
	protected GameState gamestate;
	private int initialYAlphaBeta = 10;
	private int initialXPosAlphaBeta = 0;

	public void init() {
		this.removeAll();

		this.setBackground(Color.white);

		arena = new ArenaCanvas(arenaWidth, arenaHeight);
		this.add(arena);

		arena.addKeyListener(this);
		this.addKeyListener(this);

		arena.setMessage("Press a key to start!");
	}

	// These two are not used
	public void keyTyped(KeyEvent e) {
	}

	public void keyPressed(KeyEvent e) {
	}

	// This does nothing if during a game...
	// If no game is running, it starts a new game on keypress.
	//
	// Alse game restart at a keypress could be added.
	// If so, you would have to keep track of computation threads.
	public void keyReleased(KeyEvent e) {
		if (game == false) {
			arena.clearMessage();

			// Add two players...
			Vector playerstates = new Vector();
			players = new Vector();

			Player h1 = new MinMaxImprovedPlayer(this, "Computer using MinMaxImproved");
			players.addElement(h1);
			playerstates.addElement(new PlayerState(initialXPosHuman,
					initialYPosHuman, 0, 0, 0));

			Player h2 = new MinMaxImprovedPlayer(this, "Computer using MinMax");
			players.addElement(h2);
			playerstates.addElement(new PlayerState(initialXPosMinMax,
					initialYPosMinMax, 0, 0, 0));

			// initialize a new game with the two players
			gamestate = new GameState(playerstates, 0);

			updateGUI();
			game = true;
			((Player) players.elementAt(gamestate.playerturn))
					.yourMove(gamestate);
		}
	}

	// This is called from the Player classes when
	// a move is made. It doesn't check for cheating,
	// other than moving out of order.
	public synchronized void makeMove(Move m) {
		if (m.player == gamestate.playerturn) {
			gamestate = createState(gamestate, m);

			if (gamestate.alive() <= 1) {
				String msg = "";
				int winner = -1;
				for (int p = 0; p < gamestate.playerstates.size(); p++) {
					if (((PlayerState) gamestate.playerstates.elementAt(p)).condition == 0)
						winner = p;
				}
				msg = ((Player) players.elementAt(winner)).getName();
				msg += " (";
				msg += arena.playerToColorName(winner);
				msg += ") WON! - Press a key to restart ";
				arena.setMessage(msg);
				game = false;
				updateGUI();
			}

			else {
				((Player) players.elementAt(gamestate.playerturn))
						.yourMove(gamestate);
			}
			updateGUI();

		} else {
			// This part not tested!
			arena.setMessage("Wrong player moved! Press any key to restart!");
			game = false;
			updateGUI();
		}
if (!humanPlayerExists()) {
	try {
		Thread.sleep(200);
	} catch (InterruptedException e) {
		e.printStackTrace();
	}
}
	}

	// This method will create a new GameState object from
	// an old GameState and a Move. This new object and all
	// object it contains will be separate from old objects,
	// so that they can be manipulated without fear of mixing
	// up earlier objects.

	private boolean humanPlayerExists() {
		for (Object player : players) {
			if (player instanceof HumanPlayer) {
				return true;
			}
		}
		return false;
	}

	public GameState createState(GameState gs, Move m) {

		if (m.player != gs.playerturn)
			System.err.println("Move mixup!");
		Vector pls = new Vector();
		for (int p = 0; p < gs.playerstates.size(); p++) {
			PlayerState ps = (PlayerState) gs.playerstates.elementAt(p);
			pls.addElement(new PlayerState(ps.x, ps.y, ps.dx, ps.dy,
					ps.condition));
		}

		GameState s = new GameState(pls, gs.playerturn);
		PlayerState ps = (PlayerState) s.playerstates.elementAt(s.playerturn);
		ps.dx += m.ddx;
		ps.dy += m.ddy;
		ps.x += ps.dx;
		ps.y += ps.dy;

		// legal positions 0-19 both x and y
		if ((ps.x < 0) || (ps.x > 19) || (ps.y < 0) || (ps.y > 19)) {
			ps.condition = -2; // -2 is ran off
		}

		// Check if hit someone
		for (int p = 0; p < 2; p++) {
			if (p != m.player) { // You don't win if you're in the same position
									// as yourself
				if ((ps.x == ((PlayerState) s.playerstates.elementAt(p)).x)
						&& (ps.y == ((PlayerState) s.playerstates.elementAt(p)).y)) {
					((PlayerState) s.playerstates.elementAt(p)).condition = -1; // -1
																				// =
																				// squished
				}
			}
		}

		// Update playerturn
		s.playerturn += 1;
		if (s.playerturn >= s.playerstates.size())
			s.playerturn = 0;

		return s;
	}

	public void updateGUI() {
		arena.clearBoard();

		for (int p = 0; p < gamestate.playerstates.size(); p++) {
			if (gamestate.playerturn == p)
				arena.addMarker(
						(PlayerState) gamestate.playerstates.elementAt(p), p,
						true);
			else
				arena.addMarker(
						(PlayerState) gamestate.playerstates.elementAt(p), p,
						false);

		}
		arena.repaint();
	}
}

// *****************************************
// *********** GUI Support classes *********
// *****************************************
//
// You don't have to mess around in the rest of this file...

class ArenaCanvas extends Canvas implements Runnable {
	// This class provides the game grid itself, and the necessary methods
	// for displaying the game's progress onto the grid.

	int aw;
	int ah;
	String message;

	// Pixelsize of the grid cells..
	int sqsize = 16;

	Vector markers;
	Vector removed;

	// Animation
	boolean animation = false;

	public ArenaCanvas(int aw, int ah) {
		this.aw = aw;
		this.ah = ah;
		markers = new Vector();
		removed = new Vector();
		clearMessage();
	}

	public void clearMessage() {
		message = "";
	}

	public void setMessage(String s) {
		message = s;
	}

	public void run() {
		while (animation) {
			animate();
			try {
				wait(2);
			} catch (Exception e) {
			}
		}
	}

	public synchronized void animate() {

		for (int m = 0; m < markers.size(); m++) {
			Graphics g = this.getGraphics();
			Marker ma = (Marker) markers.elementAt(m);
			if (ma.active) {
				g.setColor(Color.cyan);
				g.drawOval((ma.x * sqsize) + (sqsize / 4) - 2, (ma.y * sqsize)
						+ (sqsize / 4) - 2, sqsize / 2 + 4, sqsize / 2 + 4);

			}
		}
	}

	public synchronized int addMarker(PlayerState ps, int player, boolean active) {
		Color co = playerToColor(player);
		markers.addElement(new Marker(ps.x, ps.y, ps.dx, ps.dy, co, active));
		return markers.size();
	}

	public Color playerToColor(int player) {
		if (player == 0)
			return Color.red;
		if (player == 1)
			return Color.blue;
		if (player == 2)
			return Color.green;
		if (player == 3)
			return Color.cyan;
		return Color.black;
	}

	public String playerToColorName(int player) {
		if (player == 0)
			return "red";
		if (player == 1)
			return "blue";
		if (player == 2)
			return "green";
		if (player == 3)
			return "cyan";
		return "black";
	}

	public synchronized void clearBoard() {
		removed = markers;
		markers = new Vector();
		repaint();
	}

	public Dimension getPreferredSize() {
		return getMinimumSize();
	}

	public synchronized Dimension getMinimumSize() {
		return new Dimension((sqsize * aw) + 1, (sqsize * ah) + 41);
	}

	public void paint(Graphics g) {
		requestFocus();
		for (int m = 0; m < removed.size(); m++) {
			Marker ma = (Marker) removed.elementAt(m);
			mark(g, ma.x, ma.y, Color.white, Color.white);
			vector(g, ma.x, ma.y, ma.dx, ma.dy, Color.white);
		}
		removed = new Vector();

		// Draw grid
		g.setColor(Color.black);

		for (int x = 0; x < (aw + 1); x++)
			g.drawLine(x * sqsize, 0, x * sqsize, ah * sqsize);

		for (int y = 0; y < (ah + 1); y++)
			g.drawLine(0, y * sqsize, aw * sqsize, y * sqsize);

		// Draw message

		g.drawString(message, 5, (sqsize * ah) + 35);

		// Draw players

		for (int m = 0; m < markers.size(); m++) {
			Marker ma = (Marker) markers.elementAt(m);
			if (ma.active)
				mark(g, ma.x, ma.y, ma.c, Color.yellow);
			else
				mark(g, ma.x, ma.y, ma.c, Color.black);
		}

		for (int m = 0; m < markers.size(); m++) {
			Marker ma = (Marker) markers.elementAt(m);
			vector(g, ma.x, ma.y, ma.dx, ma.dy, ma.c);
		}
	}

	public void mark(Graphics g, int x, int y, Color back, Color border) {
		g.setColor(back);
		g.fillOval((x * sqsize) + (sqsize / 4), (y * sqsize) + (sqsize / 4),
				sqsize / 2, sqsize / 2);
		g.setColor(border);
		g.drawOval((x * sqsize) + (sqsize / 4), (y * sqsize) + (sqsize / 4),
				sqsize / 2, sqsize / 2);
	}

	public void vector(Graphics g, int x, int y, int dx, int dy, Color c) {
		g.setColor(c);
		g.drawLine(x * sqsize + sqsize / 2, y * sqsize + sqsize / 2, (x + dx)
				* sqsize + sqsize / 2, (y + dy) * sqsize + sqsize / 2);
		g.fillOval((x + dx) * sqsize + (sqsize / 2) - 2, (y + dy) * sqsize
				+ (sqsize / 2) - 2, 4, 4);
		g.drawLine((x + dx) * sqsize, (y + dy) * sqsize, (x + 1 + dx) * sqsize,
				(y + 1 + dy) * sqsize);
		g.drawLine((x + dx + 1) * sqsize, (y + dy) * sqsize, (x + dx) * sqsize,
				(y + 1 + dy) * sqsize);
	}

}

class Marker extends Object {

	Color c;
	int x;
	int y;
	int dx;
	int dy;
	boolean active = false;
	int anistate = 0;

	Marker(int x, int y, int dx, int dy, Color c, boolean active) {
		this.c = c;
		this.x = x;
		this.y = y;
		this.dx = dx;
		this.dy = dy;
		this.active = active;
	}
}

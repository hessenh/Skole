package no.hvatum.skole.logres.sudoku.console;

import java.io.IOException;
import java.io.OutputStream;
import java.io.PrintStream;

public class ConsoleStream extends OutputStream {

	private OutputStream outStream;
	private Console console;

	public ConsoleStream(PrintStream outStream, Console console, boolean isErr) {
		this.console = console;
		this.outStream = outStream;
	}

	public ConsoleStream(PrintStream outStream, Console console) {
		this(outStream, console, false);
	}

	@Override
	public void write(byte[] b, int off, int len) throws IOException {
		final char[] chars = new char[len - off];
		for (int i = off; i < len; i++) {
			chars[i] = (char) b[i];
		}
		outStream.write(b, off, len);
		console.write(String.valueOf(chars));
	}

	@Override
	public void write(int b) throws IOException {
		outStream.write((char) b);
	}

}

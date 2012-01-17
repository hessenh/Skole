
public class Sandbox {
	public static void main(String[] args) {
		String input = "[/";
		System.out.println(input.replaceAll("[\'~@#$%^&*()\";:<>/]", ""));
	}
}

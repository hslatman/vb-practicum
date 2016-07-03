package vb.week2;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;

public class Scanner {
	private int currentLineNr = 0;
	private InputStream in;
	private char currentChar;
	private String alphabet = "abcdefghijklmnopqrstuvwxyz";

	private static final char cSPACE = ' ', cTAB = '\t', cEOLr = '\r',
			cEOLn = '\n', cPERCENT = '%', cEOT = '\u0000', /* End OF Text */
			cBSLASH = '\u005C\u005C';

	// == '\\'
	// We cannot use the '\\' denotation here because
	// otherwise LaTeX's listings package will get very
	// confused. Students should use '\\' of course.

	/**
	 * Constructor.
	 * 
	 * @param in
	 *            the stream from which the characters will be read
	 */
	public Scanner(InputStream in) {
		this.in = in;
		this.currentChar = this.getNextChar();
	}
	
	public int getNumberOfLines(){
		return this.currentLineNr;
	}

	/*
	 * Returns the next character. Returns cEOT when end-of-file or in case of
	 * an error.
	 */
	private char getNextChar() {
		try {
			int ch = this.in.read();

			if (ch == -1) {
				ch = cEOT;
			} else if (ch == cEOLn) {
				this.currentLineNr++;
			}

			return (char) ch;
		} catch (IOException e) {
			return cEOT;
		}
	}

	/**
	 * Returns the next Token from the input.
	 * 
	 * @return the next Token
	 * @throws SyntaxError
	 *             when an unknown or unexpected character has been found in the
	 *             input.
	 */
	public Token scan() throws SyntaxError {
		String tkstring = "";
		Token res = null;
		while(res == null && currentChar != cEOT) {
			//System.out.println(currentChar);
			switch(currentChar){
				case cSPACE:
					currentChar = getNextChar();
					break;
				case cTAB:
					currentChar = getNextChar();
					break;
				case cEOLr:
					currentChar = getNextChar();
					break;
				case cEOLn:
					currentChar = getNextChar();
					break;
				case cPERCENT:
					int ln = this.currentLineNr;
					while(ln == this.currentLineNr){
						currentChar = getNextChar(); //wellicht nog een laatste keer getNextChar() aanroepen binnen cPERCENT...
					}
					break;
				case cBSLASH:
					currentChar = getNextChar();
					if (currentChar == cBSLASH){ //2e backslash
						res = new Token(Token.Kind.DOUBLE_BSLASH, Character.toString(cBSLASH) + Character.toString(cBSLASH));
						currentChar = getNextChar();
					} else {
						res = new Token(Token.Kind.BSLASH, Character.toString(cBSLASH)); //we hebben al een getNextChar gedaan, dus niet nog eens
					}
					break;
				case '{':
					res = new Token(Token.Kind.LCURLY, Character.toString(currentChar));
					currentChar = getNextChar();
					break;
				case '}':
					res = new Token(Token.Kind.RCURLY, Character.toString(currentChar));
					currentChar = getNextChar();
					break;
				case '&':
					res = new Token(Token.Kind.AMPERSAND, Character.toString(currentChar));
					currentChar = getNextChar();
					break;
				default:
					if(alphabet.contains(Character.toString(currentChar))){
						tkstring += currentChar;
						currentChar = getNextChar();
						while (Character.isLetter(currentChar) || Character.isDigit(currentChar)){
							tkstring += currentChar;
							currentChar = getNextChar();
						}
						if (tkstring.equals("begin")){
							res = new Token(Token.Kind.BEGIN, tkstring);
						} else if (tkstring.equals("end")){
							res = new Token(Token.Kind.END, tkstring);
						} else if (tkstring.equals("tabular")){
							res = new Token(Token.Kind.TABULAR, tkstring);
						} else {
							res = new Token(Token.Kind.IDENTIFIER, tkstring);
						}
						tkstring = "";
					} else if (alphabet.toUpperCase().contains(Character.toString(currentChar))){
						tkstring += currentChar;
						currentChar = getNextChar();
						while (Character.isLetter(currentChar) || Character.isDigit(currentChar)){
							tkstring += currentChar;
							currentChar = getNextChar();
						}
						if (tkstring.equals("begin")){
							res = new Token(Token.Kind.BEGIN, tkstring);
						} else if (tkstring.equals("end")){
							res = new Token(Token.Kind.END, tkstring);
						} else if (tkstring.equals("tabular")){
							res = new Token(Token.Kind.TABULAR, tkstring);
						} else {
							res = new Token(Token.Kind.IDENTIFIER, tkstring);
						}
						tkstring = "";
					} else if (Character.isDigit(currentChar)){
						tkstring += Character.toString(currentChar);
						currentChar = getNextChar();
						while (Character.isDigit(currentChar)){
							tkstring += Character.toString(currentChar);
							currentChar = getNextChar();
						}
						currentChar = getNextChar();
						res = new Token(Token.Kind.NUM, tkstring);
						tkstring = "";
					} else {
						//Unknown character found
						
						throw new SyntaxError("An unknown or unexpected character was found: " + currentChar);

					}
					break;
			}
		}
		return res;
	}
	
	public static void main(String[] args){
		if (args.length == 1){
			File f = new File(args[0]);
			FileInputStream in;
			try {
				in = new FileInputStream(f);
				Scanner scanner = new Scanner(in);
				Token t;
				while ((t = scanner.scan()) != null){
					//we've got a token :D
					//System.out.println("Token: " + t.getKind().getSpelling() + " " + t.getRepr());
					System.out.println(String.format("%-20s %-20s", t.getKind().getSpelling(), t.getRepr()));
				}
				System.out.println("Done Scanning.");
			} catch (FileNotFoundException e) {
				System.out.println("File not found: " + e.getMessage());
			} catch (SyntaxError e) {
				System.out.println("Syntax Error: " + e.getMessage());
			}
		} else {
			System.out.println("Geef een bestand op om te scannen!");
		}
	}

}

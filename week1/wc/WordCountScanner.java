package vb.week1.wc;

import java.io.IOException;
import java.util.Scanner;

public class WordCountScanner extends WordCount {

	@Override
	public void count() throws IOException {
        nChars = nWords = nLines = 0;
        Scanner scan = new Scanner(reader);
        
        while(scan.hasNextLine()) {
        	String line = scan.nextLine();
        	Scanner lineScan = new Scanner(line);
        	nLines ++;
        	nChars += line.length() + 1;
        	while(lineScan.hasNext()) {
        		String word = lineScan.next();
        		nWords++;
        	}
        }
    }
	public static void main(String[] args) {
        wcArgs(args, new WordCountScanner());
    }
}

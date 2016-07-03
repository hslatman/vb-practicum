package vb.week1.symtab;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;

public class ParserPlusPlus {

	private BufferedReader reader;
	private String lowAlphabet = "abcdefghijklmnopqrstuvwxyz";
	private int numHaakjes = 0;
	private SymbolTable<IdEntry> table = new SymbolTable<IdEntry>();
    
    public void parse(File f){
    	
    	System.out.println(f);
    	System.out.println("Started parsing....");
    	
    	String total = "";
    	
		try {
			reader = new BufferedReader(new FileReader(f));
			while (reader.ready()){
				total += reader.readLine();
			}
	    	int index = 0;
	    	numHaakjes = 0;
	    	boolean foundD = false;
	    	boolean foundU = false;
	    	boolean errorWhileParsing = false;
	    	while (index < total.length()){
	    		
	    		char c = total.charAt(index);
	    		
	    		if (!Character.isWhitespace(c)){
		    		switch (c){
		    			case '(':
		    				table.openScope();
		    				numHaakjes++;
		    				index++;
		    				break;
		    			case ')':
		    				if(numHaakjes > 0){
		    					table.closeScope();
		    					numHaakjes--;
		    					index++;
		    				} else {
		    					System.out.println("Geen overeenkomend openingshaakje gevonden!");
		    					errorWhileParsing = true;
		    				}
		    				break;
		    			case 'D':
		    				char dnc = total.charAt(index + 1);
		    				char dnnc = total.charAt(index + 2);
		    				if (dnc == ':' && lowAlphabet.contains(Character.toString(dnnc))){
		    					String identifier = "";
		    					int walker = 2;
		    					char k = total.charAt(index + walker);
		    					walker++;
		    					while (lowAlphabet.contains(Character.toString(k)) && index + walker < total.length()){
		    						//we're still reading an identifier...
		    						identifier += k;
		    						k = total.charAt(index + walker);
		    						walker++;
		    					}
		    					IdEntry ie = new IdEntry();
								try {
									table.enter(identifier, ie);
									System.out.println("D:" + identifier + " on level " + ie.getLevel());
								} catch (SymbolTableException e) {
									System.out.println(e.getMessage());
								}
		    					index += 2;
		    					foundD = true;
		    				} else {
		    					System.out.println("Verkeerd gebruik van 'D'!");
		    					errorWhileParsing = true;
		    				}
		    				break;
		    			case 'U':
		    				char unc = total.charAt(index + 1);
		    				char unnc = total.charAt(index + 2);
		    				if (unc == ':' && lowAlphabet.contains(Character.toString(unnc))){
		    					String identifier = "";
		    					int walker = 2;
		    					char k = total.charAt(index + walker);
		    					walker++;
		    					while (lowAlphabet.contains(Character.toString(k)) && index + walker < total.length()){
		    						//we're still reading an identifier...
		    						identifier += k;
		    						k = total.charAt(index + walker);
		    						walker++;
		    					}
		    					System.out.print("U:" + identifier + " on level " + table.currentLevel());
		    					IdEntry ie = table.retrieve(identifier);
		    					if (ie != null){
		    						System.out.println(", declared on level " + ie.getLevel());
		    						foundU = true;
		    					} else {
		    						System.out.println(", *undeclared*");
		    					}
		    					index += 2;
		    				} else {
		    					System.out.println("Verkeerd gebruik van 'U'!");
		    					errorWhileParsing = true;
		    				}
		    				break;
		    			default:
		    				if (lowAlphabet.contains(Character.toString(c))){
		    					if (foundD){
	    							//foundD = false;
	    							index++;
	    						} else if (foundU){
	    							//foundU = false;
	    							index++;
		    					} else {
		    						System.out.println("Verkeerd gebruik van karakter (geen declaratie)");
		    						errorWhileParsing = true;
		    					}
		    				} else {
		    					System.out.println("Onbekend karakter gevonden!");
		    					errorWhileParsing = true;
		    				}
		    				break;
		    		}
		    	} else {
		    		//Itereren zolang er whitespace is
		    		index++;
		    	}
	    	}
	    	if (!errorWhileParsing && numHaakjes == 0){
	    		System.out.println("Geparsed!");
	    	} else {
	    		System.out.println("FOUTJE");
	    	}
		} catch (FileNotFoundException e1) {
			e1.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}

    }
	
	public static void par(String[] args, ParserPlusPlus parser){
		for (int i = 0; i < args.length; i++) {
            String fname = args[i];
            File f = new File(fname);
			parser.parse(f);
		}
	}
	
	public static void main(String[] args){
		par(args, new ParserPlusPlus());
	}
	
}

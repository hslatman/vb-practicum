// [file: CalcInterpreter.g, started: 22-Apr-2008]
//
// Calc - Simple calculator with memory variables.
// CalcInterpreter.g: interpreter
//
// @author   Theo Ruys
// @version  2008.04.22

tree grammar CalcInterpreter;

options {
    tokenVocab=Calc;                    // import tokens from Calc.tokens
    ASTLabelType=CommonTree;            // AST nodes are of type CommonTree
}

@header {
package vb.week3.calc;
import java.util.Map;
import java.util.HashMap;
import vb.week3.calc.CalcException;
}

@members { 
    private Map<String,Integer> store = new HashMap<String,Integer>();   
    
    int debug_count = 0;
    int length;
    boolean has_run_once = false;
}



//Below catches the CalcException, then throws it. See the link for explanation
//http://stackoverflow.com/questions/8658753/antlr-not-throwing-errors-on-invalid-input
@rulecatch { 
    catch (CalcException ce) { 
        throw ce; 
    } 
}

program
    :   ^(PROGRAM (declaration | statement)+)
    ;
    
declaration
    :   ^(VAR id=IDENTIFIER type)
            { store.put($id.text, 0); } 
    ;

statement

    :   ^(BECOMES id=IDENTIFIER v=expr)
            { store.put($id.text, v);       }
    |   ^(PRINT v=expr)
            { System.out.println("" + v);   }
    |   ^(SWAP i1=IDENTIFIER i2=IDENTIFIER)
            { 	int t = store.get($i1.text); 
            	store.put($i1.text, store.get($i2.text)); 
            	store.put($i2.text, t); 
            }
    |  do_statement2
    ;


alt_do_statement
@init { System.out.println("START ALT_DO_STATEMENT"); System.out.println("INIT INDEX: " + input.index());}
@after { System.out.println("END ALT_DO_STATEMENT"); } 
    :   ^(head=DO {System.out.println(head); int i = input.mark(); int loophead = input.index(); System.out.println(loophead);} e=expr { if (e==1){ System.out.println("LOOP");  }} statement+)
    ;
    

do_statement2
@init { int i = input.index(); }
    :   ^(DO statement+ WHILE e=expr)
                {
                    if(e != 0){
                        input.rewind(i);
                        do_statement2();
                    }
                }
    ;

do_statement
@init { int i = input.index(); }
@after {  } 
    :   ^(DO e=expr stats=statement+)
            {
                if(e != 0){
                // Probleem zit hem in het feit dat de expr eerst gecheckt wordt, terwijl hij nog in de statements geüpdate kan worden
                // Zo zal de do-while altijd een keer te vaak uitgevoerd worden, als het niet anders geïmplementeerd wordt.
                // De do-while doet het correct als de loopvariabele geïnitialiseerd wordt op de waarde die uiteindelijk gecheckt wordt
                // i = 3; do print(i); i := i + 1; while i < 3; gaat correct, bijvoorbeeld
					  // http://antlr.1301665.n2.nabble.com/Tree-Grammar-for-loops-td4592670.html
	                  //input.release(i);
	                  //input.seek(i);
	                  //has_run_once = true;
	                  
	                  input.rewind(i);
	                  
                }
            }
    ;
    
expr returns [int val = 0;] 
    :   z=operand               { val = z;      }
    |   ^(PLUS x=expr y=expr)   { val = x + y;  }
    |   ^(MINUS x=expr y=expr)  { val = x - y;  }
    |   ^(MULT x=expr y=expr)  	{ val = x * y;  }
    |   ^(DIV x=expr y=expr) 	{ 	if(y==0){
    									val = -1;
    									//TODO: add the CalcException!
    									throw new CalcException("Division by 0!");
    								} else {
    									val = x / y;
    								}
    							}
    |   ^(IF c=expr e1=expr e2=expr) 	{ 	if(c == 0) { 
	    										val = e2; 
	    									} else { 
	    										val = e1; 
	    									}
	    								}
	|   ^(SMALLER e1=expr e2=expr) 		{ 	if(e1 < e2){ 
												val = 1; 
											} else { 
												val = 0;
											}
										}
    |   ^(SMALLOREQ e1=expr e2=expr) 	{ 	
                        System.out.println("SMALLOREQ");
                        if(e1 <= e2){
    											val = 1; 
    										} else { 
    											val = 0; 
    										}
    									}
    |   ^(GREATER e1=expr e2=expr) 		{ 	if(e1 > e2){
    											val = 1; 
    										} else {
    											val = 0; 
    										}
    									}
    |   ^(GREATOREQ e1=expr e2=expr) 	{ 	if(e1 >= e2){
    											val = 1; 
    										} else {
    											val = 0; 
    										}
    									}
    |   ^(EQUALS e1=expr e2=expr) 		{ 	if(e1 == e2){
    											val = 1; 
    										} else {
    											val = 0; 
    										}
    									}
    |   ^(NOTEQUALS e1=expr e2=expr) 	{ 	if(e1 != e2){
    											val = 1; 
    										} else {
    											val = 0; 
    										}
    									}
    |   ^(BECOMES id=IDENTIFIER v=expr) { store.put($id.text, v); val = v; }
    ;
    
operand returns [int val = 0]
    :   id=IDENTIFIER   { val = store.get($id.text);       } 
    |   n=NUMBER        { val = Integer.parseInt($n.text); }
    ;
    
type
    :   INTEGER
    ;

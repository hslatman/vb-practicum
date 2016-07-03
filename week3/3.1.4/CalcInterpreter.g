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
    |   ^(IF c=expr e1=expr e2=expr) 	{ 
	    									if(c == 0) { 
	    										val = e2; 
	    									} else { 
	    										val = e1; 
	    									}
	    								}
    ;
    
operand returns [int val = 0]
    :   id=IDENTIFIER   { val = store.get($id.text);       } 
    |   n=NUMBER        { val = Integer.parseInt($n.text); }
    ;
    
type
    :   INTEGER
    ;

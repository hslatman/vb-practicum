tree grammar CalcChecker;

options {
    tokenVocab=Calc;                    // import tokens from Calc.tokens
    ASTLabelType=CommonTree;            // AST nodes are of type CommonTree
}

@header {
package vb.week3.calc;
import java.util.Set;
import java.util.HashSet;
}

// Alter code generation so catch-clauses get replaced with this action. 
// This disables ANTLR error handling: CalcExceptions are propagated upwards.
@rulecatch { 
    catch (RecognitionException e) { 
        throw e; 
    } 
}

@members {
    // idset - a set of declared identifiers.
    private Set<String> idset = new HashSet<String>();   
    
    public boolean  isDeclared(String s)     { return idset.contains(s); }
    public void     declare(String s)        { idset.add(s);             }
}

program
    :   ^(PROGRAM (declaration | statement)+)
    ;
    
declaration
    :   ^(VAR id=IDENTIFIER type)
        {   if (isDeclared($id.text))
                throw new CalcException($id, "is already declared");
            else 
                declare($id.getText()); 
        }
    ;
 
statement 
    :   ^(BECOMES id=IDENTIFIER expr)
        {   if (!isDeclared($id.text))
                throw new CalcException($id, "is not declared");
        }
    |   ^(PRINT expr)
    |   ^(SWAP IDENTIFIER IDENTIFIER)
    ;
    
expr 
    :   operand
    |   ^(PLUS expr expr)
    |   ^(MINUS expr expr)
    |	^(MULT expr expr)
    |	^(DIV expr expr)
    |   ^(IF expr expr expr )
    |   ^(SMALLER expr expr)
    |   ^(SMALLOREQ expr expr)
    |   ^(GREATER expr expr)
    |   ^(GREATOREQ expr expr)
    |   ^(EQUALS expr expr)
    |   ^(NOTEQUALS expr expr)
    ;
    
operand
    :   id=IDENTIFIER 
        {   if (!isDeclared($id.text))
                throw new CalcException($id, "is not declared");
        }
    |   n=NUMBER 
    ;
    
type
    :   INTEGER
    ;

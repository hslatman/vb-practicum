grammar Calc;

options {
    k=2;                                // LL(1) - do not use LL(*)
    language=Java;                      // target language is Java (= default)
    output=AST;                         // build an AST
}

tokens {
    COLON       =   ':'     ;
    SEMICOLON   =   ';'     ;
    LPAREN      =   '('     ;
    RPAREN      =   ')'     ;
    COMMA		=	','		;

    // operators
    BECOMES     =   ':='    ;
    PLUS        =   '+'     ;
    MINUS       =   '-'     ;
    MULT		=	'*'		;
    DIV			=	'/'		;

    // keywords
    PROGRAM     =   'program'   ;
    VAR         =   'var'       ;
    PRINT       =   'print'     ;
    INTEGER     =   'integer'   ;
    
   	SWAP		=	'swap'		;
    IF			=	'if'		;
    THEN		=	'then'		;
    ELSE		=	'else'		;
    
    // relational operators
   	SMALLER			=   '<'     ;
   	SMALLOREQ		=   '<='    ;
    GREATER			=   '>'     ;
    GREATOREQ		=   '>='    ;
    EQUALS			=   '=='    ;
    NOTEQUALS		=   '!='    ;
    
    
}

@lexer::header {
package vb.week3.calc;
}

@header {
package vb.week3.calc;
}

// Parser rules

program
    :   decl_stat_blocks EOF
            ->  ^(PROGRAM decl_stat_blocks)
    ;
    
decl_stat_blocks
    :   ((declaration SEMICOLON!)* statement SEMICOLON!)+
    ;

declaration
    :   VAR^ IDENTIFIER COLON! type
    ;
    
statement
    :   assignment
    |   print_stat
    |	swap_stat
    ;

assignment
    :   lvalue BECOMES^ multiple_assignment
    ;
    
multiple_assignment
    :   expr
    |   assignment
    ;
    
swap_stat
	:	SWAP^ LPAREN! IDENTIFIER COMMA! IDENTIFIER RPAREN!
	;

print_stat
    :   PRINT^ LPAREN! expr RPAREN!
    ;

lvalue
    :   IDENTIFIER
    ;

expr
	:	exprrel
	|	exprif
	;
	
exprrel
	:	exprplusminus ((SMALLER^ | SMALLOREQ^ | GREATER^ | GREATOREQ^ | EQUALS^ | NOTEQUALS^) exprplusminus)*
	;
	
exprif
	:	IF^ expr THEN! expr ELSE! expr
	;
    
exprplusminus
    :   exprmultdiv ((PLUS^ | MINUS^) exprmultdiv)*
    ;

exprmultdiv
	:	operand ((MULT^ | DIV^) operand)*
	;

operand
    :   IDENTIFIER
    |   NUMBER
    |   LPAREN! expr RPAREN!
    ;

type
    :   INTEGER
    ;


// Lexer rules

IDENTIFIER
    :   LETTER (LETTER | DIGIT)*
    ;

NUMBER
    :   DIGIT+
    ;


COMMENT
    :   '//' .* '\n' 
            { $channel=HIDDEN; }
    ;

WS
    :   (' ' | '\t' | '\f' | '\r' | '\n')+
            { $channel=HIDDEN; }
    ;

fragment DIGIT  :   ('0'..'9') ;
fragment LOWER  :   ('a'..'z') ;
fragment UPPER  :   ('A'..'Z') ;
fragment LETTER :   LOWER | UPPER ;

// EOF


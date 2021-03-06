grammar Calc;

options {
    k=1;                                // LL(1) - do not use LL(*)
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
    
    
}

@lexer::header {
package vb.week3.calc;
}

@header {
package vb.week3.calc;
}

// Parser rules

program
    :   declarations statements EOF
            ->  ^(PROGRAM declarations? statements)
    ;
    
declarations
    :   (declaration SEMICOLON!)*
    ;
    
statements
    :   (statement SEMICOLON!)+
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
    :   lvalue BECOMES^ expr
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
	:	exprplusminus
	|	exprif
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


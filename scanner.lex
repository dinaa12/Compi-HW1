%{

/* Declarations section */
#include <stdio.h>
#include "tokens.hpp"
bool flag_b = false;
%}

%option yylineno
%option noyywrap
digit   		([1-9])
digit0			([0-9])
letter  		([a-zA-Z])
whitespace		([\t\n\r ])
printable		([ -~])|whitespace
printable_no_slash	([ -[])|([]-~])|whitespace
escapeseq		(([\\\0\t\n\r\\"])|((\x)(digit)(digit)))
binop			([+-*/])
relop			([(==)(!=)(<=)(>=)(<)(>)])

%x QUOTATION 
%x BYTE_LITERAL

%%

void							return VOID;
int								return INT;
byte							return BYTE;
bool							return BOOL;
auto							return AUTO;

and								return AND;
or								return OR;
not								return NOT;
true							return TRUE;
false							return false;

return							return RETURN;
if								return IF;
else							return ELSE;
while							return WHILE;
break							return BREAK;
continue						return CONTINUE;

;								return SC;
,								return COMMA;
(								return LPAREN;
)								return RPAREN;
{								return LBRACE;
}								return RBRACE;
=								return ASSIGN;

relop							return RELOP;
binop							return BINOP;

b								if (flag_b == true) flag_b = false; return BYTE; // piazza ???
{letter}({letter}*{digit0}*)*	return ID;

(0)|({digit}{digit0}*)/b		flag_b = true; return NUM;
(0)|({digit}{digit0}*)          return NUM;

//(.)*([\r\n]+)					return ILLEGAL_CHAR; //????
//(.)*(\n)$						return COMMENT;

/* QUOTATION - string */
"\n"|"\r"						return ILLEGAL_CHAR;	//???
"								BEGIN(QUOTATION);
<QUOTATION>(\n)$				return UNCLOSED_STR;
<QUOTATION>((\)(\n))$				return UNCLOSED_STR;
<QUOTATION>{printable_no_slash}*			return STRING;
<QUOTATION>{escapeseq}			return STRING;
<QUOTATION>\{^"}+				return ILLEGAL_ESCAPE;
<QUOTATION>"					BEGIN(INITIAL);

{whitespace}					;
\{.}*							return ILLEGAL_ESCAPE;
.								return ILLEGAL_CHAR;

%%


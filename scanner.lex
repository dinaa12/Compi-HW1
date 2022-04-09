%{

/* Declarations section */
#include <stdio.h>
#include "tokens.hpp"
bool flag_b = false;
char quotation_string[1024];
int quotation_string_size = 0;
void append_to_string();
void close_string();
void start_string();
void string_escape();
%}

%option yylineno
%option noyywrap
digit   		([1-9])
digit0			([0-9])
letter  		([a-zA-Z])
whitespace		([\t\n\r ])
printable		([ -~])|whitespace
printable_no_slash_no_quote	([ -!])|(#-\[])|([\]-~])|whitespace
escapeseq		((\\|\0|\t|\n|\r)|((\x)(digit)(digit)))
binop			(\+|\-|\*|\/)
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
false							return FALSE;

return							return RETURN;
if								return IF;
else							return ELSE;
while							return WHILE;
break							return BREAK;
continue						return CONTINUE;

;								return SC;
,								return COMMA;
\(								return LPAREN;
\)								return RPAREN;
\{								return LBRACE;
\}								return RBRACE;
=								return ASSIGN;

{relop}							return RELOP;
{binop}							return BINOP;

b								if (flag_b == true) flag_b = false; return BYTE; // piazza ???
{letter}({letter}*{digit0}*)*	return ID;

(0)|({digit}{digit0}*)/b		flag_b = true; return NUM;
(0)|({digit}{digit0}*)          return NUM;

(\/\/)(.)*(\n)$						return COMMENT;

\"\n\"|\"\r\"						return ILLEGAL_CHAR;	//???
\"								BEGIN(QUOTATION); start_string();
<QUOTATION>({printable_no_slash_no_quote}) append_to_string();
<QUOTATION>(\")					BEGIN(INITIAL); close_string(); return STRING;

{whitespace}					;
((\\)((.)*))						return ILLEGAL_ESCAPE;
.								return ILLEGAL_CHAR;

%%

void start_string() {
	quotation_string_size = 0;
}

void append_to_string() {
	quotation_string[quotation_string_size] = yytext[yyleng-1];
	quotation_string_size++;
}

void close_string() {
	quotation_string[quotation_string_size] = '\0';
}

void string_escape() {
	int curr_size = yyleng;
	switch (yytext[curr_size-1]) {
		case 'n':
			yytext[curr_size-2] = '\n';
			yytext[curr_size-1] = '\0';
			yyleng = yyleng-1;
			break;
		default:
			break;
	}
}





//(.)*([\r\n]+)					return ILLEGAL_CHAR; //????
//(.)*(\n)$						return COMMENT;


<QUOTATION>(\n)$				return UNCLOSED_STR;
<QUOTATION>((\\)(\n))$				return UNCLOSED_STR;
<QUOTATION>({printable_no_slash_no_quote}*|{escapeseq})			return STRING;
<QUOTATION>((\\)((.)*))				return ILLEGAL_ESCAPE;

<QUOTATION>({escapeseq})			string_escape();

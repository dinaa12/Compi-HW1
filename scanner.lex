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
void string_hex();
%}

%option yylineno
%option noyywrap
digit   											([1-9])
digit0												([0-9])
letter  											([a-zA-Z])
whitespace											([\t\n\r ])
printable											([ -~])|whitespace
printable_no_slash_no_quote							(([ -!])|([#-\[])|([\]-~]))
escapeseq											((\\|\0|\t|\n|\r)|((\x)(digit)(digit)))
binop												(\+|\-|\*|\/)
relop												(==|!=|<=|>=|<|>)
ascii												([\x00-\x21\x23-\x7F])

%x QUOTATION
%x QUOTATION_SLASH
%x BYTE_LITERAL

%%

void												return VOID;
int													return INT;
byte												return BYTE;
bool												return BOOL;
auto												return AUTO;

and													return AND;
or													return OR;
not													return NOT;
true												return TRUE;
false												return FALSE;

return												return RETURN;
if													return IF;
else												return ELSE;
while												return WHILE;
break												return BREAK;
continue											return CONTINUE;

;													return SC;
,													return COMMA;
\(													return LPAREN;
\)													return RPAREN;
\{													return LBRACE;
\}													return RBRACE;
=													return ASSIGN;

{relop}												return RELOP;
{binop}												return BINOP;

b													if (flag_b == true) { flag_b = false; return B;} else return ID;// piazza ???
{letter}({letter}|{digit0})*						return ID;

((0)|({digit}{digit0}*))/b							flag_b = true; return NUM;
(0)|({digit}{digit0}*)          					return NUM;
(0){digit0}+										return ILLEGAL_CHAR;

(\/\/)												return COMMENT;
((\/)(\/)((.)*))/((\n))								return COMMENT;

(\"(\\)n\"|\"(\\)r\")								return ILLEGAL_CHAR;	//???
(\")												BEGIN(QUOTATION); start_string();
<QUOTATION>(\n|\r|\r\n)								return UNCLOSED_STR; 
<QUOTATION><<EOF>>									return UNCLOSED_STR;
<QUOTATION>({printable_no_slash_no_quote}) 			append_to_string();
<QUOTATION>(\\)										BEGIN(QUOTATION_SLASH);
<QUOTATION>(\")										BEGIN(INITIAL); close_string(); return STRING;

<QUOTATION_SLASH>([0tnr])							string_escape(); BEGIN(QUOTATION); 
<QUOTATION_SLASH>((\\)|(\"))						append_to_string(); BEGIN(QUOTATION);
<QUOTATION_SLASH>((x)([0-7])(([0-9]|[A-Fa-f])))		string_hex(); BEGIN(QUOTATION);
<QUOTATION_SLASH>((x)({ascii})(({ascii})?))			return ILLEGAL_ESCAPE_HEX;
<QUOTATION_SLASH>(\n)								return UNCLOSED_STR; 
<QUOTATION_SLASH><<EOF>>							return UNCLOSED_STR;
<QUOTATION_SLASH>(.) 								return ILLEGAL_ESCAPE;

{whitespace}										;
((\\)((.)*))										return ILLEGAL_ESCAPE;
.													return ILLEGAL_CHAR;

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
	switch (yytext[yyleng-1]) {
		case 'n':
			quotation_string[quotation_string_size] = '\n';
			break;
		case 't':
			quotation_string[quotation_string_size] = '\t';
			break;
		case 'r':
			quotation_string[quotation_string_size] = '\r';
			break;
		case '0':
			quotation_string[quotation_string_size] = '\0';
			break;
		default:
			printf("ERROR");
	}
	quotation_string_size++;
}

void string_hex() {
	char hex[2] = {0,0};
	hex[0] = yytext[yyleng-2];
	hex[1] = yytext[yyleng-1];
	int decimal = 0, base = 1;
	
	for(int i = 1; i >= 0; i--)
	{
		if(hex[i] >= '0' && hex[i] <= '9')
		{
			decimal += (hex[i] - 48) * base;
			base *= 16;
		}
		else if(hex[i] >= 'A' && hex[i] <= 'F')
		{
			decimal += (hex[i] - 55) * base;
			base *= 16;
		}
		else if(hex[i] >= 'a' && hex[i] <= 'f')
		{
			decimal += (hex[i] - 87) * base;
			base *= 16;
		}
	}
	
	quotation_string[quotation_string_size] = decimal;
	quotation_string_size++;
}
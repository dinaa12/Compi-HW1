#include "tokens.hpp"
#include <iostream>
#include <cstdint>
#include <cstring>

void print_output(int line, std::string token, char* text){
    std::cout << line << " " << token << " " << text << std::endl;
}

int main(){
    int token;
    while ((token = yylex())) {
        switch (token){
            case VOID:
                print_output(yylineno, "VOID", yytext);
                break;
            case INT:
                print_output(yylineno, "INT", yytext);
                break;
            case BYTE:
                print_output(yylineno, "BYTE", yytext);
                break;
            case B:
                print_output(yylineno, "B", yytext);
                break;
            case BOOL:
                print_output(yylineno, "BOOL", yytext);
                break;
            case AND:
                print_output(yylineno, "AND", yytext);
                break;
            case OR:
                print_output(yylineno, "OR", yytext);
                break;
            case NOT:
                print_output(yylineno, "NOT", yytext);
                break;
            case TRUE:
                print_output(yylineno, "TRUE", yytext);
                break;
            case FALSE:
                print_output(yylineno, "FALSE", yytext);
                break;
            case RETURN:
                print_output(yylineno, "RETURN", yytext);
                break;
            case IF:
                print_output(yylineno, "IF", yytext);
                break;
            case ELSE:
                print_output(yylineno, "ELSE", yytext);
                break;
            case WHILE:
                print_output(yylineno, "WHILE", yytext);
                break;
            case BREAK:
                print_output(yylineno, "BREAK", yytext);
                break;
            case CONTINUE:
                print_output(yylineno, "CONTINUE", yytext);
                break;
            case SC:
                print_output(yylineno, "SC", yytext);
                break;
            case COMMA:
                print_output(yylineno, "COMMA", yytext);
                break;
            case LPAREN:
                print_output(yylineno, "LPAREN", yytext);
                break;
            case RPAREN:
                print_output(yylineno, "RPAREN", yytext);
                break;
            case LBRACE:
                print_output(yylineno, "LBRACE", yytext);
                break;
            case RBRACE:
                print_output(yylineno, "RBRACE", yytext);
                break;
            case ASSIGN:
                print_output(yylineno, "ASSIGN", yytext);
                break;
            case RELOP:
                print_output(yylineno, "RELOP", yytext);
                break;
            case BINOP:
                print_output(yylineno, "BINOP", yytext);
                break;
            case COMMENT:
                std::cout << yylineno << " COMMENT " << "//" << std::endl;
                break;
            case ID:
                print_output(yylineno, "ID", yytext);
                break;
            case NUM:
                print_output(yylineno, "NUM", yytext);
                break;
            case STRING:
                print_output(yylineno, "STRING", quotation_string);
                break;
            case AUTO:
                print_output(yylineno, "AUTO", yytext);
                break;
            case ILLEGAL_CHAR:
                std::cout << "Error " << yytext[0] << std::endl;
                exit(0);
                //break;
            case ILLEGAL_ESCAPE:
                std::cout << "Error undefined escape sequence " << yytext[yyleng-1] << std::endl;
                exit(0);
                //break;
            case UNCLOSED_STR:
                std::cout << "Error unclosed string" << std::endl;
                exit(0);
                //break;
            case ILLEGAL_ESCAPE_HEX:
                if (yytext[yyleng-3] == 'x')
                    std::cout << "Error undefined escape sequence " << yytext[yyleng-3] << yytext[yyleng-2] << yytext[yyleng-1] << std::endl;
                else
                    std::cout << "Error undefined escape sequence " << yytext[yyleng-2] << yytext[yyleng-1] << std::endl;
                exit(0);
                //break;
            default:
                break;
        }
    }
    return 0;
}

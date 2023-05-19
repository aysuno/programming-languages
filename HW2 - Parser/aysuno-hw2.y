%{
	#include<stdio.h>
	void yyerror(const char *s){}
%}

%token tSTRING
%token tNUM
%token tPRINT
%token tGET
%token tSET
%token tFUNCTION
%token tRETURN
%token tIDENT
%token tIF 
%token tEQUALITY
%token tGT 
%token tLT 
%token tGEQ 
%token tLEQ
%token tADD
%token tSUB
%token tMUL
%token tDIV
%token tINC
%token tDEC

%start program

%%      /* Grammer rules and actions */

program:           '[' stmnt_list ']'
                    | '[' ']'
                    ;

stmnt_list:         stmnt
                    | stmnt_list stmnt   
                    ;

stmnt:              set 
                    | if    
                    | print
                    | increment
                    | decrement
                    | return
                    | expression
                    ;

set:               '[' tSET ',' tIDENT ',' expression ']'
                    ;

if:                '[' tIF ',' condition ',' then else ']'
                    | '[' tIF ',' condition ',' then ']'
                    ;

print:             '[' tPRINT ',' expression ']'
                    ;

increment:         '[' tINC ',' tIDENT ']'
                    ;

decrement:         '[' tDEC ',' tIDENT ']'
                    ;

condition:         '[' tLEQ ',' expression ',' expression ']'
		            | '[' tGEQ ',' expression ',' expression ']'
		            | '[' tEQUALITY ',' expression ',' expression ']'
		            | '[' tGT ',' expression ',' expression ']'
		            | '[' tLT ',' expression ',' expression ']'
 		            ;             

expression:         tNUM
                    | tSTRING
                    | get 
                    | function 
                    | operator
                    | condition
                    ;

get:               '[' tGET ',' tIDENT ']'
                    | '[' tGET ',' tIDENT ',' '[' expression_list']' ']'
                    | '[' tGET ',' tIDENT ',' '[' ']' ']'
                    ;

function:          '[' tFUNCTION ',' '[' parameter_list ']' ',' '[' stmnt_list ']' ']'
                    | '[' tFUNCTION ',' '[' ']' ',' '[' stmnt_list ']' ']'
                    | '[' tFUNCTION ',' '[' parameter_list ']' ',' '['']' ']'
                    | '[' tFUNCTION ',' '[' ']' ',' '[' ']' ']'
                    ;

operator:          '[' tADD ',' expression ',' expression ']'
                    | '[' tSUB ',' expression ',' expression ']'
                    | '[' tMUL ',' expression ',' expression ']'
                    | '[' tDIV ',' expression ',' expression ']'
                    ;

return:            '[' tRETURN ']'
                    | '[' tRETURN ',' expression ']'
                    ;

then:              '[' stmnt_list ']'
                    | '[' ']'
                    ;

else:              '[' stmnt_list ']'
                    | '[' ']'
                    ;

expression_list:    expression
                    | expression ',' expression_list
                    ;

parameter_list:     tIDENT   
                    | parameter_list ',' tIDENT
                    ;


%%                  
int main ()
{
    if (yyparse())
    {
        // parse error
        printf("ERROR\n");
        return 1;
    }
    else
    {
        // successful parsing
        printf("OK\n");
        return 0;
    }
}
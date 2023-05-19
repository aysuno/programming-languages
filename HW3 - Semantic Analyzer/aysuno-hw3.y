%{
#include "aysuno-hw3.h"
#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <stdbool.h>

treeNode * root;
void yyerror (const char *s){}


%}

%union{
	int unLine;
	integerNode intnode;
	expNode expnode;
	char * text_value;

}

%token tPRINT tGET tSET tFUNCTION tRETURN tIDENT tEQUALITY tIF tGT tLT tGEQ tLEQ tINC tDEC
%token <text_value> tSTRING
%token <intnode> tNUM
%token <unLine> tADD 
%token <unLine> tSUB 
%token <unLine> tMUL 
%token <unLine> tDIV
%type <expnode> operation
%type <expnode> expr

%start prog


%%
prog:		'[' stmtlst ']'
;

stmtlst:	stmtlst stmt |
;

stmt:		setStmt 
			| if 
			| print 
			| unaryOperation 
			| expr {insertTree(root, $1,0); }
			| returnStmt
;

getExpr:	'[' tGET ',' tIDENT ',' '[' exprList ']' ']'
			 | '[' tGET ',' tIDENT ',' '[' ']' ']'
			 | '[' tGET ',' tIDENT ']'
;

setStmt:	'[' tSET ',' tIDENT ',' expr ']' { insertTree(root, $6 ,0); }

;

if:			'[' tIF ',' condition ',' '[' stmtlst ']' ']'
			 | '[' tIF ',' condition ',' '[' stmtlst ']' '[' stmtlst ']' ']'
;

print:		'[' tPRINT ',' expr ']' { insertTree(root, $4,0); }
;

operation:	'[' tADD ',' expr ',' expr ']' { 

				if (($4).expType == STRING && ($6).expType == STRING ){

					char * newString = malloc(strlen(($4).text) + strlen(($6).text) + 1);
					strcpy(newString, ($4).text);
   					strcat(newString, ($6).text);
					$$ =  mkStringNode(newString, 1, ($2),1);
				}

				else if(($4).expType == INTEGER && ($6).expType == INTEGER){
					integerNode doubleRes;
					doubleRes.value = ($4).intNode.value + ($6).intNode.value;

					if (($4).intNode.isFloat == 1 || ($6).intNode.isFloat == 1){ //that means one of them is float so result is float
						doubleRes.isFloat= 1;
					}
					else{
						doubleRes.isFloat= 0;	
						}
					$$ = mkIntegerNode(doubleRes, 1, ($2),1);
				}
				
				else if((($4).expType == STRING && ($6).expType == INTEGER) || (($4).expType == INTEGER && ($6).expType == STRING)){
					expNode coutn;
					coutn.myLine = ($2);
					insertTree(root, coutn, 1); //here is the mismatch
					if(($6).sub == 1){
						expNode yeni = $6;
						insertTree(root,yeni,0);
					}
					if(($4).sub == 1){
						expNode ot = $4;
						insertTree(root,ot,0);
					}

					$$ = mkRNode();
				}
				
				else {
					if(($6).sub == 1){
						expNode yeni = $6;
						insertTree(root,yeni,0);
					}
					if(($4).sub == 1){
						expNode ot = $4;
						insertTree(root,ot,0);
					}
					$$ = mkRNode();
				}
	
			}

			 | '[' tSUB ',' expr ',' expr ']' {

				if(($4).expType == INTEGER && ($6).expType == INTEGER){
					integerNode sdoubleRes;
					sdoubleRes.value = ($4).intNode.value - ($6).intNode.value;
					if (($4).intNode.isFloat == 1 || ($6).intNode.isFloat == 1){ 
						sdoubleRes.isFloat= 1;
					}
					else{
						sdoubleRes.isFloat= 0;	
					}
					
					$$ = mkIntegerNode(sdoubleRes, 1, ($2),1);
				}

				
				else if((($4).expType == STRING && ($6).expType == STRING) || (($4).expType == STRING && ($6).expType == INTEGER) || (($4).expType == INTEGER && ($6).expType == STRING)){
					expNode scoutn; //mismatch node
					scoutn.myLine = ($2);
					insertTree(root, scoutn, 1); //here is the mismatch
					if(($6).sub == 1){
						expNode yeni = $6;
						insertTree(root,yeni,0);
					}
					if(($4).sub == 1){
						expNode ot = $4;
						insertTree(root,ot,0);
					}
					$$ = mkRNode();

				}

				else {

					if(($6).sub == 1){
						expNode yeni = $6;
						insertTree(root,yeni,0);
					}
					if(($4).sub == 1){
						expNode ot = $4;
						insertTree(root,ot,0);
					}
					$$ = mkRNode();
				}
			}

			 | '[' tMUL ',' expr ',' expr ']' {
                if(($4).expType == INTEGER && ($6).expType == INTEGER){
					integerNode mdoubleRes;
					mdoubleRes.value = ($4).intNode.value * ($6).intNode.value;
					if (($4).intNode.isFloat == 1 || ($6).intNode.isFloat == 1){ 
						mdoubleRes.isFloat= 1;
					}
					else{
						mdoubleRes.isFloat= 0;	
						}
					$$ = mkIntegerNode(mdoubleRes, 1, ($2),1);
				}
				else if(($4).expType == INTEGER && ($6).expType == STRING){
					if(($4).intNode.value >= 0 && ($4).intNode.isFloat != 1){ // non  negative integer is correct
						int howmanytimes = ($4).intNode.value;
						if(howmanytimes == 0){ //it means multiply with zero so, result should be empty
							char *strresult = "";
							$$ = mkStringNode(strresult, 1, ($2),1);
						}
						else if(howmanytimes != 0){
							char *multresult;
    						size_t ln = strlen(($6).text);
    						multresult = malloc(sizeof(char)*ln);
							char *r = malloc(howmanytimes * ln);
							while (howmanytimes--) {
								strcat(multresult, ($6).text);
							}
						$$ = mkStringNode(multresult, 1, ($2),1);

						}
					}
					else{
						expNode mcoutn;
						mcoutn.myLine = ($2);
						insertTree(root, mcoutn, 1);
						if(($6).sub == 1){
							expNode yeni = $6;
							insertTree(root,yeni,0);
					    }
						if(($4).sub == 1){
						expNode ot = $4;
						insertTree(root,ot,0);
					    }
						$$ = mkRNode();
					}
				}
				else if((($4).expType == STRING && ($6).expType == STRING) || (($4).expType == STRING && ($6).expType == INTEGER) ){
					    expNode kmcoutn;
						kmcoutn.myLine = ($2);
						insertTree(root, kmcoutn, 1);
						if(($6).sub == 1){
							expNode yeni = $6;
							insertTree(root,yeni,0);
					    }
						if(($4).sub == 1){
						expNode ot = $4;
						insertTree(root,ot,0);
					    }
						$$ = mkRNode();
				}
				else {
					if(($6).sub == 1){
						expNode yeni = $6;
						insertTree(root,yeni,0);
					}
					if(($4).sub == 1){
						expNode ot = $4;
						insertTree(root,ot,0);
					}
					$$ = mkRNode();
				}
                      
			 }
			 | '[' tDIV ',' expr ',' expr ']' {

				if(($4).expType == INTEGER && ($6).expType == INTEGER){
					integerNode vdoubleRes;
					if (($4).intNode.isFloat == 0 && ($6).intNode.isFloat == 0){ 
							int sayi = ($4).intNode.value / ($6).intNode.value;
							vdoubleRes.value = sayi;
					}
					else{
						vdoubleRes.value = ($4).intNode.value / ($6).intNode.value;
					}
					
					
					if (($4).intNode.isFloat == 1 || ($6).intNode.isFloat == 1){ 
						vdoubleRes.isFloat= 1;
					}
					else{
						vdoubleRes.isFloat= 0;	
					}
					$$ = mkIntegerNode(vdoubleRes, 1, ($2),1);
				}
				
				else if((($4).expType == STRING && ($6).expType == STRING) || (($4).expType == STRING && ($6).expType == INTEGER) || (($4).expType == INTEGER && ($6).expType == STRING)){
					expNode vcoutn;
					vcoutn.myLine = ($2);
					insertTree(root, vcoutn, 1); //here is the mismatch

					if(($6).sub == 1){
							expNode yeni = $6;
							insertTree(root,yeni,0);
					}
					if(($4).sub == 1){
						expNode ot = $4;
						insertTree(root,ot,0);
					}
					$$ = mkRNode();
				}
				
				else {
					if(($6).sub == 1){
						expNode yeni = $6;
						insertTree(root,yeni,0);
					}
					if(($4).sub == 1){
						expNode ot = $4;
						insertTree(root,ot,0);
					}
					$$ = mkRNode();
				}

			 }
;	

unaryOperation: 	'[' tINC ',' tIDENT ']'
					 | '[' tDEC ',' tIDENT ']'
;

expr:		tNUM  { $$ = mkIntegerNode ($1, 0, 0,0); }
			| tSTRING  {  $$ = mkStringNode ($1, 0, 0,0);} 
			| getExpr  { $$ = mkRNode();}
			| function { $$ = mkRNode();}
			| operation 
			| condition { $$ = mkRNode();}
;

function:	 '[' tFUNCTION ',' '[' parametersList ']' ',' '[' stmtlst ']' ']'
			  | '[' tFUNCTION ',' '[' ']' ',' '[' stmtlst ']' ']'
;

condition:	'[' tEQUALITY ',' expr ',' expr ']' {
			 	insertTree(root, $4,0); 
				insertTree(root, $6,0);
			}
		     | '[' tGT ',' expr ',' expr ']' { 
				insertTree(root, $4,0); 
				insertTree(root, $6,0);
			}
		     | '[' tLT ',' expr ',' expr ']'{ 
				insertTree(root, $4,0); 
				insertTree(root, $6,0);
			}
		     | '[' tGEQ ',' expr ',' expr ']' { 
				insertTree(root, $4,0); 
				insertTree(root, $6,0);
			}
		     | '[' tLEQ ',' expr ',' expr ']' { 
				insertTree(root, $4,0); 
				insertTree(root, $6,0);
			}
;

returnStmt:	'[' tRETURN ',' expr ']' { insertTree(root, $4,0);}
		     | '[' tRETURN ']'
;

parametersList: parametersList ',' tIDENT 
				| tIDENT
;

exprList:	exprList ',' expr  {insertTree(root, $3,0);}
			| expr { insertTree(root, $1,0);}
;

%%

expNode mkRNode() {
	expNode r_tep;
    r_tep.expType = RTYPE;
    return r_tep;
}

expNode mkIntegerNode(integerNode actual, int linecheck, int line, int sub) {
	expNode tep;
    tep.expType = INTEGER;
	tep.linecheck = linecheck;
	if (linecheck == 1){
			tep.myLine = line;
	}

    tep.intNode.value = actual.value;
	tep.intNode.isFloat = actual.isFloat;
	tep.sub = sub;
	//tep.intNode.sub = sub;
	return tep;
}

expNode  mkStringNode(char * str, int linecheck, int line, int sub) {
	 expNode s_tep;
     s_tep.expType = STRING;
	 s_tep.text = str;
   	 s_tep.linecheck = linecheck;
	 if (linecheck == 1){
		s_tep.myLine = line;
	 }
	 s_tep.sub = sub;
	 return s_tep;
}

void insertTree(struct treeNode *root, expNode currentNode, int isMismatch){
	treeNode *ptr = malloc(sizeof(root));
	ptr->expnode = currentNode;
	ptr->tree_line = currentNode.myLine;
	ptr->isMismatch = isMismatch;
	treeNode *q = malloc(sizeof(root));
	q = root;
	while (q->nextPtr != NULL){
		q = q->nextPtr;
	}
	q->nextPtr = ptr;
}


int main ()
{
	//create the root node and allocate memory for it 
	root  = malloc(sizeof(treeNode));
	//assign to empty values for now
	expNode temp;
	root->expnode = temp;
	root->nextPtr = NULL;


	if (yyparse()) {
		// parse error
		printf("ERROR\n");
		return 1;
	}
	else {
		// successful parsing burada print edilecek
		//printf("OK\n"); 
		while (root != NULL){

			expNode display = root->expnode; //current node
			int mis = root->isMismatch;
			int displayloc = root->tree_line;
			
			if ( display.linecheck == 1 &&mis == 0){ 

				if (display.expType == STRING){
					printf("Result of expression on %d is (%s)\n", displayloc, display.text);
				}

				else if(display.expType == INTEGER){ 
					
					if(display.intNode.isFloat == 1){ //if the number has decimal in it
						double p = display.intNode.value;
						double son;
						if(p >= 0.0){
							double rez = (int)(p * 100 + .5);
							son = (double)rez /100;
							printf("Result of expression on %d is (%.1f)\n", displayloc, son);
						}
						else if(p < 0){
							double rez = (int)(p * 100 - .5);
							son = (double)rez /100;
							printf("Result of expression on %d is (%.1f)\n", displayloc, son);
						}
						
					}
					else if(display.intNode.isFloat == 0){
               			 printf("Result of expression on %d is (%d)\n", displayloc, ((int)display.intNode.value));
					}
				}		
			}
			else if (mis == 1){ 
				printf("Type mismatch on %d\n", displayloc);

			}
			root = root->nextPtr;
		}

		return 0;
	}
}

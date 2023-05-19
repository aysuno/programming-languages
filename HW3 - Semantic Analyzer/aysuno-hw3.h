#ifndef __HW3_H
#define __HW3_H

typedef enum { RTYPE, STRING, INTEGER } type;



typedef struct integerNode {
	double value; 
	int isFloat; //if it has decimal it is 1, otherwise it is 0
	int sub; //check if result coming from a expression
} integerNode;


typedef struct expNode {
	type expType;
    int myLine;
	char * text; //string value of the expression node
	integerNode intNode; 
	int linecheck;
	int sub; //check if result coming from a expression
	
} expNode;

typedef struct treeNode {
	expNode expnode;
    struct treeNode *nextPtr;
    int isMismatch; //if 1 it is true, else if 0 then it is false
	int tree_line;
} treeNode;

expNode mkStringNode(char * str, int linecheck, int line,int sub);
expNode mkIntegerNode(integerNode a, int linecheck, int line,int sub);
expNode mkRNode();
void insertTree(struct treeNode *root, expNode currentNode,int isMismatch);
#endif
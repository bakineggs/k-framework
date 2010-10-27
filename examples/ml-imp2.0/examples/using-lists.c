#include <stdlib.h>

struct nodeList {
  int val;
  struct nodeList *next;
};

int main()
/*@ pre < config > < env > (.).Map </ env > < heap > (.).Map </ heap > < form > TrueFormula </ form > </ config > */
/*@ post < config > < env > ?rho </ env > < heap > ?H </ heap > < form > TrueFormula </ form > </ config > */
{
  struct nodeList *x;
  struct nodeList *y;
  x = (struct nodeList*)malloc(sizeof(struct nodeList));
  x->val = 7;
  x->next = 0;
  y = (struct nodeList*)malloc(sizeof(struct nodeList));
  y->val = 6;
  y->next = x;
  x = y;
  y = (struct nodeList*)malloc(sizeof(struct nodeList));
  y->val = 5;
  y->next = x;
  x = y;
/*@ assert < config >
           < env > x |-> ?x y |-> ?x </ env >
           < heap > list(?x)([5] @ [6] @ [7]) </ heap >
           < form > TrueFormula </ form > 
           </ config > */
  y = (struct nodeList*)malloc(sizeof(struct nodeList));
  y->val = 678;
  y->next = 0;
/*@ assert < config >
           < env > x |-> ?x y |-> ?y </ env >
           < heap > list(?x)(!A) list(?y)(!B) </ heap >
           < form > TrueFormula </ form >
           </ config > */
  free(y);
/*@ assert < config >
           < env > x |-> ?x y |-> ?y </ env >
           < heap > list(?x)(!A) </ heap >
           < form > TrueFormula </ form >
           </ config > */
  return 0;
}


/*@ var ?x ?y : ?Int */
/*@ var ?A : ?Seq */
/*@ var !A !B : !Seq */
/*@ var ?rho ?H : ?MapItem */

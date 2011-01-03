#include <stdlib.h>

struct nodeList {
  int val;
  struct nodeList *next;
};

int length(struct nodeList* a)
/*@ pre < config > 
        < env > a |-> a0 </ env >
        < heap > list(a0)(A) H </ heap > 
        < form > TrueFormula </ form > </ config > */
/*@ post < config > 
         < env > ?rho </ env >
         < heap > list(a0)(A) H </ heap > 
         < form > ?l === len(A) /\ returns ?l </ form > </ config > */
{
  int l;
  struct nodeList* x;
  l = 0;
  if(a != 0)
  {
    x = a->next;
    l = length(x) + 1 ;
  }
  return l;
}

int main()
/*@ pre < config > < env > (.).Map </ env > < heap > (.).Map </ heap > < form > TrueFormula </ form > </ config > */
/*@ post < config > < env > ?rho </ env > < heap > ?H </ heap > < form > TrueFormula </ form > </ config > */
{
  int l;
  struct nodeList* x;
  x = (struct nodeList*)malloc(sizeof(struct nodeList));
  x->val = 5;
  x->next = 0;
  l = length(x);
  return 0;
}

/*@ var ?x ?l : ?Int */
/*@ var a0 : FreeInt */
/*@ var ?A ?X : ?Seq */
/*@ var A : FreeSeq */
/*@ var ?rho ?H : ?MapItem */
/*@ var H : FreeMapItem */

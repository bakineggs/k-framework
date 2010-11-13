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
         < heap > ?H </ heap > 
         < form > ?l === len(A) /\ returns ?l </ form > </ config > */
{
  int l;
  struct nodeList* x;
  x = a;
  l = 0;
/*@ invariant < config > 
              < env > a |-> a0  x |-> ?x l |-> ?l </ env >
              < heap > lseg(a0,?x)(?A)  list(?x)(?X) H </ heap >
              < form > (?A @ ?X) === A /\ ?l === len(?A) </ form >
              </ config > */
  while (x != 0) {
        x = x->next ;
        l = l + 1 ;
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
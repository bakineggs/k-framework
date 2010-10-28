#include <stdlib.h>
#include <stdio.h>

struct nodeList {
  int val;
  struct nodeList *next;
};


struct nodeList* append(struct nodeList *x, struct nodeList *y)  
/*@ pre  < config > < env > x |-> ?x  y |-> ?y  </ env >
                    < heap > list(?x)(A) list(?y)(B) H </ heap >
                    < form > TrueFormula </ form > C </ config > */
/*@ post < config > < env >  ?rho </ env >
                    < heap > list(?x)(A @ B) H </ heap > 
                    < form > returns ?x </ form > C </ config > */
{
  struct nodeList *p;
  struct nodeList *i;
  if (x == 0) x = y;
  else
  {
    p = x ;
    i = x->next; 
    /*@ invariant < config > < env > x |-> ?x i |-> ?i p |-> ?p !rho </ env >
                             < heap > lseg(?x , ?p)(?A) 
                               ?p |-> ?v : (nodeList . val)
                               (?p +Int 1) |-> ?i :  (nodeList . next)
                                list(?i)(?B)  
                               !H
                             </ heap > 
                             < form > (?A @ [?v] @ ?B) === A </ form > 
                             C </ config > */
    while (i != 0)
    {
        p = i ;
        i = i->next;
    }
    p->next = y ;
  }
  return x;
}

int main()
{
  struct nodeList *x;
  struct nodeList *y;
  struct nodeList *z;
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
             < env > x |-> ?x y |-> ?x z |-> ?z </ env > 
             < heap > list(?x)([5] @ [6] @ [7]) </ heap > 
             < form > TrueFormula </ form > </ config > */
  printf("%d %d %d",x->val, x->next->val, x->next->next->val);
  z = (struct nodeList*)malloc(sizeof(struct nodeList));
  z->val = 5;
  z->next = 0;
  y = (struct nodeList*)malloc(sizeof(struct nodeList));
  y->val = 3;
  y->next = z;
  z = y;
  y = (struct nodeList*)malloc(sizeof(struct nodeList));
  y->val = 1;
  y->next = z;
  z = y;
  /*@ assert < config > 
             < env > x |-> ?x z |-> ?z y |-> ?z </ env > 
             < heap > list(?x)([5] @ [6] @ [7]) list(?z)([1] @ [3] @ [5]) </ heap > 
             < form > TrueFormula </ form > </ config > */
  x = append(x,z);
  /*@ assert < config > 
             < env > x |-> ?x z |-> ?z y |-> ?z </ env > 
             < heap > list(?x)([5,6,7,1,3,5]) </ heap > 
             < form > TrueFormula </ form > </ config > */
  y = x;
  x = x->next;
  free(y);
  y = x;
  x = x->next;
  free(y);
  y = x;
  x = x->next;
  free(y);
  y = x;
  x = x->next;
  free(y);
  y = x;
  x = x->next;
  free(y);
  y = x;
  x = x->next;
  free(y);
  /*@ assert < config > < env > x |-> ?x y |-> ?y z |-> ?z </ env > < heap > list(0)(epsilon) </ heap > < form > TrueFormula </ form > </ config > */
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
             < env > x |-> ?x y |-> ?x z |-> ?z </ env > 
             < heap > list(?x)(!A) </ heap > 
             < form > TrueFormula </ form > </ config > */
  z = (struct nodeList*)malloc(sizeof(struct nodeList));
  z->val = 5;
  z->next = 0;
  y = (struct nodeList*)malloc(sizeof(struct nodeList));
  y->val = 3;
  y->next = z;
  z = y;
  y = (struct nodeList*)malloc(sizeof(struct nodeList));
  y->val = 1;
  y->next = z;
  z = y;
  /*@ assert < config > 
             < env > x |-> ?x z |-> ?z y |-> ?y </ env > 
             < heap > list(?x)(!A) list(?z)(!B) </ heap > 
             < form > TrueFormula </ form > </ config > */
  x = append(x,z);
  /*@ assert < config > 
             < env > x |-> ?x z |-> ?z y |-> ?y </ env > 
             < heap > list(?x)(!A @ !B) </ heap > 
             < form > TrueFormula </ form > </ config > */
  return 0;
}

/*@ var ?x ?y ?p ?i ?v ?z : ?Int */
/*@ var ?A ?B : ?Seq */
/*@ var !A !B : !Seq */
/*@ var A B : FreeSeq */
/*@ var ?rho ?H : ?MapItem */
/*@ var !rho !H : !MapItem */
/*@ var H : FreeMapItem */
/*@ var C : FreeBagItem */

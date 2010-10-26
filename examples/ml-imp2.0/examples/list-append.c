struct nodeList {
  int val;
  struct nodeList *next;
};

/*@ var ?x ?y ?p ?i ?v : ?Int */
/*@ var ?A ?B : ?Seq */
/*@ var A B : FreeSeq */
/*@ var ?rho ?H : ?MapItem */

struct nodeList* append(struct nodeList *x, struct nodeList *y)  
/*@ pre < config >
         < env > x |-> ?x  y |-> ?y  </ env >
         < heap > list(?x)(A) list(?y)(B) </ heap >
         < form > TrueFormula </ form >
         </ config > */
/*@ post < config > 
          < env >  ?rho </ env >
          < heap > list(?x)(A @ B) </ heap > 
          < form > returns ?x </ form > 
          </ config > */
{
  struct nodeList *p;
  struct nodeList *i;
  if (x == 0) x = y;
  else
  {
    p = x ;
    i = x->next; 
/*@ invariant < config > 
         < env > x |-> ?x  y |-> ?y  i |-> ?i  p |-> ?p  </ env >
         < heap > lseg(?x , ?p)(?A) 
                  ?p |-> ?v : (nodeList . val)
                  (?p +Int 1) |-> ?i :  (nodeList . next)
                  list(?i)(?B)  
                  list(?y)(B) 
         </ heap > 
         < form > (?A @ [?v] @ ?B) === A </ form > 
         </ config > */
    while (i != 0)
    {
        p = i ;
        i = i->next;
    }
    p->next = y ;
  }
  return x;
}

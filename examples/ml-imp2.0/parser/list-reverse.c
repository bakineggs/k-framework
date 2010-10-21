struct nodeList {
  int val;
  struct nodeList *next;
};


int reverse(struct nodeList *x)
/*@ pre < config > < env > x |-> ?x </ env > < heap > list(?x)(A) </ heap > < form > TrueFormula </ form > </ config > */
/*@ post < config > < env > ?rho </ env >
                   < heap > list(?x)(rev(A)) </ heap > < form > returns ?x </ form > </ config > */
{
  struct nodeList *p;
  struct nodeList *y;
  p = 0 ;
  /*@ invariant < config > < env > p |-> ?p x |-> ?x ?rho </ env >
                          < heap > list(?p)(?B) list(?x)(?C) </ heap >
                          < form > rev(A) === rev(?C) ::: ?B </ form > </ config > */
  while(x != 0) {
    y = x->next;
    x->next = p;
    p = x;
    x = y;
  }
  return p;
}

void main()
/*@ pre < config > < env > (.).Map </ env > < heap > (.).Map </ heap > < form > TrueFormula </ form > </ config > */
/*@ post < config > < env > (.).Map </ env >
                   < heap > (.).Map </ heap > < form > TrueFormula </ form > </ config > */
{
  /*@ assume < config > < env > x |-> ?x </ env > < heap > list(?x)(A) </ heap > < form > TrueFormula </ form > </ config > */
  x = reverse(x) ;
  /*@ assert < config > < env > x |-> ?x </ env > < heap > list(?x)(rev(A)) </ heap > < form > TrueFormula </ form > </ config > */
}

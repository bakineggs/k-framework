#include <stdlib.h>
#include <stdio.h>

struct purse {
  int balance;
} ;

struct purse* credit(struct purse *p, int s)
/*@ pre   < config > 
          < env > p |-> p0 s |-> s0 ?rho' </ env > 
          < heap > p0 |-> val0 : purse . balance H </ heap >
          < form > TrueFormula </ form > C </ config > */
/*@ post  < config > 
          < env > ?rho </ env > 
          < heap > p0 |-> ?val : purse . balance H </ heap >
          < form > returns p0 /\ (?val === val0 +Int s0) </ form > C </ config > */
{
  p->balance = p->balance + s;
  return p;
}

struct purse* withdraw(struct purse *p, int s)
/*@ pre   < config > 
          < env > p |-> p0 s |-> s0 </ env > 
          < heap > p0 |-> val0 : purse . balance H </ heap >
          < form > @(val0 >=Int s0) /\ @(s0 >=Int 0) </ form > C </ config > */
/*@ post  < config > 
          < env > ?rho </ env > 
          < heap > p0 |-> (val0 -Int s0) : purse . balance H </ heap >
          < form > returns p0 /\ (?val === val0 -Int s0) </ form > C </ config > */
{
  p->balance = p->balance - s;
  return p;
}

/*@ verify */
int main()
{
  struct purse* p1;
  struct purse* p2;
  int s;
  p1 = (struct purse*)malloc(sizeof(struct purse));
  p2 = (struct purse*)malloc(sizeof(struct purse));
  printf("Account#1: %d Account#2: %d\n",p1->balance,p2->balance);
  p1->balance = 0;
  printf("Account#1: %d Account#2: %d\n",p1->balance,p2->balance);
  p2->balance = 320;
  s = 100;

  credit(p2,s);
  printf("Account#1: %d Account#2 after credit: %d\n",p1->balance,p2->balance);
  return 0;
}

/*@ var val0 s0 p0 : FreeInt */
/*@ var ?val ?p1 ?p2 : ?Int */
/*@ var ?rho ?rho' : ?MapItem */
/*@ var H : FreeMapItem */
/*@ var C : FreeBagItem */


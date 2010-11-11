#include <stdlib.h>

int refact(int n)
/*@ pre  < config > < env > n |-> n0 </ env >
                    < form > @(n0 >Int 0) </ form > C </ config > */
/*@ post < config > < env > ?rho </ env >
                    < form > returns (factorial(n0)) </ form >
                    C </ config > */
{
  int res;
  res = 1;
  if (n > 1)
  {
    res = res * refact(n - 1) ;
  }
  return res;
}

int main()
{
  int f;
  f = refact(10);
  return 0;
}


/*@ var n0 : FreeInt */
/*@ var ?rho : ?MapItem */
/*@ var C : FreeBagItem */


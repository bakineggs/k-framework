#include <stdio.h>

int fibonacci(int n)
/*@ pre  < config > < env > n |-> n0 </ env >
                    < form > @(n0 >Int 0) </ form > C </ config > */
/*@ post < config > < env > ?rho </ env >
                    < form > returns (fibon(n0)) </ form >
                    C </ config > */
{
  int res;
  if (n <= 1) res = 1; 
  else res =  fibonacci(n - 1) + fibonacci(n - 2);
  return res;
}

int main()
{
  int f;
  f = fibonacci(5);
  printf("Fib. for %d is %d\n", 5,f);
  return 0;
}


/*@ var n0 : FreeInt */
/*@ var ?rho : ?MapItem */
/*@ var C : FreeBagItem */


#include <stdio.h>

    int fact(int n) {
          int result = 1;
          while (n > 0) {
            result = n * result; 
            n = n - 1;
          }
          return result;
        }
    int main() {
         int n;
         scanf("%d", &n);
         printf("%d;",fact(n));
    }


#include <stdio.h>
extern int f(int x, int y);
int z = 5;
int main(void){
	printf("1z = %d\n", z);
	printf("f(2, 3) should be 7\n");
	printf("f(2, 3)==%d\n", f(2, 3));
	return 0;
}

kmod KERNELC-PROGRAMS is including KERNELC-THREADS-SYNTAX 
  syntax Pgm ::= pSum | pCollatz | pBufferOverflow | pSimpTest  | pStrErr | pStrTest
               | pAllocateBadPrint | pAllocatePrintReversePrintFree | pAllocatePrintFree
  syntax CompilationUnit ::= pPrint.c  | pAllocateLoop.c | pAllocateGood.c | pAllocateBad.c | pReverse.c
                    | pFree.c | pStrLen.c | pStrCpy.c | pStrRead.c | pStrPrint.c | pStrDup.c | pString.c | pString2.c 
  syntax Id ::= a | b | c | d | e | i | l 
          | limit | nr | nn | n | p | q | r | s | steps | t | t1 | t2 | x | y | z 

  syntax Id ::= print | allocateLoop | reverse | quickSort

syntax Id ::= strDup | strRead | strPrint | strCpy | strLen | string | string2 | freeList 

  macro pSum = 
    #include<stdio.h>
    #include<stdlib.h>
    int main() {
         int n = 1000 ;
	 int s = 0 ;
         int i = n ;
         while (!(i <= 0)) {
           s = s + i ;
           i = i - 1 ;
         } 
         printf("%d;",s);
         return 0;
    }

  macro pCollatz = 
    #include<stdio.h>
    #include<stdlib.h>
    int main() {
         int limit = 10 ;
         int steps = 0 ; int nr = 2 ;
         int n; int d; int nn;
         while (nr <= limit) {
           n = nr ; nr = nr + 1 ;
           while (!(n <= 1)) {
             steps = steps + 1 ;
	     d = 0 ;
             nn = 2 ;
             while (nn <= n) {
               d = d + 1 ;
               nn = nn + 2 ;
             }
             if (nn <= (n + 1)) n = n + n + n + 1 ; else n = d ;
           }
         } 
         printf("%d;",steps);
         return 0;
  } 

  macro #include<pPrint.c> =
void print(int *a) {
  int * p = a ;
 while (p) {
  printf("%d;",* p);
  p = * (p + 1) ;
 }
}
 
  macro #include<pAllocateLoop.c> = 
int allocateLoop(int a,int * p) {
 int n = 0 ;
 int * q ;
 while (n != a) {
  q = (int *)malloc(2 * sizeof(int)) ;
  * q = n ;
  * (q + 1) = p ;
  p = q ;
  n = n + 1 ;
 }
 return p ;
}

---  macro pAllocateGood = allocateLoop(a,null) ;

---  macro pAllocateBad = allocateLoop(a, malloc(2), o) ;

  macro #include<pReverse.c> = int reverse(int *p) {
  int * x ; int * y ;
 if (p) {
  x = *(p + 1) ;
  *(p + 1) = NULL ;
  while (x) {
   y = *(x + 1);
   *(x + 1) = p ;
   p = x ;
   x = y ;
  }
 }
 return p ;
}

  macro #include<pFree.c> = void freeList(int * p) {
int * q;
 while (p) {
  q = * (p + 1) ;
  free(p) ;
  p = q ;
 }
}

  macro #include<pStrLen.c> = int strLen(int * a) {
   int l = 0;
   while(* a++) {l++;}
   return l;
}

  macro #include<pStrCpy.c> = void strCpy(int * a, int * b) {
   while (*a++=*b++) {} 
}

  macro #include<pStrDup.c> = int * strDup(int * a) {
    int * p = (int *)malloc((strLen(a)+1)*sizeof(int)) ;
    strCpy(p,a);
    return p;
  }

  macro #include<pString.c> = int * string() {
    int * p =  (int *)malloc(5*sizeof(int));
    p[0] = 1; p[1] = 2 ; p[2] = 3 ; p[3] = 4 ; p[4] = 0 ;
    return p;
}

  macro #include<pString2.c> =  int * string2() {
    int * p =  (int *)malloc(100*sizeof(int));
    int i = 0 ;
    while (i <= 98) {
      p[i] = i + 5 ;
      i = i + 1 ;
    }
    p[99] = 0 ;
    return p;
}


macro #include<pStrRead.c> =
int * strRead() {
  int n ;
  scanf("%d",&n);
  int * a = (int *)malloc((n+1)*sizeof(int));
  int i = 0;
  while (i != n) {
    scanf("%d",a+i);
    i++;
  }
  a[n]=0;
  return a;
}

  macro pBufferOverflow =
    #include<stdio.h>
    #include<stdlib.h>
    #include<pStrRead.c>
    #include<pStrCpy.c>
    #include<pStrPrint.c>
    int main() {
      int * x = strRead(); strPrint(x);
      int * y = strRead(); strPrint(y);
      strCpy(x,y);
      strPrint(x); strPrint(y);
      return 0;
    }

  syntax List{Exp} ::= pBufferOverflow.in1 | pBufferOverflow.in2 | pBufferOverflow.in3 

  macro pBufferOverflow.in1 = (4,10,11,12,13,2,20,21) 
  macro pBufferOverflow.in2 = (4,10,11,12,13,0)
  macro pBufferOverflow.in3 = (4,10,11,12,13,6,20,21,22,23,24,25) 

  
  macro #include<pStrPrint.c> =  void strPrint(int *a) {
   while (* a) {
     printf("%d;",* a++);
   }
}

  macro pStrTest  = 
    #include<stdio.h>
    #include<stdlib.h>
    #include<pString.c>
    #include<pStrCpy.c>
    #include<pStrLen.c>
    #include<pStrDup.c>
    #include<pStrPrint.c>
    int main() {
   int * x = string(); 
   int * y = strDup(x);
   strPrint(y);
   free(x);
   free(y);
   return 0;
}

  macro pStrErr =
    #include<stdio.h>
    #include<stdlib.h>
   #include<pString.c>
   #include<pStrPrint.c>
    int main() {
   int * x = string();
   int * y = string();
   * (y - 1) = 5 ;
   strPrint(x);
   free(x);
   free(y);
   return 0;
}

macro pAllocatePrintFree =
    #include<stdio.h>
    #include<stdlib.h>
    #include<pAllocateLoop.c>
    #include<pPrint.c>
    #include<pFree.c>
    int main() {
      int * a = allocateLoop(5,NULL); print(a); freeList(a);
      return 0;
    } 

macro pAllocatePrintReversePrintFree =
    #include<stdio.h>
    #include<stdlib.h>
    #include<pAllocateLoop.c>
    #include<pPrint.c>
    #include<pFree.c>
    #include<pReverse.c>
    int main() {
      int * a = allocateLoop(7,NULL); print(a); a = reverse(a); print(a); free(a);
      return 0;
    } 

macro pAllocateBadPrint =
    #include<stdio.h>
    #include<stdlib.h>
    #include<pAllocateLoop.c>
    #include<pPrint.c>
    #include<pFree.c>
    int main() {
      int * a = allocateLoop(2,(int *)malloc(2*sizeof(int))); print(a); free(a);
      return 0;
    } 

macro pSimpTest =
 #include<stdio.h>
    #include<stdlib.h>
    int main() {
     int * x = (int *)malloc(3*sizeof(int));
     if (x == NULL) printf("%d;",-1); else printf("%d;",x);
     return 0;
} 

 
syntax CompilationUnit ::= fNewArray.c  | fPrintArray.c
syntax Id ::= newArray | printArray
macro #include<fNewArray.c> = 
int * newArray() {
  int n ;
  scanf("%d",&n);
  int * a = (int *)malloc((n+1)*sizeof(int));
  a[0]=n;
  int i = 1;
  while (i <= n) {
    scanf("%d",a+i);
    i = i + 1;
  }
  return a;
}

macro #include<fPrintArray.c> = 
void printArray(int * a) {
  int i = 1;
  while (i <= a[0]) { 
    printf("%d;",a[i]);
    i = i+1;
  }
}

syntax Pgm ::= pSeqQuickSort |  pConcQuickSort

macro pSeqQuickSort = 
#include<stdio.h>
#include<stdlib.h>
#include<pStrRead.c>
#include<pStrPrint.c>
#include<pStrLen.c>
void quickSort(int *b,int *e) {
  int t ;
  if (! (e <= b + 1)) {
    int p = *b;
    int *l = b+1;
    int *r = e;
    while  (l+1<= r) {
      if (*l <= p) {
        l = l + 1;
      } else { 
        r = r - 1;
        t=*l;*l=*r;*r=t;
      }
    }
    l = l - 1;
    t=*l;*l=*b;*b=t;
    quickSort(b,l); 
    quickSort(r,e);
  }
}
int main() {
  int * a = strRead();
  quickSort(a,a+strLen(a));
  strPrint(a);
  free(a);
  return 0;
}

syntax List{Exp} ::= pSeqQuickSort.in

macro  pSeqQuickSort.in = (7,5,9,10,3,8,4,1,0)

macro pConcQuickSort = 
    #include<stdio.h>
    #include<stdlib.h>
    #include<fNewArray.c>
    #include<fPrintArray.c>
void quickSort(int *b,int *e) {
  int t ;
  if (! (e <= b + 1)) {
    int p = *b;
    int *l = b+1;
    int *r = e;
    while  (l+1<= r) {
      if (*l <= p) {
        l = l + 1;
      } else { 
        r = r - 1;
        t=*l;*l=*r;*r=t;
      }
    }
    l = l - 1;
    t=*l;*l=*b;*b=t;
    int t1 = spawn(quickSort(b,l)); 
    int t2 = spawn(quickSort(r,e));
    join(t1); join(t2);
  }
}
int main() {
  int * a = newArray();
  quickSort(a+1,a+a[0]+1);
  printArray(a);
  free(a);
  return 0;
}

syntax Pgm ::= pRace1 | pRace2 | pRace3 
syntax Id ::= inc
macro pRace1 =
#include<stdio.h>
#include<stdlib.h>
void inc(int *a) {
  * a = * a + 1;
}
int main() {
  int * a = (int *)malloc(1*sizeof(int));
  * a = 0;
  int t1 = spawn(inc(a));
  int t2 = spawn(inc(a));
  join(t1);
  join(t2);
  printf("%d;",*a);
  return 0;
}


syntax StmtList ::= cSynchronizedAccount | cDSynchronizedAccount | cGSynchronizedAccount 
                  | cSynchAcc ( StmtList ) | cBasicAccount
macro cBasicAccount =
int * newAccount(int m) {
  int * a = (int *)malloc(1*sizeof(int));
  *a = m;
  return a;
}

void deposit(int * a,int m) {
  *a = *a+m;
}

void withdraw(int *a, int m) {
  *a = *a-m;
}

void transfer(int *a,int *b,int m) {
  *a = *a-m;
  *b = *b+m;
}

void print(int *a) {
  printf("%d;",*a);
}

syntax Id ::= newAccount | deposit | withdraw | transfer | balance | m | run | run1 | run2

syntax Stmt ::= fTransfer | fDTransfer | fGTransfer

macro cSynchronizedAccount = cSynchAcc(fTransfer)
macro cDSynchronizedAccount = cSynchAcc(fDTransfer)
macro cGSynchronizedAccount = cSynchAcc(fGTransfer)

macro cSynchAcc(Sts) =
int *newAccount(int m) {
  int *a = (int *)malloc(1*sizeof(int));
  *a = m;
  return a;
}

void deposit(int *a, int m) {
  acquire(a);
  *a = *a+m;
  release(a);
}

void withdraw(int *a, int m) {
  acquire(a);
  if (m <= *a) {
    *a = *a - m;
  }
  release(a);
}

Sts

int balance(int *a) {
  acquire(a);
  int b = * a;
  release(a);
  return b;
}

macro fTransfer =
void transfer(int *a, int *b, int m) {
  acquire(a);
  if (m <= *a) {
    *a = *a-m;
    *b = *b+m;
  }
  release(a);
}

macro fDTransfer = 
void transfer(int *a, int *b, int m) {
  acquire(a);
  acquire(b);
  if (m <= *a) {
    *a = *a-m;
    *b = *b+m;
  }
  release(a);
  release(b);
}

macro fGTransfer = 
void transfer(int *a, int *b, int m) {
  if (a <= b) {
    acquire(a);
    acquire(b);
  } else {
    acquire(b);
    acquire(a);
  }
  if (m <= *a) {
    *a = *a-m;
    *b = *b+m;
  }
  release(a);
  release(b);
}

syntax Pgm ::= pAccount1 | pAccount2 | pAccount3 | pAccount4 | pAccount5
             | pAccountDriver1 ( StmtList ) | pAccountDriver2 ( StmtList )

macro pAccount1 = pAccountDriver1(cBasicAccount)
macro pAccount2 = pAccountDriver1(cSynchronizedAccount)
macro pAccountDriver1(Sts:StmtList) =
#include<stdio.h>
#include<stdlib.h>
Sts

void run(int *a, int *b) {
  deposit(a, 300);
  withdraw(a, 100);
  transfer(a, b, 100);
}

int main() {
  int *a = newAccount(100);
  int *b = newAccount(20);
  printf("%d;", balance(a));
  printf("%d;", balance(b));
  int t1 = spawn(run(a, b));
  int t2 = spawn(run(b, a));
  join(t1); join(t2);
  printf("%d;", balance(a));
  printf("%d;", balance(b));
  return 0;
}

macro pAccount3 = pAccountDriver1(cSynchronizedAccount)
macro pAccount4 = pAccountDriver1(cDSynchronizedAccount)
macro pAccount5 = pAccountDriver1(cGSynchronizedAccount)

macro  pAccountDriver2(Sts) =
#include<stdio.h>
#include<stdlib.h>
Sts
void run1(int *a,int *b) {
  deposit(a,300);
  withdraw(b,300);
  transfer(a,b,50);
}

void run2(int *a,int *b) {
  transfer(a,b,50);
  deposit(a,300);
  withdraw(b,300);
}

void main() {
  int *a = newAccount(100);
  int *b = newAccount(20);
  print(a);
  print(b);
  int t1 = spawn(run1(a,b));
  int t2 = spawn(run2(b,a));
  join(t1);
  join(t2);
  print(a);
  print(b);
}


  syntax Pgm ::= pPeterson.c | pPeterson1.c
  syntax Id ::= flag | turn | peterson
  macro pPeterson.c = 
#include <stdio.h>
#include <stdlib.h>

void peterson(int *flag, int *turn, int t) {
  flag[t] = 1;
  *turn = 1-t;
  while (flag[1-t] && *turn == 1-t) {}
  printf("%d;",-1-t);
  printf("%d;", 1+t);
  flag[t] = 0;
}

int main() {
  int* flag = (int *)malloc(2*sizeof(int));
  flag[0] = 0; flag[1] = 0 ;
  int * turn =  (int *)malloc(1*sizeof(int));
  int t1 = spawn(peterson(flag, turn, 0));
  int t2 = spawn(peterson(flag, turn, 1));
  join(t1);
  join(t2);
  return 0;
}


macro pPeterson1.c = 
#include <stdio.h>
#include <stdlib.h>

void peterson(int *flag, int *turn, int t) {
  flag[t] = 1;
  *turn = 1-t;
  while (*turn == 1-t && flag[1-t] ) {}
  printf("%d;",-1-t);
  printf("%d;", 1+t);
  flag[t] = 0;
}

int main() {
  int* flag = (int *)malloc(2*sizeof(int));
  flag[0] = 0; flag[1] = 0 ;
  int * turn =  (int *)malloc(1*sizeof(int));
  int t1 = spawn(peterson(flag, turn, 0));
  int t2 = spawn(peterson(flag, turn, 1));
  join(t1);
  join(t2);
  return 0;
}
endkm


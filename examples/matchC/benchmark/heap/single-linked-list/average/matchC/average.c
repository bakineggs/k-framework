#include <stdlib.h>
#include <stdio.h>

struct nodeList {
  int val;
  struct nodeList *next;
};

int length(struct listNode* x)
//@ pre  <heap> list(x)(A), H </heap> /\ x = x0
//@ post <heap> list(x0)(A), H </heap> /\ returns(len(A))
{
  int l;
  
  l = 0;
//@ invariant <heap> lseg(x0,x)(?A1), list(x)(?A2), H </heap> /\ A = ?A1 @ ?A2 /\ l = len(?A1)
  while (x) {
    l += 1;
    x = x->next ;
  }

  return l;
}

int summ(struct nodeList* a)
//@ pre  <heap> list(a)(A), H </heap> /\ a = a0
//@ post <heap> list(a0)(A), H </heap> /\ returns(thesum(A))
{
  int s;
  struct nodeList* x;
  x = a;
  s = 0;
//@ invariant <heap> lseg(a0,x)(?A), list(x)(?X), H </heap> /\ (?A @ ?X) = A /\ (s = thesum(?A))
  while (x != 0) {
    s = s + x->val;
    x = x->next;
  }
  return s;
}

int average(struct nodeList* a)
//@ pre <heap> list(a)(A), H </heap> /\ a = a0
//@ post <heap> list(a0)(A), H </heap> /\ returns(theavg(A))
{
  int s;
  int l;
//@ assert <heap> list(a0)(A), H </heap>
  s = summ(a);
//@ assert <heap> list(a0)(A), H </heap> /\ s = thesum(A)
  l = length(a);
  s = s / l;
  return s;
}

int main()
{
  struct nodeList* x;
  struct nodeList* y;
  int s;
  x = (struct nodeList*)malloc(sizeof(struct nodeList));
  x->val = 5;
  x->next = 0;
  y = (struct nodeList*)malloc(sizeof(struct nodeList));
  y->val = 4;
  y->next = x;
  x = y;
  y = (struct nodeList*)malloc(sizeof(struct nodeList));
  y->val = 3;
  y->next = x;
  x = y;
  s = summ(x);
  printf("%d\n", s);
  return 0;
}
  
  
//@ var s, l : ?Int
//@ var A, X : Seq
//@ var H : MapItem

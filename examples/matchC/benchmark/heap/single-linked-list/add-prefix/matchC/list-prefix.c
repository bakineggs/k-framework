#include <stdlib.h>
#include <stdio.h>


struct listNode {
  int val;
  struct listNode *next;
};


struct listNode* append(struct listNode *x, int i)
//@ pre  <heap> list(x)(A), H </heap> /\ i = i0
//@ post <heap> list(?x)([i0] @ A), H </heap> /\ returns(?x)
{
  struct listNode *p;
  p = (struct listNode*)malloc(sizeof(struct listNode));
  p->val = i;
  
  if (x == 0)
  { 
    p->next = 0;
  }
  else
  {
    p->next = x;
  }
  x = p;
  return x;
}

struct listNode* create(int n)
{
  struct listNode *x;
  struct listNode *y;
  x = 0;
  while (n)
  {
    y = x;
    x = (struct listNode*)malloc(sizeof(struct listNode));
    x->val = n;
    x->next = y;
    n -= 1;
  }
  return x;
}

void destroy(struct listNode* x)
//@ pre  <heap> list(x)(?A), H </heap>
//@ post <heap> H </heap>
{
  struct listNode *y;

  //@ invariant <heap> list(x)(?A), H </heap>
  while(x)
  {
    y = x->next;
    free(x);
    x = y;
  }
}


void print(struct listNode* x)
//@ pre  <heap>  list(x)(A), H </heap><out> B </out> /\ x = x0
//@ post <heap> list(x0)(A), H </heap><out> B @ A </out>
{
  /*@ invariant <heap> lseg(x0,x)(?A1), list(x)(?A2), H </heap>
                <out> B @ ?A1 </out> /\ A = ?A1 @ ?A2 */
  while(x)
  {
    printf("%d ",x->val);
    x = x->next;
  }
  printf("\n"); 
}


int main()
{
  struct listNode *x;
  struct listNode *y;

  x = create(5);
  //@ assert <heap> list(x)([1, 2, 3, 4, 5]) </heap>
  x = append(x,15);
  //@ assert <heap> list(x)([15, 1, 2, 3, 4, 5]) </heap>
  destroy(x);
  //@ assert <heap> . </heap>
  
  return 0;
}


//@ var n, i : Int
//@ var A, B, C : Seq
//@ var H : MapItem


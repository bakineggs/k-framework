#include <stdlib.h>

struct treeNode {
  int val;
  struct treeNode *left;
  struct treeNode *right;
};


struct nodeList {
  int val;
  struct nodeList *next;
};
  
struct nodeList *toListRecursive(struct treeNode *root, struct nodeList *x)
/*@ pre  < config > < env > root |-> ?root x |-> ?x </ env >
                    < heap > tree(?root)(T) list(?x)(A) H </ heap >
                    < form > TrueFormula </ form > C </ config > */
/*@ post < config > < env > ?rho </ env >
                    < heap > list(?x)(tree2seq(T) @ A) H </ heap >
                    < form > returns ?x </ form > C </ config > */
{
  struct nodeList *node;
  if (root == 0)
    return x;
  node = (struct nodeList *) malloc(sizeof(struct nodeList));
  node->val = root->val; 
  node->next = toListRecursive(root->right, x);
  node = toListRecursive(root->left, node);
  free(root);
  return node;
}

/*@ var ?root ?x : ?Int */
/*@ var T : FreeTree */
/*@ var ?T : ?Tree */
/*@ var A : FreeSeq */
/*@ var ?rho : ?MapItem */
/*@ var H : FreeMapItem */
/*@ var C : FreeBagItem */


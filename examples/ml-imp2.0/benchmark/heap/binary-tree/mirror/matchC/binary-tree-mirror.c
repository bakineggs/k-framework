#include <stdlib.h>

struct treeNode {
  int val;
  struct treeNode *left;
  struct treeNode *right;
};

struct treeNode* mirrorTree(struct treeNode* root)
/*@ pre  < config > < env > root |-> root0 </ env >
                    < heap > tree(root0)(T) H </ heap >
                    < form > TrueFormula </ form > C </ config > */
/*@ post < config > < env > ?rho </ env >
                    < heap > tree(root0)(mirror(T)) H </ heap >
                    < form > returns root0 </ form > C </ config > */
{
  struct treeNode* mirrorLeft;
	struct treeNode* mirrorRight;
  if (root != 0)
  {
    mirrorRight = mirrorTree(root->right);
    mirrorLeft = mirrorTree(root->left);
    root->left = mirrorRight;
    root->right = mirrorLeft;
  }
  return root;
}

int main()
{
  return 0;
}

/*@ var root0 : FreeInt */
/*@ var T : FreeTree */
/*@ var ?T : ?Tree */
/*@ var ?rho : ?MapItem */
/*@ var H : FreeMapItem */
/*@ var C : FreeBagItem */



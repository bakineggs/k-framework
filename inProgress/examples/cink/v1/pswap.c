   void swap(int *x, int *y)
   {
      int aux = *x;
      *x = *y ;
      *y = aux;
      //breakpoint;
   }

  void main()
  {
    int *a = (int *) malloc(1*sizeof(int));
    int *b = (int *) malloc(1*sizeof(int));
    int x;
    scanf("%d", &x); *a = x;
    scanf("%d", &x); *b = x;
//    *a = 17;
//    *b = 15;
    swap(a, b);
    printf("%d;", *a);
    printf("%d;", *b); 
    free(a);
    free(b);
  }


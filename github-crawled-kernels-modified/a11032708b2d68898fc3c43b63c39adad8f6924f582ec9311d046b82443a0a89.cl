//{"boxwidth":2,"data":0,"inc":1,"x":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline void order(unsigned int* x, unsigned int a, unsigned int b, bool asc) {
  if (asc ^ (x[hook(3, a)] < x[hook(3, b)])) {
    unsigned int auxa = x[hook(3, a)];
    unsigned int auxb = x[hook(3, b)];
    x[hook(3, a)] = auxb;
    x[hook(3, b)] = auxa;
  }
}
inline void merge2(unsigned int* x, bool asc) {
  for (int j = 0; j < 1; j++)
    order(x, j, j + 1, asc);
  ;
  ;
}
kernel void BitonicSortFusion2(global unsigned int* data, int inc, int boxwidth) {
  int id = get_global_id(0);
  inc >>= (1 - 1);
  int low = id & (inc - 1);
  int i = ((id - low) << 1) + low;
  bool asc = ((boxwidth & i) == 0);
  data += i;
  unsigned int x[2];
  for (int k = 0; k < 2; k++)
    x[hook(3, k)] = data[hook(0, k * inc)];
  merge2(x, asc);
  for (int k = 0; k < 2; k++)
    data[hook(0, k * inc)] = x[hook(3, k)];
}
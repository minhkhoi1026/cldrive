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
};
inline void merge4(unsigned int* x, bool asc) {
  for (int j = 0; j < 2; j++)
    order(x, j, j + 2, asc);
  merge2(x, asc);
  merge2(x + 2, asc);
};
inline void merge8(unsigned int* x, bool asc) {
  for (int j = 0; j < 4; j++)
    order(x, j, j + 4, asc);
  merge4(x, asc);
  merge4(x + 4, asc);
};
inline void merge16(unsigned int* x, bool asc) {
  for (int j = 0; j < 8; j++)
    order(x, j, j + 8, asc);
  merge8(x, asc);
  merge8(x + 8, asc);
}
kernel void BitonicSortFusion16(global unsigned int* data, int inc, int boxwidth) {
  int id = get_global_id(0);
  inc >>= (4 - 1);
  int low = id & (inc - 1);
  int i = ((id - low) << 4) + low;
  bool asc = ((boxwidth & i) == 0);
  data += i;
  unsigned int x[16];
  for (int k = 0; k < 16; k++)
    x[hook(3, k)] = data[hook(0, k * inc)];
  merge16(x, asc);
  for (int k = 0; k < 16; k++)
    data[hook(0, k * inc)] = x[hook(3, k)];
}
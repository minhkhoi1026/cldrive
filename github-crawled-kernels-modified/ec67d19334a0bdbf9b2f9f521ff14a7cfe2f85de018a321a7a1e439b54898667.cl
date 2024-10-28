//{"data":0,"dir":2,"inc":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void ParallelBitonic_B4(global unsigned int* restrict data, int inc, int dir) {
  inc >>= 1;
  int t = get_global_id(0);
  int low = t & (inc - 1);
  int i = ((t - low) << 2) + low;
  bool reverse = ((dir & i) == 0);
  data += i;

  unsigned int x0 = data[hook(0, 0)];
  unsigned int x1 = data[hook(0, inc)];
  unsigned int x2 = data[hook(0, 2 * inc)];
  unsigned int x3 = data[hook(0, 3 * inc)];

  {
    bool swap = reverse ^ (x0 < x2);
    unsigned int auxa = x0;
    unsigned int auxb = x2;
    x0 = (swap) ? auxb : auxa;
    x2 = (swap) ? auxa : auxb;
  }
  {
    bool swap = reverse ^ (x1 < x3);
    unsigned int auxa = x1;
    unsigned int auxb = x3;
    x1 = (swap) ? auxb : auxa;
    x3 = (swap) ? auxa : auxb;
  }
  {
    bool swap = reverse ^ (x0 < x1);
    unsigned int auxa = x0;
    unsigned int auxb = x1;
    x0 = (swap) ? auxb : auxa;
    x1 = (swap) ? auxa : auxb;
  }
  {
    bool swap = reverse ^ (x2 < x3);
    unsigned int auxa = x2;
    unsigned int auxb = x3;
    x2 = (swap) ? auxb : auxa;
    x3 = (swap) ? auxa : auxb;
  }

  data[hook(0, 0)] = x0;
  data[hook(0, inc)] = x1;
  data[hook(0, 2 * inc)] = x2;
  data[hook(0, 3 * inc)] = x3;
}
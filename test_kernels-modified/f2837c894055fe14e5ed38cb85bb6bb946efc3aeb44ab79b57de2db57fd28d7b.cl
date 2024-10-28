//{"boxwidth":2,"data":0,"inc":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void BitonicSort(global unsigned int* data, unsigned int inc, unsigned int boxwidth) {
  unsigned int id = get_global_id(0);

  unsigned int low = id & (inc - 1);
  unsigned int i = (id << 1) - low;
  bool asc = (i & boxwidth) == 0;

  data += i;

  unsigned int x0 = data[hook(0, 0)];
  unsigned int x1 = data[hook(0, inc)];

  if (asc ^ (x0 < x1)) {
    data[hook(0, 0)] = x1;
    data[hook(0, inc)] = x0;
  }
}
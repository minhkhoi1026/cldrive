//{"dev_values":0,"j":1,"k":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void bitonic_sort_step(global unsigned int* dev_values, int j, int k) {
  unsigned int i, ixj;
  i = get_global_id(0);
  ixj = i ^ j;

  if ((ixj) > i) {
    if ((i & k) == 0) {
      if (dev_values[hook(0, i)] > dev_values[hook(0, ixj)]) {
        unsigned int temp = dev_values[hook(0, i)];
        dev_values[hook(0, i)] = dev_values[hook(0, ixj)];
        dev_values[hook(0, ixj)] = temp;
      }
    }
    if ((i & k) != 0) {
      if (dev_values[hook(0, i)] < dev_values[hook(0, ixj)]) {
        unsigned int temp = dev_values[hook(0, i)];
        dev_values[hook(0, i)] = dev_values[hook(0, ixj)];
        dev_values[hook(0, ixj)] = temp;
      }
    }
  }
}
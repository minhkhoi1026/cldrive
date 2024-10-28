//{"data":1,"heads":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void lazy_segmented_scan(global unsigned int* restrict heads, global unsigned int* restrict data) {
  unsigned int idx = get_global_id(0);
  unsigned int maximum = get_global_size(0);
  if (heads[hook(0, idx)] != 0) {
    unsigned int val = data[hook(1, idx)];
    unsigned int curr = idx + 1;
    while (heads[hook(0, curr)] == 0 && curr < maximum) {
      val |= data[hook(1, curr)];
      curr += 1;
    }
    data[hook(1, idx)] = val;
  }
}
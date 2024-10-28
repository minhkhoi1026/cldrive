//{"in":0,"mean":3,"out":1,"reduce_factor":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void sum_power(global int* in, global int* out, unsigned reduce_factor, int mean) {
  int x = get_global_id(0);
  int size0 = get_global_size(0);
  unsigned begin = x;
  int i = 0, sum = 0;
  do {
    sum += (in[hook(0, begin)] - mean) * (in[hook(0, begin)] - mean);
    i++;
    begin += size0;
  } while (i != reduce_factor);
  out[hook(1, x)] = sum;
}
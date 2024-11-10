//{"in":0,"out":1,"reduce_factor":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void sum_half_improved(global short2* in, global short* out, unsigned int reduce_factor) {
  int x = get_global_id(0);
  int size0 = get_global_size(0);
  unsigned int begin = x;
  int i;
  int sum = 0;
  for (i = 0; i < reduce_factor / 2; i++) {
    sum += in[hook(0, begin)].x;
    sum += in[hook(0, begin)].y;
    begin += size0;
  }
  out[hook(1, x)] = sum;
}
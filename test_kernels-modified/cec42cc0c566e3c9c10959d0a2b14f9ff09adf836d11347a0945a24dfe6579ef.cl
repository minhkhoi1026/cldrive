//{"in":0,"out":1,"reduce_factor":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void max_half_improved(global short2* in, global short* out, unsigned int reduce_factor) {
  int x = get_global_id(0);
  int size0 = get_global_size(0);
  unsigned int begin = x;
  short2 tmp = in[hook(0, begin)];
  int max_val = tmp.x;
  max_val = tmp.y < max_val ? max_val : tmp.y;
  int i;
  for (i = 1; i < reduce_factor / 2; i++) {
    begin += size0;
    tmp = in[hook(0, begin)];
    max_val = tmp.x < max_val ? max_val : tmp.x;
    max_val = tmp.y < max_val ? max_val : tmp.y;
  }
  out[hook(1, x)] = max_val;
}
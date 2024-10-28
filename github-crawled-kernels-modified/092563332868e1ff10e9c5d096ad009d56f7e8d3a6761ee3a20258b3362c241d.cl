//{"in":0,"out":1,"reduce_factor":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void max_byte_improved(global char4* in, global char* out, unsigned int reduce_factor) {
  int x = get_global_id(0);
  int size0 = get_global_size(0);
  unsigned int begin = x;
  char4 tmp = in[hook(0, begin)];
  int max_val = tmp.x;
  max_val = tmp.y < max_val ? max_val : tmp.y;
  max_val = tmp.z < max_val ? max_val : tmp.z;
  max_val = tmp.w < max_val ? max_val : tmp.w;
  int i;
  for (i = 1; i < reduce_factor / 4; i++) {
    begin += size0;
    tmp = in[hook(0, begin)];
    max_val = tmp.x < max_val ? max_val : tmp.x;
    max_val = tmp.y < max_val ? max_val : tmp.y;
    max_val = tmp.z < max_val ? max_val : tmp.z;
    max_val = tmp.w < max_val ? max_val : tmp.w;
  }
  out[hook(1, x)] = max_val;
}
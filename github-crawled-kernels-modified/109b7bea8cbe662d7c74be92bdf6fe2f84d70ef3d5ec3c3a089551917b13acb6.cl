//{"in":0,"out":1,"reduce_factor":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void sum_byte_improved_atomic(global char4* in, global char* out, unsigned int reduce_factor) {
  int x = get_global_id(0);
  int size0 = get_global_size(0);
  unsigned int begin = x;
  int i;
  int sum = 0;
  for (i = 0; i < reduce_factor / 4; i++) {
    sum += in[hook(0, begin)].x;
    sum += in[hook(0, begin)].y;
    sum += in[hook(0, begin)].z;
    sum += in[hook(0, begin)].w;
    begin += size0;
  }
  atomic_add((global int*)out, sum);
}
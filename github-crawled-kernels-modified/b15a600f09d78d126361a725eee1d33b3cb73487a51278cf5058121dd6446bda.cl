//{"dst":1,"offset":2,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void vload_bench_1int16(global int* src, global unsigned int* dst, unsigned int offset) {
  int id = (int)get_global_id(0);
  uint16 srcV = 0;
  for (int i = 0; i < 1; i++) {
    srcV += convert_uint16(vload16(id + (i & 0xFFFF), src + offset));
  }
  vstore16(srcV, id, dst);
}
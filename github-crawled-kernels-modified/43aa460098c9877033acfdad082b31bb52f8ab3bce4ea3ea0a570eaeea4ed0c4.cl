//{"dst":2,"src0":0,"src1":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compiler_read_buffer(global float4* src0, global float4* src1, global float4* dst) {
  float4 sum = 0;
  int offset = 0, i = 0;
  int id = (int)get_global_id(0);
  int sz = (int)get_global_size(0);
  for (i = 0; i < 16; i++) {
    sum = sum + src0[hook(0, offset + id)] + src1[hook(1, offset + id)];
    offset += sz;
  }
  dst[hook(2, id)] = sum;
}
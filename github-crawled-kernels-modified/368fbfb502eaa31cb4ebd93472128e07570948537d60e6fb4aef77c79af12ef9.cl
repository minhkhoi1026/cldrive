//{"a":0,"b":1,"c":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void sum_f16(global float a[], global float b[], global float c[]) {
  int id = get_global_id(0);
  float16 x = vload16(id, b);
  float16 y = vload16(id, c);
  vstore16(x * y + x * y + x * y, id, a);
}
//{"a":0,"b":1,"c":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void vecAdd(global float* a, global float* b, global float* c) {
  size_t i = get_global_id(0);
  float4 r = vload4(i, a) + vload4(i, b);
  vstore4(r * r, i, c);
}
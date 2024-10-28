//{"c":2,"g":0,"l":1,"out":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_vload4(global float* g, local float* l, constant float* c, global float4* out) {
 private
  float p[4];
  vstore4(vload4(0, g), 0, p);
  barrier(0);
  out[hook(3, 0)] = vload4(0, g);
  out[hook(3, 1)] = vload4(0, l);
  out[hook(3, 2)] = vload4(0, c);
  out[hook(3, 3)] = vload4(0, p);
}
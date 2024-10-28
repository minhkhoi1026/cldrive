//{"fval":1,"outfval":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float __sin(float in);
float __cos(float in);
float __exp(float in);
kernel void testkernel(global float* outfval, global const float* fval) {
  int i = get_global_id(0);
  outfval[hook(0, i)] = __sin(fval[hook(1, i)]);
}
//{"a":0,"b":1,"c":2,"params":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float function_example(float a, float b) {
  return a + b;
}

kernel void func_kernel(global float* a, global float* b, global float* c, constant struct Params* params) {
  unsigned int i = get_global_id(0);

  c[hook(2, i)] = function_example(a[hook(0, i)], b[hook(1, i)]);
}
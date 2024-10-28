//{"a":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
extern float externFunc(global float* a);
kernel void externFunction(global float* a) {
  a[hook(0, 0)] = externFunc(a);
}
//{"ke":2,"m":0,"v":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_kinetic(global float* m, global float4* v, global float4* ke) {
  int i = get_global_id(0);

  ke[hook(2, i)].x = 0.5 * m[hook(0, i)] * v[hook(1, i)].x * v[hook(1, i)].x;
  ke[hook(2, i)].y = 0.5 * m[hook(0, i)] * v[hook(1, i)].y * v[hook(1, i)].y;
  ke[hook(2, i)].z = 0.5 * m[hook(0, i)] * v[hook(1, i)].z * v[hook(1, i)].z;
}
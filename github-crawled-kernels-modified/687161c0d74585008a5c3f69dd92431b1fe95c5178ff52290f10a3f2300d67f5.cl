//{"mag":1,"p":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_magnitude(global float4* p, global float* mag) {
  int i = get_global_id(0);

  float dx = p[hook(0, i)].x * p[hook(0, i)].x;
  float dy = p[hook(0, i)].y * p[hook(0, i)].y;
  float dz = p[hook(0, i)].z * p[hook(0, i)].z;

  mag[hook(1, i)] = sqrt(dx * dx + dy * dy + dz * dz);
}
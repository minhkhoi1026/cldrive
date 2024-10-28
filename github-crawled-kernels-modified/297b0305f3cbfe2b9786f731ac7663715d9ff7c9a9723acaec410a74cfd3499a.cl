//{"d":2,"v1":0,"v2":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_distance(global float4* v1, global float4* v2, global float* d) {
  int i = get_global_id(0);

  float dx = v2[hook(1, i)].x - v1[hook(0, i)].x;
  float dy = v2[hook(1, i)].y - v1[hook(0, i)].y;
  float dz = v2[hook(1, i)].z - v1[hook(0, i)].z;

  d[hook(2, i)] = sqrt(dx * dx + dy * dy + dz * dz);
}
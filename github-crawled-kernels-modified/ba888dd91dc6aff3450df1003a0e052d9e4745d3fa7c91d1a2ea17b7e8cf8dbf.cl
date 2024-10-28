//{"dim":2,"normals":1,"worlds":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void point_to_normal(global float3* worlds, global float3* normals, int2 dim) {
  int x = get_global_id(0);
  int y = get_global_id(1);
  if (x >= dim.x || y >= dim.y) {
    return;
  }
  int id = y * dim.x + x;

  x = clamp(x, 1, dim.x - 2);
  y = clamp(y, 1, dim.y - 2);
  int k = y * dim.x + x;
  float3 s = worlds[hook(0, k + 1)] - worlds[hook(0, k - 1)];
  float3 t = worlds[hook(0, k + dim.x)] - worlds[hook(0, k - dim.x)];

  normals[hook(1, id)] = normalize(-cross(s, t));
}
//{"EM":3,"dim":2,"points":0,"worlds":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void point_to_world(global float3* points, global float3* worlds, int2 dim, float16 EM) {
  int x = get_global_id(0);
  int y = get_global_id(1);
  if (x >= dim.x || y >= dim.y) {
    return;
  }
  int id = y * dim.x + x;

  float3 v = points[hook(0, id)];

  worlds[hook(1, id)] = EM.lo.lo.xyz * v.x + EM.lo.hi.xyz * v.y + EM.hi.lo.xyz * v.z + EM.hi.hi.xyz;
}
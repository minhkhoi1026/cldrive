//{"height":1,"nmap":3,"vmap":2,"width":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void measurement_normals(global const int* width, global const int* height, global const float3* vmap, global float3* nmap) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);
  int w = *width;
  int h = *height;

  int idx = w * y + x;

  float3 v1 = (x < (w - 1)) ? vmap[hook(2, w * y + x + 1)] : vmap[hook(2, w * y + x - 1)];
  float3 v2 = (y < (h - 1)) ? vmap[hook(2, w * (y + 1) + x)] : vmap[hook(2, w * (y - 1) + x)];

  float3 v = vmap[hook(2, idx)];
  nmap[hook(3, idx)] = normalize((isnan(v1) || isnan(v2) || isnan(v)) ? __builtin_astype((2147483647), float) : cross(v1 - v, v2 - v));
}
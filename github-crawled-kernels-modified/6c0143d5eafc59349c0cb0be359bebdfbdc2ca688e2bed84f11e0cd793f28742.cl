//{"P":1,"P_length":0,"k":4,"k_index":3,"k_length":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void lorenzAttractor(int P_length, global float* P, int k_length, global int* k_index, global float* k) {
  int idx = get_global_id(0);
  if (idx >= P_length)
    return;

  float3 p = vload3(idx, P);
  float a = k[hook(4, 0)];
  float b = k[hook(4, 1)];
  float c = k[hook(4, 2)];
  float dt = 0.0005;

  float3 d;
  d.x = a * (p.y - p.x);
  d.y = p.x * (b - p.z) - p.y;
  d.z = p.x * p.y - c * p.z;

  p += d * dt;
  vstore3(p, idx, P);
}
//{"G":4,"dt":3,"m":2,"p":1,"v":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void update(global float3* v, global float3* p, global float* m, float dt, float G) {
  int gid = get_global_id(0);

  float3 a_gid;
  a_gid.x = 0;
  a_gid.y = 0;
  a_gid.z = 0;

  float mass = m[hook(2, gid)];
  float3 p_gid = p[hook(1, gid)];

  for (int i = 0; i < get_global_size(0); ++i) {
    if (i == gid)
      continue;

    float3 F = p_gid - p[hook(1, i)];
    float r2 = dot(F, F) + 0.001f;

    a_gid -= F * ((G * m[hook(2, i)] / r2) / sqrt(r2));
  }

  float3 v_ = v[hook(0, gid)] + dt * a_gid;

  p[hook(1, gid)] = p_gid + dt * v_;
  v[hook(0, gid)] = v_;
}
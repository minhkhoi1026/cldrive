//{"l":1,"p":3,"q":2,"s":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void monte_carlo(global float* const s, constant const float* const l, local float* const q, constant const float const p[16]) {
  const int gid = get_global_id(0);
  const int lid = get_local_id(0);
  q[hook(2, lid)] = l[hook(1, lid)];
  for (int j = 0; j < 2e+3; ++j)
    for (int i = 0; i < 1e+3; ++i)
      s[hook(0, gid)] = s[hook(0, gid)] + q[hook(2, lid)] * 2.0f + 1.0f + p[hook(3, lid % 16)];
  s[hook(0, gid)] = 0;
  s[hook(0, gid)] = s[hook(0, gid)] + q[hook(2, lid)] * 2.0f + 1.0f + p[hook(3, lid % 16)];
}
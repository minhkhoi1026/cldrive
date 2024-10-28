//{"c":1,"dsec":3,"len":0,"nsec":2,"sm":4,"x":5,"y":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void ParIIR(const int len, const float c, constant float2* nsec, constant float2* dsec, local float* sm, constant float* x, global float* y) {
  int gid = get_global_id(0);
  int lid = get_local_id(0);
  int bls = get_local_size(0);

  float2 u;
  u.x = 0.f;
  u.y = 0.f;

  float new_u;

  int i, j;
  for (i = 0; i < len; i += 256) {
    sm[hook(4, lid)] = x[hook(5, i + lid)];

    barrier(0x01);

    for (j = 0; j < 256; j++) {
      new_u = sm[hook(4, j)] - dot(dsec[hook(3, lid)], u);

      u.y = u.x;
      u.x = new_u;

      float suby = dot(nsec[hook(2, lid)], u);
      float blk_sum = work_group_reduce_add(suby);

      if (lid == 0) {
        y[hook(6, get_group_id(0) * len + i + j)] = blk_sum + c * sm[hook(4, j)];
      }
    }
  }
}
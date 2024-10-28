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

      sm[hook(4, 256 + lid)] = dot(nsec[hook(2, lid)], u);

      barrier(0x01);

      int pos = 256 + lid;

      if (bls >= 256) {
        if (lid < 128) {
          sm[hook(4, pos)] += sm[hook(4, pos + 128)];
        }
        barrier(0x01);
      }
      if (bls >= 128) {
        if (lid < 64) {
          sm[hook(4, pos)] += sm[hook(4, pos + 64)];
        }
        barrier(0x01);
      }
      if (bls >= 64) {
        if (lid < 32) {
          sm[hook(4, pos)] += sm[hook(4, pos + 32)];
        }
        barrier(0x01);
      }
      if (bls >= 32) {
        if (lid < 16) {
          sm[hook(4, pos)] += sm[hook(4, pos + 16)];
        }
        barrier(0x01);
      }
      if (bls >= 16) {
        if (lid < 8) {
          sm[hook(4, pos)] += sm[hook(4, pos + 8)];
        }
        barrier(0x01);
      }
      if (bls >= 8) {
        if (lid < 4) {
          sm[hook(4, pos)] += sm[hook(4, pos + 4)];
        }
        barrier(0x01);
      }
      if (bls >= 4) {
        if (lid < 2) {
          sm[hook(4, pos)] += sm[hook(4, pos + 2)];
        }
        barrier(0x01);
      }
      if (bls >= 2) {
        if (lid < 1) {
          sm[hook(4, pos)] += sm[hook(4, pos + 1)];
        }
        barrier(0x01);
      }

      if (lid == 0) {
        y[hook(6, get_group_id(0) * len + i + j)] = sm[hook(4, 256)] + c * sm[hook(4, j)];
      }

      barrier(0x01);
    }
  }
}
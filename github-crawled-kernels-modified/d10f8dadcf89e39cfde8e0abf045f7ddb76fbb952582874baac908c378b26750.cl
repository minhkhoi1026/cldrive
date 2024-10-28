//{"FLAG":1,"P":0,"imax":2,"jmax":3,"p0_result":4,"scratch":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
struct float4 {
  float x;
  float y;
  struct float4* next;
};

struct particleline {
  int length;
  struct float4* Particles;
};

struct float4* partalloc(float x, float y);
kernel void POISSON_p0_kernel(global float* P, global int* FLAG, int imax, int jmax, global float* p0_result, local float* scratch) {
  imax = imax + 2;
  jmax = jmax + 2;

  unsigned int gid = get_global_id(0);
  unsigned int tid = get_local_id(0);

  int i = gid / imax;
  int j = gid % jmax;

  if ((i > 0 && i < imax - 1) && (j > 0 && j < jmax - 1)) {
    if (FLAG[hook(1, i * jmax + j)] & 0x0010) {
      scratch[hook(5, tid)] = P[hook(0, i * jmax + j)] * P[hook(0, i * jmax + j)];
    } else {
      scratch[hook(5, tid)] = 0.0;
    }
  } else {
    scratch[hook(5, tid)] = 0.0;
  }

  barrier(0x01);

  for (unsigned int s = 1; s < get_local_size(0); s *= 2) {
    if ((tid % (2 * s)) == 0) {
      scratch[hook(5, tid)] += scratch[hook(5, tid + s)];
    }
    barrier(0x01);
  }

  if (tid == 0) {
    p0_result[hook(4, get_group_id(0) * get_num_groups(1) + get_group_id(1))] = scratch[hook(5, 0)];
  }
}

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
kernel void POISSON_2_comp_res_kernel(global float* P, global float* RHS, global int* FLAG, int imax, int jmax, float rdx2, float rdy2, global float* res_result, local float* scratch) {
  imax = imax + 2;
  jmax = jmax + 2;

  unsigned int gid = get_global_id(0);
  unsigned int tid = get_local_id(0);

  int i = gid & (imax - 1);
  int j = gid >> (int)log2((float)jmax);

  float add;

  if ((i > 0 && i < imax - 1) && (j > 0 && j < jmax - 1)) {
    if ((FLAG[hook(2, i * jmax + j)] & 0x0010) && (FLAG[hook(2, i * jmax + j)] < 0x0100)) {
      add = (P[hook(0, (i + 1) * jmax + j)] - 2 * P[hook(0, i * jmax + j)] + P[hook(0, (i - 1) * jmax + j)]) * rdx2 + (P[hook(0, i * jmax + j + 1)] - 2 * P[hook(0, i * jmax + j)] + P[hook(0, i * jmax + j - 1)]) * rdy2 - RHS[hook(1, i * jmax + j)];

      scratch[hook(8, tid)] = add * add;
    } else {
      scratch[hook(8, tid)] = 0.0;
    }
  } else {
    scratch[hook(8, tid)] = 0.0;
  }

  barrier(0x01);
  for (int s = get_local_size(0) / 2; s > 0; s >>= 1) {
    if (tid < s) {
      scratch[hook(8, tid)] += scratch[hook(8, tid + s)];
    }
    barrier(0x01);
  }

  if (tid == 0) {
    res_result[hook(7, get_group_id(0))] = scratch[hook(8, 0)];
  }
}
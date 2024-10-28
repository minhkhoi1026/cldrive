//{"F":0,"FLAG":3,"F_l":9,"G":1,"G_l":10,"RHS":2,"delt":6,"delx":7,"dely":8,"imax":4,"jmax":5}
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
kernel void COMP_RHS_kernel(global float* F, global float* G, global float* RHS, global int* FLAG, int imax, int jmax, float delt, float delx, float dely, local float* F_l, local float* G_l) {
  imax = imax + 2;
  jmax = jmax + 2;

  int i = get_global_id(1);
  int j = get_global_id(0);

  int ti = get_local_id(1);
  int tj = get_local_id(0);

  int local_size_i = get_local_size(1);
  int local_size_j = get_local_size(0);

  if ((i > 0 && i < imax - 1) && (j > 0 && j < jmax - 1)) {
    F_l[hook(9, ti * local_size_j + tj)] = F[hook(0, i * jmax + j)] - F[hook(0, (i - 1) * jmax + j)];
    G_l[hook(10, ti * local_size_j + tj)] = G[hook(1, i * jmax + j)] - G[hook(1, i * jmax + j - 1)];
  } else {
    F_l[hook(9, ti * local_size_j + tj)] = 0;
    G_l[hook(10, ti * local_size_j + tj)] = 0;
  }

  barrier(0x01);

  if ((i > 0 && i < imax - 1) && (j > 0 && j < jmax - 1)) {
    if ((FLAG[hook(3, i * jmax + j)] & 0x0010) && (FLAG[hook(3, i * jmax + j)] < 0x0100)) {
      RHS[hook(2, i * jmax + j)] = (F_l[hook(9, ti * local_size_j + tj)] / delx + G_l[hook(10, ti * local_size_j + tj)] / dely) / delt;
    }
  }
}
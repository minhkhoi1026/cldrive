//{"FLAG":2,"P":0,"RHS":1,"beta_2":7,"imax":3,"jmax":4,"omg":8,"rdx2":5,"rdy2":6}
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
kernel void POISSON_2_relaxation_kernel(global float* P, global float* RHS, global int* FLAG, int imax, int jmax, float rdx2, float rdy2, float beta_2, float omg) {
  imax = imax + 2;
  jmax = jmax + 2;

  unsigned int gid = get_global_id(0);

  int i, j;

  for (i = 1; i <= imax - 2; i++) {
    for (j = 1; j <= jmax - 2; j++) {
      if ((FLAG[hook(2, i * jmax + j)] & 0x0010) && (FLAG[hook(2, i * jmax + j)] < 0x0100)) {
        P[hook(0, i * jmax + j)] = (1. - omg) * P[hook(0, i * jmax + j)] - beta_2 * ((P[hook(0, (i + 1) * jmax + j)] + P[hook(0, (i - 1) * jmax + j)]) * rdx2 + (P[hook(0, i * jmax + j + 1)] + P[hook(0, i * jmax + j - 1)]) * rdy2 - RHS[hook(1, i * jmax + j)]);
      }
    }
  }
}
//{"F":0,"FLAG":3,"G":1,"RHS":2,"delt":6,"delx":7,"dely":8,"imax":4,"jmax":5}
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
kernel void COMP_RHS_kernel(global float* F, global float* G, global float* RHS, global int* FLAG, int imax, int jmax, float delt, float delx, float dely) {
  imax = imax + 2;
  jmax = jmax + 2;

  int i = get_global_id(1);
  int j = get_global_id(0);

  if ((i > 0 && i < imax - 1) && (j > 0 && j < jmax - 1)) {
    if ((FLAG[hook(3, i * jmax + j)] & 0x0010) && (FLAG[hook(3, i * jmax + j)] < 0x0100)) {
      RHS[hook(2, i * jmax + j)] = ((F[hook(0, i * jmax + j)] - F[hook(0, (i - 1) * jmax + j)]) / delx + (G[hook(1, i * jmax + j)] - G[hook(1, i * jmax + j - 1)]) / dely) / delt;
    }
  }
}
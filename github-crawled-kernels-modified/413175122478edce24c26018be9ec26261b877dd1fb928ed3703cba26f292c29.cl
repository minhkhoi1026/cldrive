//{"F":2,"FLAG":5,"G":3,"P":4,"U":0,"V":1,"delt":8,"delx":9,"dely":10,"imax":6,"jmax":7}
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
kernel void ADAP_UV_kernel(global float* U, global float* V, global float* F, global float* G, global float* P, global int* FLAG, int imax, int jmax, float delt, float delx, float dely) {
  imax = imax + 2;
  jmax = jmax + 2;

  int i = get_global_id(1);
  int j = get_global_id(0);

  if ((i > 0 && i < imax - 2) && (j > 0 && j < jmax - 1)) {
    if (((FLAG[hook(5, i * jmax + j)] & 0x0010) && (FLAG[hook(5, i * jmax + j)] < 0x1000)) && ((FLAG[hook(5, (i + 1) * jmax + j)] & 0x0010) && (FLAG[hook(5, (i + 1) * jmax + j)] < 0x1000))) {
      U[hook(0, i * jmax + j)] = F[hook(2, i * jmax + j)] - (P[hook(4, (i + 1) * jmax + j)] - P[hook(4, i * jmax + j)]) * delt / delx;
    }
  }

  if ((i > 0 && i < imax - 1) && (j > 0 && j < jmax - 2)) {
    if (((FLAG[hook(5, i * jmax + j)] & 0x0010) && (FLAG[hook(5, i * jmax + j)] < 0x1000)) && ((FLAG[hook(5, i * jmax + j + 1)] & 0x0010) && (FLAG[hook(5, i * jmax + j + 1)] < 0x1000))) {
      V[hook(1, i * jmax + j)] = G[hook(3, i * jmax + j)] - (P[hook(4, i * jmax + j + 1)] - P[hook(4, i * jmax + j)]) * delt / dely;
    }
  }
}
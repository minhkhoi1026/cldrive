//{"FLAG":4,"Pr":12,"Re":11,"TEMP":2,"TEMP_new":3,"U":0,"V":1,"delt":7,"delx":8,"dely":9,"gamma":10,"imax":5,"jmax":6}
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
kernel void COMP_TEMP_kernel(global float* U, global float* V, global float* TEMP, global float* TEMP_new, global int* FLAG, int imax, int jmax, float delt, float delx, float dely, float gamma, float Re, float Pr) {
  float LAPLT, DUTDX, DVTDY;

  imax = imax + 2;
  jmax = jmax + 2;

  int i = get_global_id(1);
  int j = get_global_id(0);

  if ((i > 0 && i < imax - 1) && (j > 0 && j < jmax - 1)) {
    if ((FLAG[hook(4, i * jmax + j)] & 0x0010) && (FLAG[hook(4, i * jmax + j)] < 0x1000)) {
      LAPLT = (TEMP[hook(2, (i + 1) * jmax + j)] - 2.0 * TEMP[hook(2, i * jmax + j)] + TEMP[hook(2, (i - 1) * jmax + j)]) * (1. / delx / delx) + (TEMP[hook(2, i * jmax + j + 1)] - 2.0 * TEMP[hook(2, i * jmax + j)] + TEMP[hook(2, i * jmax + j - 1)]) * (1. / dely / dely);
      DUTDX = ((U[hook(0, i * jmax + j)] * 0.5 * (TEMP[hook(2, i * jmax + j)] + TEMP[hook(2, (i + 1) * jmax + j)]) - U[hook(0, (i - 1) * jmax + j)] * 0.5 * (TEMP[hook(2, (i - 1) * jmax + j)] + TEMP[hook(2, i * jmax + j)])) + gamma * (fabs(U[hook(0, i * jmax + j)]) * 0.5 * (TEMP[hook(2, i * jmax + j)] - TEMP[hook(2, (i + 1) * jmax + j)]) - fabs(U[hook(0, (i - 1) * jmax + j)]) * 0.5 * (TEMP[hook(2, (i - 1) * jmax + j)] - TEMP[hook(2, i * jmax + j)]))) / delx;
      DVTDY = ((V[hook(1, i * jmax + j)] * 0.5 * (TEMP[hook(2, i * jmax + j)] + TEMP[hook(2, i * jmax + j + 1)]) - V[hook(1, i * jmax + j - 1)] * 0.5 * (TEMP[hook(2, i * jmax + j - 1)] + TEMP[hook(2, i * jmax + j)])) + gamma * (fabs(V[hook(1, i * jmax + j)]) * 0.5 * (TEMP[hook(2, i * jmax + j)] - TEMP[hook(2, i * jmax + j + 1)]) - fabs(V[hook(1, i * jmax + j - 1)]) * 0.5 * (TEMP[hook(2, i * jmax + j - 1)] - TEMP[hook(2, i * jmax + j)]))) / dely;

      TEMP_new[hook(3, i * jmax + j)] = TEMP[hook(2, i * jmax + j)] + delt * (LAPLT / Re / Pr - DUTDX - DVTDY);
    }
  }
}
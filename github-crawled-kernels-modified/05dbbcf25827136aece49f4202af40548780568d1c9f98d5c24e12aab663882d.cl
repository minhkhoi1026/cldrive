//{"FLAG":4,"Pr":12,"Re":11,"TEMP":2,"TEMP_l":13,"TEMP_new":3,"U":0,"U_l":14,"V":1,"V_l":15,"delt":7,"delx":8,"dely":9,"gamma":10,"imax":5,"jmax":6,"localHeight":16,"localWidth":17}
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
kernel void COMP_TEMP_kernel(global float* U, global float* V, global float* TEMP, global float* TEMP_new, global int* FLAG, int imax, int jmax, float delt, float delx, float dely, float gamma, float Re, float Pr, local float* TEMP_l, local float* U_l, local float* V_l, int localHeight, int localWidth) {
  float LAPLT, DUTDX, DVTDY;

  imax = imax + 2;
  jmax = jmax + 2;

  int i = get_global_id(1);
  int j = get_global_id(0);

  int ti = get_local_id(1);
  int tj = get_local_id(0);

  int local_size_i = get_local_size(1);
  int local_size_j = get_local_size(0);

  TEMP_l[hook(13, ti * local_size_j + tj)] = TEMP[hook(2, i * jmax + j)];

  barrier(0x01);

  if ((i > 0 && i < imax - 1) && (j > 0 && j < jmax - 1)) {
    if ((FLAG[hook(4, i * jmax + j)] & 0x0010) && (FLAG[hook(4, i * jmax + j)] < 0x1000)) {
      if (ti < localWidth && tj < localHeight) {
        LAPLT = (TEMP_l[hook(13, (ti + 1) * local_size_j + tj)] - 2.0 * TEMP_l[hook(13, ti * local_size_j + tj)] + TEMP_l[hook(13, (ti - 1) * local_size_j + tj)]) * (1. / delx / delx) + (TEMP_l[hook(13, ti * local_size_j + tj + 1)] - 2.0 * TEMP_l[hook(13, ti * local_size_j + tj)] + TEMP_l[hook(13, ti * local_size_j + tj - 1)]) * (1. / dely / dely);
        DUTDX = ((U[hook(0, i * jmax + j)] * 0.5 * (TEMP_l[hook(13, ti * local_size_j + tj)] + TEMP_l[hook(13, (ti + 1) * local_size_j + tj)]) - U[hook(0, (i - 1) * jmax + j)] * 0.5 * (TEMP_l[hook(13, (ti - 1) * local_size_j + tj)] + TEMP_l[hook(13, ti * local_size_j + tj)])) + gamma * (fabs(U[hook(0, i * jmax + j)]) * 0.5 * (TEMP_l[hook(13, ti * local_size_j + tj)] - TEMP_l[hook(13, (ti + 1) * local_size_j + tj)]) - fabs(U[hook(0, (i - 1) * jmax + j)]) * 0.5 * (TEMP_l[hook(13, (ti - 1) * local_size_j + tj)] - TEMP_l[hook(13, ti * local_size_j + tj)]))) / delx;
        DVTDY = ((V[hook(1, i * jmax + j)] * 0.5 * (TEMP_l[hook(13, ti * local_size_j + tj)] + TEMP_l[hook(13, ti * local_size_j + tj + 1)]) - V[hook(1, i * jmax + j - 1)] * 0.5 * (TEMP_l[hook(13, ti * local_size_j + tj - 1)] + TEMP_l[hook(13, ti * local_size_j + tj)])) + gamma * (fabs(V[hook(1, i * jmax + j)]) * 0.5 * (TEMP_l[hook(13, ti * local_size_j + tj)] - TEMP_l[hook(13, ti * local_size_j + tj + 1)]) - fabs(V[hook(1, i * jmax + j - 1)]) * 0.5 * (TEMP_l[hook(13, ti * local_size_j + tj - 1)] - TEMP_l[hook(13, ti * local_size_j + tj)]))) / dely;

        TEMP_new[hook(3, i * jmax + j)] = TEMP_l[hook(13, ti * local_size_j + tj)];
      }
    }
  }
}
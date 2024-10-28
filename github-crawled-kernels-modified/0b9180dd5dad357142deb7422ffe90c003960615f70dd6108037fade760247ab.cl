//{"F":3,"FLAG":5,"G":4,"GX":11,"GY":12,"Re":14,"TEMP":2,"U":0,"V":1,"beta":15,"delt":8,"delx":9,"dely":10,"gamma":13,"imax":6,"jmax":7}
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
kernel void COMP_FG_kernel(global float* U, global float* V, global float* TEMP, global float* F, global float* G, global int* FLAG, int imax, int jmax, float delt, float delx, float dely, float GX, float GY, float gamma, float Re, float beta) {
  float DU2DX, DUVDY, DUVDX, DV2DY, LAPLU, LAPLV;

  imax = imax + 2;
  jmax = jmax + 2;

  int i = get_global_id(1);
  int j = get_global_id(0);

  if ((i > 0 && i < imax - 1) && (j > 0 && j < jmax - 1)) {
    if (((FLAG[hook(5, i * jmax + j)] & 0x0010) && (FLAG[hook(5, i * jmax + j)] < 0x1000)) && ((FLAG[hook(5, (i + 1) * jmax + j)] & 0x0010) && (FLAG[hook(5, (i + 1) * jmax + j)] < 0x1000))) {
      DU2DX = ((U[hook(0, i * jmax + j)] + U[hook(0, (i + 1) * jmax + j)]) * (U[hook(0, i * jmax + j)] + U[hook(0, (i + 1) * jmax + j)]) + gamma * fabs(U[hook(0, i * jmax + j)] + U[hook(0, (i + 1) * jmax + j)]) * (U[hook(0, i * jmax + j)] - U[hook(0, (i + 1) * jmax + j)]) - (U[hook(0, (i - 1) * jmax + j)] + U[hook(0, i * jmax + j)]) * (U[hook(0, (i - 1) * jmax + j)] + U[hook(0, i * jmax + j)]) - gamma * fabs(U[hook(0, (i - 1) * jmax + j)] + U[hook(0, i * jmax + j)]) * (U[hook(0, (i - 1) * jmax + j)] - U[hook(0, i * jmax + j)])) / (4.0 * delx);
      DUVDY = ((V[hook(1, i * jmax + j)] + V[hook(1, (i + 1) * jmax + j)]) * (U[hook(0, i * jmax + j)] + U[hook(0, i * jmax + (j + 1))]) + gamma * fabs(V[hook(1, i * jmax + j)] + V[hook(1, (i + 1) * jmax + j)]) * (U[hook(0, i * jmax + j)] - U[hook(0, i * jmax + (j + 1))]) - (V[hook(1, i * jmax + (j - 1))] + V[hook(1, (i + 1) * jmax + (j - 1))]) * (U[hook(0, i * jmax + (j - 1))] + U[hook(0, i * jmax + j)]) - gamma * fabs(V[hook(1, i * jmax + (j - 1))] + V[hook(1, (i + 1) * jmax + (j - 1))]) * (U[hook(0, i * jmax + (j - 1))] - U[hook(0, i * jmax + j)])) / (4.0 * dely);
      LAPLU = (U[hook(0, (i + 1) * jmax + j)] - 2.0 * U[hook(0, i * jmax + j)] + U[hook(0, (i - 1) * jmax + j)]) / delx / delx + (U[hook(0, i * jmax + (j + 1))] - 2.0 * U[hook(0, i * jmax + j)] + U[hook(0, i * jmax + (j - 1))]) / dely / dely;

      F[hook(3, i * jmax + j)] = U[hook(0, i * jmax + j)] + delt * (LAPLU / Re - DU2DX - DUVDY + GX) - delt * beta * GX * (TEMP[hook(2, i * jmax + j)] + TEMP[hook(2, (i + 1) * jmax + j)]) / 2;
    } else {
      F[hook(3, i * jmax + j)] = U[hook(0, i * jmax + j)];
    }

    if (((FLAG[hook(5, i * jmax + j)] & 0x0010) && (FLAG[hook(5, i * jmax + j)] < 0x1000)) && ((FLAG[hook(5, i * jmax + (j + 1))] & 0x0010) && (FLAG[hook(5, i * jmax + (j + 1))] < 0x1000))) {
      DUVDX = ((U[hook(0, i * jmax + j)] + U[hook(0, i * jmax + (j + 1))]) * (V[hook(1, i * jmax + j)] + V[hook(1, (i + 1) * jmax + j)]) + gamma * fabs(U[hook(0, i * jmax + j)] + U[hook(0, i * jmax + (j + 1))]) * (V[hook(1, i * jmax + j)] - V[hook(1, (i + 1) * jmax + j)]) - (U[hook(0, (i - 1) * jmax + j)] + U[hook(0, (i - 1) * jmax + (j + 1))]) * (V[hook(1, (i - 1) * jmax + j)] + V[hook(1, i * jmax + j)]) - gamma * fabs(U[hook(0, (i - 1) * jmax + j)] + U[hook(0, (i - 1) * jmax + (j + 1))]) * (V[hook(1, (i - 1) * jmax + j)] - V[hook(1, i * jmax + j)])) / (4.0 * delx);
      DV2DY = ((V[hook(1, i * jmax + j)] + V[hook(1, i * jmax + (j + 1))]) * (V[hook(1, i * jmax + j)] + V[hook(1, i * jmax + (j + 1))]) + gamma * fabs(V[hook(1, i * jmax + j)] + V[hook(1, i * jmax + (j + 1))]) * (V[hook(1, i * jmax + j)] - V[hook(1, i * jmax + (j + 1))]) - (V[hook(1, i * jmax + (j - 1))] + V[hook(1, i * jmax + j)]) * (V[hook(1, i * jmax + (j - 1))] + V[hook(1, i * jmax + j)]) - gamma * fabs(V[hook(1, i * jmax + (j - 1))] + V[hook(1, i * jmax + j)]) * (V[hook(1, i * jmax + (j - 1))] - V[hook(1, i * jmax + j)])) / (4.0 * dely);

      LAPLV = (V[hook(1, (i + 1) * jmax + j)] - 2.0 * V[hook(1, i * jmax + j)] + V[hook(1, (i - 1) * jmax + j)]) / delx / delx + (V[hook(1, i * jmax + (j + 1))] - 2.0 * V[hook(1, i * jmax + j)] + V[hook(1, i * jmax + (j - 1))]) / dely / dely;

      G[hook(4, i * jmax + j)] = V[hook(1, i * jmax + j)] + delt * (LAPLV / Re - DUVDX - DV2DY + GY) - delt * beta * GY * (TEMP[hook(2, i * jmax + j)] + TEMP[hook(2, i * jmax + (j + 1))]) / 2;
      ;
    } else {
      G[hook(4, i * jmax + j)] = V[hook(1, i * jmax + j)];
    }

  } else if ((i == 0) && (j > 0 && j < jmax - 1)) {
    F[hook(3, j)] = U[hook(0, j)];

  } else if ((j == 0) && (i > 0 && i < imax - 1)) {
    G[hook(4, i * jmax)] = V[hook(1, i * jmax)];
  }
}
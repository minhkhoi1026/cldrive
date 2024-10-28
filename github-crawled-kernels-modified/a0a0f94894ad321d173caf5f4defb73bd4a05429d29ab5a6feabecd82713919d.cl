//{"P":2,"TEMP":3,"U":0,"V":1,"imax":4,"jmax":5,"wE":7,"wN":8,"wS":9,"wW":6}
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
kernel void SETBCOND_outer_kernel(global float* U, global float* V, global float* P, global float* TEMP, int imax, int jmax, int wW, int wE, int wN, int wS) {
  imax = imax + 2;
  jmax = jmax + 2;

  int i = get_global_id(1);
  int j = get_global_id(0);

  if ((i >= 0 && i <= imax - 1) && (j >= 0 && j <= jmax - 1)) {
    if (wW == 1) {
      U[hook(0, 0 * jmax + j)] = 0.0;
      V[hook(1, 0 * jmax + j)] = V[hook(1, 1 * jmax + j)];
    }
    if (wW == 2) {
      U[hook(0, 0 * jmax + j)] = 0.0;
      V[hook(1, 0 * jmax + j)] = (-1.0) * V[hook(1, 1 * jmax + j)];
    }
    if (wW == 3) {
      U[hook(0, 0 * jmax + j)] = U[hook(0, 1 * jmax + j)];
      V[hook(1, 0 * jmax + j)] = V[hook(1, 1 * jmax + j)];
    }
    if (wW == 4) {
      U[hook(0, 0 * jmax + j)] = U[hook(0, (imax - 2) * jmax + j)];
      V[hook(1, 0 * jmax + j)] = V[hook(1, (imax - 2) * jmax + j)];
      V[hook(1, 1 * jmax + j)] = V[hook(1, (imax - 2) * jmax + j)];
      P[hook(2, 1 * jmax + j)] = P[hook(2, (imax - 2) * jmax + j)];
    }

    TEMP[hook(3, 0 * jmax + j)] = TEMP[hook(3, 1 * jmax + j)];

    if (wE == 1) {
      U[hook(0, (imax - 2) * jmax + j)] = 0.0;
      V[hook(1, (imax - 1) * jmax + j)] = V[hook(1, (imax - 2) * jmax + j)];
    }
    if (wE == 2) {
      U[hook(0, (imax - 2) * jmax + j)] = 0.0;
      V[hook(1, (imax - 1) * jmax + j)] = (-1.0) * V[hook(1, (imax - 2) * jmax + j)];
    }
    if (wE == 3) {
      U[hook(0, (imax - 2) * jmax + j)] = U[hook(0, (imax - 3) * jmax + j)];
      V[hook(1, (imax - 1) * jmax + j)] = V[hook(1, (imax - 2) * jmax + j)];
    }
    if (wE == 4) {
      U[hook(0, (imax - 2) * jmax + j)] = U[hook(0, 1 * jmax + j)];
      V[hook(1, (imax - 1) * jmax + j)] = V[hook(1, 2 * jmax + j)];
    }

    TEMP[hook(3, (imax - 1) * jmax + j)] = TEMP[hook(3, (imax - 2) * jmax + j)];

    if (wN == 1) {
      V[hook(1, i * jmax + (jmax - 2))] = 0.0;
      U[hook(0, i * jmax + (jmax - 1))] = U[hook(0, i * jmax + (jmax - 2))];
    }
    if (wN == 2) {
      V[hook(1, i * jmax + (jmax - 2))] = 0.0;
      U[hook(0, i * jmax + (jmax - 1))] = (-1.0) * U[hook(0, i * jmax + (jmax - 2))];
    }
    if (wN == 3) {
      V[hook(1, i * jmax + (jmax - 2))] = V[hook(1, i * jmax + (jmax - 3))];
      U[hook(0, i * jmax + (jmax - 1))] = U[hook(0, i * jmax + (jmax - 2))];
    }
    if (wN == 4) {
      V[hook(1, i * jmax + (jmax - 2))] = V[hook(1, i * jmax + 1)];
      U[hook(0, i * jmax + (jmax - 1))] = U[hook(0, i * jmax + 2)];
    }

    TEMP[hook(3, i * jmax + 0)] = TEMP[hook(3, i * jmax + 1)];

    if (wS == 1) {
      V[hook(1, i * jmax + 0)] = 0.0;
      U[hook(0, i * jmax + 0)] = U[hook(0, i * jmax + 1)];
    }
    if (wS == 2) {
      V[hook(1, i * jmax + 0)] = 0.0;
      U[hook(0, i * jmax + 0)] = (-1.0) * U[hook(0, i * jmax + 1)];
    }
    if (wS == 3) {
      V[hook(1, i * jmax + 0)] = V[hook(1, i * jmax + 1)];
      U[hook(0, i * jmax + 0)] = U[hook(0, i * jmax + 1)];
    }
    if (wS == 4) {
      V[hook(1, i * jmax + 0)] = V[hook(1, i * jmax + (jmax - 3))];
      U[hook(0, i * jmax + 0)] = U[hook(0, i * jmax + (jmax - 3))];
      U[hook(0, i * jmax + 1)] = U[hook(0, i * jmax + (jmax - 2))];
      P[hook(2, i * jmax + 1)] = P[hook(2, i * jmax + (jmax - 2))];
    }

    TEMP[hook(3, i * jmax + (jmax - 1))] = TEMP[hook(3, i * jmax + (jmax - 2))];
  }
}
//{"FLAG":1,"P":0,"imax":2,"jmax":3}
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
kernel void POISSON_2_copy_boundary_kernel(global float* P, global int* FLAG, int imax, int jmax) {
  imax = imax + 2;
  jmax = jmax + 2;

  int i = get_global_id(1);
  int j = get_global_id(0);

  if ((j == 0) && (i > 0 && i < imax - 1)) {
    P[hook(0, i * jmax)] = P[hook(0, i * jmax + 1)];
    P[hook(0, i * jmax + (jmax - 1))] = P[hook(0, i * jmax + (jmax - 2))];
  } else if ((i == 0) && (j > 0 && j < jmax - 1)) {
    P[hook(0, j)] = P[hook(0, jmax + j)];
    P[hook(0, (imax - 1) * jmax + j)] = P[hook(0, (imax - 2) * jmax + j)];
  }

  else if ((i > 0 && i < imax - 1) && (j > 0 && j < jmax - 1)) {
    if (FLAG[hook(1, i * jmax + j)] >= 0x0001 && FLAG[hook(1, i * jmax + j)] <= 0x000a) {
      switch (FLAG[hook(1, i * jmax + j)]) {
        case 0x0001: {
          P[hook(0, i * jmax + j)] = P[hook(0, i * jmax + j + 1)];
          break;
        }
        case 0x0008: {
          P[hook(0, i * jmax + j)] = P[hook(0, (i + 1) * jmax + j)];
          break;
        }
        case 0x0002: {
          P[hook(0, i * jmax + j)] = P[hook(0, i * jmax + j - 1)];
          break;
        }
        case 0x0004: {
          P[hook(0, i * jmax + j)] = P[hook(0, (i - 1) * jmax + j)];
          break;
        }
        case 0x0009: {
          P[hook(0, i * jmax + j)] = 0.5 * (P[hook(0, i * jmax + j + 1)] + P[hook(0, (i + 1) * jmax + j)]);
          break;
        }
        case 0x000a: {
          P[hook(0, i * jmax + j)] = 0.5 * (P[hook(0, i * jmax + j - 1)] + P[hook(0, (i + 1) * jmax + j)]);
          break;
        }
        case 0x0006: {
          P[hook(0, i * jmax + j)] = 0.5 * (P[hook(0, i * jmax + j - 1)] + P[hook(0, (i - 1) * jmax + j)]);
          break;
        }
        case 0x0005: {
          P[hook(0, i * jmax + j)] = 0.5 * (P[hook(0, i * jmax + j + 1)] + P[hook(0, (i - 1) * jmax + j)]);
          break;
        }
        default:
          break;
      }
    }
  }
}
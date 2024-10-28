//{"FLAG":3,"TEMP":2,"U":0,"V":1,"imax":4,"jmax":5}
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
kernel void SETBCOND_inner_kernel(global float* U, global float* V, global float* TEMP, global int* FLAG, int imax, int jmax) {
  imax = imax + 2;
  jmax = jmax + 2;

  int i = get_global_id(1);
  int j = get_global_id(0);

  if ((i > 0 && i < imax - 1) && (j > 0 && j < jmax - 1)) {
    if (FLAG[hook(3, i * jmax + j)] & 0x000f) {
      switch (FLAG[hook(3, i * jmax + j)]) {
        case 0x0001: {
          V[hook(1, i * jmax + j)] = 0.0;
          U[hook(0, i * jmax + j)] = -U[hook(0, i * jmax + (j + 1))];
          U[hook(0, (i - 1) * jmax + j)] = -U[hook(0, (i - 1) * jmax + (j + 1))];
          TEMP[hook(2, i * jmax + j)] = TEMP[hook(2, i * jmax + (j + 1))];
          break;
        }
        case 0x0008: {
          U[hook(0, i * jmax + j)] = 0.0;
          V[hook(1, i * jmax + j)] = -V[hook(1, (i + 1) * jmax + j)];
          V[hook(1, i * jmax + (j - 1))] = -V[hook(1, (i + 1) * jmax + (j - 1))];
          TEMP[hook(2, i * jmax + j)] = TEMP[hook(2, (i + 1) * jmax + j)];
          break;
        }
        case 0x0002: {
          V[hook(1, i * jmax + (j - 1))] = 0.0;
          U[hook(0, i * jmax + j)] = -U[hook(0, i * jmax + (j - 1))];
          U[hook(0, (i - 1) * jmax + j)] = -U[hook(0, (i - 1) * jmax + (j - 1))];
          TEMP[hook(2, i * jmax + j)] = TEMP[hook(2, i * jmax + (j - 1))];
          break;
        }
        case 0x0004: {
          U[hook(0, (i - 1) * jmax + j)] = 0.0;
          V[hook(1, i * jmax + j)] = -V[hook(1, (i - 1) * jmax + j)];
          V[hook(1, i * jmax + (j - 1))] = -V[hook(1, (i - 1) * jmax + (j - 1))];
          TEMP[hook(2, i * jmax + j)] = TEMP[hook(2, (i - 1) * jmax + j)];
          break;
        }
        case 0x0009: {
          V[hook(1, i * jmax + j)] = 0.0;
          U[hook(0, i * jmax + j)] = 0.0;
          V[hook(1, i * jmax + (j - 1))] = -V[hook(1, (i + 1) * jmax + (j - 1))];
          U[hook(0, (i - 1) * jmax + j)] = -U[hook(0, (i - 1) * jmax + (j + 1))];
          TEMP[hook(2, i * jmax + j)] = 0.5 * (TEMP[hook(2, i * jmax + (j + 1))] + TEMP[hook(2, (i + 1) * jmax + j)]);
          break;
        }
        case 0x000a: {
          V[hook(1, i * jmax + (j - 1))] = 0.0;
          U[hook(0, i * jmax + j)] = 0.0;
          V[hook(1, i * jmax + j)] = -V[hook(1, (i + 1) * jmax + j)];
          U[hook(0, (i - 1) * jmax + j)] = -U[hook(0, (i - 1) * jmax + (j - 1))];
          TEMP[hook(2, i * jmax + j)] = 0.5 * (TEMP[hook(2, i * jmax + (j - 1))] + TEMP[hook(2, (i + 1) * jmax + j)]);
          break;
        }
        case 0x0006: {
          V[hook(1, i * jmax + (j - 1))] = 0.0;
          U[hook(0, (i - 1) * jmax + j)] = 0.0;
          V[hook(1, i * jmax + j)] = -V[hook(1, (i - 1) * jmax + j)];
          U[hook(0, i * jmax + j)] = -U[hook(0, i * jmax + (j - 1))];
          TEMP[hook(2, i * jmax + j)] = 0.5 * (TEMP[hook(2, i * jmax + (j - 1))] + TEMP[hook(2, (i - 1) * jmax + j)]);
          break;
        }
        case 0x0005: {
          V[hook(1, i * jmax + j)] = 0.0;
          U[hook(0, (i - 1) * jmax + j)] = 0.0;
          V[hook(1, i * jmax + (j - 1))] = -V[hook(1, (i - 1) * jmax + (j - 1))];
          U[hook(0, i * jmax + j)] = -U[hook(0, i * jmax + (j + 1))];
          TEMP[hook(2, i * jmax + j)] = 0.5 * (TEMP[hook(2, i * jmax + (j + 1))] + TEMP[hook(2, (i - 1) * jmax + j)]);
          break;
        }
        default:
          break;
      }
    }
  }
}
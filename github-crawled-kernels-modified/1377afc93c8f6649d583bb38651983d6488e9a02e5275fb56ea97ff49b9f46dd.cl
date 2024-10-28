//{"Nx":3,"Ny":4,"Nz":5,"input1":0,"input2":1,"output":2,"pixels1":8,"pixels1[1 + i2]":7,"pixels1[1 + i2][1 + j2]":6,"pixels1[1 + i3]":13,"pixels1[1 + i3][1 + j3]":12,"pixels2":11,"pixels2[(1 + 1) + i2 + i3]":15,"pixels2[(1 + 1) + i2 + i3][(1 + 1) + j2 + j3]":14,"pixels2[(1 + 1) + i2]":10,"pixels2[(1 + 1) + i2][(1 + 1) + j2]":9}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void run(read_only image3d_t input1, read_only image3d_t input2, global short* output, const int Nx, const int Ny, const int Nz) {
  const float SIGMA = 10.f;

  const sampler_t sampler = 0 | 2 | 0x10;

  unsigned int i = get_global_id(0);
  unsigned int j = get_global_id(1);
  unsigned int k = get_global_id(2);

  int pix0 = (int)(read_imageui(input1, sampler, (int4)(i, j, k, 0)).x);

  float res = 0;
  float sum = 0;

  float pixels1[2 * 1 + 1][2 * 1 + 1][2 * 1 + 1];
  float pixels2[2 * (1 + 1) + 1][2 * (1 + 1) + 1][2 * (1 + 1) + 1];

  for (int i2 = -1; i2 <= 1; i2++) {
    for (int j2 = -1; j2 <= 1; j2++) {
      for (int k2 = -1; k2 <= 1; k2++) {
        float p1 = (float)(read_imageui(input1, sampler, (int4)(i + i2, j + j2, k + k2, 0)).x);
        pixels1[hook(8, 1 + i2)][hook(7, 1 + j2)][hook(6, 1 + k2)] = p1;
      }
    }
  }

  for (int i2 = -(1 + 1); i2 <= (1 + 1); i2++) {
    for (int j2 = -(1 + 1); j2 <= (1 + 1); j2++) {
      for (int k2 = -(1 + 1); k2 <= (1 + 1); k2++) {
        float p1 = (float)(read_imageui(input2, sampler, (int4)(i + i2, j + j2, k + k2, 0)).x);
        pixels2[hook(11, (1 + 1) + i2)][hook(10, (1 + 1) + j2)][hook(9, (1 + 1) + k2)] = p1;
      }
    }
  }

  for (int i2 = -1; i2 <= 1; i2++) {
    for (int j2 = -1; j2 <= 1; j2++) {
      for (int k2 = -1; k2 <= 1; k2++) {
        float dist = 0.f;

        for (int i3 = -1; i3 <= 1; i3++) {
          for (int j3 = -1; j3 <= 1; j3++) {
            for (int k3 = -1; k3 <= 1; k3++) {
              float p1 = pixels1[hook(8, 1 + i3)][hook(13, 1 + j3)][hook(12, 1 + k3)];
              float p2 = pixels2[hook(11, (1 + 1) + i2 + i3)][hook(15, (1 + 1) + j2 + j3)][hook(14, (1 + 1) + k2 + k3)];
              dist += .1f * (p1 - p2) * (p1 - p2);
            }
          }
        }

        int pix1 = read_imageui(input2, sampler, (int4)(i + i2, j + j2, k + k2, 0)).x;

        float weight = exp(-1.f / SIGMA / SIGMA * dist);

        res += pix1 * weight;
        sum += weight;
      }
    }
  }

  output[hook(2, i + j * Nx + k * Nx * Ny)] = (short)(res / sum);
}
//{"filter":2,"input":1,"output":0,"sh_input":4,"sh_input[i]":3,"sh_input[ty + yi * 1024 + i]":7,"sum":6,"sum[yi]":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void convolution_kernel(global float* output, global float* input, global float* filter) {
  int ty = get_local_id(1);
  int tx = get_local_id(0);
  int by = get_group_id(1) * 1024 * 1;
  int bx = get_group_id(0) * 2048 * 1;

  local float sh_input[1024 * 1 + ((17 / 2) * 2)][(2048 * 1 + ((17 / 2) * 2))];

  for (int i = ty; i < min(1024 * 1 + ((17 / 2) * 2), (4096 + ((17 / 2) * 2))); i += 1024) {
    for (int j = tx; j < min(2048 * 1 + ((17 / 2) * 2), (4096 + ((17 / 2) * 2))); j += 2048) {
      sh_input[hook(4, i)][hook(3, j)] = input[hook(1, (by + i) * (4096 + ((17 / 2) * 2)) + (bx + j))];
    }
  }
  barrier(0x01);

  float sum[1][1];
  for (int yi = 0; yi < 1; yi++) {
    for (int xi = 0; xi < 1; xi++) {
      sum[hook(6, yi)][hook(5, xi)] = 0.0f;
    }
  }

  for (int i = 0; i < 17; i++) {
    for (int j = 0; j < 17; j++) {
      for (int yi = 0; yi < 1; yi++) {
        for (int xi = 0; xi < 1; xi++) {
          sum[hook(6, yi)][hook(5, xi)] += sh_input[hook(4, ty + yi * 1024 + i)][hook(7, tx + xi * 2048 + j)] * filter[hook(2, i * 17 + j)];
        }
      }
    }
  }

  for (int yi = 0; yi < 1; yi++) {
    for (int xi = 0; xi < 1; xi++) {
      output[hook(0, (by + ty + yi * 1024) * 4096 + bx + tx + xi * 2048)] = sum[hook(6, yi)][hook(5, xi)];
    }
  }
}
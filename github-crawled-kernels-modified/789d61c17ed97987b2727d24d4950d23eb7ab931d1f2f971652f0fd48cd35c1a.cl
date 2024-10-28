//{"cols":3,"data":0,"gaus":1,"l_data":5,"out":4,"rows":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void gaussian(global unsigned char* data, global float* gaus, int rows, int cols, global unsigned char* out) {
  int sum = 0;
  local int l_data[(16 + 2) * (16 + 2)];
  int g_row = get_global_id(0);
  int g_col = get_global_id(1);
  int l_row = get_local_id(0) + 1;
  int l_col = get_local_id(1) + 1;

  int pos = g_row * cols + g_col;

  for (int r = get_local_id(0); r < get_local_size(0) + 2; r += get_local_size(0)) {
    for (int c = get_local_id(1); c < get_local_size(1) + 2; c += get_local_size(1)) {
      l_data[hook(5, r * (16 + 2) + c)] = data[hook(0, (g_row - 1) * cols + g_col - 1)];
    }
  }

  barrier(0x01);

  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      sum += gaus[hook(1, i * 3 + j)] * l_data[hook(5, (i + l_row - 1) * (16 + 2) + j + l_col - 1)];
    }
  }

  out[hook(4, pos)] = min(255, max(0, sum));
}
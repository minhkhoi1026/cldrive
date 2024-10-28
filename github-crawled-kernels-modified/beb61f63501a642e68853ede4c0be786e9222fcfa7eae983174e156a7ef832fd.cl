//{"dst":1,"height":5,"src":0,"structure":2,"structure_size":3,"width":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void erode(global const float* src, global float* dst, constant unsigned int* structure, int structure_size, int width, int height) {
  int g_idx = get_global_id(0);
  if (g_idx < width * height) {
    float val_r = src[hook(0, g_idx * 3)];
    float val_g = src[hook(0, g_idx * 3 + 1)];
    float val_b = src[hook(0, g_idx * 3 + 2)];
    int row = g_idx / width;
    int column = g_idx % width;
    for (int i = -(structure_size - 1) / 2; i <= (structure_size - 1) / 2; i++) {
      for (int j = -(structure_size - 1) / 2; j <= (structure_size - 1) / 2; j++) {
        int s_idx = (i + 3) * structure_size + j + 3;
        if (structure[hook(2, s_idx)] == 0) {
          continue;
        }
        int row_el = clamp(row + i, 0, height - 1);
        int column_el = clamp(column + j, 0, width - 1);
        int el_idx = row_el * width + column_el;
        val_r = max(val_r, src[hook(0, el_idx * 3)]);
        val_g = max(val_g, src[hook(0, el_idx * 3 + 1)]);
        val_b = max(val_b, src[hook(0, el_idx * 3 + 2)]);
      }
    }
    dst[hook(1, g_idx * 3)] = val_r;
    dst[hook(1, g_idx * 3 + 1)] = val_g;
    dst[hook(1, g_idx * 3 + 2)] = val_b;
  }
}
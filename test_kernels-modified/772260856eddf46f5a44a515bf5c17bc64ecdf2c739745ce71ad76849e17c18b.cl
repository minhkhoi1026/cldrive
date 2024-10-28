//{"col":2,"row_offset":1,"size":0,"val":3,"x":4,"y":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float ReadVecFromImg(int ind, read_only image2d_t img, const sampler_t smp) {
  if (ind < 0)
    return 0;

  int imgPos = ind;
  int2 coords;
  coords.x = imgPos & 0x1fff;
  coords.y = imgPos >> 13;

  float4 temp = read_imagef(img, smp, coords);
  return temp.x;
}

kernel void s_kernel_test(const int size, global const int* row_offset, global const int* col, global const float* val, read_only image2d_t x, global float* y) {
  const sampler_t smp = 0 | 4 | 0x10;

  int idx = get_global_id(0);

  if (idx >= size)
    return;

  float suma = 0.0;

  for (int k = row_offset[hook(1, idx)]; k < row_offset[hook(1, idx + 1)]; k++) {
    suma += val[hook(3, k)] * ReadVecFromImg(col[hook(2, k)], x, smp);
  }

  y[hook(5, idx)] = suma;
}
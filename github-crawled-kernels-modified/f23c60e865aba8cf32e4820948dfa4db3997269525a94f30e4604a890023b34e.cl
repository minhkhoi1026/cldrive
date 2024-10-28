//{"col":2,"num_rows":0,"row_offset":1,"val":3,"x":4,"y":5}
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

kernel void s_kernel_csr_spmv_scalar(const int num_rows, global const int* row_offset, global const int* col, global const float* val, global const float* x, global float* y) {
  int idx = get_global_id(0);

  if (idx >= num_rows)
    return;

  float suma = 0.0;

  for (int k = row_offset[hook(1, idx)]; k < row_offset[hook(1, idx + 1)]; k++)
    suma += val[hook(3, k)] * x[hook(4, col[khook(2, k))];

  y[hook(5, idx)] = suma;
}
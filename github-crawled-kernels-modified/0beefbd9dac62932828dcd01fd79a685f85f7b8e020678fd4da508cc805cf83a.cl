//{"coeff":3,"dest":4,"height":1,"src":2,"width":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void conv_reference(const int width, const int height, const global float* src, constant float* coeff, global float* dest) {
  const int tid_x = get_global_id(0);
  const int tid_y = get_global_id(1);
  const int tid_z = get_global_id(2);

  float acc = 0.0f;

  for (int fx = -1; fx <= 1; ++fx) {
    const int index_x = tid_x + 1 + fx;
    for (int fy = -1; fy <= 1; ++fy) {
      const int index_y = tid_y + 1 + fy;
      for (int fz = -1; fz <= 1; ++fz) {
        const int index_z = tid_z + 1 + fz;

        float coefficient = coeff[hook(3, (fz + 1) * (1 + 1 + 1) * (1 + 1 + 1) + (fy + 1) * (1 + 1 + 1) + (fx + 1))];
        acc += coefficient * src[hook(2, index_z * (height + 2 * 1) * (width + 2 * 1) + index_y * (width + 2 * 1) + index_x)];
      }
    }
  }

  dest[hook(4, tid_z * height * width + tid_y * width + tid_x)] = acc;
}
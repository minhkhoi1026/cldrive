//{"coeff":3,"dest":4,"size_x":0,"size_y":1,"src":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void conv_reference(const int size_x, const int size_y, const global float* src, constant float* coeff, global float* dest) {
  const int tid_x = get_global_id(0);
  const int tid_y = get_global_id(1);

  float acc = 0.0f;

  for (int fx = -(3); fx <= (3); ++fx) {
    for (int fy = -(3); fy <= (3); ++fy) {
      const int index_x = tid_x + (3) + fx;
      const int index_y = tid_y + (3) + fy;

      float coefficient = coeff[hook(3, (fy + (3)) * ((3) + (3) + 1) + (fx + (3)))];
      acc += coefficient * src[hook(2, index_y * (size_x + 2 * (3)) + index_x)];
    }
  }

  dest[hook(4, tid_y * size_x + tid_x)] = acc;
}
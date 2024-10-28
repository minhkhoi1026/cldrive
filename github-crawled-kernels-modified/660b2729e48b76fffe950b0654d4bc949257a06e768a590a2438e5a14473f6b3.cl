//{"M":1,"X":0,"Y":2,"input_height":4,"input_width":3,"maps":5,"output_height":7,"output_width":6,"region_height":9,"region_width":8,"stride_height":11,"stride_width":10}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void AMAXIMUM_POOLING_FWD(global float* X, global unsigned int* M, global float* Y, unsigned int input_width, unsigned int input_height, unsigned int maps, unsigned int output_width, unsigned int output_height, unsigned int region_width, unsigned int region_height, unsigned int stride_width, unsigned int stride_height) {
  const unsigned int output_x = get_global_id(0);
  const unsigned int output_y = get_global_id(1);
  const unsigned int skid = get_global_id(2);

  const unsigned int input_x = output_x * stride_width;
  const unsigned int input_y = output_y * stride_height;

  const unsigned int M_idx_sk = input_width * input_height * skid;

  float maximum = -0x1.fffffep127f;
  unsigned int max_x = 0;
  unsigned int max_y = 0;
  for (unsigned int y = 0; y < region_height; y++) {
    const unsigned int M_idx_line = M_idx_sk + (input_width * (input_y + y));
    for (unsigned int x = 0; x < region_width; x++) {
      const unsigned int M_idx = M_idx_line + input_x + x;
      const float X_val = X[hook(0, M_idx)];
      if (X_val > maximum) {
        max_x = x;
        max_y = y;
        maximum = X_val;
      }
    }
  }

  const unsigned int Y_idx_sk = output_width * output_height * skid;
  const unsigned int Y_idx_line = Y_idx_sk + (output_width * output_y);
  Y[hook(2, Y_idx_line + output_x)] = maximum;

  M[hook(1, Y_idx_line + output_x)] = (input_y + max_y) * input_width + (input_x + max_x);
}
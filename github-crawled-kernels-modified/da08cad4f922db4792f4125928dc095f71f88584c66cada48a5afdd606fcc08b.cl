//{"M":1,"X":0,"Y":2,"input_height":4,"input_width":3,"maps":5,"output_height":7,"output_width":6,"region_height":9,"region_width":8,"stride_height":11,"stride_width":10}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void AMAXIMUM_POOLING_BWD(global float* X, global unsigned int* M, global float* Y, unsigned int input_width, unsigned int input_height, unsigned int maps, unsigned int output_width, unsigned int output_height, unsigned int region_width, unsigned int region_height, unsigned int stride_width, unsigned int stride_height) {
  const unsigned int input_x = get_global_id(0);
  const unsigned int input_y = get_global_id(1);
  const unsigned int skid = get_global_id(2);
  const unsigned int mask_index = input_y * input_width + input_x;

  const unsigned int Y_idx_sk = output_width * output_height * skid;

  const unsigned int oxstart = (input_x < region_width) ? 0 : (input_x - region_width) / stride_width + 1;
  const unsigned int oxend = min(input_x / stride_width + 1, output_width);

  const unsigned int oystart = (input_y < region_height) ? 0 : (input_y - region_height) / stride_height + 1;
  const unsigned int oyend = min(input_y / stride_height + 1, output_height);

  float sum = 0.0;
  unsigned int runs = 0;
  for (unsigned int output_y = oystart; output_y < oyend; output_y++) {
    const unsigned int Y_idx_line = Y_idx_sk + (output_width * output_y);
    for (unsigned int output_x = oxstart; output_x < oxend; output_x++) {
      runs++;
      const unsigned int Y_idx = Y_idx_line + output_x;

      if (M[hook(1, Y_idx)] == mask_index)
        sum += Y[hook(2, Y_idx)];
    }
  }

  const unsigned int M_idx_sk = input_width * input_height * skid;
  const unsigned int M_idx_line = M_idx_sk + (input_width * input_y);
  const unsigned int M_idx = M_idx_line + input_x;

  X[hook(0, M_idx)] = sum;
}
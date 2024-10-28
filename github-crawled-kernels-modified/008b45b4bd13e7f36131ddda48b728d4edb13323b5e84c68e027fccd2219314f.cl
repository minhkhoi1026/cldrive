//{"dH":9,"dW":10,"input_data":0,"input_h":5,"input_n":4,"input_offset":1,"input_w":6,"kH":7,"kW":8,"output_data":2,"output_offset":3,"ptr_input":11}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void subsample(const global float* input_data, int input_offset, global float* output_data, int output_offset, int input_n, int input_h, int input_w, int kH, int kW, int dH, int dW) {
  global const float* input = input_data + input_offset;
  global float* output = output_data + output_offset;

  int xx, yy;

  int output_w = (input_w - kW) / dW + 1;
  int output_h = (input_h - kH) / dH + 1;

  int o = get_group_id(0);
  int i = o;

  int xx_start = get_local_id(0);
  int xx_end = output_w;
  int xx_step = get_local_size(0);

  int yy_start = get_local_size(1) * get_group_id(1) + get_local_id(1);
  int yy_end = output_h;
  int yy_step = get_local_size(1) * get_num_groups(1);

  output = output + o * output_w * output_h;
  input = input + i * input_w * input_h;

  for (yy = yy_start; yy < yy_end; yy += yy_step) {
    for (xx = xx_start; xx < xx_end; xx += xx_step) {
      const global float* ptr_input = input + yy * dH * input_w + xx * dW;
      global float* ptr_output = output + yy * output_w + xx;
      float sum = 0;
      int kx, ky;
      for (ky = 0; ky < kH; ky++) {
        for (kx = 0; kx < kW; kx++)
          sum += ptr_input[hook(11, kx)];
        ptr_input += input_w;
      }

      *ptr_output = sum / (float)(kW * kH);
    }
  }
}
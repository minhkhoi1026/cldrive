//{"dH":13,"dW":14,"indices_data":4,"indices_offset":5,"indices_x_offset":6,"indices_y_offset":7,"input_data":0,"input_h":9,"input_n":8,"input_offset":1,"input_w":10,"kH":11,"kW":12,"output_data":2,"output_offset":3,"ptr_input":15}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void maxpool(const global float* input_data, int input_offset, global float* output_data, int output_offset, global float* indices_data, int indices_offset, int indices_x_offset, int indices_y_offset, int input_n, int input_h, int input_w, int kH, int kW, int dH, int dW) {
  global const float* input = input_data + input_offset;
  global float* output = output_data + output_offset;
  global float* indices_x = indices_data + indices_offset + indices_x_offset;
  global float* indices_y = indices_data + indices_offset + indices_y_offset;

  int xx, yy;

  const int output_w = floor((float)(input_w - kW) / dW + 1);
  const int output_h = floor((float)(input_h - kH) / dH + 1);

  int o = get_group_id(0);
  int i = o;

  int xx_start = get_local_id(0);
  int xx_end = output_w;
  const int xx_step = get_local_size(0);

  int yy_start = get_local_size(1) * get_group_id(1) + get_local_id(1);
  int yy_end = output_h;
  const int yy_step = get_local_size(1) * get_num_groups(1);

  output = output + o * output_w * output_h;
  input = input + i * input_w * input_h;
  indices_x = indices_x + o * output_w * output_h;
  indices_y = indices_y + o * output_w * output_h;

  for (yy = yy_start; yy < yy_end; yy += yy_step) {
    for (xx = xx_start; xx < xx_end; xx += xx_step) {
      global const float* ptr_input = input + yy * dH * input_w + xx * dW;
      global float* ptr_output = output + yy * output_w + xx;
      global float* ptr_ind_x = indices_x + yy * output_w + xx;
      global float* ptr_ind_y = indices_y + yy * output_w + xx;
      int argmax_x = -1;
      int argmax_y = -1;
      float max = -0x1.fffffep127f;
      int kx, ky;
      for (ky = 0; ky < kH; ky++) {
        for (kx = 0; kx < kW; kx++) {
          float val = ptr_input[hook(15, kx)];
          if (val > max) {
            max = val;
            argmax_x = kx;
            argmax_y = ky;
          }
        }
        ptr_input += input_w;
      }

      *ptr_output = max;
      *ptr_ind_x = argmax_x + 1;
      *ptr_ind_y = argmax_y + 1;
    }
  }
}
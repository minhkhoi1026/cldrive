//{"dH":13,"dW":14,"gradInput_data":0,"gradInput_offset":1,"gradOutput_data":2,"gradOutput_offset":3,"indices_data":4,"indices_offset":5,"indices_x_offset":6,"indices_y_offset":7,"input_h":9,"input_n":8,"input_w":10,"kH":11,"kW":12,"ptr_gradInput":17,"staggerCombo":16,"staggerRatio":15}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void maxgradinput_staggered(global float* gradInput_data, int gradInput_offset, global const float* gradOutput_data, int gradOutput_offset, global const float* indices_data, int indices_offset, int indices_x_offset, int indices_y_offset, int input_n, int input_h, int input_w, int kH, int kW, int dH, int dW, int staggerRatio, int staggerCombo) {
  global float* gradInput = gradInput_data + gradInput_offset;
  global const float* gradOutput = gradOutput_data + gradOutput_offset;
  global const float* indices_x = indices_data + indices_offset + indices_x_offset;
  global const float* indices_y = indices_data + indices_offset + indices_y_offset;

  int xx, yy;

  const int output_w = floor((float)(input_w - kW) / dW + 1);
  const int output_h = floor((float)(input_h - kH) / dH + 1);

  int o = get_group_id(0);
  int i = o;

  int xx_start = get_local_id(0) * staggerRatio + (staggerCombo & 1);
  int xx_end = output_w;
  int xx_step = get_local_size(0) * staggerRatio;

  int yy_start = (get_local_size(1) * get_group_id(1) + get_local_id(1)) * staggerRatio + (staggerCombo >> 1);
  int yy_end = output_h;
  int yy_step = get_local_size(1) * get_num_groups(1) * staggerRatio;

  gradOutput = gradOutput + o * output_w * output_h;
  gradInput = gradInput + i * input_w * input_h;
  indices_x = indices_x + o * output_w * output_h;
  indices_y = indices_y + o * output_w * output_h;

  for (yy = yy_start; yy < yy_end; yy += yy_step) {
    for (xx = xx_start; xx < xx_end; xx += xx_step) {
      global float* ptr_gradInput = gradInput + yy * dH * input_w + xx * dW;
      global const float* ptr_gradOutput = gradOutput + yy * output_w + xx;
      global const float* ptr_ind_x = indices_x + yy * output_w + xx;
      global const float* ptr_ind_y = indices_y + yy * output_w + xx;
      float z = *ptr_gradOutput;

      int argmax_x = (*ptr_ind_x) - 1;
      int argmax_y = (*ptr_ind_y) - 1;

      ptr_gradInput[hook(17, argmax_x + argmax_y * input_w)] += z;
    }
  }
}
//{"dH":9,"dW":10,"gradInput_data":0,"gradInput_offset":1,"gradOutput_data":2,"gradOutput_offset":3,"input_h":5,"input_n":4,"input_w":6,"kH":7,"kW":8,"ptr_gradInput":11}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void subgradinput(global float* gradInput_data, int gradInput_offset, const global float* gradOutput_data, int gradOutput_offset, int input_n, int input_h, int input_w, int kH, int kW, int dH, int dW) {
  global float* gradInput = gradInput_data + gradInput_offset;
  const global float* gradOutput = gradOutput_data + gradOutput_offset;

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

  gradOutput = gradOutput + o * output_w * output_h;
  gradInput = gradInput + i * input_w * input_h;

  for (yy = yy_start; yy < yy_end; yy += yy_step) {
    for (xx = xx_start; xx < xx_end; xx += xx_step) {
      global float* ptr_gradInput = gradInput + yy * dH * input_w + xx * dW;
      const global float* ptr_gradOutput = gradOutput + yy * output_w + xx;
      float z = *ptr_gradOutput;
      int kx, ky;
      for (ky = 0; ky < kH; ky++) {
        for (kx = 0; kx < kW; kx++)
          ptr_gradInput[hook(11, kx)] += z / (float)(kW * kH);
        ptr_gradInput += input_w;
      }
    }
  }
}
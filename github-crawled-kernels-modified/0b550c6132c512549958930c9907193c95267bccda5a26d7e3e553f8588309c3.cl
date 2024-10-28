//{"cols":2,"filter":4,"filter_width":5,"img_in":0,"pipe_out":3,"rows":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 0 | 0x10 | 2;
kernel void producer(image2d_t read_only img_in, int rows, int cols, global float* pipe_out, constant float* filter, int filter_width) {
  int col = get_global_id(0);
  int row = get_global_id(1);

  int half_width = (int)(filter_width / 2);

  float sum = 0.0f;

  int filter_idx = 0;

  int2 coords;

  for (int i = -half_width; i <= half_width; i++) {
    coords.y = row + i;

    for (int j = -half_width; j <= half_width; j++) {
      coords.x = col + j;

      float4 pixel = read_imagef(img_in, sampler, coords);
      sum += pixel.x * filter[hook(4, filter_idx++)];
    }
  }

  int gid = row * cols + col;
  pipe_out[hook(3, gid)] = sum;
}
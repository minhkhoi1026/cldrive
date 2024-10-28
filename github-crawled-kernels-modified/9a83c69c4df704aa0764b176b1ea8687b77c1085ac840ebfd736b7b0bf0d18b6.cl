//{"bias_buffer":1,"dY":0,"output_height":3,"output_maps":4,"output_width":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void BIAS_GRADIENT_PART1(global float* dY, global float* bias_buffer, unsigned int output_width, unsigned int output_height, unsigned int output_maps) {
  const unsigned int output_map = get_global_id(0);
  const unsigned int sample = get_global_id(1);

  const unsigned int dY_idx_sample = output_width * output_height * output_maps * sample;
  const unsigned int dY_idx_omap = dY_idx_sample + output_width * output_height * output_map;

  float sum = 0;

  for (unsigned int y = 0; y < output_height; y++) {
    const unsigned int dY_idx_line = dY_idx_omap + output_width * y;
    if (output_width > 3) {
      const unsigned int vector_fetch_end = (output_width - 4) & ~(0x3);
      for (unsigned int x = 0; (x << 2) <= vector_fetch_end; x++) {
        const float4 dY_val = vload4(x, dY + dY_idx_line);
        sum += dot(dY_val, 1.0);
      }
      for (unsigned int x = vector_fetch_end + 4; x < output_width; x++) {
        const float dY_val = dY[hook(0, dY_idx_line + x)];
        sum += dY_val;
      }
    } else {
      for (unsigned int x = 0; x < output_width; x++) {
        const float dY_val = dY[hook(0, dY_idx_line + x)];
        sum += dY_val;
      }
    }
  }

  bias_buffer[hook(1, sample * output_maps + output_map)] = sum;
}
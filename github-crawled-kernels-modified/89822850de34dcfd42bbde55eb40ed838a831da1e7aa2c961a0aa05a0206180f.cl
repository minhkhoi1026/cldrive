//{"amount":8,"gaussian_kernel":6,"in":0,"in_offset":2,"kernel_length":5,"kernel_offset":4,"out":1,"out_offset":3,"sigma_sq2":7,"threshold":9}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t sampler = 0 | 4 | 0x10;
kernel void unsharp(read_only image2d_t in, write_only image2d_t out, int2 in_offset, int2 out_offset, int kernel_offset, int kernel_length, local float* gaussian_kernel, float sigma_sq2, float amount, float threshold) {
  if (get_local_id(0) * get_local_id(1) == 0) {
    for (int y = 0; y < kernel_length; ++y) {
      for (int x = 0; x < kernel_length; ++x) {
        const float fx = kernel_offset + x;
        const float fy = kernel_offset + y;
        const float z = half_sqrt(fx * fx + fy * fy);
        gaussian_kernel[hook(6, y * kernel_length + x)] = native_exp(-(z * z) / sigma_sq2);
      }
    }
  }

  mem_fence(0x01);

  const int2 pos = (int2)(get_global_id(0), get_global_id(1));
  float blur = 0.0f;
  float w_sum = 0.0f;
  for (int y = 0; y < kernel_length; ++y) {
    for (int x = 0; x < kernel_length; ++x) {
      const float4 px = read_imagef(in, sampler, pos + in_offset + (int2)(x + kernel_offset, y + kernel_offset));
      const float w = gaussian_kernel[hook(6, kernel_length * y + x)] * ((px.w > 0.5f) ? 1.0f : 0.0f);
      w_sum += w;
      blur += px.x * w;
    }
  }
  float4 px = read_imagef(in, sampler, pos + in_offset);
  if (w_sum > 0.0f) {
    float hf = px.x - half_divide(blur, w_sum);
    const float hf_abs = fabs(hf);
    hf *= (hf_abs < threshold) ? (amount * half_divide(hf_abs, threshold)) : amount;
    px.x = clamp(px.x + hf, px.x * 0.5f, fma(px.x, 0.5f, 0.5f));
  }
  write_imagef(out, pos + out_offset, px);
}
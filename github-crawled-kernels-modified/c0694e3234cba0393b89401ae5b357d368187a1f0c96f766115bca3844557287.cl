//{"input":0,"matrix":3,"output":1,"p_in":5,"p_out":6,"table":4,"vertical_offset":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
unsigned int get_sector_id(float u, float v) {
  u = fabs(u) > 0.00001f ? u : 0.00001f;
  float tg = v / u;
  unsigned int se = tg > 1 ? (tg > 2 ? 3 : 2) : (tg > 0.5 ? 1 : 0);
  unsigned int so = tg > -1 ? (tg > -0.5 ? 3 : 2) : (tg > -2 ? 1 : 0);
  return tg > 0 ? (u > 0 ? se : (se + 8)) : (u > 0 ? (so + 12) : (so + 4));
}

__inline void cl_csc_rgbatonv12(float4* in, float* out, global float* matrix) {
  (*out) = matrix[hook(3, 0)] * (*in).x + matrix[hook(3, 1)] * (*in).y + matrix[hook(3, 2)] * (*in).z;
  (*(out + 1)) = matrix[hook(3, 0)] * (*(in + 1)).x + matrix[hook(3, 1)] * (*(in + 1)).y + matrix[hook(3, 2)] * (*(in + 1)).z;
  (*(out + 2)) = matrix[hook(3, 0)] * (*(in + 2)).x + matrix[hook(3, 1)] * (*(in + 2)).y + matrix[hook(3, 2)] * (*(in + 2)).z;
  (*(out + 3)) = matrix[hook(3, 0)] * (*(in + 3)).x + matrix[hook(3, 1)] * (*(in + 3)).y + matrix[hook(3, 2)] * (*(in + 3)).z;
  (*(out + 4)) = matrix[hook(3, 3)] * (*in).x + matrix[hook(3, 4)] * (*in).y + matrix[hook(3, 5)] * (*in).z;
  (*(out + 5)) = matrix[hook(3, 6)] * (*in).x + matrix[hook(3, 7)] * (*in).y + matrix[hook(3, 8)] * (*in).z;
}

__inline void cl_macc(float* in, global float* table) {
  unsigned int table_id;
  float ui, vi, uo, vo;
  ui = (*in);
  vi = (*(in + 1));
  table_id = get_sector_id(ui, vi);

  uo = ui * table[hook(4, 4 * table_id)] + vi * table[hook(4, 4 * table_id + 1)];
  vo = ui * table[hook(4, 4 * table_id + 2)] + vi * table[hook(4, 4 * table_id + 3)];

  (*in) = uo + 0.5;
  (*(in + 1)) = vo + 0.5;
}

kernel void kernel_yuv_pipe(read_only image2d_t input, write_only image2d_t output, unsigned int vertical_offset, global float* matrix, global float* table) {
  int x = get_global_id(0);
  int y = get_global_id(1);
  sampler_t sampler = 0 | 0 | 0x10;

  float4 p_in[4];
  float p_out[6];

  p_in[hook(5, 0)] = read_imagef(input, sampler, (int2)(2 * x, 2 * y));
  p_in[hook(5, 1)] = read_imagef(input, sampler, (int2)(2 * x + 1, 2 * y));
  p_in[hook(5, 2)] = read_imagef(input, sampler, (int2)(2 * x, 2 * y + 1));
  p_in[hook(5, 3)] = read_imagef(input, sampler, (int2)(2 * x + 1, 2 * y + 1));

  cl_csc_rgbatonv12(&p_in[hook(5, 0)], &p_out[hook(6, 0)], matrix);
  cl_macc(&p_out[hook(6, 4)], table);

  write_imagef(output, (int2)(2 * x, 2 * y), (float4)p_out[hook(6, 0)]);
  write_imagef(output, (int2)(2 * x + 1, 2 * y), (float4)p_out[hook(6, 1)]);
  write_imagef(output, (int2)(2 * x, 2 * y + 1), (float4)p_out[hook(6, 2)]);
  write_imagef(output, (int2)(2 * x + 1, 2 * y + 1), (float4)p_out[hook(6, 3)]);
  write_imagef(output, (int2)(2 * x, y + vertical_offset), (float4)p_out[hook(6, 4)]);
  write_imagef(output, (int2)(2 * x + 1, y + vertical_offset), (float4)p_out[hook(6, 5)]);
}
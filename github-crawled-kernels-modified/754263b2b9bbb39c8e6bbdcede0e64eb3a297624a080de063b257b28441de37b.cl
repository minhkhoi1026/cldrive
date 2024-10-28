//{"B":15,"G":14,"R":13,"coeff_U":23,"coeff_V":24,"coeff_Y":20,"diff_U":21,"diff_V":22,"diff_Y":19,"in":17,"inB":27,"inG":26,"inR":25,"in_prev":18,"inputFrame0":11,"inputFramePre":2,"inputFramePreUV":3,"matrix":5,"out":12,"output":0,"output_uv":1,"plannar_offset":4,"table":6,"table_id":16,"thr_uv":9,"thr_y":8,"tnr_yuv_enable":10,"yuv_gain":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
unsigned int get_sector_id(float u, float v) {
  u = fabs(u) > 0.00001f ? u : 0.00001f;
  float tg = v / u;
  unsigned int se = tg > 1.f ? (tg > 2.f ? 3 : 2) : (tg > 0.5f ? 1 : 0);
  unsigned int so = tg > -1.f ? (tg > -0.5f ? 3 : 2) : (tg > -2.f ? 1 : 0);
  return tg > 0 ? (u > 0 ? se : (se + 8)) : (u > 0 ? (so + 12) : (so + 4));
}

__inline void cl_csc_rgbatonv12(float8* R, float8* G, float8* B, float8* out, global float* matrix) {
  out[hook(12, 0)] = mad(matrix[hook(5, 0)], R[hook(13, 0)], mad(matrix[hook(5, 1)], G[hook(14, 0)], matrix[hook(5, 2)] * B[hook(15, 0)]));
  out[hook(12, 1)] = mad(matrix[hook(5, 0)], R[hook(13, 1)], mad(matrix[hook(5, 1)], G[hook(14, 1)], matrix[hook(5, 2)] * B[hook(15, 1)]));

  out[hook(12, 2)].s0 = mad(matrix[hook(5, 3)], R[hook(13, 0)].s0, mad(matrix[hook(5, 4)], G[hook(14, 0)].s0, matrix[hook(5, 5)] * B[hook(15, 0)].s0));
  out[hook(12, 2)].s1 = mad(matrix[hook(5, 6)], R[hook(13, 0)].s0, mad(matrix[hook(5, 7)], G[hook(14, 0)].s0, matrix[hook(5, 8)] * B[hook(15, 0)].s0));
  out[hook(12, 2)].s2 = mad(matrix[hook(5, 3)], R[hook(13, 0)].s2, mad(matrix[hook(5, 4)], G[hook(14, 0)].s2, matrix[hook(5, 5)] * B[hook(15, 0)].s2));
  out[hook(12, 2)].s3 = mad(matrix[hook(5, 6)], R[hook(13, 0)].s2, mad(matrix[hook(5, 7)], G[hook(14, 0)].s2, matrix[hook(5, 8)] * B[hook(15, 0)].s2));
  out[hook(12, 2)].s4 = mad(matrix[hook(5, 3)], R[hook(13, 0)].s4, mad(matrix[hook(5, 4)], G[hook(14, 0)].s4, matrix[hook(5, 5)] * B[hook(15, 0)].s4));
  out[hook(12, 2)].s5 = mad(matrix[hook(5, 6)], R[hook(13, 0)].s4, mad(matrix[hook(5, 7)], G[hook(14, 0)].s4, matrix[hook(5, 8)] * B[hook(15, 0)].s4));
  out[hook(12, 2)].s6 = mad(matrix[hook(5, 3)], R[hook(13, 0)].s6, mad(matrix[hook(5, 4)], G[hook(14, 0)].s6, matrix[hook(5, 5)] * B[hook(15, 0)].s6));
  out[hook(12, 2)].s7 = mad(matrix[hook(5, 6)], R[hook(13, 0)].s6, mad(matrix[hook(5, 7)], G[hook(14, 0)].s6, matrix[hook(5, 8)] * B[hook(15, 0)].s6));
}

__inline void cl_macc(float8* in, global float* table) {
  unsigned int table_id[4];
  float8 out;

  table_id[hook(16, 0)] = get_sector_id(in[hook(17, 0)].s0, in[hook(17, 0)].s1);
  table_id[hook(16, 1)] = get_sector_id(in[hook(17, 0)].s2, in[hook(17, 0)].s3);
  table_id[hook(16, 2)] = get_sector_id(in[hook(17, 0)].s4, in[hook(17, 0)].s5);
  table_id[hook(16, 3)] = get_sector_id(in[hook(17, 0)].s6, in[hook(17, 0)].s7);

  out.s0 = mad(in[hook(17, 0)].s0, table[hook(6, 4 * table_id[0hook(16, 0))], in[hook(17, 0)].s1 * table[hook(6, 4 * table_id[0hook(16, 0) + 1)]) + 0.5f;
  out.s1 = mad(in[hook(17, 0)].s0, table[hook(6, 4 * table_id[0hook(16, 0) + 2)], in[hook(17, 0)].s1 * table[hook(6, 4 * table_id[0hook(16, 0) + 3)]) + 0.5f;
  out.s2 = mad(in[hook(17, 0)].s2, table[hook(6, 4 * table_id[1hook(16, 1))], in[hook(17, 0)].s3 * table[hook(6, 4 * table_id[1hook(16, 1) + 1)]) + 0.5f;
  out.s3 = mad(in[hook(17, 0)].s2, table[hook(6, 4 * table_id[1hook(16, 1) + 2)], in[hook(17, 0)].s3 * table[hook(6, 4 * table_id[1hook(16, 1) + 3)]) + 0.5f;
  out.s4 = mad(in[hook(17, 0)].s4, table[hook(6, 4 * table_id[0hook(16, 0))], in[hook(17, 0)].s5 * table[hook(6, 4 * table_id[0hook(16, 0) + 1)]) + 0.5f;
  out.s5 = mad(in[hook(17, 0)].s4, table[hook(6, 4 * table_id[0hook(16, 0) + 2)], in[hook(17, 0)].s5 * table[hook(6, 4 * table_id[0hook(16, 0) + 3)]) + 0.5f;
  out.s6 = mad(in[hook(17, 0)].s6, table[hook(6, 4 * table_id[1hook(16, 1))], in[hook(17, 0)].s7 * table[hook(6, 4 * table_id[1hook(16, 1) + 1)]) + 0.5f;
  out.s7 = mad(in[hook(17, 0)].s6, table[hook(6, 4 * table_id[1hook(16, 1) + 2)], in[hook(17, 0)].s7 * table[hook(6, 4 * table_id[1hook(16, 1) + 3)]) + 0.5f;

  in[hook(17, 0)] = out;
}
__inline void cl_tnr_yuv(float8* in, read_only image2d_t inputFramePre, read_only image2d_t inputFramePreUV, int x, int y, float gain_yuv, float thr_y, float thr_uv, unsigned int x_offset)

{
  float8 in_prev[3];
  sampler_t sampler = 0 | 0 | 0x10;

  in_prev[hook(18, 0)] = convert_float8(__builtin_astype((convert_ushort4(read_imageui(inputFramePre, sampler, (int2)(x, 2 * y)))), uchar8)) / 256.0f;
  in_prev[hook(18, 1)] = convert_float8(__builtin_astype((convert_ushort4(read_imageui(inputFramePre, sampler, (int2)(x, 2 * y + 1)))), uchar8)) / 256.0f;
  in_prev[hook(18, 2)] = convert_float8(__builtin_astype((convert_ushort4(read_imageui(inputFramePreUV, sampler, (int2)(x, y)))), uchar8)) / 256.0f;

  float diff_max = 0.8f;
  float diff_Y[4], coeff_Y[4];

  diff_Y[hook(19, 0)] = 0.25f * (fabs(in[hook(17, 0)].s0 - in_prev[hook(18, 0)].s0) + fabs(in[hook(17, 0)].s1 - in_prev[hook(18, 0)].s1) + fabs(in[hook(17, 1)].s0 - in_prev[hook(18, 1)].s0) + fabs(in[hook(17, 1)].s1 - in_prev[hook(18, 1)].s1));
  diff_Y[hook(19, 1)] = 0.25f * (fabs(in[hook(17, 0)].s2 - in_prev[hook(18, 0)].s2) + fabs(in[hook(17, 0)].s3 - in_prev[hook(18, 0)].s3) + fabs(in[hook(17, 1)].s2 - in_prev[hook(18, 1)].s2) + fabs(in[hook(17, 1)].s3 - in_prev[hook(18, 1)].s3));
  diff_Y[hook(19, 2)] = 0.25f * (fabs(in[hook(17, 0)].s4 - in_prev[hook(18, 0)].s4) + fabs(in[hook(17, 0)].s5 - in_prev[hook(18, 0)].s5) + fabs(in[hook(17, 1)].s4 - in_prev[hook(18, 1)].s4) + fabs(in[hook(17, 1)].s5 - in_prev[hook(18, 1)].s5));
  diff_Y[hook(19, 3)] = 0.25f * (fabs(in[hook(17, 0)].s6 - in_prev[hook(18, 0)].s6) + fabs(in[hook(17, 0)].s7 - in_prev[hook(18, 0)].s7) + fabs(in[hook(17, 1)].s6 - in_prev[hook(18, 1)].s6) + fabs(in[hook(17, 1)].s7 - in_prev[hook(18, 1)].s7));

  coeff_Y[hook(20, 0)] = (diff_Y[hook(19, 0)] < thr_y) ? gain_yuv : (mad(diff_Y[hook(19, 0)], 1 - gain_yuv, diff_max * gain_yuv - thr_y) / (diff_max - thr_y));
  coeff_Y[hook(20, 1)] = (diff_Y[hook(19, 1)] < thr_y) ? gain_yuv : (mad(diff_Y[hook(19, 1)], 1 - gain_yuv, diff_max * gain_yuv - thr_y) / (diff_max - thr_y));
  coeff_Y[hook(20, 2)] = (diff_Y[hook(19, 2)] < thr_y) ? gain_yuv : (mad(diff_Y[hook(19, 2)], 1 - gain_yuv, diff_max * gain_yuv - thr_y) / (diff_max - thr_y));
  coeff_Y[hook(20, 3)] = (diff_Y[hook(19, 3)] < thr_y) ? gain_yuv : (mad(diff_Y[hook(19, 3)], 1 - gain_yuv, diff_max * gain_yuv - thr_y) / (diff_max - thr_y));

  coeff_Y[hook(20, 0)] = (coeff_Y[hook(20, 0)] < 1.0f) ? coeff_Y[hook(20, 0)] : 1.0f;
  coeff_Y[hook(20, 1)] = (coeff_Y[hook(20, 1)] < 1.0f) ? coeff_Y[hook(20, 1)] : 1.0f;
  coeff_Y[hook(20, 2)] = (coeff_Y[hook(20, 2)] < 1.0f) ? coeff_Y[hook(20, 2)] : 1.0f;
  coeff_Y[hook(20, 3)] = (coeff_Y[hook(20, 3)] < 1.0f) ? coeff_Y[hook(20, 3)] : 1.0f;

  in[hook(17, 0)].s01 = mad(in[hook(17, 0)].s01 - in_prev[hook(18, 0)].s01, coeff_Y[hook(20, 0)], in_prev[hook(18, 0)].s01);
  in[hook(17, 1)].s01 = mad(in[hook(17, 1)].s01 - in_prev[hook(18, 1)].s01, coeff_Y[hook(20, 0)], in_prev[hook(18, 1)].s01);
  in[hook(17, 0)].s23 = mad(in[hook(17, 0)].s23 - in_prev[hook(18, 0)].s23, coeff_Y[hook(20, 1)], in_prev[hook(18, 0)].s23);
  in[hook(17, 1)].s23 = mad(in[hook(17, 1)].s23 - in_prev[hook(18, 1)].s23, coeff_Y[hook(20, 1)], in_prev[hook(18, 1)].s23);
  in[hook(17, 0)].s45 = mad(in[hook(17, 0)].s45 - in_prev[hook(18, 0)].s45, coeff_Y[hook(20, 2)], in_prev[hook(18, 0)].s45);
  in[hook(17, 1)].s45 = mad(in[hook(17, 1)].s45 - in_prev[hook(18, 1)].s45, coeff_Y[hook(20, 2)], in_prev[hook(18, 1)].s45);
  in[hook(17, 0)].s67 = mad(in[hook(17, 0)].s67 - in_prev[hook(18, 0)].s67, coeff_Y[hook(20, 3)], in_prev[hook(18, 0)].s67);
  in[hook(17, 1)].s67 = mad(in[hook(17, 1)].s67 - in_prev[hook(18, 1)].s67, coeff_Y[hook(20, 3)], in_prev[hook(18, 1)].s67);

  float diff_U[4], diff_V[4], coeff_U[4], coeff_V[4];

  diff_U[hook(21, 0)] = fabs(in[hook(17, 3)].s0 - in_prev[hook(18, 3)].s0);
  diff_U[hook(21, 1)] = fabs(in[hook(17, 3)].s2 - in_prev[hook(18, 3)].s2);
  diff_U[hook(21, 2)] = fabs(in[hook(17, 3)].s4 - in_prev[hook(18, 3)].s4);
  diff_U[hook(21, 3)] = fabs(in[hook(17, 3)].s6 - in_prev[hook(18, 3)].s6);

  diff_V[hook(22, 0)] = fabs(in[hook(17, 3)].s1 - in_prev[hook(18, 3)].s1);
  diff_V[hook(22, 1)] = fabs(in[hook(17, 3)].s3 - in_prev[hook(18, 3)].s3);
  diff_V[hook(22, 2)] = fabs(in[hook(17, 3)].s5 - in_prev[hook(18, 3)].s5);
  diff_V[hook(22, 3)] = fabs(in[hook(17, 3)].s7 - in_prev[hook(18, 3)].s7);

  coeff_U[hook(23, 0)] = (diff_U[hook(21, 0)] < thr_uv) ? gain_yuv : (mad(diff_U[hook(21, 0)], 1 - gain_yuv, diff_max * gain_yuv - thr_uv) / (diff_max - thr_uv));
  coeff_U[hook(23, 1)] = (diff_U[hook(21, 1)] < thr_uv) ? gain_yuv : (mad(diff_U[hook(21, 1)], 1 - gain_yuv, diff_max * gain_yuv - thr_uv) / (diff_max - thr_uv));
  coeff_U[hook(23, 2)] = (diff_U[hook(21, 2)] < thr_uv) ? gain_yuv : (mad(diff_U[hook(21, 2)], 1 - gain_yuv, diff_max * gain_yuv - thr_uv) / (diff_max - thr_uv));
  coeff_U[hook(23, 3)] = (diff_U[hook(21, 3)] < thr_uv) ? gain_yuv : (mad(diff_U[hook(21, 3)], 1 - gain_yuv, diff_max * gain_yuv - thr_uv) / (diff_max - thr_uv));

  coeff_V[hook(24, 0)] = (diff_V[hook(22, 0)] < thr_uv) ? gain_yuv : (mad(diff_V[hook(22, 0)], 1 - gain_yuv, diff_max * gain_yuv - thr_uv) / (diff_max - thr_uv));
  coeff_V[hook(24, 1)] = (diff_V[hook(22, 1)] < thr_uv) ? gain_yuv : (mad(diff_V[hook(22, 1)], 1 - gain_yuv, diff_max * gain_yuv - thr_uv) / (diff_max - thr_uv));
  coeff_V[hook(24, 2)] = (diff_V[hook(22, 2)] < thr_uv) ? gain_yuv : (mad(diff_V[hook(22, 2)], 1 - gain_yuv, diff_max * gain_yuv - thr_uv) / (diff_max - thr_uv));
  coeff_V[hook(24, 3)] = (diff_V[hook(22, 3)] < thr_uv) ? gain_yuv : (mad(diff_V[hook(22, 3)], 1 - gain_yuv, diff_max * gain_yuv - thr_uv) / (diff_max - thr_uv));

  coeff_U[hook(23, 0)] = (coeff_U[hook(23, 0)] < 1.0f) ? coeff_U[hook(23, 0)] : 1.0f;
  coeff_U[hook(23, 1)] = (coeff_U[hook(23, 1)] < 1.0f) ? coeff_U[hook(23, 1)] : 1.0f;
  coeff_U[hook(23, 2)] = (coeff_U[hook(23, 2)] < 1.0f) ? coeff_U[hook(23, 2)] : 1.0f;
  coeff_U[hook(23, 3)] = (coeff_U[hook(23, 3)] < 1.0f) ? coeff_U[hook(23, 3)] : 1.0f;

  coeff_V[hook(24, 0)] = (coeff_V[hook(24, 0)] < 1.0f) ? coeff_V[hook(24, 0)] : 1.0f;
  coeff_V[hook(24, 1)] = (coeff_V[hook(24, 1)] < 1.0f) ? coeff_V[hook(24, 1)] : 1.0f;
  coeff_V[hook(24, 2)] = (coeff_V[hook(24, 2)] < 1.0f) ? coeff_V[hook(24, 2)] : 1.0f;
  coeff_V[hook(24, 3)] = (coeff_V[hook(24, 3)] < 1.0f) ? coeff_V[hook(24, 3)] : 1.0f;

  in[hook(17, 2)].s0 = mad(in[hook(17, 2)].s0 - in_prev[hook(18, 2)].s0, coeff_U[hook(23, 0)], in_prev[hook(18, 2)].s0);
  in[hook(17, 2)].s1 = mad(in[hook(17, 2)].s1 - in_prev[hook(18, 2)].s1, coeff_V[hook(24, 0)], in_prev[hook(18, 2)].s1);
  in[hook(17, 2)].s2 = mad(in[hook(17, 2)].s2 - in_prev[hook(18, 2)].s2, coeff_U[hook(23, 1)], in_prev[hook(18, 2)].s2);
  in[hook(17, 2)].s3 = mad(in[hook(17, 2)].s3 - in_prev[hook(18, 2)].s3, coeff_V[hook(24, 1)], in_prev[hook(18, 2)].s3);
  in[hook(17, 2)].s4 = mad(in[hook(17, 2)].s4 - in_prev[hook(18, 2)].s4, coeff_U[hook(23, 2)], in_prev[hook(18, 2)].s4);
  in[hook(17, 2)].s5 = mad(in[hook(17, 2)].s5 - in_prev[hook(18, 2)].s5, coeff_V[hook(24, 2)], in_prev[hook(18, 2)].s5);
  in[hook(17, 2)].s6 = mad(in[hook(17, 2)].s6 - in_prev[hook(18, 2)].s6, coeff_U[hook(23, 3)], in_prev[hook(18, 2)].s6);
  in[hook(17, 2)].s7 = mad(in[hook(17, 2)].s7 - in_prev[hook(18, 2)].s7, coeff_V[hook(24, 3)], in_prev[hook(18, 2)].s7);
}
kernel void kernel_yuv_pipe(write_only image2d_t output, write_only image2d_t output_uv, read_only image2d_t inputFramePre, read_only image2d_t inputFramePreUV, unsigned int plannar_offset, global float* matrix, global float* table, float yuv_gain, float thr_y, float thr_uv, unsigned int tnr_yuv_enable, read_only image2d_t inputFrame0)

{
  int x = get_global_id(0);
  int y = get_global_id(1);
  int offsetX = get_global_size(0);
  sampler_t sampler = 0 | 0 | 0x10;
  float8 inR[2], inG[2], inB[2];
  float8 out[3];
  inR[hook(25, 0)] = convert_float8(__builtin_astype((read_imageui(inputFrame0, sampler, (int2)(x, 2 * y))), ushort8)) / 65536.0f;
  inR[hook(25, 1)] = convert_float8(__builtin_astype((read_imageui(inputFrame0, sampler, (int2)(x, 2 * y + 1))), ushort8)) / 65536.0f;
  inG[hook(26, 0)] = convert_float8(__builtin_astype((read_imageui(inputFrame0, sampler, (int2)(x, 2 * y + plannar_offset))), ushort8)) / 65536.0f;
  inG[hook(26, 1)] = convert_float8(__builtin_astype((read_imageui(inputFrame0, sampler, (int2)(x, 2 * y + 1 + plannar_offset))), ushort8)) / 65536.0f;
  inB[hook(27, 0)] = convert_float8(__builtin_astype((read_imageui(inputFrame0, sampler, (int2)(x, 2 * y + plannar_offset * 2))), ushort8)) / 65536.0f;
  inB[hook(27, 1)] = convert_float8(__builtin_astype((read_imageui(inputFrame0, sampler, (int2)(x, 2 * y + 1 + plannar_offset * 2))), ushort8)) / 65536.0f;

  cl_csc_rgbatonv12(&inR[hook(25, 0)], &inG[hook(26, 0)], &inB[hook(27, 0)], &out[hook(12, 0)], matrix);
  cl_macc(&out[hook(12, 2)], table);

  if (tnr_yuv_enable) {
    cl_tnr_yuv(&out[hook(12, 0)], inputFramePre, inputFramePreUV, x, y, yuv_gain, thr_y, thr_uv, offsetX);
  }

  write_imageui(output, (int2)(x, 2 * y), convert_uint4(__builtin_astype((convert_uchar8_sat(out[hook(12, 0)] * 255.0f)), ushort4)));
  write_imageui(output, (int2)(x, 2 * y + 1), convert_uint4(__builtin_astype((convert_uchar8_sat(out[hook(12, 1)] * 255.0f)), ushort4)));
  write_imageui(output_uv, (int2)(x, y), convert_uint4(__builtin_astype((convert_uchar8_sat(out[hook(12, 2)] * 255.0f)), ushort4)));
}
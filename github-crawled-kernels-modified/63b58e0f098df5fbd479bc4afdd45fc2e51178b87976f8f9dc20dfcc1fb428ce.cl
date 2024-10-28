//{"fft":0,"fft_batch":2,"fft_log2_len":1,"h":15,"histo_buf":14,"histo_ofs":10,"histo_scale":9,"histo_t0d":8,"histo_t0r":7,"histo_tex_r":5,"histo_tex_w":6,"live_alpha":12,"live_buf":13,"live_vbo":17,"max_buf":16,"max_vbo":18,"spectrum_vbo":11,"wf_offset":4,"wf_tex":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
__attribute__((reqd_work_group_size(16, 16, 1))) kernel void display(global const float2* fft, const unsigned int fft_log2_len, const unsigned int fft_batch, write_only image2d_t wf_tex, const unsigned int wf_offset, read_only image2d_t histo_tex_r, write_only image2d_t histo_tex_w, const float histo_t0r, const float histo_t0d, const float histo_scale, const float histo_ofs, global float2* spectrum_vbo, const float live_alpha) {
  int gidx;
  float max_pwr = -1000.0f;

  local float live_buf[16 * 16];
  local float max_buf[16 * 16];
  local unsigned int histo_buf[16 * 128];

  const float live_one_minus_alpha = 1.0f - live_alpha;
  live_buf[hook(13, get_local_id(1) * get_local_size(0) + get_local_id(0))] = 0.0f;

  local unsigned int* h = &histo_buf[hook(14, get_local_id(1) * get_local_size(0) + get_local_id(0))];

  h[hook(15, 0)] = 0;
  h[hook(15, 256)] = 0;
  h[hook(15, 512)] = 0;
  h[hook(15, 768)] = 0;
  h[hook(15, 1024)] = 0;
  h[hook(15, 1280)] = 0;
  h[hook(15, 1536)] = 0;
  h[hook(15, 1792)] = 0;

  barrier(0x01);

  for (gidx = 0; gidx < fft_batch; gidx += get_local_size(1)) {
    int fft_idx = ((gidx + get_local_id(1)) << fft_log2_len) + get_global_id(0);
    float2 fft_value = fft[hook(0, fft_idx)];

    float pwr = log10(hypot(fft_value.x, fft_value.y));

    max_pwr = max(max_pwr, pwr);

    int2 coord;
    coord.x = get_global_id(0);
    coord.y = (get_local_id(1) + wf_offset + gidx) & (get_image_height(wf_tex) - 1);

    write_imagef(wf_tex, coord, (float4)(pwr, 0.0f, 0.0f, 0.0f));

    live_buf[hook(13, get_local_id(1) * get_local_size(0) + get_local_id(0))] += pwr * native_powr(live_one_minus_alpha, (float)(fft_batch - gidx - get_local_id(1) - 1));
    int bin = (int)round(histo_scale * (pwr + histo_ofs));

    if (bin < 0 || bin > 127)

      bin = (bin < 0) ? 0 : 127;
    atomic_inc(&histo_buf[hook(14, (bin << 4) + get_local_id(0))]);
  }

  max_buf[hook(16, get_local_id(1) * get_local_size(0) + get_local_id(0))] = max_pwr;

  barrier(0x01);

  global float2* live_vbo = &spectrum_vbo[hook(11, 0)];

  if (get_global_id(1) == 0) {
    int i, n;
    float sum;
    float2 vertex;

    sum = 0.0f;
    for (i = 0; i < get_local_size(1); i++)
      sum += live_buf[hook(13, i * get_local_size(0) + get_local_id(0))];

    n = get_global_size(0) >> 1;
    i = get_global_id(0) ^ n;

    vertex = live_vbo[hook(17, i)];

    if (!isfinite(vertex.y))
      vertex.y = sum / get_local_size(1);

    vertex.x = ((float)i / (float)n) - 1.0f;
    vertex.y = vertex.y * native_powr(live_one_minus_alpha, (float)fft_batch) + sum * live_alpha;

    live_vbo[hook(17, i)] = vertex;
  }

  for (gidx = 0; gidx < 128; gidx += get_local_size(1)) {
    const sampler_t direct_sample = 0 | 0x10 | 2;

    int2 coord;
    coord.x = get_global_id(0);
    coord.y = gidx + get_local_id(1);

    float4 hv = read_imagef(histo_tex_r, direct_sample, coord);

    unsigned int hc = histo_buf[hook(14, coord.y * get_local_size(0) + get_local_id(0))]

        ;

    if ((hv.x <= 0.01f) && (hc == 0))
      continue;

    float a = (float)hc / (float)fft_batch;
    float b = a * native_recip(histo_t0r);
    float c = b + native_recip(histo_t0d);
    float d = b * native_recip(c);
    float e = native_powr(1.0f - c, (float)fft_batch);

    hv.x = (hv.x - d) * e + d;

    hv.x = clamp(hv.x, 0.0f, 1.0f);

    write_imagef(histo_tex_w, coord, hv);
  }

  global float2* max_vbo = &spectrum_vbo[hook(11, 1 << fft_log2_len)];

  if (get_global_id(1) == 0) {
    int i, j, n;
    float2 vertex;
    n = get_global_size(0) >> 1;
    i = get_global_id(0) ^ n;

    max_pwr = max_vbo[hook(18, i)].y;
    if (!isfinite(max_pwr))
      max_pwr = -0x1.fffffep127f;

    vertex.x = ((float)i / (float)n) - 1.0f;
    max_pwr = max_pwr * 0.999f + 0.001f * live_vbo[hook(17, i)].y;
    for (j = 0; j < get_local_size(1); j++)
      max_pwr = max(max_pwr, max_buf[hook(16, j * get_local_size(0) + get_local_id(0))]);
    vertex.y = max_pwr;

    max_vbo[hook(18, i)] = vertex;
  }
}
//{"alpha_over_size":7,"channels":3,"height":4,"in":1,"in_off":11,"k":8,"negative_beta":10,"nthreads":0,"num":2,"out":9,"out_off":12,"size":6,"width":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void lrn_full_no_scale_float(const int nthreads, global const float* in, const int num, const int channels, const int height, const int width, const int size, const float alpha_over_size, const float k, global float* const out, const float negative_beta) {
  for (int index = get_global_id(0); index < nthreads; index += get_global_size(0)) {
    const int w = index % width;
    const int h = (index / width) % height;
    const int n = index / width / height;
    const int offset = (n * channels * height + h) * width + w;
    const int step = height * width;
    global const float* in_off = in + offset;
    global float* out_off = out + offset;
    float scale_val;
    int head = 0;
    const int pre_pad = (size - 1) / 2;
    const int post_pad = size - pre_pad - 1;
    float accum_scale = 0;

    while (head < post_pad && head < channels) {
      accum_scale += in_off[hook(11, head * step)] * in_off[hook(11, head * step)];
      ++head;
    }

    while (head < channels) {
      accum_scale += in_off[hook(11, head * step)] * in_off[hook(11, head * step)];
      if (head - size >= 0) {
        accum_scale -= in_off[hook(11, (head - size) * step)] * in_off[hook(11, (head - size) * step)];
      }
      scale_val = k + accum_scale * alpha_over_size;
      out_off[hook(12, (head - post_pad) * step)] = in_off[hook(11, (head - post_pad) * step)] * (float)native_powr((float)scale_val, (float)negative_beta);
      ++head;
    }

    while (head < channels + post_pad) {
      if (head - size >= 0) {
        accum_scale -= in_off[hook(11, (head - size) * step)] * in_off[hook(11, (head - size) * step)];
      }
      scale_val = k + accum_scale * alpha_over_size;
      out_off[hook(12, (head - post_pad) * step)] = in_off[hook(11, (head - post_pad) * step)] * (float)native_powr((float)scale_val, (float)negative_beta);
      ++head;
    }
  }
}
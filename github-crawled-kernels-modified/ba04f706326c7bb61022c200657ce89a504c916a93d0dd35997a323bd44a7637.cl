//{"batch_num":5,"bit_size":2,"input":0,"lcl_input":1,"sign":6,"size":3,"stride":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
unsigned int get_reorder_num(unsigned int v, unsigned int bit_size) {
  v = ((v >> 1) & 0x55555555) | ((v & 0x55555555) << 1);
  v = ((v >> 2) & 0x33333333) | ((v & 0x33333333) << 2);
  v = ((v >> 4) & 0x0F0F0F0F) | ((v & 0x0F0F0F0F) << 4);
  v = ((v >> 8) & 0x00FF00FF) | ((v & 0x00FF00FF) << 8);
  v = (v >> 16) | (v << 16);

  v = v >> (32 - bit_size);

  return v;
}

kernel void fft_radix2_local(global float2* input, local float2* lcl_input, unsigned int bit_size, unsigned int size, unsigned int stride, unsigned int batch_num, float sign) {
  unsigned int grp_id = get_group_id(0);
  unsigned int grp_num = get_num_groups(0);

  unsigned int lcl_sz = get_local_size(0);
  unsigned int lcl_id = get_local_id(0);
  const float NUM_PI = 3.14159265358979323846;

  for (unsigned int batch_id = grp_id; batch_id < batch_num; batch_id += grp_num) {
    for (unsigned int p = lcl_id; p < size; p += lcl_sz) {
      unsigned int v = get_reorder_num(p, bit_size);
      lcl_input[hook(1, v)] = input[hook(0, batch_id * stride + p)];
    }

    barrier(0x01);

    for (unsigned int s = 0; s < bit_size; s++) {
      unsigned int ss = 1 << s;

      float cs, sn;

      for (unsigned int tid = lcl_id; tid < size; tid += lcl_sz) {
        unsigned int group = (tid & (ss - 1));
        unsigned int pos = ((tid >> s) << (s + 1)) + group;

        float2 in1 = lcl_input[hook(1, pos)];
        float2 in2 = lcl_input[hook(1, pos + ss)];

        float arg = group * sign * NUM_PI / ss;

        sn = sincos(arg, &cs);
        float2 ex = (float2)(cs, sn);

        float2 tmp = (float2)(in2.x * ex.x - in2.y * ex.y, in2.x * ex.y + in2.y * ex.x);

        lcl_input[hook(1, pos + ss)] = in1 - tmp;
        lcl_input[hook(1, pos)] = in1 + tmp;
      }

      barrier(0x01);
    }

    for (unsigned int p = lcl_id; p < size; p += lcl_sz) {
      input[hook(0, batch_id * stride + p)] = lcl_input[hook(1, p)];
    }
  }
}
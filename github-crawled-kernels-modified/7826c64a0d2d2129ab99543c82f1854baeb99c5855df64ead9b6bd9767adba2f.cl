//{"batch_num":4,"input":0,"output":1,"sign":5,"size":2,"stride":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void fft_direct(global float2* input, global float2* output, unsigned int size, unsigned int stride, unsigned int batch_num, float sign) {
  const float NUM_PI = 3.14159265358979323846;

  for (unsigned int batch_id = 0; batch_id < batch_num; batch_id++) {
    for (unsigned int k = get_global_id(0); k < size; k += get_global_size(0)) {
      float2 f = 0.0f;

      for (unsigned int n = 0; n < size; n++) {
        float2 in = input[hook(0, n * stride + batch_id)];

        float sn, cs;
        float arg = sign * 2 * NUM_PI * k / size * n;
        sn = sincos(arg, &cs);

        float2 ex = (float2)(cs, sn);
        f = f + (float2)(in.x * ex.x - in.y * ex.y, in.x * ex.y + in.y * ex.x);
      }

      output[hook(1, k * stride + batch_id)] = f;
    }
  }
}
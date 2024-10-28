//{"dst":1,"loop":3,"pwr":2,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void bench_math_exp2(global float* src, global float* dst, float pwr, unsigned int loop) {
  float result = src[hook(0, get_global_id(0))];

  for (; loop > 0; loop--)
    result = exp2(result) * 0.1f;

  dst[hook(1, get_global_id(0))] = result;
}
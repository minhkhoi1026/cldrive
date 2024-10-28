//{}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void testKernel(global float* randomNumbers, global ulong* MWC_RNG_x, global unsigned int* MWC_RNG_a);
inline float my_divide(float a, float b);
inline float my_recip(float a);
inline float my_powr(float a, float b);
inline float my_sqrt(float a);
inline float my_cos(float a);
inline float my_sin(float a);
inline float my_log(float a);
inline float my_exp(float a);
inline float sqr(float a);
inline float my_divide(float a, float b) {
  return a / b;
}
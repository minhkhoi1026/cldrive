//{"factor":2,"input1":0,"size":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void fft_div_vec_scalar(global float2* input1, unsigned int size, float factor) {
  for (unsigned int i = get_global_id(0); i < size; i += get_global_size(0)) {
    input1[hook(0, i)] /= factor;
  }
}
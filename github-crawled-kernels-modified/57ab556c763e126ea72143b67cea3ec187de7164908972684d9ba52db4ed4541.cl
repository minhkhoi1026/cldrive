//{"alpha":4,"height":2,"interf_imag":1,"interf_real":0,"width":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void weighted_multiply(global float* interf_real, global float* interf_imag, const int height, const int width, const float alpha) {
  const int tx = get_global_id(0);
  const int ty = get_global_id(1);

  const int idx = tx * width + ty;

  if (tx < height && ty < width) {
    const float psd = sqrt(pow(interf_real[hook(0, idx)], 2.0f) + pow(interf_imag[hook(1, idx)], 2.0f));
    interf_real[hook(0, idx)] = pow(psd, alpha) * interf_real[hook(0, idx)];
    interf_imag[hook(1, idx)] = pow(psd, alpha) * interf_imag[hook(1, idx)];
  }
}
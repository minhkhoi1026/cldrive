//{"ampl":2,"height":4,"interf_imag":1,"interf_real":0,"phase":3,"width":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void slc2real(global float* interf_real, global float* interf_imag, global float* ampl, global float* phase, const int height, const int width) {
  const int tx = get_global_id(0);
  const int ty = get_global_id(1);

  const int idx = tx * width + ty;

  if (tx < height && ty < width) {
    ampl[hook(2, idx)] = fabs(sqrt(pow(interf_real[hook(0, idx)], 2.0f) + pow(interf_imag[hook(1, idx)], 2.0f)));
    phase[hook(3, idx)] = atan2(interf_imag[hook(1, idx)], interf_real[hook(0, idx)]);
  }
}
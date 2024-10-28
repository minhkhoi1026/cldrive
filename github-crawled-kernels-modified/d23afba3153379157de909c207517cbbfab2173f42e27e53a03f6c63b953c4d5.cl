//{"ampl_master":0,"ampl_slave":1,"height":5,"interf_imag":4,"interf_real":3,"phase":2,"width":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void raw_interferogram(global float* ampl_master, global float* ampl_slave, global float* phase, global float* interf_real, global float* interf_imag, const int height, const int width) {
  const int tx = get_global_id(0);
  const int ty = get_global_id(1);

  const int idx = tx * width + ty;

  if (tx < height && ty < width) {
    interf_real[hook(3, idx)] = 0.5f * (ampl_master[hook(0, idx)] + ampl_slave[hook(1, idx)]) * cos(phase[hook(2, idx)]);
    interf_imag[hook(4, idx)] = 0.5f * (ampl_master[hook(0, idx)] + ampl_slave[hook(1, idx)]) * sin(phase[hook(2, idx)]);
  }
}
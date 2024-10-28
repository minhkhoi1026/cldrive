//{"Imag":1,"Mag":2,"Phase":3,"Real":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void PostFFT_32f(global float* Real, global float* Imag, global float* Mag, global float* Phase) {
  int k = get_global_id(0);
  int j = get_global_id(1);
  int i = get_global_id(2);

  int linear_coord = i + get_global_size(2) * j + get_global_size(1) * get_global_size(2) * k;

  float o = hypot(Real[hook(0, linear_coord)], Imag[hook(1, linear_coord)]);
  Mag[hook(2, linear_coord)] = 20 * log10(o);

  Phase[hook(3, linear_coord)] = atan2(Imag[hook(1, linear_coord)], Real[hook(0, linear_coord)]);
}
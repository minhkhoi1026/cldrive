//{"ampl_master":0,"ampl_slave":1,"covmat":3,"height":4,"phase":2,"width":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void covmat_create(global float* ampl_master, global float* ampl_slave, global float* phase, global float* covmat, const int height, const int width) {
  const int h = get_group_id(0) * get_local_size(0) + get_local_id(0);
  const int w = get_group_id(1) * get_local_size(1) + get_local_id(1);

  if ((h < height) && (w < width)) {
    const int idx = h * width + w;

    const float el_00real = ampl_master[hook(0, idx)] * ampl_master[hook(0, idx)];
    const float el_00imag = 0.0f;

    const float el_01real = ampl_master[hook(0, idx)] * ampl_slave[hook(1, idx)] * cos(phase[hook(2, idx)]);
    const float el_01imag = ampl_master[hook(0, idx)] * ampl_slave[hook(1, idx)] * sin(phase[hook(2, idx)]);

    const float el_10real = el_01real;
    const float el_10imag = -el_01imag;

    const float el_11real = ampl_slave[hook(1, idx)] * ampl_slave[hook(1, idx)];
    const float el_11imag = 0.0f;

    covmat[hook(3, idx)] = el_00real;
    covmat[hook(3, idx + 1 * height * width)] = el_00imag;

    covmat[hook(3, idx + 2 * height * width)] = el_01real;
    covmat[hook(3, idx + 3 * height * width)] = el_01imag;

    covmat[hook(3, idx + 4 * height * width)] = el_10real;
    covmat[hook(3, idx + 5 * height * width)] = el_10imag;

    covmat[hook(3, idx + 6 * height * width)] = el_11real;
    covmat[hook(3, idx + 7 * height * width)] = el_11imag;
  }
}
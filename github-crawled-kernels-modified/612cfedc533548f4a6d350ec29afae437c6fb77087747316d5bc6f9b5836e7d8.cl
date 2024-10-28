//{"coh_filt":3,"covmat":0,"height":4,"phase_filt":2,"ref_filt":1,"width":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void covmat_decompose(global float* covmat, global float* ref_filt, global float* phase_filt, global float* coh_filt, const int height, const int width) {
  const int h = get_group_id(0) * get_local_size(0) + get_local_id(0);
  const int w = get_group_id(1) * get_local_size(1) + get_local_id(1);

  if ((h < height) && (w < width)) {
    const int idx = h * width + w;

    const float ampl_master = sqrt(covmat[hook(0, idx)]);
    const float ampl_slave = sqrt(covmat[hook(0, idx + 6 * height * width)]);

    ref_filt[hook(1, idx)] = pow(0.5f * (ampl_master + ampl_slave), 2.0f);
    phase_filt[hook(2, idx)] = atan2(covmat[hook(0, idx + 3 * height * width)], covmat[hook(0, idx + 2 * height * width)]);
    coh_filt[hook(3, idx)] = sqrt(pow(covmat[hook(0, idx + 3 * height * width)], 2.0f) + pow(covmat[hook(0, idx + 2 * height * width)], 2.0f)) / (ampl_master * ampl_slave);
  }
}
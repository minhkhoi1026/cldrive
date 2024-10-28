//{"ampl_master":0,"ampl_slave":1,"filter_data_a":3,"filter_data_x_imag":5,"filter_data_x_real":4,"height_overlap":6,"patch_size":8,"phase":2,"width_overlap":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void precompute_filter_values(global float* ampl_master, global float* ampl_slave, global float* phase, global float* filter_data_a, global float* filter_data_x_real, global float* filter_data_x_imag, const int height_overlap, const int width_overlap, const int patch_size) {
  const int width_sws = width_overlap - patch_size + 1;
  const int height_sws = height_overlap - patch_size + 1;
  const int psh = (patch_size - 1) / 2;

  const int tx = get_group_id(0) * get_local_size(0) + get_local_id(0);
  const int ty = get_group_id(1) * get_local_size(1) + get_local_id(1);

  if (tx < height_sws && ty < width_sws) {
    const float a1 = ampl_master[hook(0, (tx + psh) * width_overlap + (ty + psh))];
    const float a2 = ampl_slave[hook(1, (tx + psh) * width_overlap + (ty + psh))];
    const float dp = phase[hook(2, (tx + psh) * width_overlap + (ty + psh))];

    filter_data_a[hook(3, tx * width_sws + ty)] = 0.5f * (pow(a1, 2.0f) + pow(a2, 2.0f));
    filter_data_x_real[hook(4, tx * width_sws + ty)] = a1 * a2 * cos(-dp);
    filter_data_x_imag[hook(5, tx * width_sws + ty)] = a1 * a2 * sin(-dp);
  }
}
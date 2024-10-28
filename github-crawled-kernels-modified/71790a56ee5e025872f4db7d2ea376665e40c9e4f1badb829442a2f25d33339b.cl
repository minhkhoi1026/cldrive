//{"k2max":4,"k2min":3,"kxp2":1,"kyp2":2,"n_detect":5,"probe":0,"probe_ny":6,"temp":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void sum_intensity(global float2* probe, global float* kxp2, global float* kyp2, global float* k2min, global float* k2max, int n_detect, int probe_ny, global float* temp) {
  int ix = get_global_id(0);
  int probe_nx = get_global_size(0);

  for (int idetect = 0; idetect < n_detect; idetect++) {
    temp[hook(7, idetect * probe_nx + ix)] = 0;
  }

  for (int iy = 0; iy < probe_ny; iy++) {
    float prr = probe[hook(0, iy * probe_nx + ix)].s0;
    float pri = probe[hook(0, iy * probe_nx + ix)].s1;
    float absolute = prr * prr + pri * pri;
    float k2 = kxp2[hook(1, ix)] + kyp2[hook(2, iy)];

    for (int idetect = 0; idetect < n_detect; idetect++) {
      if ((k2 >= k2min[hook(3, idetect)]) && (k2 <= k2max[hook(4, idetect)])) {
        temp[hook(7, idetect * probe_nx + ix)] += absolute;
      }
    }
  }
}
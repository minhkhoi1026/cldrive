//{"complex_data":0,"k2max":5,"kx2":3,"ky2":4,"propagator_x":1,"propagator_y":2,"slice":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void propagate(global float2* complex_data, global const float2* propagator_x, global const float2* propagator_y, global float* kx2, global float* ky2, float k2max, int slice) {
  size_t ix = get_global_id(0);
  size_t iy = get_global_id(1);
  size_t index = iy * get_global_size(0) + ix;
  float pxr, pxi, pyr, pyi;
  float2 w, t;

  if (kx2[hook(3, ix)] < k2max) {
    pxr = propagator_x[hook(1, ix)].s0;
    pxi = propagator_x[hook(1, ix)].s1;

    if ((kx2[hook(3, ix)] + ky2[hook(4, iy)]) < k2max) {
      pyr = propagator_y[hook(2, iy)].s0;
      pyi = propagator_y[hook(2, iy)].s1;
      w = complex_data[hook(0, index)];
      t.s0 = w.s0 * pyr - w.s1 * pyi;
      t.s1 = w.s0 * pyi + w.s1 * pyr;
      complex_data[hook(0, index)].s0 = t.s0 * pxr - t.s1 * pxi;
      complex_data[hook(0, index)].s1 = t.s0 * pxi + t.s1 * pxr;
    } else {
      complex_data[hook(0, index)] = 0.0f;
    }

  } else {
    complex_data[hook(0, index)] = 0.0f;
  }
}
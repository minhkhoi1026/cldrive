//{"chi1":4,"chi2":5,"chi3":6,"df":15,"dfa2":11,"dfa2phi":12,"dfa3":13,"dfa3phi":14,"k2maxa":2,"k2maxb":3,"p_spat_freqx":16,"p_spat_freqx2":18,"p_spat_freqy":17,"p_spat_freqy2":19,"probe_data":9,"spat_freqx":20,"spat_freqy":21,"wavlen":10,"x":0,"xoff":7,"y":1,"yoff":8}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void prepare_probe_espread(float x, float y, float k2maxa, float k2maxb, float chi1, float chi2, float chi3, float xoff, float yoff, global float2* probe_data, float wavlen, float dfa2, float dfa2phi, float dfa3, float dfa3phi, float df, global float* p_spat_freqx, global float* p_spat_freqy, global float* p_spat_freqx2, global float* p_spat_freqy2, global float* spat_freqx, global float* spat_freqy) {
  size_t ix = get_global_id(0);
  size_t iy = get_global_id(1);
  size_t index = iy * get_global_size(0) + ix;

  size_t nx = get_global_size(0);
  size_t ny = get_global_size(1);

  float2 pd = probe_data[hook(9, index)];
  float scale = 1.0 / sqrt((float)nx * (float)ny);

  float pi = 4.0f * atan(1.0f);

  float k2 = p_spat_freqx2[hook(18, ix)] + p_spat_freqy2[hook(19, iy)];

  float ktheta2 = k2 * (wavlen * wavlen);
  float w = 2.0f * pi * (xoff * p_spat_freqx[hook(16, ix)] + yoff * p_spat_freqy[hook(17, iy)]);
  float phi = atan2(spat_freqy[hook(21, iy)], spat_freqx[hook(20, ix)]);

  float chi = ktheta2 * (-df + chi2 + dfa2 * sin(2.0f * (phi - dfa2phi))) / 2.0f;
  chi *= 2 * pi / wavlen;
  chi -= w;

  if (fabs(k2 - k2maxa) <= chi1) {
    pd.s0 = 0.5 * scale * cos(chi);
    pd.s1 = -0.5 * scale * sin(chi);
  } else if ((k2 >= k2maxa) && (k2 <= k2maxb)) {
    pd.s0 = scale * cos(chi);
    pd.s1 = -scale * sin(chi);
  } else {
    pd.s0 = 0.0f;
    pd.s1 = 0.0f;
  }

  probe_data[hook(9, index)] = pd;
}
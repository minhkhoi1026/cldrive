//{"dss_D":7,"dss_F":8,"dss_PSR":3,"dss_U":6,"dss_W":4,"dss_decay":5,"dss_lastSpike":11,"dss_r":10,"dss_u":9,"hasFireds":2,"step":1,"t":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void advance_spikeHit_ps_pa(const float t, const int step, global const int* hasFireds, global float* dss_PSR, global const float* dss_W, global const float* dss_decay, global const float* dss_U, global const float* dss_D, global const float* dss_F, global float* dss_u, global float* dss_r, global float* dss_lastSpike) {
  long gid = get_global_id(0);

  float PSR = dss_PSR[hook(3, gid)];
  float decay = dss_decay[hook(5, gid)];
  PSR *= decay;

  if (hasFireds[hook(2, step)]) {
    float r = dss_r[hook(10, gid)];
    float u = dss_u[hook(9, gid)];
    if (dss_lastSpike[hook(11, gid)] > 0) {
      float isi = t - dss_lastSpike[hook(11, gid)];
      r = 1 + (((r * (1 - u)) - 1) * exp(-isi / dss_D[hook(7, gid)]));

      float U = dss_U[hook(6, gid)];
      u = U + (u * (1 - U) * exp(-isi / dss_F[hook(8, gid)]));

      dss_r[hook(10, gid)] = r;
      dss_u[hook(9, gid)] = u;
    }
    PSR += ((dss_W[hook(4, gid)] / decay) * u * r);
    dss_lastSpike[hook(11, gid)] = t;
  }
  dss_PSR[hook(3, gid)] = PSR;
}
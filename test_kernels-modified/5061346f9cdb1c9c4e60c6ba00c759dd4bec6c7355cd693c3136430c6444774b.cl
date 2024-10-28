//{"dss_D":10,"dss_F":11,"dss_PSR":6,"dss_U":9,"dss_W":7,"dss_decay":8,"dss_lastSpike":14,"dss_r":13,"dss_u":12,"hasFireds":3,"incoming_synapse_start_idxs":5,"nSteps":2,"step":1,"t":0,"ttl_PSRs_coll":15,"ttl_incoming_synapses":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void advance_spikeHit_pn_pa(const float t, const int step, const int nSteps, global const int* hasFireds, global const int* ttl_incoming_synapses, global const long* incoming_synapse_start_idxs, global float* dss_PSR, global const float* dss_W, global const float* dss_decay, global const float* dss_U, global const float* dss_D, global const float* dss_F, global float* dss_u, global float* dss_r, global float* dss_lastSpike, global float* ttl_PSRs_coll) {
  long gid = get_global_id(0);

  long out_idx = gid * nSteps;

  float ttl_PSR = 0;
  int ttl_incoming_synapse = ttl_incoming_synapses[hook(4, gid)];
  long start_idx = incoming_synapse_start_idxs[hook(5, gid)];
  for (int i = 0; i < ttl_incoming_synapse; i++) {
    long sid = start_idx + (long)i;

    float PSR = dss_PSR[hook(6, sid)];
    float decay = dss_decay[hook(8, sid)];
    PSR *= decay;

    if (hasFireds[hook(3, step)]) {
      float r = dss_r[hook(13, sid)];
      float u = dss_u[hook(12, sid)];
      if (dss_lastSpike[hook(14, sid)] > 0) {
        float isi = t - dss_lastSpike[hook(14, sid)];
        r = 1 + (((r * (1 - u)) - 1) * exp(-isi / dss_D[hook(10, sid)]));

        float U = dss_U[hook(9, sid)];
        u = U + (u * (1 - U) * exp(-isi / dss_F[hook(11, sid)]));

        dss_r[hook(13, sid)] = r;
        dss_u[hook(12, sid)] = u;
      }
      PSR += ((dss_W[hook(7, sid)] / decay) * u * r);
      dss_lastSpike[hook(14, sid)] = t;
    }
    dss_PSR[hook(6, sid)] = PSR;
    ttl_PSR += PSR;
  }
  ttl_PSRs_coll[hook(15, out_idx + step)] = ttl_PSR;
}
//{"dss_PSR":4,"incoming_synapse_start_idxs":3,"nSteps":1,"step":0,"ttl_PSRs_coll":5,"ttl_incoming_synapses":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void sum_up_psr(const int step, const int nSteps, global const int* ttl_incoming_synapses, global const long* incoming_synapse_start_idxs, global float* dss_PSR, global float* ttl_PSRs_coll) {
  long gid = get_global_id(0);

  long out_idx = gid * nSteps;

  float ttl_PSR = 0;
  int ttl_incoming_synapse = ttl_incoming_synapses[hook(2, gid)];
  long start_idx = incoming_synapse_start_idxs[hook(3, gid)];
  for (int i = 0; i < ttl_incoming_synapse; i++) {
    long sid = start_idx + (long)i;

    float PSR = dss_PSR[hook(4, sid)];
    ttl_PSR += PSR;
  }
  ttl_PSRs_coll[hook(5, out_idx + step)] = ttl_PSR;
}
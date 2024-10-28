//{"Iinjects":2,"Vms":4,"dt":0,"lifNeurons":3,"spikes":5,"step":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void nextState_plir(const float dt, const int step, global const float* Iinjects, global float* lifNeurons, global float* Vms, global int* spikes) {
  long gid = get_global_id(0);
  long ln_idx = gid * 13;

  lifNeurons[hook(3, ln_idx + 8)] = Iinjects[hook(2, step)];

  if (lifNeurons[hook(3, ln_idx + 11)] > 0) {
    lifNeurons[hook(3, ln_idx + 11)] -= 1;
    lifNeurons[hook(3, ln_idx + 12)] = 0;
  } else if (lifNeurons[hook(3, ln_idx + 5)] >= lifNeurons[hook(3, ln_idx + 2)]) {
    lifNeurons[hook(3, ln_idx + 12)] = 1;
    lifNeurons[hook(3, ln_idx + 11)] = (float)ceil(lifNeurons[hook(3, ln_idx + 6)] / dt);
    lifNeurons[hook(3, ln_idx + 5)] = lifNeurons[hook(3, ln_idx + 3)];
  } else {
    lifNeurons[hook(3, ln_idx + 12)] = 0;
    lifNeurons[hook(3, ln_idx + 7)] = lifNeurons[hook(3, ln_idx + 7)] + lifNeurons[hook(3, ln_idx + 8)] + (lifNeurons[hook(3, ln_idx + 1)] / lifNeurons[hook(3, ln_idx + 0)]);
    lifNeurons[hook(3, ln_idx + 5)] = (lifNeurons[hook(3, ln_idx + 9)] * lifNeurons[hook(3, ln_idx + 5)]) + (lifNeurons[hook(3, ln_idx + 10)] * lifNeurons[hook(3, ln_idx + 7)]);
  }

  lifNeurons[hook(3, ln_idx + 7)] = 0;

  Vms[hook(4, gid)] = lifNeurons[hook(3, ln_idx + 5)];
  if (lifNeurons[hook(3, ln_idx + 12)]) {
    spikes[hook(5, gid)] = 1;
  } else {
    spikes[hook(5, gid)] = 0;
  }
}
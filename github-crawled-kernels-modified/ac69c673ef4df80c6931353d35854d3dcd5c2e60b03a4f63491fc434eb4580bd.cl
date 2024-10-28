//{"Iinjects":2,"Vms":4,"dt":0,"input_len":1,"lifNeurons":3,"spikes":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void nextState_clcr(const float dt, const int input_len, global const float* Iinjects, global float* lifNeurons, global float* Vms, global int* spikes) {
  long gid = get_global_id(0);

  long ln_idx = gid * 13;

  long out_idx = gid * input_len;

  for (int step = 0; step < input_len; step++) {
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

    Vms[hook(4, out_idx + step)] = lifNeurons[hook(3, ln_idx + 5)];
    if (lifNeurons[hook(3, ln_idx + 12)]) {
      spikes[hook(5, out_idx + step)] = 1;
    } else {
      spikes[hook(5, out_idx + step)] = 0;
    }
    barrier(0x01 | 0x02);
  }
}
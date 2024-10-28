//{"Iinjects":2,"Vms":16,"dt":0,"input_len":1,"lif_C1":12,"lif_C2":13,"lif_Iinject":11,"lif_Rm":3,"lif_Trefract":9,"lif_Vinit":7,"lif_Vm":8,"lif_Vreset":6,"lif_Vresting":4,"lif_Vthresh":5,"lif_hasFired":15,"lif_nStepsInRefr":14,"lif_summationPoint":10,"spikes":17}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void nextState_clcr_pa(const float dt, const int input_len, global const float* Iinjects, global const float* lif_Rm, global const float* lif_Vresting, global const float* lif_Vthresh, global const float* lif_Vreset, global const float* lif_Vinit, global float* lif_Vm, global const float* lif_Trefract, global float* lif_summationPoint, global float* lif_Iinject, global const float* lif_C1, global const float* lif_C2, global int* lif_nStepsInRefr, global int* lif_hasFired, global float* Vms, global int* spikes) {
  long gid = get_global_id(0);

  long out_idx = gid * input_len;

  int nStepsInRefr = lif_nStepsInRefr[hook(14, gid)];
  int hasFired;
  float Vm = lif_Vm[hook(8, gid)];
  float summationPoint = lif_summationPoint[hook(10, gid)];

  for (int step = 0; step < input_len; step++) {
    if (nStepsInRefr > 0) {
      nStepsInRefr -= 1;
      hasFired = 0;
    } else if (Vm >= lif_Vthresh[hook(5, gid)]) {
      hasFired = 1;
      spikes[hook(17, out_idx + step)] = 1;
      nStepsInRefr = ceil(lif_Trefract[hook(9, gid)] / dt);
      Vm = lif_Vreset[hook(6, gid)];
    } else {
      hasFired = 0;
      summationPoint = summationPoint + Iinjects[hook(2, step)] + (lif_Vresting[hook(4, gid)] / lif_Rm[hook(3, gid)]);
      Vm = (lif_C1[hook(12, gid)] * Vm) + (lif_C2[hook(13, gid)] * summationPoint);
    }
    summationPoint = 0;
    Vms[hook(16, out_idx + step)] = Vm;
    barrier(0x01 | 0x02);
  }
}
//{"Iinjects":3,"Vms":17,"dt":0,"input_len":2,"lif_C1":13,"lif_C2":14,"lif_Iinject":12,"lif_Rm":4,"lif_Trefract":10,"lif_Vinit":8,"lif_Vm":9,"lif_Vreset":7,"lif_Vresting":5,"lif_Vthresh":6,"lif_hasFired":16,"lif_nStepsInRefr":15,"lif_summationPoint":11,"spikes":18,"step":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void nextState_plcr_pa(const float dt, const int step, const int input_len, global const float* Iinjects, global const float* lif_Rm, global const float* lif_Vresting, global const float* lif_Vthresh, global const float* lif_Vreset, global const float* lif_Vinit, global float* lif_Vm, global const float* lif_Trefract, global float* lif_summationPoint, global float* lif_Iinject, global const float* lif_C1, global const float* lif_C2, global int* lif_nStepsInRefr, global int* lif_hasFired, global float* Vms, global int* spikes) {
  long gid = get_global_id(0);

  long out_idx = gid * input_len;

  float Iinject = Iinjects[hook(3, step)];
  lif_Iinject[hook(12, gid)] = Iinject;
  int hasFired;
  float Vm = lif_Vm[hook(9, gid)];

  if (lif_nStepsInRefr[hook(15, gid)] > 0) {
    lif_nStepsInRefr[hook(15, gid)] -= 1;
    hasFired = 0;
  } else if (Vm >= lif_Vthresh[hook(6, gid)]) {
    hasFired = 1;
    lif_nStepsInRefr[hook(15, gid)] = ceil(lif_Trefract[hook(10, gid)] / dt);
    Vm = lif_Vreset[hook(7, gid)];
  } else {
    hasFired = 0;
    float summationPoint = lif_summationPoint[hook(11, gid)] + Iinject + (lif_Vresting[hook(5, gid)] / lif_Rm[hook(4, gid)]);
    Vm = (lif_C1[hook(13, gid)] * Vm) + (lif_C2[hook(14, gid)] * summationPoint);
  }
  lif_hasFired[hook(16, gid)] = hasFired;
  lif_summationPoint[hook(11, gid)] = 0;

  lif_Vm[hook(9, gid)] = Vm;
  Vms[hook(17, out_idx + step)] = Vm;
  if (hasFired) {
    spikes[hook(18, out_idx + step)] = 1;
  } else {
    spikes[hook(18, out_idx + step)] = 0;
  }
}
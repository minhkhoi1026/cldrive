//{"Iinjects":2,"Vms":16,"dt":0,"input_len":1,"lif_C1":12,"lif_C2":13,"lif_Iinject":11,"lif_Rm":3,"lif_Trefract":9,"lif_Vinit":7,"lif_Vm":8,"lif_Vreset":6,"lif_Vresting":4,"lif_Vthresh":5,"lif_hasFired":15,"lif_nStepsInRefr":14,"lif_summationPoint":10,"spikes":17}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void nextState_clcrwg_pa(const float dt, const int input_len, global const float* Iinjects, global const float* lif_Rm, global const float* lif_Vresting, global const float* lif_Vthresh, global const float* lif_Vreset, global const float* lif_Vinit, global float* lif_Vm, global const float* lif_Trefract, global float* lif_summationPoint, global float* lif_Iinject, global const float* lif_C1, global const float* lif_C2, global int* lif_nStepsInRefr, global int* lif_hasFired, global float* Vms, global int* spikes) {
  long grid = get_group_id(0);
  if (grid != 0)
    return;

  long gsz = get_global_size(0);
  long lsz = get_local_size(0);
  long lid = get_local_id(0);
  long start_idx = ((lid * gsz) / lsz);
  long end_idx = ((((lid + 1) * gsz) / lsz) - 1);

  int input_len_lm = input_len;
  for (int step = 0; step < input_len_lm; step++) {
    for (long idx = start_idx; idx <= end_idx; idx++) {
      long out_idx = idx * input_len_lm;

      int nStepsInRefr = lif_nStepsInRefr[hook(14, idx)];
      int hasFired;
      float Vm = lif_Vm[hook(8, idx)];
      float summationPoint = lif_summationPoint[hook(10, idx)];

      if (nStepsInRefr > 0) {
        nStepsInRefr -= 1;
        hasFired = 0;
      } else if (Vm >= lif_Vthresh[hook(5, idx)]) {
        hasFired = 1;
        spikes[hook(17, out_idx + step)] = 1;
        nStepsInRefr = ceil(lif_Trefract[hook(9, idx)] / dt);
        Vm = lif_Vreset[hook(6, idx)];
      } else {
        hasFired = 0;
        summationPoint = summationPoint + Iinjects[hook(2, step)] + (lif_Vresting[hook(4, idx)] / lif_Rm[hook(3, idx)]);
        Vm = (lif_C1[hook(12, idx)] * Vm) + (lif_C2[hook(13, idx)] * summationPoint);
      }
      Vms[hook(16, out_idx + step)] = Vm;
      lif_Vm[hook(8, idx)] = Vm;
      lif_nStepsInRefr[hook(14, idx)] = nStepsInRefr;
      lif_hasFired[hook(15, idx)] = hasFired;
      lif_summationPoint[hook(10, idx)] = 0;
    }
    barrier(0x01 | 0x02);
  }
}
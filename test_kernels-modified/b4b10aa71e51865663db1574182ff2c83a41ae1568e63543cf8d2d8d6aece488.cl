//{"DQ":5,"Q":6,"dequant":4,"dqcoeff_base":0,"dqcoeff_offset":1,"qcoeff_base":2,"qcoeff_offset":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant int cospi8sqrt2minus1 = 20091;
constant int sinpi8sqrt2 = 35468;
constant int rounding = 0;
void vp8_short_idct4x4llm(global short*, short*, int);
void cl_memset_short(global short*, int, size_t);
kernel void vp8_dequantize_b_kernel(global short* dqcoeff_base, int dqcoeff_offset, global short* qcoeff_base, int qcoeff_offset, global short* dequant) {
  global short* DQ = dqcoeff_base + dqcoeff_offset;
  global short* Q = qcoeff_base + qcoeff_offset;

  int tid = get_global_id(0);
  if (tid < 16) {
    DQ[hook(5, tid)] = Q[hook(6, tid)] * dequant[hook(4, tid)];
  }
}
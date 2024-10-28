//{"APF":0,"PPF":1,"VEL":2,"fPulseValue":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void ckSeismic(global float* APF, global float* PPF, global float* VEL, float fPulseValue) {
  int x = get_global_id(0);
  int y = get_global_id(1);
  int off = y * 128 + x;

  if (x > 2 && x < 128 - 2 && y > 2 && y < 128 - 2) {
    PPF[hook(1, off)] = 2.0f * APF[hook(0, off)] - PPF[hook(1, off)] + VEL[hook(2, off)] * (16.0f * (APF[hook(0, off - 1)] + APF[hook(0, off + 1)] + APF[hook(0, off - 128)] + APF[hook(0, off + 128)]) - (APF[hook(0, off - 2)] + APF[hook(0, off + 2)] + APF[hook(0, off - (128 * 2))] + APF[hook(0, off + (128 * 2))]) - 60.0f * APF[hook(0, off)]);
  }

  if (off == 16)
    PPF[hook(1, off)] += fPulseValue;
}
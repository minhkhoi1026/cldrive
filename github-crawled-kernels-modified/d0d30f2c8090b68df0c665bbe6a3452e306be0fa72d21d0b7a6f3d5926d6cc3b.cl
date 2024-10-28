//{"APF":0,"PPF":1,"fPulseValue":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void ckInit(global float* APF, global float* PPF, float fPulseValue) {
  int x = get_global_id(0);
  int y = get_global_id(1);
  int off = y * 128 + x;

  APF[hook(0, off)] = 0.0f;
  PPF[hook(1, off)] = 0.0f;

  if (off == 16)
    APF[hook(0, off)] += fPulseValue;
}
//{"height":3,"lclTrg":7,"lclTrg[2]":9,"lclTrg[i]":6,"lclTrg[pixelNo]":8,"out":2,"petalNo":5,"tmp":0,"trg":1,"width":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void diffCoarse(constant float* tmp, global float* trg, global float* out, const int height, const int width, const int petalNo) {
  local float lclTrg[2 + 1][8 * 8];

  const int lid = get_local_id(0);
  const int gx = get_global_id(0);
  const int gy = get_global_id(1);

  int i;
  for (i = 0; i < (2 * 8 * 8) / 64; i++) {
    lclTrg[hook(7, i)][hook(6, lid)] =

        trg[hook(1, (gy * width + (gx / 64) * 64 + i) * (25 * 8) + (25 - 8) * 8 + lid)];
  }

  float diffs = 0.0;

  const int pixelNo = lid / (64 / 2);
  const int rotationNo = (lid / (64 / (2 * 8))) % 8;

  const int DIFFS = (2 * 2 * 8 * 8) / 64;

  const int trgPetal = (petalNo + rotationNo) % 8;
  const int trgFirstGradient = (lid % (8 / DIFFS)) * DIFFS + rotationNo;
  for (i = 0; i < DIFFS; i++) {
    diffs += fabs(tmp[hook(0, lid)] - lclTrg[hook(7, pixelNo)][hook(8, trgPetal * 8 + (trgFirstGradient + i) % 8)]);
  }

  lclTrg[hook(7, 2)][hook(9, lid)] = diffs;

  barrier(0x01);

  if (lid < 64 / 2)
    lclTrg[hook(7, 2)][hook(9, lid * 2)] = lclTrg[hook(7, 2)][hook(9, lid * 2)] + lclTrg[hook(7, 2)][hook(9, lid * 2 + 1)];

  barrier(0x01);

  if (lid < (64 / (2 * 2))) {
    diffs = lclTrg[hook(7, 2)][hook(9, lid * 4)] + lclTrg[hook(7, 2)][hook(9, lid * 4 + 2)];

    out[hook(2, (gy * width + gx / (64 / 2)) * 8 + lid)] += diffs;
  }
}
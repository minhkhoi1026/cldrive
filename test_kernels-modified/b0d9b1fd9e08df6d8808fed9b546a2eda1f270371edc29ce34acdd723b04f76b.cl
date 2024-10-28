//{"Qi":6,"Qr":5,"ck":7,"kGlobalIndex":1,"numK":0,"sQi":12,"sQr":11,"sX":8,"sY":9,"sZ":10,"x":2,"y":3,"z":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
struct kValues {
  float Kx;
  float Ky;
  float Kz;
  float PhiMag;
};
kernel void ComputeQ_GPU(int numK, int kGlobalIndex, global float* x, global float* y, global float* z, global float* Qr, global float* Qi, global struct kValues* ck) {
  float sX[4];
  float sY[4];
  float sZ[4];
  float sQr[4];
  float sQi[4];

  int getgroupid0 = get_global_id(0) / get_local_size(0);

  for (int tx = 0; tx < 4; tx++) {
    int xIndex = getgroupid0 * 256 + 4 * get_local_id(0) + tx;

    sX[hook(8, tx)] = x[hook(2, xIndex)];
    sY[hook(9, tx)] = y[hook(3, xIndex)];
    sZ[hook(10, tx)] = z[hook(4, xIndex)];
    sQr[hook(11, tx)] = Qr[hook(5, xIndex)];
    sQi[hook(12, tx)] = Qi[hook(6, xIndex)];
  }

  int kIndex = 0;
  for (; (kIndex < 1024) && (kGlobalIndex < numK); kIndex++, kGlobalIndex++) {
    float kx = ck[hook(7, kIndex)].Kx;
    float ky = ck[hook(7, kIndex)].Ky;
    float kz = ck[hook(7, kIndex)].Kz;
    float pm = ck[hook(7, kIndex)].PhiMag;

    for (int tx = 0; tx < 4; tx++) {
      float expArg = 6.2831853071795864769252867665590058f * (kx * sX[hook(8, tx)] + ky * sY[hook(9, tx)] + kz * sZ[hook(10, tx)]);
      sQr[hook(11, tx)] += pm * cos(expArg);
      sQi[hook(12, tx)] += pm * sin(expArg);
    }
  }

  for (int tx = 0; tx < 4; tx++) {
    int xIndex = getgroupid0 * 256 + 4 * get_local_id(0) + tx;

    Qr[hook(5, xIndex)] = sQr[hook(11, tx)];
    Qi[hook(6, xIndex)] = sQi[hook(12, tx)];
  }
}
//{"Qi":6,"Qr":5,"ck":7,"kGlobalIndex":1,"numK":0,"x":2,"y":3,"z":4}
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

kernel void ComputeQ_GPU(int numK, int kGlobalIndex, global float* x, global float* y, global float* z, global float* Qr, global float* Qi, constant struct kValues* ck) {
  float sX;
  float sY;
  float sZ;
  float sQr;
  float sQi;

  int xIndex = get_group_id(0) * 256 + get_local_id(0);

  sX = x[hook(2, xIndex)];
  sY = y[hook(3, xIndex)];
  sZ = z[hook(4, xIndex)];
  sQr = Qr[hook(5, xIndex)];
  sQi = Qi[hook(6, xIndex)];

  int kIndex = 0;
  if (numK % 2) {
    float expArg = 6.2831853071795864769252867665590058f * (ck[hook(7, 0)].Kx * sX + ck[hook(7, 0)].Ky * sY + ck[hook(7, 0)].Kz * sZ);
    sQr += ck[hook(7, 0)].PhiMag * cos(expArg);
    sQi += ck[hook(7, 0)].PhiMag * sin(expArg);
    kIndex++;
    kGlobalIndex++;
  }

  for (; (kIndex < 1024) && (kGlobalIndex < numK); kIndex += 2, kGlobalIndex += 2) {
    float expArg = 6.2831853071795864769252867665590058f * (ck[hook(7, kIndex)].Kx * sX + ck[hook(7, kIndex)].Ky * sY + ck[hook(7, kIndex)].Kz * sZ);
    sQr += ck[hook(7, kIndex)].PhiMag * cos(expArg);
    sQi += ck[hook(7, kIndex)].PhiMag * sin(expArg);

    int kIndex1 = kIndex + 1;
    float expArg1 = 6.2831853071795864769252867665590058f * (ck[hook(7, kIndex1)].Kx * sX + ck[hook(7, kIndex1)].Ky * sY + ck[hook(7, kIndex1)].Kz * sZ);
    sQr += ck[hook(7, kIndex1)].PhiMag * cos(expArg1);
    sQi += ck[hook(7, kIndex1)].PhiMag * sin(expArg1);
  }

  Qr[hook(5, xIndex)] = sQr;
  Qi[hook(6, xIndex)] = sQi;
}
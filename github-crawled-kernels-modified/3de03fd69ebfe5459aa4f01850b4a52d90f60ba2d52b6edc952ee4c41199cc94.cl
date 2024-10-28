//{"dimx":1,"dimy":2,"dimz":3,"input":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kselect(global float* input, int dimx, int dimy, int dimz) {
  int xgid = get_global_id(0);
  int ygid = get_global_id(1);
  int zgid;

  if ((xgid < dimx) && (ygid < dimy)) {
    for (zgid = 0; zgid < 4; ++zgid) {
      input[hook(0, (8 + dimx) * ((8 + dimy) * (zgid + 4) + ygid + 4) + xgid + 4)] = (8 + dimx) * ((8 + dimy) * (zgid + 4) + (ygid + 4)) + xgid + 4;
    }
    for (zgid = dimz - 4; zgid < dimz; ++zgid) {
      input[hook(0, (8 + dimx) * ((8 + dimy) * (zgid + 4) + ygid + 4) + xgid + 4)] = (8 + dimx) * ((8 + dimy) * (zgid + 4) + (ygid + 4)) + xgid + 4;
    }
  }

  if (((xgid >= 0) && (xgid < 4)) || ((xgid >= (dimx - 4)) && (xgid < dimx))) {
    for (zgid = 0; zgid < dimz; ++zgid) {
      input[hook(0, (8 + dimx) * ((8 + dimy) * (zgid + 4) + ygid + 4) + xgid + 4)] = (8 + dimx) * ((8 + dimy) * (zgid + 4) + (ygid + 4)) + xgid + 4;
    }
  }

  if (((ygid >= 0) && (ygid < 4)) || ((ygid >= (dimy - 4)) && (ygid < dimy))) {
    for (zgid = 0; zgid < dimz; ++zgid) {
      input[hook(0, (8 + dimx) * ((8 + dimy) * (zgid + 4) + ygid + 4) + xgid + 4)] = (8 + dimx) * ((8 + dimy) * (zgid + 4) + (ygid + 4)) + xgid + 4;
    }
  }
}
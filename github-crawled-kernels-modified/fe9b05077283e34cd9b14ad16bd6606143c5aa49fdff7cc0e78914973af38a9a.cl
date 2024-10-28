//{"dimx":0,"dimy":1,"dimz":2,"tab":4,"u0":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void pack_back(int dimx, int dimy, int dimz, global float* u0, global float* tab) {
  int xgid = get_global_id(0);
  int ygid = get_global_id(1);
  int zgid;
  if ((ygid >= 0) && (ygid < 4)) {
    for (zgid = 0; zgid < dimz; ++zgid) {
      tab[hook(4, xgid + dimx * (ygid + (zgid * 4)))] = u0[hook(3, (2 * 4 + dimx) * ((2 * 4 + dimy) * (zgid + 4) + (ygid + 4)) + xgid + 4)];
    }
  }
}
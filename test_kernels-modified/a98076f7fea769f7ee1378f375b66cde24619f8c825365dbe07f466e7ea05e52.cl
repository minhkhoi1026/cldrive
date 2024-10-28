//{"I":2,"L0":5,"Lm":4,"Lp":6,"O":3,"nx":0,"ny":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void blur2D_scanline(int nx, int ny, global float* I, global float* O) {
  local float L[32 * 3];
  local float* Lm = L;
  local float* L0 = L + 32;
  local float* Lp = L + 64;

  const int il = get_local_id(0);

  Lm[hook(4, il)] = I[hook(2, get_global_id(0))];
  L0[hook(5, il)] = I[hook(2, nx + get_global_id(0))];

  barrier(0x01);
  for (int iy = 1; iy < (ny - 1); iy++) {
    Lp[hook(6, il)] = I[hook(2, (iy + 1) * nx + get_global_id(0))];
    barrier(0x01);
    O[hook(3, iy * nx + get_global_id(0))] = (Lm[hook(4, il - 18 - 1)] + Lm[hook(4, il - 18)] + Lm[hook(4, il - 18 + 1)] + L0[hook(5, il - 1)] + L0[hook(5, il)] + L0[hook(5, il + 1)] + Lp[hook(6, il + 18 - 1)] + Lp[hook(6, il + 18)] + Lp[hook(6, il + 18 + 1)]) * 0.11111111111;
    barrier(0x01);
    local float* Ltmp = Lm;
    Lm = L0;
    L0 = Lp;
    Lp = Ltmp;
  }
}
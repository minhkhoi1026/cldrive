//{"b":0,"ldy":4,"ldz":5,"multiplier":6,"nx":1,"ny":2,"nz":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void block(global float* b, int nx, int ny, int nz, int ldy, int ldz, float multiplier) {
  const int i = get_global_id(0);
  if (i < (nz * ldz) + (ny * ldy) + nx)
    b[hook(0, i)] = b[hook(0, i)] * multiplier;
}
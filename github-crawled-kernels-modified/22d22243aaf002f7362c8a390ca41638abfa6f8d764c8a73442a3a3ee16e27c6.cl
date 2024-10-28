//{"A0":2,"Anext":3,"c0":0,"c1":1,"nx":4,"ny":5,"nz":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void naive_kernel(float c0, float c1, global float* A0, global float* Anext, int nx, int ny, int nz) {
  int i = get_global_id(0) + 1;
  int j = get_global_id(1) + 1;
  int k = get_global_id(2) + 1;

  if (i < nx - 1) {
    Anext[hook(3, ((i) + nx * ((j) + ny * (k))))] = c1 * (A0[hook(2, ((i) + nx * ((j) + ny * (k + 1))))] + A0[hook(2, ((i) + nx * ((j) + ny * (k - 1))))] + A0[hook(2, ((i) + nx * ((j + 1) + ny * (k))))] + A0[hook(2, ((i) + nx * ((j - 1) + ny * (k))))] + A0[hook(2, ((i + 1) + nx * ((j) + ny * (k))))] + A0[hook(2, ((i - 1) + nx * ((j) + ny * (k))))]) - A0[hook(2, ((i) + nx * ((j) + ny * (k))))] * c0;
  }
}
//{"Nx":2,"Ny":3,"a":0,"b":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void run(global const short* a, global short* b, const int Nx, const int Ny) {
  int i = get_global_id(0);
  int j = get_global_id(1);

  b[hook(1, i + Nx * j)] = 10 * i + j;
}
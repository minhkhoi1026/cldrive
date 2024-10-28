//{"E":1,"m":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_energy(global float* m, global float* E) {
  int i = get_global_id(0);
  float c = 299792458;
  E[hook(1, i)] = m[hook(0, i)] * c * c;
}
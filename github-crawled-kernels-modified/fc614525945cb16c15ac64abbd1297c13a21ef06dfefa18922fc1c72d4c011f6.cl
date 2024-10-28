//{"Mg":0,"d":2,"f_mag":3,"m":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_gravity(float Mg, global float* m, global float* d, global float* f_mag) {
  int i = get_global_id(0);

  float G = 0.00000000006673;

  f_mag[hook(3, i)] = (Mg * m[hook(1, i)] * G) / (d[hook(2, i)] * d[hook(2, i)]);
}
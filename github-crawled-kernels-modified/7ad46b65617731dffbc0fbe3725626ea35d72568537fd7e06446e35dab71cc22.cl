//{"dst":1,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void double_precision_check(global float* src, global float* dst) {
  int id = (int)get_global_id(0);
  double d0 = 0.12345678912345678 + src[hook(0, 1)];
  double d1 = 0.12355678922345678 + src[hook(0, 0)];
  float rem = d1 - d0;
  dst[hook(1, id)] = rem;
}
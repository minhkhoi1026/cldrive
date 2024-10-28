//{"dst":0,"gamma":3,"n":2,"src":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void power_law(global float* dst, global float* src, int n, float gamma) {
  unsigned int xgid = get_global_id(0);
  unsigned int ygid = get_global_id(1);

  unsigned int iid = ygid * n + xgid;

  unsigned int C = 1;

  dst[hook(0, iid)] = C * (pow(src[hook(1, iid)], gamma));
}
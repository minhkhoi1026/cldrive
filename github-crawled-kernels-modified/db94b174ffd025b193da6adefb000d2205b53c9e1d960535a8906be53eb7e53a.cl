//{"dst":0,"n":2,"src":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void negative(global float* dst, global float* src, int n) {
  unsigned int xgid = get_global_id(0);
  unsigned int ygid = get_global_id(1);

  unsigned int iid = ygid * n + xgid;
  unsigned int oid = xgid * n + ygid;

  dst[hook(0, iid)] = 255 - src[hook(1, iid)];
}
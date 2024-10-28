//{"dst":0,"n":2,"src":1,"thresh":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void linear_trnsfrm(global float* dst, global float* src, int n, int thresh) {
  unsigned int xgid = get_global_id(0);
  unsigned int ygid = get_global_id(1);

  unsigned int iid = ygid * n + xgid;
  if (src[hook(1, iid)] > thresh) {
    dst[hook(0, iid)] = 255;
  } else {
    dst[hook(0, iid)] = 0;
  }
}
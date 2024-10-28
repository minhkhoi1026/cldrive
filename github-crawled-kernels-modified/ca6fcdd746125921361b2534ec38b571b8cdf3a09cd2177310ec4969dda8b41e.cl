//{"dst":0,"height":3,"src":1,"width":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void transpose(global float* dst, global float* src, int width, int height) {
  unsigned int xgid = get_global_id(0);
  unsigned int ygid = get_global_id(1);

  unsigned int iid = ygid * width + xgid;
  unsigned int oid = xgid * height + ygid;

  dst[hook(0, oid)] = src[hook(1, iid)];
}
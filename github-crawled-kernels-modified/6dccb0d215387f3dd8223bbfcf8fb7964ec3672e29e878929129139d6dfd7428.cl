//{"imageIn_1":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void hdrvdp(global double4* imageIn_1) {
  return;
}
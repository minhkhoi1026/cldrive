//{"mem":0,"val":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void memset_float(global float* mem, float val) {
  mem[hook(0, get_global_id(0))] = val;
}
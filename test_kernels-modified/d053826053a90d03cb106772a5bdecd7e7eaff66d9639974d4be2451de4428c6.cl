//{"src":0,"val":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void set_array(global float* src, float val) {
  int gid = get_global_id(0);
  src[hook(0, gid)] = val;
}
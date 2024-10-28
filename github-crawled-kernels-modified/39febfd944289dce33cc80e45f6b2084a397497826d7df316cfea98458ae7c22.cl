//{"dst":1,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void fullCopy(global const unsigned int* src, global unsigned int* dst) {
  unsigned int gid = get_global_id(0);
  uint4 loaded = vload4(gid, src);
  vstore4(loaded, gid, dst);
}
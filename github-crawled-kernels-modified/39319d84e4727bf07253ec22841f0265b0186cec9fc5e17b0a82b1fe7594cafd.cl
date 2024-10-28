//{"alpha":1,"n":0,"offx":3,"x":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void fillbuffer(const int n, const char alpha, global char* x, const int offx) {
  for (int index = get_global_id(0); index < n; index += get_global_size(0)) {
    x[hook(2, index + offx)] = alpha;
  }
}
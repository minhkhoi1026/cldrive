//{"count":2,"in":0,"out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void mapBlock(global int* in, global int* out, const int count) {
  int x = get_global_id(0);
  int y = get_global_id(1);
  int width = get_global_size(0);

  int tid = (y * width) + x;
  if (tid < count) {
    out[hook(1, tid)] = in[hook(0, tid)];
  }
}
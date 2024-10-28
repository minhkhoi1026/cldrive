//{"count":2,"in":0,"out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void square(global int* in, global int* out, const int count) {
  int tid = get_global_id(0);
  if (tid < count) {
    int val = in[hook(0, tid)];
    out[hook(1, tid)] = val * val;
  }
}
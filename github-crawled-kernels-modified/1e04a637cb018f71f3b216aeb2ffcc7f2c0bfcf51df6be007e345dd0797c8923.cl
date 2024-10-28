//{"in":0,"len":2,"out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void sum(global const int* in, global int* out, const unsigned int len) {
  int i, t;

  i = get_global_id(0);
  if (i < len) {
    t = in[hook(0, i)];
    out[hook(1, i)] = (t * (t + 1)) / 2;
  }
}
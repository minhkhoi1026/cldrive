//{"data":2,"in":0,"out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void nn_add_local(global int* in, global int* out, local int* data) {
  int gX = get_global_id(0);
  int lX = get_local_id(0);
  int m = get_local_size(0);

  data[hook(2, lX)] = in[hook(0, gX)];
  if (lX == m - 1)
    data[hook(2, m)] = select(in[hook(0, gX + 1)], 0, gX == get_global_size(0) - 1);
  barrier(0x01);

  out[hook(1, gX)] = data[hook(2, lX)] + data[hook(2, lX + 1)];
}
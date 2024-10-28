//{"src":0,"src_size":3,"trgt":1,"work_per_workitem":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void op_coalesced(global const int* src, global int* trgt, int work_per_workitem, int src_size) {
  int i = get_global_id(0);

  while (i < src_size) {
    int r = src[hook(0, i)];
    trgt[hook(1, i)] = (r) / ((r) + 1010) + (r) / 1319 + (r) * ((r)-13);

    i += get_global_size(0);
  }
}
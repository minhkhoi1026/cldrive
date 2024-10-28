//{"data":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void localAddress(global float* data) {
  int id = get_local_id(0);

  data[hook(0, get_local_id(0) + get_group_id(0) * get_local_size(0))] = id;
}
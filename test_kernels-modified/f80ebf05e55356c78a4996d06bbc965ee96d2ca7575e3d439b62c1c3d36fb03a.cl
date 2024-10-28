//{"out":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void atomTest4(global int* out) {
  int lid = get_local_id(0);
  out[hook(0, 0)] = out[hook(0, 0)] + lid;
}
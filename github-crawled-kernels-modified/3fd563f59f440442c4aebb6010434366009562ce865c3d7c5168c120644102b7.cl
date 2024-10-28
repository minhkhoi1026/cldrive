//{"data":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void globalAddress(global float* data) {
  int id = get_global_id(0);
  data[hook(0, id)] = id;
}
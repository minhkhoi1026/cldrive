//{"data":0,"size":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void square(global int* data, unsigned int size) {
  unsigned int gid = get_global_id(0);
  if (gid < size) {
    data[hook(0, gid)] = data[hook(0, gid)] * data[hook(0, gid)];
  }
}
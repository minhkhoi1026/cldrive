//{"data":1,"index":2,"res":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void THClStorageGet(global float* res, global float* data, int index) {
  if (get_global_id(0) == 0) {
    res[hook(0, 0)] = data[hook(1, index)];
  }
}
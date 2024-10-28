//{"data":0,"index":1,"value":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void THClStorageSet(global float* data, int index, float value) {
  if (get_global_id(0) == 0) {
    data[hook(0, index)] = value;
  }
}
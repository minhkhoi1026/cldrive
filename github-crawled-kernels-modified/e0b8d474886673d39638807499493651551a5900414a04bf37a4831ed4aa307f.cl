//{"data":0,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void intragroup_hidden_race(global int* data, global int* output) {
  int id = get_local_id(0);
  output[hook(1, id)] = data[hook(0, 0)];
  barrier(0x01);
  if (id == 0) {
    data[hook(0, 0)] = -1;
  }
}
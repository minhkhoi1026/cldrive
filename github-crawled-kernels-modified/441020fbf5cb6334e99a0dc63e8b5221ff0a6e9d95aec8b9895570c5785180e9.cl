//{"data":0,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void naive_reduction(global float* data, global float* output) {
  float sum = 0.0;
  int lid = get_local_id(0);
  if (get_global_id(0) == 0) {
    for (int i = 0; i < 1048576; i++) {
      sum += data[hook(0, i)];
    }
  }
  *output = sum;
}
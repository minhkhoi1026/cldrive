//{"N":1,"data":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void foo(global float* data, int N) {
  int tid = get_global_id(0);
  if (tid < N) {
    data[hook(0, tid)] += 3.0f;
  }
}
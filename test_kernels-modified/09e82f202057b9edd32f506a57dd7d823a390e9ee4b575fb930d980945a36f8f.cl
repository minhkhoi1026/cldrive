//{"N":0,"x":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void simple(int N, global float* x) {
  int id = get_global_id(0);

  if (id < N)
    x[hook(1, id)] = id;
}
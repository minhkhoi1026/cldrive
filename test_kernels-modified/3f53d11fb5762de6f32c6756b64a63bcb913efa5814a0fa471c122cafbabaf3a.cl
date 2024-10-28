//{"a":1,"acc":2,"elements":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void reduce_serial(global const int* elements, global const float* a, global float* acc) {
  int i;

  for (i = 0; i < (*elements); ++i) {
    *acc += a[hook(1, i)];
  }
}
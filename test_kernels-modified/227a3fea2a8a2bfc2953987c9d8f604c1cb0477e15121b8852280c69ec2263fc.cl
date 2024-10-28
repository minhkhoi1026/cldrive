//{"a1":1,"a2":2,"out":3,"size":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void MSE(unsigned int size, global const float* a1, global const float* a2, global float* out) {
  unsigned int id = get_global_id(0);
  if (id < size) {
    out[hook(3, id)] = pown((a1[hook(1, id)] - a2[hook(2, id)]), 2);
  }
}
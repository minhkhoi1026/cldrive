//{"output":3,"size":0,"x":1,"y":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
typedef int2 int2;
;
;
;
;
;
;
kernel void Div(unsigned int size, global const float* x, global const float* y, global float* output) {
  unsigned int base = get_local_id(0) + (get_global_id(0) - get_local_id(0)) * 10;
  for (unsigned int i = 0; i < 10; i++) {
    unsigned int index = base + i * get_local_size(0);
    if (index < size) {
      output[hook(3, index)] = (x[hook(1, index)]) / (y[hook(2, index)]);
    }
  }
}
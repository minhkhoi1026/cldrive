//{"out":3,"size":0,"v":2,"x":1}
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
;
kernel void ScalarDiv(unsigned int size, global const float* x, float v, global float* out) {
  unsigned int base = get_local_id(0) + (get_global_id(0) - get_local_id(0)) * 10;
  for (unsigned int i = 0; i < 10; i++) {
    unsigned int index = base + i * get_local_size(0);
    if (index < size) {
      out[hook(3, index)] = (x[hook(1, index)]) / (v);
    }
  }
}
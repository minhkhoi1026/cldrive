//{"a":4,"in1":0,"in2":1,"offset":5,"out":2,"size":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void saxpy(global int* in1, global int* in2, global int* out, int size, float a, unsigned int offset) {
  int idx = get_global_id(0) + offset;

  if (idx >= 0 && idx < size) {
    out[hook(2, idx)] = (a * (float)in1[hook(0, idx)]) + in2[hook(1, idx)];
  }
}
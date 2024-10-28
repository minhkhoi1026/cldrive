//{"out":0,"outValues":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant int outVal = 42;
constant int outIndex = 7;
constant int outValues[16] = {17, 01, 11, 12, 1955, 11, 5, 1985, 113, 1, 24, 1984, 7, 23, 1979, 97};

kernel void constant_kernel(global int* out) {
  int tid = get_global_id(0);

  if (tid == 0) {
    out[hook(0, 0)] = outVal;
    out[hook(0, 1)] = outValues[hook(1, outIndex)];
  } else {
    out[hook(0, tid + 1)] = outValues[hook(1, tid)];
  }
}
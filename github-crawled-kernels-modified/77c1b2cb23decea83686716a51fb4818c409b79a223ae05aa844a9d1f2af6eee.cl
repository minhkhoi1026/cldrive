//{"coeff":1,"numTap":3,"output":0,"temp_input":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void FIR(global float* output, global float* coeff, global float* temp_input, unsigned int numTap) {
  unsigned int tid = get_global_id(0);
  unsigned int numData = get_global_size(0);
  unsigned int xid = tid + numTap - 1;

  float sum = 0;
  unsigned int i = 0;

  for (i = 0; i < numTap; i++) {
    sum += coeff[hook(1, i)] * temp_input[hook(2, tid + i)];
  }
  output[hook(0, tid)] = sum;
}
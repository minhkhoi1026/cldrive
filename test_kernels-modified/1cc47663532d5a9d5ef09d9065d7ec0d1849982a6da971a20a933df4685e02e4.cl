//{"coeff":1,"history":3,"input":2,"num_tap":4,"output":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void FIR(global float* output, global float* coeff, global float* input, global float* history, unsigned int num_tap) {
  unsigned int tid = get_global_id(0);
  unsigned int num_data = get_global_size(0);

  float sum = 0;
  unsigned int i = 0;
  for (i = 0; i < num_tap; i++) {
    if (tid >= i) {
      sum = sum + coeff[hook(1, i)] * input[hook(2, tid - i)];
    } else {
      sum = sum + coeff[hook(1, i)] * history[hook(3, num_tap - (i - tid))];
    }
  }
  output[hook(0, tid)] = sum;
}
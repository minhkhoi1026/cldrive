//{"coeff":2,"history":3,"input":0,"num_tap":4,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void FIR(global float* input, global float* output, global float* coeff, global float* history, unsigned int num_tap) {
  unsigned int tid = get_global_id(0);
  unsigned int num_data = get_global_size(0);

  float sum = 0;
  unsigned int i = 0;
  for (i = 0; i < num_tap; i++) {
    if (tid >= i) {
      sum = sum + coeff[hook(2, i)] * input[hook(0, tid - i)];
    } else {
      sum = sum + coeff[hook(2, i)] * history[hook(3, num_tap - (i - tid))];
    }
  }
  output[hook(1, tid)] = sum;

  barrier(0x02);

  if (tid >= num_data - num_tap) {
    history[hook(3, num_tap - (num_data - tid))] = input[hook(0, tid)];
  }

  barrier(0x02);
}
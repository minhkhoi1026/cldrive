//{"N":4,"filters":3,"input":0,"output":2,"table":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void mulAndSum(global float* input, global float* table, global float* output, int filters, int N) {
  int idx = get_global_id(0);
  output[hook(2, idx)] = 0;

  for (int i = 0; i < filters; i++)
    output[hook(2, idx)] += input[hook(0, i * N + idx)] * table[hook(1, i)];
}
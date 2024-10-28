//{"chids":1,"input":0,"k":3,"output":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void produce_fills(global const unsigned int* restrict input, global const unsigned int* restrict chids, global unsigned int* restrict output, private unsigned int k) {
  const unsigned int thread = get_global_id(0);
  const unsigned int idx_a = 2 * thread;
  const unsigned int idx_b = 2 * thread + 1;
  if (idx_a < k) {
    unsigned int inp_a = input[hook(0, idx_a)];
    unsigned int chi_a = chids[hook(1, idx_a)];
    output[hook(2, idx_a)] = (idx_a != 0 && inp_a == input[hook(0, idx_a - 1)]) ? chi_a - chids[hook(1, idx_a - 1)] - 1 : chi_a;
    if (idx_b < k) {
      output[hook(2, idx_b)] = (input[hook(0, idx_b)] == inp_a) ? chids[hook(1, idx_b)] - chi_a - 1 : chids[hook(1, idx_b)];
    }
  }
}
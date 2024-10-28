//{"N":9,"block_size":6,"nth_block":5,"num_blocks":7,"num_states":8,"obs":0,"state_comb_logp":4,"state_combs":2,"states":1,"trans_p":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void sample_state_blocked(global float* obs, global unsigned int* states, global unsigned int* state_combs, global float* trans_p, global float* state_comb_logp, unsigned int nth_block, unsigned int block_size, unsigned int num_blocks, unsigned int num_states, unsigned int N) {
  unsigned int kth_within_block = get_global_id(1);
  unsigned int nth_comb = get_global_id(0);
  unsigned int comb_offset = nth_comb * block_size;
  unsigned int eff_block_size = min(block_size, N - nth_block * block_size);

  if (kth_within_block > eff_block_size) {
    state_comb_logp[hook(4, comb_offset + kth_within_block)] = 0;
    return;
  }

  unsigned int is_beginning = nth_block == 0 && kth_within_block == 0;
  unsigned int is_end = nth_block == num_blocks - 1 && kth_within_block == eff_block_size - 1;
  unsigned int prev_state = (!is_beginning) * states[hook(1, (!is_beginning) * (nth_block * block_size + kth_within_block - 1))];

  float trans_logp = log(trans_p[hook(3, prev_state * (num_states + 1) + state_combs[chook(2, comb_offset + kth_within_block))]);
  trans_logp += is_end * log(trans_p[hook(3, state_combs[chook(2, comb_offset + kth_within_block) * (num_states + 1) + 0)]);

  state_comb_logp[hook(4, comb_offset + kth_within_block)] = trans_logp;
}
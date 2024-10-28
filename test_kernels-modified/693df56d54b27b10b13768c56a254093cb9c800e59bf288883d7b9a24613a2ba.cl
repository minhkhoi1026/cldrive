//{"diff":0,"n_noisy":2,"residual":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void init(global uchar* diff, global uchar* residual, const unsigned int n_noisy) {
  const int noisy_idx = get_global_id(0);
  if (noisy_idx < n_noisy) {
    diff[hook(0, noisy_idx)] = 0;
  }
  if (get_local_id(0) == 0)
    residual[hook(1, get_group_id(0))] = 0;
}
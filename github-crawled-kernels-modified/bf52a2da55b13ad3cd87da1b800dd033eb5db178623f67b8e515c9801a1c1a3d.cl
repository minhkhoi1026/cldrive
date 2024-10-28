//{"input":0,"output":1,"width":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void LaunchOrderTest(global int* input, global int* output, int width) {
  int gr_idx0 = get_group_id(0);
  int gr_idx1 = get_group_id(1);
  int n_gr0 = get_num_groups(0);
  int l_idx0 = get_local_id(0);
  int l_idx1 = get_local_id(1);
  int i, result;

  if ((l_idx0 | l_idx1) == 0)
    atomic_inc(input);

  for (i = 1; i < 10000; i++)
    ;
  barrier(0x02);
  result = input[hook(0, 0)];
  barrier(0x02);
  for (i = 1; i < 10000; i++)
    ;

  if ((l_idx0 | l_idx1) == 0)
    output[hook(1, gr_idx1 * n_gr0 + gr_idx0)] = result;
}
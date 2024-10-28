//{"ft_input":0,"n_v2":3,"offset":2,"output":4,"uv_ref":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void ft_to_vis2(global float2* ft_input, global unsigned int* uv_ref, private unsigned int offset, private unsigned int n_v2, global float* output) {
  size_t i = get_global_id(0);

  unsigned int uv_index = uv_ref[hook(1, i)];

  float2 temp = ft_input[hook(0, uv_index)];

  temp.s0 = temp.s0 * temp.s0 + temp.s1 * temp.s1;
  temp.s1 = 0;

  if (i < n_v2)
    output[hook(4, offset + i)] = temp.s0;
}
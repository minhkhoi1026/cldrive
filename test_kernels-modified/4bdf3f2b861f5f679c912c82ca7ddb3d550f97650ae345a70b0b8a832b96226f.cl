//{"((__global int4 *)input)":3,"((__global int4 *)output)":4,"in_size":2,"input":1,"output":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void prefixSum(global int* restrict output, global int* restrict input, const unsigned int in_size) {
  int4 tmp_buff;
  tmp_buff.s0 = 0;
  int size = in_size / 4;
  for (int i = 0; i < size; i++) {
    int4 in = ((global int4*)input)[hook(3, i)];
    tmp_buff.s1 = tmp_buff.s0 + in.s0;
    tmp_buff.s2 = tmp_buff.s1 + in.s1;
    tmp_buff.s3 = tmp_buff.s2 + in.s2;
    ((global int4*)output)[hook(4, i)] = tmp_buff;
    tmp_buff.s0 = tmp_buff.s3 + in.s3;
  }
}
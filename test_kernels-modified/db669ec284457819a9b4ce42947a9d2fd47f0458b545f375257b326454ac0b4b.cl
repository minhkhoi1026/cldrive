//{"loop_limit":1,"sum_buffer":3,"sum_out":0,"total_limit":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void ItermPrefixSum(global float2* sum_out, unsigned int loop_limit, unsigned int total_limit) {
  unsigned int id = get_global_id(0);
  unsigned int glbl_sz = get_global_size(0);
  unsigned int groupID = get_group_id(0);
  unsigned int lcl_id = get_local_id(0);

  local float2 sum_buffer[256];

  float2 my_sum = (float2)(0, 0);

  for (int i = id, k = 0; i < total_limit && k < loop_limit; i += 256, k++) {
    my_sum += sum_out[hook(0, i)];
  }

  sum_buffer[hook(3, lcl_id)] = my_sum;

  barrier(0x01);

  if (lcl_id < 128) {
    my_sum += sum_buffer[hook(3, lcl_id + 128)];
    sum_buffer[hook(3, lcl_id)] = my_sum;
  }
  barrier(0x01);
  if (lcl_id < 64) {
    my_sum += sum_buffer[hook(3, lcl_id + 64)];
    sum_buffer[hook(3, lcl_id)] = my_sum;
  }
  barrier(0x01);
  if (lcl_id < 32) {
    my_sum += sum_buffer[hook(3, lcl_id + 32)];
    sum_buffer[hook(3, lcl_id)] = my_sum;
  }
  barrier(0x01);
  if (lcl_id < 16) {
    my_sum += sum_buffer[hook(3, lcl_id + 16)];
    sum_buffer[hook(3, lcl_id)] = my_sum;
  }
  barrier(0x01);
  if (lcl_id < 8) {
    my_sum += sum_buffer[hook(3, lcl_id + 8)];
    sum_buffer[hook(3, lcl_id)] = my_sum;
  }
  barrier(0x01);
  if (lcl_id < 4) {
    my_sum += sum_buffer[hook(3, lcl_id + 4)];
    sum_buffer[hook(3, lcl_id)] = my_sum;
  }
  barrier(0x01);
  if (lcl_id < 2) {
    my_sum += sum_buffer[hook(3, lcl_id + 2)];
    sum_buffer[hook(3, lcl_id)] = my_sum;
  }
  barrier(0x01);
  if (lcl_id == 0) {
    my_sum += sum_buffer[hook(3, 1)];
    sum_out[hook(0, groupID)] = my_sum;
    ;
  }
}
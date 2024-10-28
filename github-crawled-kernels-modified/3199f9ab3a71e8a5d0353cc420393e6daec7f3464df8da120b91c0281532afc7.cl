//{"Block_log2":2,"IR_In":0,"IR_In_sz":3,"sum_buffer":4,"sum_out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void CopyIRKernel16bitInterSum(const global unsigned int* IR_In, global float2* sum_out, unsigned int Block_log2, unsigned int IR_In_sz) {
  unsigned int id = get_global_id(0);
  unsigned int glbl_sz = get_global_size(0);
  unsigned int groupID = get_group_id(0);
  unsigned int lcl_id = get_local_id(0);
  unsigned int id_rem = id - ((id >> Block_log2) << Block_log2);
  unsigned int id_out = ((id >> Block_log2) << (Block_log2 + 1)) + id_rem;

  local float2 sum_buffer[256];

  sum_buffer[hook(4, lcl_id)] = (float2)(0, 0);

  barrier(0x01);

  float2 IR_L = (float2)(0, 0);
  float2 IR_R = (float2)(0, 0);

  unsigned int IR = (id < IR_In_sz) ? IR_In[hook(0, id)] : 0;

  int i_L = (((int)(IR & 0xffff) << 16) >> 16);
  int i_R = ((int)IR >> 16);
  IR_L.s0 = (float)i_L;
  IR_R.s0 = (float)i_R;

  float2 my_sum = (float2)(IR_L.s0, IR_R.s0);

  sum_buffer[hook(4, lcl_id)] = my_sum;
  barrier(0x01);

  if (lcl_id < 128) {
    my_sum += sum_buffer[hook(4, lcl_id + 128)];
    sum_buffer[hook(4, lcl_id)] = my_sum;
  }
  barrier(0x01);
  if (lcl_id < 64) {
    my_sum += sum_buffer[hook(4, lcl_id + 64)];
    sum_buffer[hook(4, lcl_id)] = my_sum;
  }
  barrier(0x01);
  if (lcl_id < 32) {
    my_sum += sum_buffer[hook(4, lcl_id + 32)];
    sum_buffer[hook(4, lcl_id)] = my_sum;
  }
  barrier(0x01);
  if (lcl_id < 16) {
    my_sum += sum_buffer[hook(4, lcl_id + 16)];
    sum_buffer[hook(4, lcl_id)] = my_sum;
  }
  barrier(0x01);
  if (lcl_id < 8) {
    my_sum += sum_buffer[hook(4, lcl_id + 8)];
    sum_buffer[hook(4, lcl_id)] = my_sum;
  }
  barrier(0x01);
  if (lcl_id < 4) {
    my_sum += sum_buffer[hook(4, lcl_id + 4)];
    sum_buffer[hook(4, lcl_id)] = my_sum;
  }
  barrier(0x01);
  if (lcl_id < 2) {
    my_sum += sum_buffer[hook(4, lcl_id + 2)];
    sum_buffer[hook(4, lcl_id)] = my_sum;
  }
  barrier(0x01);
  if (lcl_id == 0) {
    my_sum += sum_buffer[hook(4, 1)];
    sum_out[hook(1, groupID)] = my_sum;
  }
}
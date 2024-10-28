//{"data":0,"group_result":2,"local_result":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void add_numbers(global float4* data, local float* local_result, global float* group_result) {
  float sum;
  float4 input1, input2, sum_vector;
  unsigned int global_addr, local_addr;

  global_addr = get_global_id(0) * 2;
  input1 = data[hook(0, global_addr)];
  input2 = data[hook(0, global_addr + 1)];
  sum_vector = input1 + input2;

  local_addr = get_local_id(0);
  local_result[hook(1, local_addr)] = sum_vector.s0 + sum_vector.s1 + sum_vector.s2 + sum_vector.s3;
  barrier(0x01);

  if (get_local_id(0) == 0) {
    sum = 0.0f;
    for (int i = 0; i < (int)get_local_size(0); i++) {
      sum += local_result[hook(1, i)];
    }
    group_result[hook(2, get_group_id(0))] = sum;
  }
}
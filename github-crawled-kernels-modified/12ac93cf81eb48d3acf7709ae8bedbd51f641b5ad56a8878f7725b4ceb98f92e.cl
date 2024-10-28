//{"input":0,"input_stride":1,"local_array":4,"output":2,"output_stride":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void unsupported_builtins(const global float4* input, int input_stride, global float4* output, int output_stride) {
  local float4 local_array[10];

  prefetch(input, input_stride);

  event_t event_1 = async_work_group_copy(local_array, input, sizeof(local_array) / sizeof(local_array[hook(4, 0)]), 0);

  event_t event_2 = async_work_group_copy(output, local_array, sizeof(local_array) / sizeof(local_array[hook(4, 0)]), 0);

  event_t event_3 = async_work_group_strided_copy(local_array, input, sizeof(local_array) / sizeof(local_array[hook(4, 0)]), input_stride, 0);

  event_t event_4 = async_work_group_strided_copy(output, local_array, sizeof(local_array) / sizeof(local_array[hook(4, 0)]), output_stride, 0);

  wait_group_events(1, &event_1);

  wait_group_events(1, &event_2);

  wait_group_events(1, &event_3);

  wait_group_events(1, &event_4);
}
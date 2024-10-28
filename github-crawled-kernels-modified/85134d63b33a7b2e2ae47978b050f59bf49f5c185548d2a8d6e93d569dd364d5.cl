//{"input_channel":3,"input_ptr":0,"output_channel":4,"output_ptr":1,"plane_number":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t SAMPLER = 0 | 4 | 0x10;
kernel void iohw2oihw(global const float* input_ptr, global float* output_ptr, int plane_number, int input_channel, int output_channel) {
  const int ic_index = get_global_id(0), oc_index = get_global_id(1);
  if (ic_index >= input_channel || oc_index >= output_channel) {
    return;
  }
  const int input_offset = (ic_index * output_channel + oc_index) * plane_number;
  const int output_offset = (oc_index * input_channel + ic_index) * plane_number;
  for (int i = 0; i < plane_number; ++i) {
    output_ptr[hook(1, output_offset + i)] = input_ptr[hook(0, input_offset + i)];
  }
}
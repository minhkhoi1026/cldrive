//{"((__global float *)conv)":2,"conv":1,"output_unpack":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void default_functionkernel3(global float* restrict output_unpack, global void* restrict conv) {
  output_unpack[hook(0, ((((((((int)get_group_id(2)) * 8) + ((int)get_local_id(2))) * 56) + ((int)get_group_id(1))) * 56) + ((int)get_group_id(0))))] = ((global float*)conv)[hook(2, ((((((((int)get_group_id(2)) * 2) + (((int)get_local_id(2)) / 4)) * 12544) + (((int)get_local_id(2)) % 4)) + (((int)get_group_id(1)) * 224)) + (((int)get_group_id(0)) * 4)))];
}
//{"img_input":0,"img_output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void vglClNdNot(global char* img_input, global char* img_output) {
  int coord = ((get_global_id(2) - get_global_offset(2)) * get_global_size(1) * get_global_size(0)) + ((get_global_id(1) - get_global_offset(1)) * get_global_size(0)) + (get_global_id(0) - get_global_offset(0));

  img_output[hook(1, coord)] = 255 - img_input[hook(0, coord)];
}
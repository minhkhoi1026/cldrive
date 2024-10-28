//{"img_input":0,"img_output":1,"thresh":2,"top":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void vglClNdThreshold(global char* img_input, global char* img_output, unsigned char thresh, unsigned char top) {
  int coord = ((get_global_id(2) - get_global_offset(2)) * get_global_size(1) * get_global_size(0)) + ((get_global_id(1) - get_global_offset(1)) * get_global_size(0)) + (get_global_id(0) - get_global_offset(0));

  img_output[hook(1, coord)] = img_input[hook(0, coord)];

  if (img_input[hook(0, coord)] > thresh)
    img_output[hook(1, coord)] = top;
  else
    img_output[hook(1, coord)] = 0;
}
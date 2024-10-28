//{"img_input1":0,"img_input2":1,"img_output":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void vglClNdBinMin(global unsigned char* img_input1, global unsigned char* img_input2, global unsigned char* img_output) {
  int coord = ((get_global_id(2) - get_global_offset(2)) * get_global_size(1) * get_global_size(0)) + ((get_global_id(1) - get_global_offset(1)) * get_global_size(0)) + (get_global_id(0) - get_global_offset(0));

  unsigned char p1 = img_input1[hook(0, coord)];
  unsigned char p2 = img_input2[hook(1, coord)];
  unsigned char result = p1 & p2;
  img_output[hook(2, coord)] = result;
}
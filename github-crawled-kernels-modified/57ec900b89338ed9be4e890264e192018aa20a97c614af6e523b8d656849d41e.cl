//{"img_input1":0,"img_input2":1,"output":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void vglClNdBinEqual(global unsigned char* img_input1, global unsigned char* img_input2, global char* output) {
  if (output[hook(2, 0)] == 1)
    return;

  int coord = ((get_global_id(2) - get_global_offset(2)) * get_global_size(1) * get_global_size(0)) + ((get_global_id(1) - get_global_offset(1)) * get_global_size(0)) + (get_global_id(0) - get_global_offset(0));

  unsigned char p1 = img_input1[hook(0, coord)];
  unsigned char p2 = img_input2[hook(1, coord)];

  if (!(p1 == p2)) {
    output[hook(2, 0)] = 1;
  }
}
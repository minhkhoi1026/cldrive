//{"channels_map":3,"chnl_stride":4,"current_bin":7,"frame_ln":6,"gbitreverse":2,"in":0,"out":1,"que_ln":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void amdFromQReverse(global const float* in, global float* out, global const short* gbitreverse, global const int* channels_map, int chnl_stride, int que_ln, int frame_ln, int current_bin) {
  int glbl_id = get_global_id(0);
  int chnl = channels_map[hook(3, get_group_id(1))];
  int chnl_off = chnl_stride * chnl;
  int bin = (glbl_id < get_global_size(0) / 2) ? current_bin : (current_bin - 1);
  int in_id = (glbl_id < get_global_size(0) / 2) ? glbl_id : glbl_id - get_global_size(0) / 2;
  bin = (bin < 0) ? que_ln - 1 : bin;

  int bin_off = bin * frame_ln;
  out[hook(1, gbitreverse[ghook(2, glbl_id) + get_global_size(0) * chnl)] = in[hook(0, in_id + chnl_off + bin_off)];
}
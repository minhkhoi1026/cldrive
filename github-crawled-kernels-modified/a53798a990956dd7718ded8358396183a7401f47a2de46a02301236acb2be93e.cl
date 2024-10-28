//{"channels_map":3,"chnl_stride":4,"gbitreverse":2,"in":0,"out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void amdFromSReverse(global const float* in, global float* out, global const short* gbitreverse, global const int* channels_map, int chnl_stride) {
  int glbl_id = get_global_id(0);
  int chnl = channels_map[hook(3, get_group_id(1))];
  int chnl_off = chnl_stride * chnl;

  out[hook(1, gbitreverse[ghook(2, glbl_id) + chnl_off)] = in[hook(0, glbl_id + chnl_off)];
}
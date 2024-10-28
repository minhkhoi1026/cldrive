//{"X":0,"Y":1,"region_height":7,"region_width":6,"source_height":5,"source_width":4,"target_factor":8,"target_height":3,"target_width":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void UP(global float* X, global float* Y, unsigned int target_width, unsigned int target_height, unsigned int source_width, unsigned int source_height, unsigned int region_width, unsigned int region_height, float target_factor) {
  unsigned int target_x = get_global_id(0);
  unsigned int target_y = get_global_id(1);
  unsigned int target_skid = get_global_id(2);

  unsigned int source_x = target_x / region_width;
  unsigned int source_y = target_y / region_height;

  unsigned int X_sk = source_width * source_height * target_skid;
  const unsigned int X_line = X_sk + (source_width * source_y);
  const unsigned int X_idx = X_line + source_x;
  const float X_val = X[hook(0, X_idx)];

  unsigned int Y_sk = target_width * target_height * target_skid;
  unsigned int Y_line = Y_sk + (target_width * target_y);
  unsigned int Y_idx = Y_line + target_x;
  Y[hook(1, Y_idx)] = X_val * target_factor;
}
//{"H":3,"W":2,"cosTheta":5,"dest_data":0,"sinTheta":4,"src_data":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void img_rotate(global float* dest_data, global float* src_data, int W, int H, float sinTheta, float cosTheta) {
  const int ix = get_global_id(0);
  const int iy = get_global_id(1);

  float xpos = ((float)ix) * cosTheta + ((float)iy) * sinTheta;
  float ypos = -1.0f * ((float)ix) * sinTheta + ((float)iy) * cosTheta;

  if (((int)xpos >= 0) && ((int)xpos < W) && ((int)ypos >= 0) && ((int)ypos < H)) {
    dest_data[hook(0, (int)ypos * W + (int)xpos)] = src_data[hook(1, iy * W + ix)];
  }
}
//{"H":3,"W":2,"cosTheta":5,"dest_data":1,"sinTheta":4,"src_data":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void image_rotate(global uchar* src_data, global uchar* dest_data, int W, int H, float sinTheta, float cosTheta) {
  const int ix = get_global_id(0);
  const int iy = get_global_id(1);

  float x0 = W / 2.0f;
  float y0 = H / 2.0f;

  float xOff = ix - x0;
  float yOff = iy - y0;

  int xpos = (int)(xOff * cosTheta + yOff * sinTheta + x0);
  int ypos = (int)(yOff * cosTheta - xOff * sinTheta + y0);

  if ((xpos >= 0) && (xpos < W) && (ypos >= 0) && (ypos < H)) {
    dest_data[hook(1, iy * W + ix)] = src_data[hook(0, ypos * W + xpos)];
  } else {
    dest_data[hook(1, iy * W + ix)] = 0;
  }
}
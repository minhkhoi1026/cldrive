//{"bottom":7,"d_dst":1,"d_src":0,"height":3,"left":4,"pitch":8,"right":6,"top":5,"width":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void pitch_comprison_0(global uchar* d_src, global uchar* d_dst, int width, int height, int left, int top, int right, int bottom, int pitch) {
  int x = left + get_global_id(0);
  int y = top + get_global_id(1);
  int idx = x + y * width;

  bool isInBound = x <= right && y <= bottom;

  short center = d_src[hook(0, idx)];
  short diff = (center - d_src[hook(0, idx - pitch)]) + (center - d_src[hook(0, idx + pitch)]);
  diff = diff >= 0 ? diff : -diff;

  if (isInBound) {
    d_dst[hook(1, idx)] = (uchar)(diff);
  }
}
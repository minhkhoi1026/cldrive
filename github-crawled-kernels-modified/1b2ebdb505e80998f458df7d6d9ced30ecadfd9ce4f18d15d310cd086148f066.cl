//{"datacost":0,"dispFinal":1,"dispRange":4,"dispScale":5,"height":3,"width":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void winner_takes_all(global float* datacost, global uchar* dispFinal, int width, int height, int dispRange, int dispScale) {
  int tx = get_local_id(0);
  int ty = get_local_id(1);
  int j = tx + get_group_id(0) * get_local_size(0);
  int i = ty + get_group_id(1) * get_local_size(1);

  float minCost = 0x1.fffffep127f;
  float cost = 0.0f;
  uchar disparity = 0;
  {
    for (int d = 0; d < dispRange; ++d) {
      cost = datacost[hook(0, dispRange * (width * i + j) + d)];
      if (minCost > cost) {
        minCost = cost;
        disparity = d;
      }
    }
    dispFinal[hook(1, i * width + j)] = disparity * (uchar)dispScale;
  }
}
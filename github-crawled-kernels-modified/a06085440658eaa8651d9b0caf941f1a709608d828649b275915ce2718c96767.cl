//{"c_warpMat":2,"cols":3,"rows":4,"xmap":0,"xmap_offset":7,"xmap_step":5,"ymap":1,"ymap_offset":8,"ymap_step":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void buildWarpAffineMaps(global float* xmap, global float* ymap, constant float* c_warpMat, int cols, int rows, int xmap_step, int ymap_step, int xmap_offset, int ymap_offset) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  if (x < cols && y < rows) {
    int xmap_index = mad24(y, xmap_step, x + xmap_offset);
    int ymap_index = mad24(y, ymap_step, x + ymap_offset);

    float xcoo = c_warpMat[hook(2, 0)] * x + c_warpMat[hook(2, 1)] * y + c_warpMat[hook(2, 2)];
    float ycoo = c_warpMat[hook(2, 3)] * x + c_warpMat[hook(2, 4)] * y + c_warpMat[hook(2, 5)];

    xmap[hook(0, xmap_index)] = xcoo;
    ymap[hook(1, ymap_index)] = ycoo;
  }
}
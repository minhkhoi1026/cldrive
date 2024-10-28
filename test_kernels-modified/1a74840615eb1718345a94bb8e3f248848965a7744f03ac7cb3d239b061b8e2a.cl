//{"endPtIds":2,"finalLoc":3,"input_image":0,"loc":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t sampler = 0 | 0 | 0x10;
bool checkRimCornerBool(global uchar* D, int idx, int idy, int sz_x, int r_rim);
void checkRimCorner(global uchar* D, int idx, int idy, int sz_x, int r_rim, uchar* pcol1, uchar* pcol2, uchar* pcol3);
void shrinkBox(global uchar* D, size_t* px, size_t* py, int w, int h, int sz_x);
void jointDetect(global uchar* D, size_t* px, size_t* py, int w, int h, int sz_x);
void binarySearch(int x1, int x2, int y1, int y2, int* x_ret, int* y_ret, int w, int h, global uchar* D);
uchar getColVal_colMajor(int x, int y, int w, int h, global uchar* D);
void shrinkLine(float x1, float x2, float y1, float y2, float d, read_only image2d_t input_image, float* px, float* py);
kernel void getLineCrossing(read_only image2d_t input_image, global float* loc, global int* endPtIds, global float* finalLoc) {
  size_t id = get_global_id(0);
  int endId1 = endPtIds[hook(2, id * 2)];
  int endId2 = endPtIds[hook(2, id * 2 + 1)];

  float x1 = loc[hook(1, 2 * endId1)];
  float y1 = loc[hook(1, 2 * endId1 + 1)];

  float x2 = loc[hook(1, 2 * endId2)];
  float y2 = loc[hook(1, 2 * endId2 + 1)];

  float d = sqrt((x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1));

  float x = (x1 + x2) / 2;
  float y = (y1 + y2) / 2;
  shrinkLine(x1, x2, y1, y2, d, input_image, &x, &y);

  finalLoc[hook(3, 2 * id)] = x;
  finalLoc[hook(3, 2 * id + 1)] = y;
}
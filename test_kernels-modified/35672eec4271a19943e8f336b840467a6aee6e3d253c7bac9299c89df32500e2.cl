//{"nPts":2,"out_image":0,"pts":1}
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
kernel void writeCorners(write_only image2d_t out_image, global float* pts, int nPts) {
  size_t p0 = get_global_id(0);
  int2 pos;
  float4 pixelf;

  int x = (int)pts[hook(1, p0 * 2)];
  int y = (int)pts[hook(1, p0 * 2 + 1)];

  int s = 5;
  int flag = 0;
  for (int i = -s; i < s; i++) {
    for (int j = -s; j < s; j++) {
      if (x + i >= 0 && x + i < 1080 && y + j >= 0 && y + j < 1920) {
        pos.x = y + j;
        pos.y = x + i;
        pixelf.x = 1.0;
        pixelf.y = 1.0;
        pixelf.z = 1.0;
        pixelf.w = 1.0;
        write_imagef(out_image, pos, pixelf);
      }
    }
  }
}
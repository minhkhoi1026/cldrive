//{"colPixel":2,"input_image":0,"loc":1}
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
kernel void getColPixels(read_only image2d_t input_image, global float* loc, global float* colPixel) {
  size_t id = get_global_id(0);

  float x = loc[hook(1, 2 * id)];
  float y = loc[hook(1, 2 * id + 1)];

  int2 pos;
  float4 pfBase;

  pos.y = floor(x + 0.5f);
  pos.x = floor(y + 0.5f);

  pfBase = read_imagef(input_image, sampler, pos);

  colPixel[hook(2, 3 * id)] = pfBase.x;
  colPixel[hook(2, 3 * id + 1)] = pfBase.y;
  colPixel[hook(2, 3 * id + 2)] = pfBase.z;
}
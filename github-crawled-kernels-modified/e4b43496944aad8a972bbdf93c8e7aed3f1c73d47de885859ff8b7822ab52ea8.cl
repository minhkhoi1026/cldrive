//{"aMaskSize":0,"dstImg":2,"srcImg":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t sampler = 0 | 2 | 0x10;
kernel void to_blur(int aMaskSize, read_only image2d_t srcImg, write_only image2d_t dstImg) {
  int global_id = get_global_id(0);
  int offset = aMaskSize / 2;
  int sum_r = 0;
  int sum_g = 0;
  int sum_b = 0;
  int width = get_image_width(srcImg);
  int height = get_image_height(srcImg);
  int row_n = global_id / width;
  int col_n = global_id % width;
  uint4 float3;
  int2 coord;
  int count = 0;

  for (int y = -offset; y <= offset; y++) {
    for (int x = -offset; x <= offset; x++) {
      coord = (int2)(col_n + x, row_n + y);
      if (coord.x < 0 || coord.x >= width || coord.y < 0 || coord.y >= height) {
        continue;
      }
      float3 = read_imageui(srcImg, sampler, coord);
      sum_r += float3.x;
      sum_g += float3.y;
      sum_b += float3.z;
      count += 1;
    }
  }
  float3.x = sum_r / count;
  float3.y = sum_g / count;
  float3.z = sum_b / count;
  coord = (int2)(col_n, row_n);
  write_imageui(dstImg, coord, float3);
}
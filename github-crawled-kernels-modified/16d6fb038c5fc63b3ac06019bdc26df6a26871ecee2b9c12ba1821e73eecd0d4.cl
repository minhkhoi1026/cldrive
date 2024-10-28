//{"filterhor":2,"filterver":3,"img1":0,"img2":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void sobel(read_only image2d_t img1, write_only image2d_t img2, constant int* filterhor, constant int* filterver) {
  const sampler_t smp = 0 | 4 | 0x10;
  int2 coord = (int2)(get_global_id(0), get_global_id(1));
  uint4 val = read_imageui(img1, smp, coord);
  if (coord.x > 1 && coord.y > 1 && coord.x < 511 && coord.y < 511) {
    uint4 val1 = read_imageui(img1, smp, (int2)(coord.x - 1, coord.y - 1));
    uint4 val2 = read_imageui(img1, smp, (int2)(coord.x, coord.y - 1));
    uint4 val3 = read_imageui(img1, smp, (int2)(coord.x + 1, coord.y - 1));
    uint4 val4 = read_imageui(img1, smp, (int2)(coord.x - 1, coord.y));
    uint4 val5 = read_imageui(img1, smp, (int2)(coord.x, coord.y));
    uint4 val6 = read_imageui(img1, smp, (int2)(coord.x + 1, coord.y));
    uint4 val7 = read_imageui(img1, smp, (int2)(coord.x - 1, coord.y + 1));
    uint4 val8 = read_imageui(img1, smp, (int2)(coord.x, coord.y + 1));
    uint4 val9 = read_imageui(img1, smp, (int2)(coord.x + 1, coord.y + 1));
    int x1 = filterhor[hook(2, 0)] * val1.x + filterhor[hook(2, 1)] * val2.x + filterhor[hook(2, 2)] * val3.x + filterhor[hook(2, 3)] * val4.x + filterhor[hook(2, 4)] * val5.x + filterhor[hook(2, 5)] * val6.x + filterhor[hook(2, 6)] * val7.x + filterhor[hook(2, 7)] * val8.x + filterhor[hook(2, 8)] * val9.x;
    int y1 = filterhor[hook(2, 0)] * val1.y + filterhor[hook(2, 1)] * val2.y + filterhor[hook(2, 2)] * val3.y + filterhor[hook(2, 3)] * val4.y + filterhor[hook(2, 4)] * val5.y + filterhor[hook(2, 5)] * val6.y + filterhor[hook(2, 6)] * val7.y + filterhor[hook(2, 7)] * val8.y + filterhor[hook(2, 8)] * val9.y;
    int z1 = filterhor[hook(2, 0)] * val1.z + filterhor[hook(2, 1)] * val2.z + filterhor[hook(2, 2)] * val3.z + filterhor[hook(2, 3)] * val4.z + filterhor[hook(2, 4)] * val5.z + filterhor[hook(2, 5)] * val6.z + filterhor[hook(2, 6)] * val7.z + filterhor[hook(2, 7)] * val8.z + filterhor[hook(2, 8)] * val9.z;
    int x2 = filterver[hook(3, 0)] * val1.x + filterver[hook(3, 1)] * val2.x + filterver[hook(3, 2)] * val3.x + filterver[hook(3, 3)] * val4.x + filterver[hook(3, 4)] * val5.x + filterver[hook(3, 5)] * val6.x + filterver[hook(3, 6)] * val7.x + filterver[hook(3, 7)] * val8.x + filterver[hook(3, 8)] * val9.x;
    int y2 = filterver[hook(3, 0)] * val1.y + filterver[hook(3, 1)] * val2.y + filterver[hook(3, 2)] * val3.y + filterver[hook(3, 3)] * val4.y + filterver[hook(3, 4)] * val5.y + filterver[hook(3, 5)] * val6.y + filterver[hook(3, 6)] * val7.y + filterver[hook(3, 7)] * val8.y + filterver[hook(3, 8)] * val9.y;
    int z2 = filterver[hook(3, 0)] * val1.z + filterver[hook(3, 1)] * val2.z + filterver[hook(3, 2)] * val3.z + filterver[hook(3, 3)] * val4.z + filterver[hook(3, 4)] * val5.z + filterver[hook(3, 5)] * val6.z + filterver[hook(3, 6)] * val7.z + filterver[hook(3, 7)] * val8.z + filterver[hook(3, 8)] * val9.z;
    val.x = sqrt((float)(x1 * x1 + x2 * x2));
    val.y = sqrt((float)(y1 * y1 + y2 * y2));
    val.z = sqrt((float)(z1 * z1 + z2 * z2));
  }
  write_imageui(img2, coord, val);
}
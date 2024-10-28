//{"dst":3,"height":2,"src":0,"width":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t nearestSampler = 0 | 2 | 0x10;
kernel void rgbtoyuyv(read_only image2d_t src, unsigned int width, unsigned int height, global uchar* dst) {
  unsigned int gx = get_global_id(0);
  unsigned int x = gx * 2;
  unsigned int gy = get_global_id(1);

  if ((x + 1 < width) & (gy < height)) {
    unsigned int off = (gy * width * 2) + (x * 2);

    uint4 value0 = read_imageui(src, nearestSampler, (int2){x, gy});
    uint4 value1 = read_imageui(src, nearestSampler, (int2){x + 1, gy});

    unsigned int Y0 = 16 + (65.738 / 256) * value0.x + (129.057 / 256) * value0.y + (25.064 / 256) * value0.z;
    unsigned int Cb0 = 128 - (37.945 / 256) * value0.x - (74.494 / 256) * value0.y + (112.439 / 256) * value0.z;
    unsigned int Cr0 = 128 + (112.439 / 256) * value0.x - (94.154 / 256) * value0.y - (18.285 / 256) * value0.z;

    unsigned int Y1 = 16 + (65.738 / 256) * value1.x + (129.057 / 256) * value1.y + (25.064 / 256) * value1.z;
    unsigned int Cb1 = 128 - (37.945 / 256) * value1.x - (74.494 / 256) * value1.y + (112.439 / 256) * value1.z;
    unsigned int Cr1 = 128 + (112.439 / 256) * value1.x - (94.154 / 256) * value1.y - (18.285 / 256) * value1.z;

    dst[hook(3, off)] = (Cb0 + Cb1) / 2.0;
    dst[hook(3, off + 1)] = Y0;
    dst[hook(3, off + 2)] = (Cr0 + Cr1) / 2.0;
    dst[hook(3, off + 3)] = Y1;
  }
}
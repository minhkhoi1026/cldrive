//{"dstImage":1,"saturatie":2,"srcImage":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void saturatieKernel(read_only image2d_t srcImage, write_only image2d_t dstImage, const float saturatie) {
  const sampler_t sampler = 1 | 6 | 0x10;
  int x = get_global_id(0);
  int y = get_global_id(1);
  int2 coords = (int2)(x, y);

  float4 currentPixel = (float4)0.0f;

  currentPixel = read_imagef(srcImage, sampler, coords);

  float Pr = 0.299f;
  float Pg = 0.587f;
  float Pb = 0.114f;

  float comp = (currentPixel.x) * (currentPixel.x) * Pr + (currentPixel.y) * (currentPixel.y) * Pg + (currentPixel.z) * (currentPixel.z) * Pb;
  float P = sqrt(comp);

  currentPixel.x = P + ((currentPixel.x) - P) * saturatie;
  currentPixel.y = P + ((currentPixel.y) - P) * saturatie;
  currentPixel.z = P + ((currentPixel.z) - P) * saturatie;

  write_imagef(dstImage, coords, currentPixel);
}
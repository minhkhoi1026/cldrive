//{"imageHeight":3,"imageWidth":2,"inputImage":0,"outputImage":1,"theta":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 0 | 0x20 | 4;
kernel void rotation(read_only image2d_t inputImage, write_only image2d_t outputImage, int imageWidth, int imageHeight, float theta) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  float x0 = imageWidth / 2.0f;
  float y0 = imageHeight / 2.0f;

  int xprime = x - x0;
  int yprime = y - y0;

  float sinTheta = sin(theta);
  float cosTheta = cos(theta);

  float2 readCoord;
  readCoord.x = xprime * cosTheta - yprime * sinTheta + x0;
  readCoord.y = xprime * sinTheta + yprime * cosTheta + y0;

  float value;
  value = read_imagef(inputImage, sampler, readCoord).x;

  write_imagef(outputImage, (int2)(x, y), (float4)(value, 0.f, 0.f, 0.f));
}
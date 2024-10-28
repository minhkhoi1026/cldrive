//{"UVOut":2,"YOut":1,"orX":3,"orY":4,"p":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
int clip(int x) {
  if (x > 255)
    return 255;

  if (x < 0)
    return 0;

  return x;
}

kernel void simple_write_shared(global unsigned char* p, write_only image2d_t YOut, write_only image2d_t UVOut, global int* orX, global int* orY) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);

  float4 pixel = (float4)0;
  float4 float3;

  int2 coord = (int2)(x, y);
  const sampler_t smp = 0x10;

  int width = 640;
  int amount = width * 480;
  int Y, U, V;
  float R, G, B;
  int originalY;

  int originX = *orX;
  int originY = *orY;

  int imageWidth = 1920;

  R = (int)p[hook(0, x / 2 * 4 + originX * 4 + 2 + y / 2 * imageWidth * 4 + originY * imageWidth * 4)];
  G = (int)p[hook(0, x / 2 * 4 + originX * 4 + 1 + y / 2 * imageWidth * 4 + originY * imageWidth * 4)];
  B = (int)p[hook(0, x / 2 * 4 + originX * 4 + 0 + y / 2 * imageWidth * 4 + originY * imageWidth * 4)];

  clip(R);
  clip(G);
  clip(B);

  R = R / 255.0;
  G = G / 255.0;
  B = B / 255.0;

  Y = (66 * R + 129 * G + 25 * B + 16);
  U = (-38 * R - 74 * G + 112 * B + 128);
  V = (112 * R - 94 * G - 18 * B + 128);

  pixel = (float4)(Y / 255.0, 0.0, 0.0, 0.0);
  write_imagef(YOut, coord, pixel);

  if (x % 2 == 0 && y % 2 == 0) {
    int2 coordUV = (int2)(x / 2, y / 2);
    pixel = (float4)(U / 255.0, V / 255.0, 0.0, 0.0);
    write_imagef(UVOut, coordUV, pixel);
  }
}
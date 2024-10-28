//{"gaussianBlur":4,"image":0,"pixels":3,"xRes":1,"yRes":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void gaussianBlurKernel(write_only image2d_t image, const int xRes, const int yRes, global const float* restrict pixels, const int gaussianBlur) {
  const int x = get_global_id(0) % xRes;
  const int y = get_global_id(0) / xRes;
  float r, g, b;

  if (gaussianBlur == 0) {
    r = pixels[hook(3, y * xRes * 3 + x * 3 + 0)];
    g = pixels[hook(3, y * xRes * 3 + x * 3 + 1)];
    b = pixels[hook(3, y * xRes * 3 + x * 3 + 2)];
  }

  else {
    const int yu = (y == yRes - 1) ? y : y + 1;
    const int yd = (y == 0) ? y : y - 1;
    const int xl = (x == 0) ? x : x - 1;
    const int xr = (x == xRes - 1) ? x : x + 1;

    r = (+1.0 * pixels[hook(3, yu * xRes * 3 + x * 3 + 0)] + 1.0 * pixels[hook(3, y * xRes * 3 + xr * 3 + 0)] + 4.0 * pixels[hook(3, y * xRes * 3 + x * 3 + 0)] + 1.0 * pixels[hook(3, y * xRes * 3 + xl * 3 + 0)] + 1.0 * pixels[hook(3, yd * xRes * 3 + x * 3 + 0)]) / 8.0;
    g = (+1.0 * pixels[hook(3, yu * xRes * 3 + x * 3 + 1)] + 1.0 * pixels[hook(3, y * xRes * 3 + xr * 3 + 1)] + 4.0 * pixels[hook(3, y * xRes * 3 + x * 3 + 1)] + 1.0 * pixels[hook(3, y * xRes * 3 + xl * 3 + 1)] + 1.0 * pixels[hook(3, yd * xRes * 3 + x * 3 + 1)]) / 8.0;
    b = (+1.0 * pixels[hook(3, yu * xRes * 3 + x * 3 + 2)] + 1.0 * pixels[hook(3, y * xRes * 3 + xr * 3 + 2)] + 4.0 * pixels[hook(3, y * xRes * 3 + x * 3 + 2)] + 1.0 * pixels[hook(3, y * xRes * 3 + xl * 3 + 2)] + 1.0 * pixels[hook(3, yd * xRes * 3 + x * 3 + 2)]) / 8.0;
  }

  int2 coord = {x, y};
  float4 colour = {r, g, b, 1.0};
  write_imagef(image, coord, colour);
}
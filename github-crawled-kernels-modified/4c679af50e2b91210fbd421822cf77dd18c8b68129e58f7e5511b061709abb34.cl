//{"height":4,"numRGBElements":2,"pixels":0,"pixelsOut":1,"width":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void blurry(global unsigned char* pixels, global unsigned char* pixelsOut, int numRGBElements, int width, int height) {
  const int i = get_global_id(0);
  pixelsOut[hook(1, i)] = ((pixels[hook(0, i - 3)] * 0.333) + (pixels[hook(0, i)] * 0.333) + (pixels[hook(0, i + 3)] * 0.333));
}
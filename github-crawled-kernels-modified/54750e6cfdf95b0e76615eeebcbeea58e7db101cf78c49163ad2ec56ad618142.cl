//{"height":3,"image":0,"result":1,"width":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline unsigned int pos2idx(unsigned int x, unsigned int y, unsigned int w) {
  return (y * w + x) * 3;
}

kernel void grayscale(const global uchar* restrict image, global uchar* result, unsigned int width, unsigned int height) {
  unsigned int x = get_global_id(0), y = get_global_id(1);

  unsigned int index = (y * width + x) * 3;
  uchar gray = 0.2126 * image[hook(0, index + 0)] + 0.7152 * image[hook(0, index + 1)] + 0.0722 * image[hook(0, index + 2)];
  result[hook(1, index + 0)] = gray;
  result[hook(1, index + 1)] = gray;
  result[hook(1, index + 2)] = gray;
}
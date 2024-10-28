//{"color_conversion_table":0,"image":1,"sz":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void color_space_transform(global unsigned int* color_conversion_table, global unsigned char* image, unsigned int sz) {
  size_t gx = get_global_id(0);

  if (gx < sz) {
    gx *= 3;

    unsigned char r = image[hook(1, gx + 0)];
    unsigned char g = image[hook(1, gx + 1)];
    unsigned char b = image[hook(1, gx + 2)];

    unsigned int ry = color_conversion_table[hook(0, 0 + r * 3 + 0)];
    unsigned int rcr = color_conversion_table[hook(0, 0 + r * 3 + 1)];
    unsigned int rcb = color_conversion_table[hook(0, 0 + r * 3 + 2)];

    unsigned int gy = color_conversion_table[hook(0, 768 + g * 3 + 0)];
    unsigned int gcr = color_conversion_table[hook(0, 768 + g * 3 + 1)];
    unsigned int gcb = color_conversion_table[hook(0, 768 + g * 3 + 2)];

    unsigned int by = color_conversion_table[hook(0, 1536 + b * 3 + 0)];
    unsigned int bcr = color_conversion_table[hook(0, 1536 + b * 3 + 1)];
    unsigned int bcb = color_conversion_table[hook(0, 1536 + b * 3 + 2)];

    image[hook(1, gx + 0)] = ((unsigned char)((ry + gy + by) >> 0x10));
    image[hook(1, gx + 1)] = ((unsigned char)((rcb + gcb + bcb) >> 0x10));
    image[hook(1, gx + 2)] = ((unsigned char)((rcr + gcr + bcr) >> 0x10));
  }
}
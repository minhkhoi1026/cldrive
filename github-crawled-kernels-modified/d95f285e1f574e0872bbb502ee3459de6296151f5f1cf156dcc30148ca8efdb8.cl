//{"height":3,"img":0,"result":1,"width":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void sort(int* a, int* b, int* c) {
  int swap;
  if (*a > *b) {
    swap = *a;
    *a = *b;
    *b = swap;
  }
  if (*a > *c) {
    swap = *a;
    *a = *c;
    *c = swap;
  }
  if (*b > *c) {
    swap = *b;
    *b = *c;
    *c = swap;
  }
}

kernel void medianFilter(global float* img, global float* result, global int* width, global int* height) {
  int w = *width;
  int h = *height;
  int posx = get_global_id(1);
  int posy = get_global_id(0);
  int i = w * posy + posx;

  if (posx == 0 || posy == 0 || posx == w - 1 || posy == h - 1) {
    result[hook(1, i)] = img[hook(0, i)];
  } else {
    int pixel00, pixel01, pixel02, pixel10, pixel11, pixel12, pixel20, pixel21, pixel22;
    pixel00 = img[hook(0, i - 1 - w)];
    pixel01 = img[hook(0, i - w)];
    pixel02 = img[hook(0, i + 1 - w)];
    pixel10 = img[hook(0, i - 1)];
    pixel11 = img[hook(0, i)];
    pixel12 = img[hook(0, i + 1)];
    pixel20 = img[hook(0, i - 1 + w)];
    pixel21 = img[hook(0, i + w)];
    pixel22 = img[hook(0, i + 1 + w)];

    sort(&(pixel00), &(pixel01), &(pixel02));
    sort(&(pixel10), &(pixel11), &(pixel12));
    sort(&(pixel20), &(pixel21), &(pixel22));

    sort(&(pixel00), &(pixel10), &(pixel20));
    sort(&(pixel01), &(pixel11), &(pixel21));
    sort(&(pixel02), &(pixel12), &(pixel22));

    sort(&(pixel00), &(pixel11), &(pixel22));

    result[hook(1, i)] = pixel11;
  }
}
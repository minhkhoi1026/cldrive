//{"img":1,"rst":0,"sz":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void histogram(global unsigned int* rst, constant unsigned int* img, constant unsigned int* sz) {
  unsigned int idx;

  for (idx = 0; idx < 768; ++idx)
    rst[hook(0, idx)] = 0;

  for (idx = 0; idx < *sz; idx += 3)
    rst[hook(0, img[ihook(1, idx))]++;

  rst += 256;
  for (idx = 1; idx < *sz; idx += 3)
    rst[hook(0, img[ihook(1, idx))]++;

  rst += 256;
  for (idx = 2; idx < *sz; idx += 3)
    rst[hook(0, img[ihook(1, idx))]++;
}
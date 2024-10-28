//{"I":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void imginit(write_only image2d_t I) {
  const int r = get_global_id(1);
  const int c = get_global_id(0);

  const int2 dim = get_image_dim(I);

  if (c >= dim.x || r >= dim.y)
    return;

  write_imagei(I, (int2)(c, r), (int4)(r - c, 0, 0, 0));
}
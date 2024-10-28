//{"pointsCount":2,"pointsList":1,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 0 | 0x10 | 4;
kernel void buildPointsList_basic(read_only image2d_t src, global unsigned int* pointsList, volatile global int* pointsCount) {
  int2 gid = {get_global_id(0), get_global_id(1)};
  if (any(gid >= get_image_dim(src)))
    return;

  float pix = read_imagef(src, sampler, gid).x;

  if (pix > 0.0f) {
    unsigned int coord = (gid.x << 16) | (gid.y & 0xFFFF);
    int idx = atomic_inc(pointsCount);
    pointsList[hook(1, idx)] = coord;
  }
}
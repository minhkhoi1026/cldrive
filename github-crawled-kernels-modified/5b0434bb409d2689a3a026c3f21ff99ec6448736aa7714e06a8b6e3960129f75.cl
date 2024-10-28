//{"cmax":3,"cmin":4,"img":0,"layer":2,"o":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void image(write_only image2d_t img, global double* o, int layer, double cmax, double cmin) {
  const sampler_t smp = 0 | 4 | 0x10;
  int2 coord = (int2)(get_global_id(0), get_global_id(1));
  int i = get_global_id(0) + get_global_id(1) * get_global_size(0) + layer * get_global_size(0) * get_global_size(1);
  float4 val;
  double e = o[hook(1, i)];
  if (e < 0) {
    val.x = fabs(e / cmin);
    val.y = 0;
    val.z = 0;
    val.w = 0;
  } else {
    val.x = 0;
    val.y = fabs(e / cmax);
    val.z = 0;
    val.w = 0;
  }
  write_imagef(img, coord, val);
}
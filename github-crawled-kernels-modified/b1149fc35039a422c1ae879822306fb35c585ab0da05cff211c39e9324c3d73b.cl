//{"out":7,"sb":0,"sbHeight":6,"sbPadding":4,"sbPitch":2,"sbStart":1,"sbStride":3,"sbWidth":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void energyMap(const global float2* sb, const unsigned int sbStart, const unsigned int sbPitch, const unsigned int sbStride, const unsigned int sbPadding, const unsigned int sbWidth, const unsigned int sbHeight, write_only image2d_t out) {
  int2 pos = (int2)(get_global_id(0), get_global_id(1));

  if (all(pos < (int2)(sbWidth, sbHeight))) {
    size_t idx = sbStart + pos.x + pos.y * sbStride;

    float minAbsH2 = (__builtin_inff());
    for (int n = 0; n < 6; ++n) {
      float2 h = sb[hook(0, idx + sbPitch * n)];

      minAbsH2 = fmin(minAbsH2, dot(h, h));
    }

    write_imagef(out, pos, 2 * sqrt(minAbsH2));
  }
}
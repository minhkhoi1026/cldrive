//{"abs_h_2":8,"out":7,"sb":0,"sbHeight":6,"sbPadding":4,"sbPitch":2,"sbStart":1,"sbStride":3,"sbWidth":5,"wx":9,"wy":10}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void energyMap(const global float2* sb, const unsigned int sbStart, const unsigned int sbPitch, const unsigned int sbStride, const unsigned int sbPadding, const unsigned int sbWidth, const unsigned int sbHeight, write_only image2d_t out) {
  int2 pos = (int2)(get_global_id(0), get_global_id(1));

  if (all(pos < (int2)(sbWidth, sbHeight))) {
    size_t idx = sbStart + pos.x + pos.y * sbStride;

    float abs_h_2[6];
    for (int n = 0; n < 6; ++n) {
      float2 h = sb[hook(0, idx + sbPitch * n)];

      abs_h_2[hook(8, n)] = dot(h, h);
    }

    float wx[] = {-1.4612, -3.2674, -4.3836, -4.3836, -3.2674, -1.461};
    float wy[] = {-4.3836, -3.2674, -1.4612, 1.4612, 3.2674, 4.3836};

    float H00 = 0, H11 = 0, H01 = 0;

    for (int n = 0; n < 6; ++n) {
      H00 -= wx[hook(9, n)] * wx[hook(9, n)] * abs_h_2[hook(8, n)];
      H11 -= wy[hook(10, n)] * wy[hook(10, n)] * abs_h_2[hook(8, n)];
      H01 -= wx[hook(9, n)] * wy[hook(10, n)] * abs_h_2[hook(8, n)];
    }

    float root = sqrt(H00 * H00 + H11 * H11 - 2.f * H11 * H00 + 4.f * H01 * H01);

    float l0 = -(H00 + H11 + root) / 2.f;
    float l1 = -(H00 + H11 - root) / 2.f;

    float result = l0 * l0 / (l1 + 0.1f);

    write_imagef(out, pos, result);
  }
}
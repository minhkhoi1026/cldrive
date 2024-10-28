//{"abs_h_2":8,"out":7,"sb":0,"sbHeight":6,"sbPadding":4,"sbPitch":2,"sbStart":1,"sbStride":3,"sbWidth":5}
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

    float energy = 0.f;
    for (int n = 0; n < 6; ++n) {
      float2 h = sb[hook(0, idx + sbPitch * n)];

      abs_h_2[hook(8, n)] = dot(h, h);

      energy += abs_h_2[hook(8, n)];
    }

    float e = sqrt(energy);

    float result = (sqrt(abs_h_2[hook(8, 0)] * abs_h_2[hook(8, 3)]) + sqrt(abs_h_2[hook(8, 1)] * abs_h_2[hook(8, 4)]) + sqrt(abs_h_2[hook(8, 2)] * abs_h_2[hook(8, 5)])) / fmax(1.e-6f, e) - 0.3f * e;

    write_imagef(out, pos, 4.f * result);
  }
}
//{"H":5,"W":4,"dst":2,"mask":1,"size":3,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 0 | 2 | 0x10;
kernel void process(read_only image2d_t src, constant float* mask, write_only image2d_t dst, private int size, private int W, private int H) {
  const int2 pos = {get_global_id(0), get_global_id(1)};

  unsigned int x, y;
  float4 value;
  float4 float3;
  int i, xOff, yOff, center;

  center = size / 2;

  if ((pos.x > center && pos.x < (W - center)) && (pos.y > center && pos.y < (H - center))) {
    value = (float4)(0, 0, 0, 0);
    for (y = 0; y < size; y++) {
      yOff = (y - center);
      for (x = 0; x < size; x++) {
        xOff = (x - center);

        float3 = read_imagef(src, sampler, (int2)(pos.x + xOff, pos.y + yOff));
        value.x += mask[hook(1, y * size + x)] * float3.x;
        value.y += mask[hook(1, y * size + x)] * float3.y;
        value.z += mask[hook(1, y * size + x)] * float3.z;
      }
    }
    write_imagef(dst, pos, value);

  } else {
    float3 = read_imagef(src, sampler, pos);
    write_imagef(dst, pos, float3);
  }
}
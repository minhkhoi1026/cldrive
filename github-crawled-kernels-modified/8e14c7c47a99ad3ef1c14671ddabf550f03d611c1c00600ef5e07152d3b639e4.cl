//{"dstImg":1,"mapxImg":2,"mapyImg":3,"srcImg":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t sampler = 0 | 2 | 0x10;
inline float4 readBayer(read_only image2d_t img, int2 xy, int2 sensorPattern) {
  float p1 = read_imagef(img, sampler, xy).s0;
  float p2 = read_imagef(img, sampler, xy + (int2)(1, 0)).s0;
  float p3 = read_imagef(img, sampler, xy + (int2)(0, 1)).s0;
  float p4 = read_imagef(img, sampler, xy + (int2)(1, 1)).s0;

  xy = (xy + sensorPattern) % 2;
  if (all(xy == (int2)(0, 0))) {
    return (float4)(p1, (p2 + p3) / 2, p4, 1);
  } else if (all(xy == (int2)(1, 0))) {
    return (float4)(p2, (p1 + p4) / 2, p3, 1);
  } else if (all(xy == (int2)(0, 1))) {
    return (float4)(p3, (p1 + p4) / 2, p2, 1);
  } else {
    return (float4)(p4, (p2 + p3) / 2, p1, 1);
  }
}

inline float4 readLinear(read_only image2d_t img, float2 xy) {
  int2 xy00 = convert_int2_rtn(xy);
  float4 img00 = read_imagef(img, sampler, xy00);
  float4 img10 = read_imagef(img, sampler, xy00 + (int2)(1, 0));
  float4 img01 = read_imagef(img, sampler, xy00 + (int2)(0, 1));
  float4 img11 = read_imagef(img, sampler, xy00 + (int2)(1, 1));
  float4 img0 = mix(img00, img10, xy.x - xy00.x);
  float4 img1 = mix(img01, img11, xy.x - xy00.x);
  return mix(img0, img1, xy.y - xy00.y);
}

inline float4 readBayerLinear(read_only image2d_t img, float2 xy, int2 sensorPattern) {
  int2 xy00 = convert_int2_rtn(xy);
  float4 img00 = readBayer(img, xy00, sensorPattern);
  float4 img10 = readBayer(img, xy00 + (int2)(1, 0), sensorPattern);
  float4 img01 = readBayer(img, xy00 + (int2)(0, 1), sensorPattern);
  float4 img11 = readBayer(img, xy00 + (int2)(1, 1), sensorPattern);
  float4 img0 = mix(img00, img10, xy.x - xy00.x);
  float4 img1 = mix(img01, img11, xy.x - xy00.x);
  return mix(img0, img1, xy.y - xy00.y);
}

kernel void remap(read_only image2d_t srcImg, write_only image2d_t dstImg, read_only image2d_t mapxImg, read_only image2d_t mapyImg) {
  int x = get_global_id(0), y = get_global_id(1);
  int2 xy = (int2)(x, y);

  if (x >= get_image_width(dstImg) || y >= get_image_height(dstImg)) {
    return;
  }

  float x2 = read_imagef(mapxImg, sampler, xy).s0;
  float y2 = read_imagef(mapyImg, sampler, xy).s0;
  float2 xy2 = (float2)(x2, y2);
  float4 rgb = readLinear(srcImg, xy2);
  write_imagef(dstImg, xy, rgb);
}
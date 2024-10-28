//{"delta":3,"origin":2,"srcField":1,"srcSize":0,"tgtField":7,"tgtSize":5,"tgtStride":6,"velocityScale":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float2 bilinear(float x, float y, float2 g00, float2 g10, float2 g01, float2 g11) {
  float a = (1.0 - x) * (1.0 - y);
  float b = x * (1.0 - y);
  float c = (1.0 - x) * y;
  float d = x * y;
  float u = g00.x * a + g10.x * b + g01.x * c + g11.x * d;
  float v = g00.y * a + g10.y * b + g01.y * c + g11.y * d;
  return (float2)(u, v);
}
float2 interpolate(float2 coord, uint2 srcSize, global float2* srcField) {
  int fi = floor(coord.x);

  int fj = floor(coord.y);

  unsigned int ci = min(fi + 1u, srcSize.x - 1u);
  unsigned int cj = min(fj + 1u, srcSize.y - 1u);

  int rowOfs = fj * srcSize.x;

  float2 g00 = srcField[hook(1, rowOfs + fi)];
  float2 g10 = srcField[hook(1, rowOfs + ci)];

  rowOfs = cj * srcSize.x;
  float2 g01 = srcField[hook(1, rowOfs + fi)];
  float2 g11 = srcField[hook(1, rowOfs + ci)];

  return bilinear(coord.x - fi, coord.y - fj, g00, g10, g01, g11);
}
float4 distortion(float2 latlon) {
  float H = 0.0000630957344f;
  float hu = latlon.x < 0 ? H : -H;
  float hv = latlon.y < 0 ? H : -H;
  float2 pu = (float2)(latlon.x + hu, latlon.y);
  float2 pv = (float2)(latlon.x, latlon.y + hv);

  float k = cos(latlon.y * 3.1415926535897932384626433832795f * 2.0 / 360.0);

  return (float4)((pu.x - latlon.x) / hu / k, (pu.y - latlon.y) / hu / k, (pv.x - latlon.x) / hv, (pv.y - latlon.y) / hv);
}

float2 distort(float2 latlon, float scale, float2 wind) {
  float2 uv = wind * scale;
  float4 d = distortion(latlon);

  wind.x = d.x * uv.x + d.z * uv.y;
  wind.y = d.y * uv.x + d.w * uv.y;

  return wind;
}
kernel void gridInterpolate(uint2 srcSize, global float2* srcField, float2 origin, float2 delta, float velocityScale, uint2 tgtSize, unsigned int tgtStride, global float2* tgtField) {
  uint2 tgtPoint = (uint2)(get_global_id(0), get_global_id(1));
  if (tgtSize.x == 0 || tgtSize.y == 0)
    return;

  float2 srcPoint = (float2)(clamp((float)(tgtPoint.x * srcSize.x) / (float)tgtSize.x, 0.0f, (float)srcSize.x - 0.1f), clamp((float)(tgtPoint.y * srcSize.y) / (float)tgtSize.y, 0.0f, (float)srcSize.y - 0.1f));
  float2 wind = interpolate(srcPoint, srcSize, srcField);

  float2 latlon;
  latlon.x = (srcPoint.x - origin.x);
  latlon.y = (origin.y - srcPoint.y);

  wind = distort(latlon, velocityScale, wind);

  tgtField[hook(7, tgtPoint.x + tgtPoint.y * tgtStride)] = wind;
}
//{"dest":1,"srce":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float minComp(float4 v) {
  float t = (v.x < v.y) ? v.x : v.y;
  t = (t < v.z) ? t : v.z;
  return t;
}

float maxComp(float4 v) {
  float t = (v.x > v.y) ? v.x : v.y;
  t = (t > v.z) ? t : v.z;
  return t;
}

float4 RGBtoHSV(float4 RGB) {
  float4 HSV = (float4)0.0f;
  float minVal = minComp(RGB);
  float maxVal = maxComp(RGB);
  float delta = maxVal - minVal;
  if (delta != 0.0f) {
    float4 delRGB = ((((float4)(maxVal)-RGB) / 6.0f) + (delta / 2.0f)) / delta;

    HSV.y = delta / maxVal;

    if (RGB.x == maxVal)
      HSV.x = delRGB.z - delRGB.y;
    else if (RGB.y == maxVal)
      HSV.x = (1.0 / 3.0) + delRGB.x - delRGB.z;
    else if (RGB.z == maxVal)
      HSV.x = (2.0 / 3.0) + delRGB.y - delRGB.x;

    if (HSV.x < 0.0f)
      HSV.x += 1.0f;
    if (HSV.x > 1.0f)
      HSV.x -= 1.0f;
  }
  HSV.z = maxVal;
  HSV.w = RGB.w;
  return (HSV);
}

float4 HSVtoRGB(float4 HSV) {
  float4 RGB = (float4)0.0f;
  if (HSV.z != 0.0f) {
    float var_h = HSV.x * 6.0f;
    float var_i = floor(var_h - 0.000001f);
    float var_1 = HSV.z * (1.0f - HSV.y);
    float var_2 = HSV.z * (1.0f - HSV.y * (var_h - var_i));
    float var_3 = HSV.z * (1.0f - HSV.y * (1 - (var_h - var_i)));
    switch ((int)(var_i)) {
      case 0:
        RGB = (float4)(HSV.z, var_3, var_1, HSV.w);
        break;
      case 1:
        RGB = (float4)(var_2, HSV.z, var_1, HSV.w);
        break;
      case 2:
        RGB = (float4)(var_1, HSV.z, var_3, HSV.w);
        break;
      case 3:
        RGB = (float4)(var_1, var_2, HSV.z, HSV.w);
        break;
      case 4:
        RGB = (float4)(HSV.z, var_1, var_2, HSV.w);
        break;
      default:
        RGB = (float4)(HSV.z, var_1, var_2, HSV.w);
        break;
    }
  }
  RGB.w = HSV.w;
  return (RGB);
}

kernel void clRGBtoHSV(read_only image2d_t srce, write_only image2d_t dest) {
  const sampler_t sampler = 0 | 0x10 | 4;
  int x = get_global_id(0);
  int y = get_global_id(1);
  int2 idx = (int2)(x, y);
  write_imagef(dest, idx, RGBtoHSV(read_imagef(srce, sampler, idx)));
}
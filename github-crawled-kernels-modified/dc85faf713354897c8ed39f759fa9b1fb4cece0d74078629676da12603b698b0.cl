//{"brightness":4,"d_output":0,"density":3,"imageH":2,"imageW":1,"invViewMatrix":7,"transferFunc":9,"transferOffset":5,"transferScale":6,"volume":8}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t volumeSampler = 1 | 6 | 0x20;
constant sampler_t transferFuncSampler = 1 | 2 | 0x20;
int intersectBox(float4 r_o, float4 r_d, float4 boxmin, float4 boxmax, float* tnear, float* tfar) {
  float4 invR = (float4)(1.0f, 1.0f, 1.0f, 1.0f) / r_d;
  float4 tbot = invR * (boxmin - r_o);
  float4 ttop = invR * (boxmax - r_o);

  float4 tmin = min(ttop, tbot);
  float4 tmax = max(ttop, tbot);

  float largest_tmin = max(max(tmin.x, tmin.y), max(tmin.x, tmin.z));
  float smallest_tmax = min(min(tmax.x, tmax.y), min(tmax.x, tmax.z));

  *tnear = largest_tmin;
  *tfar = smallest_tmax;

  return smallest_tmax > largest_tmin;
}

unsigned int rgbaFloatToInt(float4 rgba) {
  rgba.x = clamp(rgba.x, 0.0f, 1.0f);
  rgba.y = clamp(rgba.y, 0.0f, 1.0f);
  rgba.z = clamp(rgba.z, 0.0f, 1.0f);
  rgba.w = clamp(rgba.w, 0.0f, 1.0f);
  return ((unsigned int)(rgba.w * 255.0f) << 24) | ((unsigned int)(rgba.z * 255.0f) << 16) | ((unsigned int)(rgba.y * 255.0f) << 8) | (unsigned int)(rgba.x * 255.0f);
}

kernel void d_render(global unsigned int* d_output, unsigned int imageW, unsigned int imageH, float density, float brightness, float transferOffset, float transferScale, constant float* invViewMatrix, read_only image3d_t volume, read_only image2d_t transferFunc) {
  unsigned int x = get_global_id(0);
  unsigned int y = get_global_id(1);

  float u = (x / (float)imageW) * 2.0f - 1.0f;
  float v = (y / (float)imageH) * 2.0f - 1.0f;

  float4 boxMin = (float4)(-1.0f, -1.0f, -1.0f, 1.0f);
  float4 boxMax = (float4)(1.0f, 1.0f, 1.0f, 1.0f);

  float4 eyeRay_o;
  float4 eyeRay_d;

  eyeRay_o = (float4)(invViewMatrix[hook(7, 3)], invViewMatrix[hook(7, 7)], invViewMatrix[hook(7, 11)], 1.0f);

  float4 temp = normalize(((float4)(u, v, -2.0f, 0.0f)));
  eyeRay_d.x = dot(temp, ((float4)(invViewMatrix[hook(7, 0)], invViewMatrix[hook(7, 1)], invViewMatrix[hook(7, 2)], invViewMatrix[hook(7, 3)])));
  eyeRay_d.y = dot(temp, ((float4)(invViewMatrix[hook(7, 4)], invViewMatrix[hook(7, 5)], invViewMatrix[hook(7, 6)], invViewMatrix[hook(7, 7)])));
  eyeRay_d.z = dot(temp, ((float4)(invViewMatrix[hook(7, 8)], invViewMatrix[hook(7, 9)], invViewMatrix[hook(7, 10)], invViewMatrix[hook(7, 11)])));
  eyeRay_d.w = 0.0f;

  float tnear, tfar;
  int hit = intersectBox(eyeRay_o, eyeRay_d, boxMin, boxMax, &tnear, &tfar);
  if (!hit) {
    if ((x < imageW) && (y < imageH)) {
      unsigned int i = (y * imageW) + x;
      d_output[hook(0, i)] = 0;
    }
    return;
  }
  if (tnear < 0.0f)
    tnear = 0.0f;

  temp = (float4)(0.0f, 0.0f, 0.0f, 0.0f);
  float t = tfar;

  for (unsigned int i = 0; i < 500; i++) {
    float4 pos = eyeRay_o + eyeRay_d * t;
    pos = pos * 0.5f + 0.5f;

    float4 sample = read_imagef(volume, volumeSampler, pos);

    float2 transfer_pos = (float2)((sample.x - transferOffset) * transferScale, 0.5f);
    float4 col = read_imagef(transferFunc, transferFuncSampler, transfer_pos);

    float a = col.w * density;
    temp = mix(temp, col, (float4)(a, a, a, a));

    t -= 0.01f;
    if (t < tnear)
      break;
  }
  temp *= brightness;

  if ((x < imageW) && (y < imageH)) {
    unsigned int i = (y * imageW) + x;
    d_output[hook(0, i)] = rgbaFloatToInt(temp);
  }
}
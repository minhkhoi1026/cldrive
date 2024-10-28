//{"arg":12,"buffer":3,"input":0,"key":13,"length":2,"result":1,"rgb_to_xyz":5,"rgb_to_xyz[0]":4,"rgb_to_xyz[1]":6,"rgb_to_xyz[2]":7,"xyz_to_rgb":9,"xyz_to_rgb[0]":8,"xyz_to_rgb[1]":10,"xyz_to_rgb[2]":11}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float4 Lab_2_LCH(float4 Lab) {
  float H = atan2(Lab.z, Lab.y);

  H = (H > 0.0f) ? H / (2.0f * 3.14159265358979323846264338327950288f) : 1.0f - fabs(H) / (2.0f * 3.14159265358979323846264338327950288f);

  float L = Lab.x;
  float C = sqrt(Lab.y * Lab.y + Lab.z * Lab.z);

  return (float4)(L, C, H, Lab.w);
}

float4 LCH_2_Lab(float4 LCH) {
  float L = LCH.x;
  float a = cos(2.0f * 3.14159265358979323846264338327950288f * LCH.z) * LCH.y;
  float b = sin(2.0f * 3.14159265358979323846264338327950288f * LCH.z) * LCH.y;

  return (float4)(L, a, b, LCH.w);
}

float cbrt_5f(float f) {
  union {
    float f;
    unsigned int i;
  } p;
  p.f = f;
  p.i = p.i / 3 + 709921077;
  return p.f;
}

float cbrta_halleyf(float a, float R) {
  const float a3 = a * a * a;
  const float b = a * (a3 + R + R) / (a3 + a3 + R);
  return b;
}

float lab_f(float x) {
  const float epsilon = 216.0f / 24389.0f;
  const float kappa = 24389.0f / 27.0f;
  if (x > epsilon) {
    const float a = cbrt_5f(x);
    return cbrta_halleyf(a, x);
  } else
    return (kappa * x + 16.0f) / 116.0f;
}

float4 XYZ_to_Lab(float4 xyz) {
  float4 lab;
  const float4 d50 = (float4)(0.9642f, 1.0f, 0.8249f, 1.0f);

  xyz /= d50;
  xyz.x = lab_f(xyz.x);
  xyz.y = lab_f(xyz.y);
  xyz.z = lab_f(xyz.z);
  lab.x = 116.0f * xyz.y - 16.0f;
  lab.y = 500.0f * (xyz.x - xyz.y);
  lab.z = 200.0f * (xyz.y - xyz.z);

  return lab;
}

float4 lab_f_inv(float4 x) {
  const float4 epsilon = (float4)0.206896551f;
  const float4 kappa = (float4)(24389.0f / 27.0f);
  return (x > epsilon) ? x * x * x : (116.0f * x - (float4)16.0f) / kappa;
}

float4 Lab_to_XYZ(float4 Lab) {
  const float4 d50 = (float4)(0.9642f, 1.0f, 0.8249f, 0.0f);
  float4 f, XYZ;
  f.y = (Lab.x + 16.0f) / 116.0f;
  f.x = Lab.y / 500.0f + f.y;
  f.z = f.y - Lab.z / 200.0f;
  XYZ = d50 * lab_f_inv(f);

  return XYZ;
}

float4 prophotorgb_to_XYZ(float4 rgb) {
  const float rgb_to_xyz[3][3] = {
      {0.7976749f, 0.1351917f, 0.0313534f},
      {0.2880402f, 0.7118741f, 0.0000857f},
      {0.0000000f, 0.0000000f, 0.8252100f},
  };
  float4 XYZ = (float4)(0.0f, 0.0f, 0.0f, 0.0f);
  XYZ.x += rgb_to_xyz[hook(5, 0)][hook(4, 0)] * rgb.x;
  XYZ.x += rgb_to_xyz[hook(5, 0)][hook(4, 1)] * rgb.y;
  XYZ.x += rgb_to_xyz[hook(5, 0)][hook(4, 2)] * rgb.z;
  XYZ.y += rgb_to_xyz[hook(5, 1)][hook(6, 0)] * rgb.x;
  XYZ.y += rgb_to_xyz[hook(5, 1)][hook(6, 1)] * rgb.y;
  XYZ.y += rgb_to_xyz[hook(5, 1)][hook(6, 2)] * rgb.z;
  XYZ.z += rgb_to_xyz[hook(5, 2)][hook(7, 0)] * rgb.x;
  XYZ.z += rgb_to_xyz[hook(5, 2)][hook(7, 1)] * rgb.y;
  XYZ.z += rgb_to_xyz[hook(5, 2)][hook(7, 2)] * rgb.z;
  return XYZ;
}

float4 XYZ_to_prophotorgb(float4 XYZ) {
  const float xyz_to_rgb[3][3] = {
      {1.3459433f, -0.2556075f, -0.0511118f},
      {-0.5445989f, 1.5081673f, 0.0205351f},
      {0.0000000f, 0.0000000f, 1.2118128f},
  };
  float4 rgb = (float4)(0.0f, 0.0f, 0.0f, 0.0f);
  rgb.x += xyz_to_rgb[hook(9, 0)][hook(8, 0)] * XYZ.x;
  rgb.x += xyz_to_rgb[hook(9, 0)][hook(8, 1)] * XYZ.y;
  rgb.x += xyz_to_rgb[hook(9, 0)][hook(8, 2)] * XYZ.z;
  rgb.y += xyz_to_rgb[hook(9, 1)][hook(10, 0)] * XYZ.x;
  rgb.y += xyz_to_rgb[hook(9, 1)][hook(10, 1)] * XYZ.y;
  rgb.y += xyz_to_rgb[hook(9, 1)][hook(10, 2)] * XYZ.z;
  rgb.z += xyz_to_rgb[hook(9, 2)][hook(11, 0)] * XYZ.x;
  rgb.z += xyz_to_rgb[hook(9, 2)][hook(11, 1)] * XYZ.y;
  rgb.z += xyz_to_rgb[hook(9, 2)][hook(11, 2)] * XYZ.z;
  return rgb;
}

float4 Lab_to_prophotorgb(float4 Lab) {
  float4 XYZ = Lab_to_XYZ(Lab);
  return XYZ_to_prophotorgb(XYZ);
}

float4 prophotorgb_to_Lab(float4 rgb) {
  float4 XYZ = prophotorgb_to_XYZ(rgb);
  return XYZ_to_Lab(XYZ);
}

float4 RGB_2_HSL(const float4 RGB) {
  float H, S, L;

  float R = RGB.x;
  float G = RGB.y;
  float B = RGB.z;

  float var_Min = fmin(R, fmin(G, B));
  float var_Max = fmax(R, fmax(G, B));
  float del_Max = var_Max - var_Min;

  L = (var_Max + var_Min) / 2.0f;

  if (del_Max < 1e-6f) {
    H = 0.0f;
    S = 0.0f;
  } else {
    if (L < 0.5f)
      S = del_Max / (var_Max + var_Min);
    else
      S = del_Max / (2.0f - var_Max - var_Min);

    float del_R = (((var_Max - R) / 6.0f) + (del_Max / 2.0f)) / del_Max;
    float del_G = (((var_Max - G) / 6.0f) + (del_Max / 2.0f)) / del_Max;
    float del_B = (((var_Max - B) / 6.0f) + (del_Max / 2.0f)) / del_Max;

    if (R == var_Max)
      H = del_B - del_G;
    else if (G == var_Max)
      H = (1.0f / 3.0f) + del_R - del_B;
    else if (B == var_Max)
      H = (2.0f / 3.0f) + del_G - del_R;

    if (H < 0.0f)
      H += 1.0f;
    if (H > 1.0f)
      H -= 1.0f;
  }

  return (float4)(H, S, L, RGB.w);
}

float Hue_2_RGB(float v1, float v2, float vH) {
  if (vH < 0.0f)
    vH += 1.0f;
  if (vH > 1.0f)
    vH -= 1.0f;
  if ((6.0f * vH) < 1.0f)
    return (v1 + (v2 - v1) * 6.0f * vH);
  if ((2.0f * vH) < 1.0f)
    return (v2);
  if ((3.0f * vH) < 2.0f)
    return (v1 + (v2 - v1) * ((2.0f / 3.0f) - vH) * 6.0f);
  return (v1);
}

float4 HSL_2_RGB(const float4 HSL) {
  float R, G, B;

  float H = HSL.x;
  float S = HSL.y;
  float L = HSL.z;

  float var_1, var_2;

  if (S < 1e-6f) {
    R = B = G = L;
  } else {
    if (L < 0.5f)
      var_2 = L * (1.0f + S);
    else
      var_2 = (L + S) - (S * L);

    var_1 = 2.0f * L - var_2;

    R = Hue_2_RGB(var_1, var_2, H + (1.0f / 3.0f));
    G = Hue_2_RGB(var_1, var_2, H);
    B = Hue_2_RGB(var_1, var_2, H - (1.0f / 3.0f));
  }

  return (float4)(R, G, B, HSL.w);
}

float4 RGB_2_HSV(const float4 RGB) {
  float4 HSV;

  float minv = fmin(RGB.x, fmin(RGB.y, RGB.z));
  float maxv = fmax(RGB.x, fmax(RGB.y, RGB.z));
  float delta = maxv - minv;

  HSV.z = maxv;
  HSV.w = RGB.w;

  if (fabs(maxv) > 1e-6f && fabs(delta) > 1e-6f) {
    HSV.y = delta / maxv;
  } else {
    HSV.x = 0.0f;
    HSV.y = 0.0f;
    return HSV;
  }

  if (RGB.x == maxv)
    HSV.x = (RGB.y - RGB.z) / delta;
  else if (RGB.y == maxv)
    HSV.x = 2.0f + (RGB.z - RGB.x) / delta;
  else
    HSV.x = 4.0f + (RGB.x - RGB.y) / delta;

  HSV.x /= 6.0f;

  if (HSV.x < 0)
    HSV.x += 1.0f;

  return HSV;
}

float4 HSV_2_RGB(const float4 HSV) {
  float4 RGB;

  if (fabs(HSV.y) < 1e-6f) {
    RGB.x = RGB.y = RGB.z = HSV.z;
    RGB.w = HSV.w;
    return RGB;
  }

  int i = floor(6.0f * HSV.x);
  float v = HSV.z;
  float w = HSV.w;
  float p = v * (1.0f - HSV.y);
  float q = v * (1.0f - HSV.y * (6.0f * HSV.x - i));
  float t = v * (1.0f - HSV.y * (1.0f - (6.0f * HSV.x - i)));

  switch (i) {
    case 0:
      RGB = (float4)(v, t, p, w);
      break;
    case 1:
      RGB = (float4)(q, v, p, w);
      break;
    case 2:
      RGB = (float4)(p, v, t, w);
      break;
    case 3:
      RGB = (float4)(p, q, v, w);
      break;
    case 4:
      RGB = (float4)(t, p, v, w);
      break;
    case 5:
    default:
      RGB = (float4)(v, p, q, w);
      break;
  }
  return RGB;
}

float4 XYZ_to_sRGB(float4 XYZ) {
  float4 sRGB;

  sRGB.x = 3.1338561f * XYZ.x - 1.6168667f * XYZ.y - 0.4906146f * XYZ.z;
  sRGB.y = -0.9787684f * XYZ.x + 1.9161415f * XYZ.y + 0.0334540f * XYZ.z;
  sRGB.z = 0.0719453f * XYZ.x - 0.2289914f * XYZ.y + 1.4052427f * XYZ.z;
  sRGB.w = XYZ.w;

  return sRGB;
}

float4 sRGB_to_XYZ(float4 sRGB) {
  float4 XYZ;

  XYZ.x = 0.4360747f * sRGB.x + 0.3850649f * sRGB.y + 0.1430804f * sRGB.z;
  XYZ.y = 0.2225045f * sRGB.x + 0.7168786f * sRGB.y + 0.0606169f * sRGB.z;
  XYZ.z = 0.0139322f * sRGB.x + 0.0971045f * sRGB.y + 0.7141733f * sRGB.z;
  XYZ.w = sRGB.w;

  return XYZ;
}

float GAUSS(float center, float wings, float x) {
  const float b = -1.0f + center * 2.0f;
  const float c = (wings / 10.0f) / 2.0f;
  return exp(-(x - b) * (x - b) / (c * c));
}

typedef enum _channelmixer_output_t { CHANNEL_HUE = 0, CHANNEL_SATURATION, CHANNEL_LIGHTNESS, CHANNEL_RED, CHANNEL_GREEN, CHANNEL_BLUE, CHANNEL_GRAY, CHANNEL_SIZE } _channelmixer_output_t;

void encrypt_tea(unsigned int* arg) {
  const unsigned int key[] = {0xa341316c, 0xc8013ea4, 0xad90777d, 0x7e95761e};
  unsigned int v0 = arg[hook(12, 0)], v1 = arg[hook(12, 1)];
  unsigned int sum = 0;
  unsigned int delta = 0x9e3779b9;
  for (int i = 0; i < 8; i++) {
    sum += delta;
    v0 += ((v1 << 4) + key[hook(13, 0)]) ^ (v1 + sum) ^ ((v1 >> 5) + key[hook(13, 1)]);
    v1 += ((v0 << 4) + key[hook(13, 2)]) ^ (v0 + sum) ^ ((v0 >> 5) + key[hook(13, 3)]);
  }
  arg[hook(12, 0)] = v0;
  arg[hook(12, 1)] = v1;
}

float tpdf(unsigned int urandom) {
  float frandom = (float)urandom / 0xFFFFFFFFu;

  return (frandom < 0.5f ? (sqrt(2.0f * frandom) - 1.0f) : (1.0f - sqrt(2.0f * (1.0f - frandom))));
}

kernel void pixelmax_second(global float* input, global float* result, const int length, local float* buffer) {
  int x = get_global_id(0);
  float accu = -(__builtin_inff());

  while (x < length) {
    float element = input[hook(0, x)];
    accu = (accu > element) ? accu : element;
    x += get_global_size(0);
  }

  int lid = get_local_id(0);
  buffer[hook(3, lid)] = accu;

  barrier(0x01);

  for (int offset = get_local_size(0) / 2; offset > 0; offset = offset / 2) {
    if (lid < offset) {
      float other = buffer[hook(3, lid + offset)];
      float mine = buffer[hook(3, lid)];
      buffer[hook(3, lid)] = (mine > other) ? mine : other;
    }
    barrier(0x01);
  }

  if (lid == 0) {
    result[hook(1, get_group_id(0))] = buffer[hook(3, 0)];
  }
}
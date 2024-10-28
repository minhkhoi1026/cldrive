//{"height":2,"mask":0,"parameters":13,"rgb_to_xyz":5,"rgb_to_xyz[0]":4,"rgb_to_xyz[1]":6,"rgb_to_xyz[2]":7,"scaled":12,"value":3,"width":1,"xyz_to_rgb":9,"xyz_to_rgb[0]":8,"xyz_to_rgb[1]":10,"xyz_to_rgb[2]":11}
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

typedef enum dt_develop_blend_mode_t { DEVELOP_BLEND_MASK_FLAG = 0x80, DEVELOP_BLEND_DISABLED = 0x00, DEVELOP_BLEND_NORMAL = 0x01, DEVELOP_BLEND_LIGHTEN = 0x02, DEVELOP_BLEND_DARKEN = 0x03, DEVELOP_BLEND_MULTIPLY = 0x04, DEVELOP_BLEND_AVERAGE = 0x05, DEVELOP_BLEND_ADD = 0x06, DEVELOP_BLEND_SUBSTRACT = 0x07, DEVELOP_BLEND_DIFFERENCE = 0x08, DEVELOP_BLEND_SCREEN = 0x09, DEVELOP_BLEND_OVERLAY = 0x0A, DEVELOP_BLEND_SOFTLIGHT = 0x0B, DEVELOP_BLEND_HARDLIGHT = 0x0C, DEVELOP_BLEND_VIVIDLIGHT = 0x0D, DEVELOP_BLEND_LINEARLIGHT = 0x0E, DEVELOP_BLEND_PINLIGHT = 0x0F, DEVELOP_BLEND_LIGHTNESS = 0x10, DEVELOP_BLEND_CHROMA = 0x11, DEVELOP_BLEND_HUE = 0x12, DEVELOP_BLEND_COLOR = 0x13, DEVELOP_BLEND_INVERSE = 0x14, DEVELOP_BLEND_UNBOUNDED = 0x15, DEVELOP_BLEND_COLORADJUST = 0x16, DEVELOP_BLEND_DIFFERENCE2 = 0x17, DEVELOP_BLEND_NORMAL2 = 0x18, DEVELOP_BLEND_BOUNDED = 0x19, DEVELOP_BLEND_LAB_LIGHTNESS = 0x1A, DEVELOP_BLEND_LAB_COLOR = 0x1B, DEVELOP_BLEND_HSV_LIGHTNESS = 0x1C, DEVELOP_BLEND_HSV_COLOR = 0x1D, DEVELOP_BLEND_LAB_L = 0x1E, DEVELOP_BLEND_LAB_A = 0x1F, DEVELOP_BLEND_LAB_B = 0x20, DEVELOP_BLEND_RGB_R = 0x21, DEVELOP_BLEND_RGB_G = 0x22, DEVELOP_BLEND_RGB_B = 0x23 } dt_develop_blend_mode_t;

typedef enum dt_develop_mask_mode_t { DEVELOP_MASK_DISABLED = 0x00, DEVELOP_MASK_ENABLED = 0x01, DEVELOP_MASK_MASK = 0x02, DEVELOP_MASK_CONDITIONAL = 0x04, DEVELOP_MASK_BOTH = (DEVELOP_MASK_MASK | DEVELOP_MASK_CONDITIONAL) } dt_develop_mask_mode_t;

typedef enum dt_develop_mask_combine_mode_t { DEVELOP_COMBINE_NORM = 0x00, DEVELOP_COMBINE_INV = 0x01, DEVELOP_COMBINE_EXCL = 0x00, DEVELOP_COMBINE_INCL = 0x02, DEVELOP_COMBINE_MASKS_POS = 0x04, DEVELOP_COMBINE_NORM_EXCL = (DEVELOP_COMBINE_NORM | DEVELOP_COMBINE_EXCL), DEVELOP_COMBINE_NORM_INCL = (DEVELOP_COMBINE_NORM | DEVELOP_COMBINE_INCL), DEVELOP_COMBINE_INV_EXCL = (DEVELOP_COMBINE_INV | DEVELOP_COMBINE_EXCL), DEVELOP_COMBINE_INV_INCL = (DEVELOP_COMBINE_INV | DEVELOP_COMBINE_INCL) } dt_develop_mask_combine_mode_t;

typedef enum iop_cs_t { iop_cs_Lab, iop_cs_rgb, iop_cs_RAW } iop_cs_t;

typedef enum dt_develop_blendif_channels_t {
  DEVELOP_BLENDIF_L_in = 0,
  DEVELOP_BLENDIF_A_in = 1,
  DEVELOP_BLENDIF_B_in = 2,

  DEVELOP_BLENDIF_L_out = 4,
  DEVELOP_BLENDIF_A_out = 5,
  DEVELOP_BLENDIF_B_out = 6,

  DEVELOP_BLENDIF_GRAY_in = 0,
  DEVELOP_BLENDIF_RED_in = 1,
  DEVELOP_BLENDIF_GREEN_in = 2,
  DEVELOP_BLENDIF_BLUE_in = 3,

  DEVELOP_BLENDIF_GRAY_out = 4,
  DEVELOP_BLENDIF_RED_out = 5,
  DEVELOP_BLENDIF_GREEN_out = 6,
  DEVELOP_BLENDIF_BLUE_out = 7,

  DEVELOP_BLENDIF_C_in = 8,
  DEVELOP_BLENDIF_h_in = 9,

  DEVELOP_BLENDIF_C_out = 12,
  DEVELOP_BLENDIF_h_out = 13,

  DEVELOP_BLENDIF_H_in = 8,
  DEVELOP_BLENDIF_S_in = 9,
  DEVELOP_BLENDIF_l_in = 10,

  DEVELOP_BLENDIF_H_out = 12,
  DEVELOP_BLENDIF_S_out = 13,
  DEVELOP_BLENDIF_l_out = 14,

  DEVELOP_BLENDIF_MAX = 14,
  DEVELOP_BLENDIF_unused = 15,

  DEVELOP_BLENDIF_active = 31,

  DEVELOP_BLENDIF_SIZE = 16,

  DEVELOP_BLENDIF_Lab_MASK = 0x3377,
  DEVELOP_BLENDIF_RGB_MASK = 0x77FF
} dt_develop_blendif_channels_t;

typedef enum dt_dev_pixelpipe_display_mask_t { DT_DEV_PIXELPIPE_DISPLAY_NONE = 0, DT_DEV_PIXELPIPE_DISPLAY_MASK = 1 << 0, DT_DEV_PIXELPIPE_DISPLAY_CHANNEL = 1 << 1, DT_DEV_PIXELPIPE_DISPLAY_OUTPUT = 1 << 2, DT_DEV_PIXELPIPE_DISPLAY_L = 1 << 3, DT_DEV_PIXELPIPE_DISPLAY_a = 2 << 3, DT_DEV_PIXELPIPE_DISPLAY_b = 3 << 3, DT_DEV_PIXELPIPE_DISPLAY_R = 4 << 3, DT_DEV_PIXELPIPE_DISPLAY_G = 5 << 3, DT_DEV_PIXELPIPE_DISPLAY_B = 6 << 3, DT_DEV_PIXELPIPE_DISPLAY_GRAY = 7 << 3, DT_DEV_PIXELPIPE_DISPLAY_LCH_C = 8 << 3, DT_DEV_PIXELPIPE_DISPLAY_LCH_h = 9 << 3, DT_DEV_PIXELPIPE_DISPLAY_HSL_H = 10 << 3, DT_DEV_PIXELPIPE_DISPLAY_HSL_S = 11 << 3, DT_DEV_PIXELPIPE_DISPLAY_HSL_l = 12 << 3, DT_DEV_PIXELPIPE_DISPLAY_ANY = (~0) << 2 } dt_dev_pixelpipe_display_mask_t;

float blendif_factor_Lab(const float4 input, const float4 output, const unsigned int blendif, global const float* parameters, const unsigned int mask_mode, const unsigned int mask_combine) {
  float result = 1.0f;
  float scaled[DEVELOP_BLENDIF_SIZE];

  if (!(mask_mode & DEVELOP_MASK_CONDITIONAL))
    return (mask_combine & DEVELOP_COMBINE_INCL) ? 0.0f : 1.0f;

  scaled[hook(12, DEVELOP_BLENDIF_L_in)] = clamp(input.x / 100.0f, 0.0f, 1.0f);
  scaled[hook(12, DEVELOP_BLENDIF_A_in)] = clamp((input.y + 128.0f) / 256.0f, 0.0f, 1.0f);
  scaled[hook(12, DEVELOP_BLENDIF_B_in)] = clamp((input.z + 128.0f) / 256.0f, 0.0f, 1.0f);

  scaled[hook(12, DEVELOP_BLENDIF_L_out)] = clamp(output.x / 100.0f, 0.0f, 1.0f);
  scaled[hook(12, DEVELOP_BLENDIF_A_out)] = clamp((output.y + 128.0f) / 256.0f, 0.0f, 1.0f);
  scaled[hook(12, DEVELOP_BLENDIF_B_out)] = clamp((output.z + 128.0f) / 256.0f, 0.0f, 1.0f);

  if ((blendif & 0x7f00) != 0) {
    float4 LCH_input = Lab_2_LCH(input);
    float4 LCH_output = Lab_2_LCH(output);

    scaled[hook(12, DEVELOP_BLENDIF_C_in)] = clamp(LCH_input.y / (128.0f * sqrt(2.0f)), 0.0f, 1.0f);
    scaled[hook(12, DEVELOP_BLENDIF_h_in)] = clamp(LCH_input.z, 0.0f, 1.0f);

    scaled[hook(12, DEVELOP_BLENDIF_C_out)] = clamp(LCH_output.y / (128.0f * sqrt(2.0f)), 0.0f, 1.0f);
    scaled[hook(12, DEVELOP_BLENDIF_h_out)] = clamp(LCH_output.z, 0.0f, 1.0f);
  }

  for (int ch = 0; ch <= DEVELOP_BLENDIF_MAX; ch++) {
    if ((DEVELOP_BLENDIF_Lab_MASK & (1 << ch)) == 0)
      continue;

    if ((blendif & (1 << ch)) == 0) {
      result *= (!(blendif & (1 << (ch + 16)))) == (!(mask_combine & DEVELOP_COMBINE_INCL)) ? 1.0f : 0.0f;
      continue;
    }

    if (result <= 0.000001f)
      break;

    float factor;

    if (scaled[hook(12, ch)] >= parameters[hook(13, 4 * ch + 1)] && scaled[hook(12, ch)] <= parameters[hook(13, 4 * ch + 2)]) {
      factor = 1.0f;
    } else if (scaled[hook(12, ch)] > parameters[hook(13, 4 * ch + 0)] && scaled[hook(12, ch)] < parameters[hook(13, 4 * ch + 1)]) {
      factor = (scaled[hook(12, ch)] - parameters[hook(13, 4 * ch + 0)]) / fmax(0.01f, parameters[hook(13, 4 * ch + 1)] - parameters[hook(13, 4 * ch + 0)]);
    } else if (scaled[hook(12, ch)] > parameters[hook(13, 4 * ch + 2)] && scaled[hook(12, ch)] < parameters[hook(13, 4 * ch + 3)]) {
      factor = 1.0f - (scaled[hook(12, ch)] - parameters[hook(13, 4 * ch + 2)]) / fmax(0.01f, parameters[hook(13, 4 * ch + 3)] - parameters[hook(13, 4 * ch + 2)]);
    } else
      factor = 0.0f;

    if ((blendif & (1 << (ch + 16))) != 0)
      factor = 1.0f - factor;

    result *= ((mask_combine & DEVELOP_COMBINE_INCL) ? 1.0f - factor : factor);
  }

  return (mask_combine & DEVELOP_COMBINE_INCL) ? 1.0f - result : result;
}

float blendif_factor_rgb(const float4 input, const float4 output, const unsigned int blendif, global const float* parameters, const unsigned int mask_mode, const unsigned int mask_combine) {
  float result = 1.0f;
  float scaled[DEVELOP_BLENDIF_SIZE];

  if (!(mask_mode & DEVELOP_MASK_CONDITIONAL))
    return (mask_combine & DEVELOP_COMBINE_INCL) ? 0.0f : 1.0f;

  scaled[hook(12, DEVELOP_BLENDIF_GRAY_in)] = clamp(0.3f * input.x + 0.59f * input.y + 0.11f * input.z, 0.0f, 1.0f);
  scaled[hook(12, DEVELOP_BLENDIF_RED_in)] = clamp(input.x, 0.0f, 1.0f);
  scaled[hook(12, DEVELOP_BLENDIF_GREEN_in)] = clamp(input.y, 0.0f, 1.0f);
  scaled[hook(12, DEVELOP_BLENDIF_BLUE_in)] = clamp(input.z, 0.0f, 1.0f);
  scaled[hook(12, DEVELOP_BLENDIF_GRAY_out)] = clamp(0.3f * output.x + 0.59f * output.y + 0.11f * output.z, 0.0f, 1.0f);
  scaled[hook(12, DEVELOP_BLENDIF_RED_out)] = clamp(output.x, 0.0f, 1.0f);
  scaled[hook(12, DEVELOP_BLENDIF_GREEN_out)] = clamp(output.y, 0.0f, 1.0f);
  scaled[hook(12, DEVELOP_BLENDIF_BLUE_out)] = clamp(output.z, 0.0f, 1.0f);

  if ((blendif & 0x7f00) != 0) {
    float4 HSL_input = RGB_2_HSL(input);
    float4 HSL_output = RGB_2_HSL(output);

    scaled[hook(12, DEVELOP_BLENDIF_H_in)] = clamp(HSL_input.x, 0.0f, 1.0f);
    scaled[hook(12, DEVELOP_BLENDIF_S_in)] = clamp(HSL_input.y, 0.0f, 1.0f);
    scaled[hook(12, DEVELOP_BLENDIF_l_in)] = clamp(HSL_input.z, 0.0f, 1.0f);

    scaled[hook(12, DEVELOP_BLENDIF_H_out)] = clamp(HSL_output.x, 0.0f, 1.0f);
    scaled[hook(12, DEVELOP_BLENDIF_S_out)] = clamp(HSL_output.y, 0.0f, 1.0f);
    scaled[hook(12, DEVELOP_BLENDIF_l_out)] = clamp(HSL_output.z, 0.0f, 1.0f);
  }

  for (int ch = 0; ch <= DEVELOP_BLENDIF_MAX; ch++) {
    if ((DEVELOP_BLENDIF_RGB_MASK & (1 << ch)) == 0)
      continue;

    if ((blendif & (1 << ch)) == 0) {
      result *= (!(blendif & (1 << (ch + 16)))) == (!(mask_combine & DEVELOP_COMBINE_INCL)) ? 1.0f : 0.0f;
      continue;
    }

    if (result <= 0.000001f)
      break;

    float factor;
    if (scaled[hook(12, ch)] >= parameters[hook(13, 4 * ch + 1)] && scaled[hook(12, ch)] <= parameters[hook(13, 4 * ch + 2)]) {
      factor = 1.0f;
    } else if (scaled[hook(12, ch)] > parameters[hook(13, 4 * ch + 0)] && scaled[hook(12, ch)] < parameters[hook(13, 4 * ch + 1)]) {
      factor = (scaled[hook(12, ch)] - parameters[hook(13, 4 * ch + 0)]) / fmax(0.01f, parameters[hook(13, 4 * ch + 1)] - parameters[hook(13, 4 * ch + 0)]);
    } else if (scaled[hook(12, ch)] > parameters[hook(13, 4 * ch + 2)] && scaled[hook(12, ch)] < parameters[hook(13, 4 * ch + 3)]) {
      factor = 1.0f - (scaled[hook(12, ch)] - parameters[hook(13, 4 * ch + 2)]) / fmax(0.01f, parameters[hook(13, 4 * ch + 3)] - parameters[hook(13, 4 * ch + 2)]);
    } else
      factor = 0.0f;

    if ((blendif & (1 << (ch + 16))) != 0)
      factor = 1.0f - factor;

    result *= ((mask_combine & DEVELOP_COMBINE_INCL) ? 1.0f - factor : factor);
  }

  return (mask_combine & DEVELOP_COMBINE_INCL) ? 1.0f - result : result;
}

kernel void blendop_set_mask(write_only image2d_t mask, const int width, const int height, const float value) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);

  if (x >= width || y >= height)
    return;

  write_imagef(mask, (int2)(x, y), value);
}
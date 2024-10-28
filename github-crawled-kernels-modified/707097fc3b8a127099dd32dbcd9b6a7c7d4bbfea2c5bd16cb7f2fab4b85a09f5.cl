//{"height":3,"screenInput":0,"screenOutput":1,"width":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float FxaaLuma(uchar3 rgb) {
  return (float)rgb.y * 1.96321f + (float)rgb.x;
}

kernel void AntiAliasingFXAA(global uchar4* screenInput, global uchar4* screenOutput, global int* width, global int* height) {
  int id = get_global_id(0);
  int x = id % *width;
  int y = id / *width;

  bool canUp = true;
  bool canDown = true;
  bool canWest = true;
  bool canEast = true;

  uchar3 rgbM = screenInput[hook(0, id)].xyz;

  float lumaM = FxaaLuma(rgbM);

  uchar3 rgbW = rgbM;
  uchar3 rgbE = rgbM;
  uchar3 rgbN = rgbM;
  uchar3 rgbS = rgbM;
  float lumaW = lumaM;
  float lumaE = lumaM;
  float lumaN = lumaM;
  float lumaS = lumaM;

  if (x > 0) {
    rgbW = screenInput[hook(0, id - 1)].xyz;
    lumaW = FxaaLuma(rgbN);
  } else {
    screenOutput[hook(1, id)] = screenInput[hook(0, id)];
    return;
  }
  if (x < *width - 1) {
    rgbE = screenInput[hook(0, id + 1)].xyz;
    lumaE = FxaaLuma(rgbE);
  } else {
    screenOutput[hook(1, id)] = screenInput[hook(0, id)];
    return;
  }
  if (y > 0) {
    rgbN = screenInput[hook(0, id - *width)].xyz;
    lumaN = FxaaLuma(rgbN);
  } else {
    screenOutput[hook(1, id)] = screenInput[hook(0, id)];
    return;
  }
  if (y < *height - 1) {
    rgbS = screenInput[hook(0, id + *width)].xyz;
    lumaS = FxaaLuma(rgbS);
  } else {
    screenOutput[hook(1, id)] = screenInput[hook(0, id)];
    return;
  }

  float rangeMin = min(lumaM, min(min(lumaN, lumaW), min(lumaS, lumaE)));
  float rangeMax = max(lumaM, max(max(lumaN, lumaW), max(lumaS, lumaE)));
  float range = rangeMax - rangeMin;
  if (range < max((float)1 / 16, rangeMax * 1 / 8)) {
    screenOutput[hook(1, id)] = screenInput[hook(0, id)];
    return;
  }

  float lumaL = (lumaN + lumaW + lumaE + lumaS) * 0.25;
  int rangeL = fabs(lumaL - lumaM);
  float blendL = max(0.0f, (rangeL / range) - 1 / 4) * 0;
  blendL = min((float)3 / 4, blendL);

  float3 rgbL = convert_float3(rgbM);
  rgbL += convert_float3(rgbN);
  rgbL += convert_float3(rgbW);
  rgbL += convert_float3(rgbE);
  rgbL += convert_float3(rgbS);

  uchar3 rgbNW = rgbM;
  uchar3 rgbNE = rgbM;
  uchar3 rgbSW = rgbM;
  uchar3 rgbSE = rgbM;
  float lumaNW = lumaM;
  float lumaNE = lumaM;
  float lumaSW = lumaM;
  float lumaSE = lumaM;

  rgbNW = screenInput[hook(0, id - *width - 1)].xyz;
  lumaNW = FxaaLuma(rgbNW);

  rgbNE = screenInput[hook(0, id - *width + 1)].xyz;
  lumaNE = FxaaLuma(rgbNE);

  rgbSW = screenInput[hook(0, id + *width - 1)].xyz;
  lumaSW = FxaaLuma(rgbSW);

  rgbSE = screenInput[hook(0, id + *width + 1)].xyz;
  lumaSE = FxaaLuma(rgbSE);

  rgbL += convert_float3(rgbNW);
  rgbL += convert_float3(rgbNE);
  rgbL += convert_float3(rgbSW);
  rgbL += convert_float3(rgbSE);
  rgbL = rgbL * (float3)(0.1111f, 0.1111f, 0.1111f);

  screenOutput[hook(1, id)].x = (uchar)rgbL.x;
  screenOutput[hook(1, id)].y = (uchar)rgbL.y;
  screenOutput[hook(1, id)].z = (uchar)rgbL.z;
  screenOutput[hook(1, id)].w = 255;
}
//{"appFrame":0,"blend1":17,"blend2":18,"blend3":19,"blend4":20,"blend5":21,"blend6":22,"blend7":23,"blend8":24,"decay":25,"f1Enabled":9,"f2Enabled":10,"f3Enabled":11,"f4Enabled":12,"f5Enabled":13,"f6Enabled":14,"f7Enabled":15,"f8Enabled":16,"frame1":1,"frame2":2,"frame3":3,"frame4":4,"frame5":5,"frame6":6,"frame7":7,"frame8":8,"output":26}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float additiveBlend(float v1, float v2, float blendFactor) {
  float res = (v1 * (1.0f - blendFactor)) + (v2 * blendFactor);
  if (res > 255.0f) {
    res = 255.0f;
  }
  return res;
}

kernel void additive(global float* appFrame, global float* frame1, global float* frame2, global float* frame3, global float* frame4, global float* frame5, global float* frame6, global float* frame7, global float* frame8, float f1Enabled, float f2Enabled, float f3Enabled, float f4Enabled, float f5Enabled, float f6Enabled, float f7Enabled, float f8Enabled, float blend1, float blend2, float blend3, float blend4, float blend5, float blend6, float blend7, float blend8, float decay, global float* output) {
  size_t i = get_global_id(0);

  output[hook(26, i)] = additiveBlend(appFrame[hook(0, i)], 0.0f, decay);

  if (f1Enabled == 1) {
    output[hook(26, i)] = additiveBlend(output[hook(26, i)], frame1[hook(1, i)], blend1);
  }
  if (f2Enabled == 1) {
    output[hook(26, i)] = additiveBlend(output[hook(26, i)], frame2[hook(2, i)], blend2);
  }
  if (f3Enabled == 1) {
    output[hook(26, i)] = additiveBlend(output[hook(26, i)], frame3[hook(3, i)], blend3);
  }
  if (f4Enabled == 1) {
    output[hook(26, i)] = additiveBlend(output[hook(26, i)], frame4[hook(4, i)], blend4);
  }
  if (f5Enabled == 1) {
    output[hook(26, i)] = additiveBlend(output[hook(26, i)], frame5[hook(5, i)], blend5);
  }
  if (f6Enabled == 1) {
    output[hook(26, i)] = additiveBlend(output[hook(26, i)], frame6[hook(6, i)], blend6);
  }
  if (f7Enabled == 1) {
    output[hook(26, i)] = additiveBlend(output[hook(26, i)], frame7[hook(7, i)], blend7);
  }
  if (f8Enabled == 1) {
    output[hook(26, i)] = additiveBlend(output[hook(26, i)], frame8[hook(8, i)], blend8);
  }
}
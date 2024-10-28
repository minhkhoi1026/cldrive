//{"colors":2,"input":0,"keys":3,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
unsigned int interpolateColor(unsigned int c1, unsigned int c2, float m) {
  int channelC1;
  int channelC2;

  channelC1 = (c1 >> 24) & 0xff;
  channelC2 = (c2 >> 24) & 0xff;
  int a = (int)(channelC1 + m * (channelC2 - channelC1));

  channelC1 = (c1 >> 16) & 0xff;
  channelC2 = (c2 >> 16) & 0xff;
  int r = (int)(channelC1 + m * (channelC2 - channelC1));

  channelC1 = (c1 >> 8) & 0xff;
  channelC2 = (c2 >> 8) & 0xff;
  int g = (int)(channelC1 + m * (channelC2 - channelC1));

  channelC1 = c1 & 0xff;
  channelC2 = c2 & 0xff;
  int b = (int)(channelC1 + m * (channelC2 - channelC1));

  return (a << 24) | (r << 16) | (g << 8) | b;
}

unsigned int getColor(float value, constant float* keys, constant unsigned int* colors, int numKeys, unsigned int nanColor) {
  if (isnan(value)) {
    return nanColor;
  } else if (numKeys == 1) {
    return colors[hook(2, 0)];
  } else {
    int i = -1;
    while (i + 1 < numKeys && keys[hook(3, i + 1)] < value) {
      i++;
    }

    if (i < 0) {
      return colors[hook(2, 0)];
    } else if (i + 1 == numKeys) {
      return colors[hook(2, i)];
    } else {
      float m = (value - keys[hook(3, i)]) / (keys[hook(3, i + 1)] - keys[hook(3, i)]);
      return interpolateColor(colors[hook(2, i)], colors[hook(2, i + 1)], m);
    }
  }
}

kernel void colorize_(global float* input, global unsigned int* output) {
  int i = get_global_id(0);
  float value = input[hook(0, i)];
  if (isnan(value)) {
    output[hook(1, i)] = 0;
  } else {
    unsigned int gray = ((unsigned int)(255 * value)) & 255;
    output[hook(1, i)] = (255 << 24) | (gray << 16) | (gray << 8) | gray;
  }
}
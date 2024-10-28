//{"colors":3,"input":0,"keys":2,"nanColor":5,"numKeys":4,"output":1}
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
    return colors[hook(3, 0)];
  } else {
    int i = -1;
    while (i + 1 < numKeys && keys[hook(2, i + 1)] < value) {
      i++;
    }

    if (i < 0) {
      return colors[hook(3, 0)];
    } else if (i + 1 == numKeys) {
      return colors[hook(3, i)];
    } else {
      float m = (value - keys[hook(2, i)]) / (keys[hook(2, i + 1)] - keys[hook(2, i)]);
      return interpolateColor(colors[hook(3, i)], colors[hook(3, i + 1)], m);
    }
  }
}

kernel void colorize(global float* input, global unsigned int* output, constant float* keys, constant unsigned int* colors, int numKeys, unsigned int nanColor) {
  int i = get_global_id(0);
  output[hook(1, i)] = getColor(input[hook(0, i)], keys, colors, numKeys, nanColor);
}
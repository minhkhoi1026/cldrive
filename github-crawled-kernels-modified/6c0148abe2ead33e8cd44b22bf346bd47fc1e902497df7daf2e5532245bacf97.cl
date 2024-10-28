//{"bufferRight":0,"width":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant int redChannelOffset = 0;
constant int greenChannelOffset = 1;
constant int blueChannelOffset = 2;
constant int channelsPerPixel = 4;
constant int channelIncreaseValue = 10;
kernel void applyRightImageEffect(global uchar* bufferRight, unsigned int width) {
  const int indexWidth = get_global_id(0);
  const int indexHeight = get_global_id(1);

  const int pixelBlueChannelIndex = channelsPerPixel * width * indexHeight + channelsPerPixel * indexWidth + blueChannelOffset;

  bufferRight[hook(0, pixelBlueChannelIndex)] += channelIncreaseValue;
}
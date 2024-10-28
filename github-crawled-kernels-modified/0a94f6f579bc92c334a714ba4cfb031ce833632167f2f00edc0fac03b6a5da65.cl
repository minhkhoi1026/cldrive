//{"bufferLeft":0,"bufferRight":1,"width":2}
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
kernel void mergeImages(global uchar* bufferLeft, global uchar* bufferRight, unsigned int width) {
  const int indexWidth = get_global_id(0);
  const int indexHeight = get_global_id(1);

  const int pixelIndex = channelsPerPixel * width * indexHeight + channelsPerPixel * indexWidth;
  const int pixelGreenChannelIndex = pixelIndex + greenChannelOffset;
  const int pixelBlueChannelIndex = pixelIndex + blueChannelOffset;

  bufferLeft[hook(0, pixelGreenChannelIndex)] = bufferRight[hook(1, pixelGreenChannelIndex)];
  bufferLeft[hook(0, pixelBlueChannelIndex)] = bufferRight[hook(1, pixelBlueChannelIndex)];
}
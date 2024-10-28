//{"inputImage":0,"outputImage":1,"waveAmp":2,"waveLength":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t sampler = 0 | 0x20 | 2;
float2 effect(float x, float y, float a, float w) {
  float m = sqrt(x * x + y * y);
  float s = sin(w * m);
  float x1 = a * y * m * s;
  float y1 = -a * x * m * s;
  return (float2)(x1, y1);
}

float2 displacement(int xi, int yi, int width, int height, double waveAmp, double waveLength) {
  float aspect = ((float)height) / ((float)width);
  float x = ((float)xi) / ((float)width), y = ((float)yi) / ((float)height);
  return effect(x - 0.5, aspect * (y - 0.5 + 0.35), waveAmp, waveLength) - effect(x - 0.5, aspect * (y - 0.5 - 0.35), waveAmp, waveLength) + effect(x - 0.5, aspect * (y), 2, 5000);
}

kernel void filter(read_only image2d_t inputImage, write_only image2d_t outputImage, double waveAmp, double waveLength) {
  int2 dimensions = get_image_dim(inputImage);
  int width = dimensions.x, height = dimensions.y;
  int channelDataType = get_image_channel_data_type(inputImage);
  int channelOrder = get_image_channel_order(inputImage);
  int x = get_global_id(0), y = get_global_id(1);
  int2 coordinates = (int2)(x, y);
  float2 disp = displacement(x, y, width, height, waveAmp, waveLength);
  float fx = (float)coordinates.x;
  float fy = (float)coordinates.y;
  float2 fromCoordinates = (float2)(fx, fy) + disp;

  float newX = (float)(x / (float)width);
  float newY = (float)(y / (float)height);

  float x0 = floor(fromCoordinates.x);
  float xf = x0 + 1.f;
  float y0 = floor(fromCoordinates.y);
  float yf = y0 + 1.f;
  float deltaX = fromCoordinates.x - x0;
  float deltaY = fromCoordinates.y - y0;

  float centerX = (float)(width) / 2.f;
  float centerY = (float)(height) / 2.f;

  float2 pos0 = (float2)(x0, y0);
  float2 pos1 = (float2)(x0 + 1, y0);
  float2 int2 = (float2)(x0, y0 + 1);
  float2 pos3 = (float2)(x0 + 1, y0 + 1);

  float4 componentX0 = ((read_imagef(inputImage, sampler, pos1) - read_imagef(inputImage, sampler, pos0)) * deltaX + read_imagef(inputImage, sampler, pos0));
  float4 componentX1 = ((read_imagef(inputImage, sampler, pos3) - read_imagef(inputImage, sampler, int2)) * deltaX + read_imagef(inputImage, sampler, int2));
  float4 finalPixelComponent = (componentX1 - componentX0) * deltaY + componentX0;
  float4 minval = (float4)(0.f, 0.f, 0.f, 0.f);
  float4 maxval = (float4)(1.f, 1.f, 1.f, 1.f);
  finalPixelComponent = clamp(finalPixelComponent, minval, maxval);

  write_imagef(outputImage, coordinates, finalPixelComponent);
}
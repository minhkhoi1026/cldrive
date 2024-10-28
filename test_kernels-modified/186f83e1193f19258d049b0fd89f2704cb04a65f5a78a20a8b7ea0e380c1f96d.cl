//{"areaRect":7,"image":1,"origin":4,"stride":3,"volSize_imgWidth":2,"volume":0,"xAxis":5,"yAxis":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float4 metricToNormal(float4 point, float4 volSize) {
  return ((float4)(point.x / volSize.x, point.y / volSize.y, point.z / volSize.z, 0));
}

float4 pixelToVolume(float relX, float relY, float4 area, float4 planeOrigin, float4 xAxis, float4 yAxis) {
  float aX = (relX * area.z) + area.x;
  float aY = (relY * area.w) + area.y;

  return planeOrigin + (aX * xAxis) + (aY * yAxis);
}

const sampler_t samplerNN = 1 | 2 | 0x10;

const sampler_t samplerLN = 1 | 2 | 0x20;

kernel void extract_slice_linear(read_only image3d_t volume, global float* image, const float4 volSize_imgWidth, const unsigned int stride, const float4 origin, const float4 xAxis, const float4 yAxis, const float4 areaRect) {
  int i = get_global_id(0);
  int imgWidth = (int)volSize_imgWidth.w;
  int x = i % imgWidth;
  int y = i / imgWidth;
  float imgW = volSize_imgWidth.w;
  float imgH = (get_global_size(0) / imgWidth);

  float4 coord = metricToNormal(pixelToVolume(x / imgW, y / imgH, areaRect, origin, xAxis, yAxis), volSize_imgWidth);
  if (coord.x <= 0 || coord.y <= 0 || coord.z <= 0 || coord.x >= 1 || coord.y >= 1 || coord.z >= 1) {
    image[hook(1, i)] = (float)__builtin_astype((2147483647), float);
  } else {
    float4 value = read_imagef(volume, samplerLN, coord);
    image[hook(1, i)] = value.x;
  }
}
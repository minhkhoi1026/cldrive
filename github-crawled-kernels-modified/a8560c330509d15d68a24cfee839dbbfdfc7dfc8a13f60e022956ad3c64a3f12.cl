//{"float3":5,"height":2,"iterations":4,"outImage":0,"radius":3,"width":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float2 complex_sqr(const float2 a) {
  return (float2)(a.x * a.x - a.y * a.y, a.x * a.y + a.y * a.x);
}

void colorMapYUV(const float index, const float maxIterations, global uchar* float3) {
  if (index == maxIterations) {
    float3[hook(5, 0)] = 0;
    float3[hook(5, 1)] = 0;
    float3[hook(5, 2)] = 0;
    return;
  }

  const float y = 0.2f;
  const float u = -1.0f + 2.0f * (index / maxIterations);
  const float v = 0.5f - (index / maxIterations);

  const float r = y + 1.28033f * v;
  const float g = y - 0.21482f * u - 0.38059f * v;
  const float b = y + 2.12798f * u;

  float3[hook(5, 0)] = (char)(r * 255.0f);
  float3[hook(5, 1)] = (char)(g * 255.0f);
  float3[hook(5, 2)] = (char)(b * 255.0f);
}

kernel void mandelbrot(global uchar* outImage, const int width, const int height, const float radius, const int iterations) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);

  float2 z = (float2)(0.0f, 0.0f);
  float2 c = (float2)(-2.5f, 1.5f);
  c += (float2)(x * (1 - (-2.5f)) / width, y * (-1.5f - 1.5f) / height);
  int i = 0;

  while ((length(z) <= (radius)) && (i < iterations)) {
    z = complex_sqr(z) + c;
    i++;
  }

  if (i < iterations) {
    i += 1.0f - (log(log(length(z)) / log(2.0f)) / log(2.0f));
  }

  colorMapYUV(i, iterations, outImage + ((y * width + x) * 3));
}
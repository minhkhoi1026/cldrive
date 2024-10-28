//{"dir":3,"height":2,"input":0,"norm":4,"output":5,"width":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void dft(global float2* input, const unsigned int width, const unsigned int height, const float dir, const float norm, global float2* output) {
  int u = get_global_id(0);
  int v = get_global_id(1);

  if (u >= width || v >= height)
    return;

  float2 sum = (float2)(0.0f, 0.0f);

  for (int y = 0; y < height; ++y) {
    for (int x = 0; x < width; ++x) {
      float a = (float)u * (float)x / (float)width;
      float b = (float)v * (float)y / (float)height;

      float angle = dir * 2.0 * (float)3.14159265358979323846f * (a + b);
      float sinval, cosval;
      sinval = sincos(angle, &cosval);

      float2 c;
      float2 f = input[hook(0, x + y * width)];
      c.x = (cosval * f.x) - (sinval * f.y);
      c.y = (cosval * f.y) + (f.x * sinval);

      sum += c;
    }
  }

  int index = u + v * width;
  output[hook(5, index)] = sum * (float2)(norm);
}
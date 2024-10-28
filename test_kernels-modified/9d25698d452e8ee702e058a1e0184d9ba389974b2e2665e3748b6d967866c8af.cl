//{"a0":4,"a1":5,"a2":6,"a3":7,"b1":8,"b2":9,"coefn":11,"coefp":10,"height":3,"input":0,"output":1,"width":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void RecursiveGaussian_kernel(global const uchar4* input, global uchar4* output, const int width, const int height, const float a0, const float a1, const float a2, const float a3, const float b1, const float b2, const float coefp, const float coefn) {
  unsigned int x = get_global_id(0);

  if (x >= width)
    return;

  float4 xp = (float4)0.0f;
  float4 yp = (float4)0.0f;
  float4 yb = (float4)0.0f;

  for (int y = 0; y < height; y++) {
    int pos = x + y * width;
    float4 xc = (float4)(input[hook(0, pos)].x, input[hook(0, pos)].y, input[hook(0, pos)].z, input[hook(0, pos)].w);
    float4 yc = (a0 * xc) + (a1 * xp) - (b1 * yp) - (b2 * yb);
    output[hook(1, pos)] = (uchar4)(yc.x, yc.y, yc.z, yc.w);
    xp = xc;
    yb = yp;
    yp = yc;
  }

  barrier(0x02);

  float4 xn = (float4)(0.0f);
  float4 xa = (float4)(0.0f);
  float4 yn = (float4)(0.0f);
  float4 ya = (float4)(0.0f);

  for (int y = height - 1; y > -1; y--) {
    int pos = x + y * width;
    float4 xc = (float4)(input[hook(0, pos)].x, input[hook(0, pos)].y, input[hook(0, pos)].z, input[hook(0, pos)].w);
    float4 yc = (a2 * xn) + (a3 * xa) - (b1 * yn) - (b2 * ya);
    xa = xn;
    xn = xc;
    ya = yn;
    yn = yc;
    float4 temp = (float4)(output[hook(1, pos)].x, output[hook(1, pos)].y, output[hook(1, pos)].z, output[hook(1, pos)].w) + yc;
    output[hook(1, pos)] = (uchar4)(temp.x, temp.y, temp.z, temp.w);
  }
}
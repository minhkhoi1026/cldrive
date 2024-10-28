//{"chunk":4,"dst":1,"h":3,"src":0,"w":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compiler_box_blur_float(global const float4* src, global float4* dst, int w, int h, int chunk) {
  const int x = get_global_id(0);
  int y = get_global_id(1) * chunk;
  const int yend = min(y + chunk, h);

  const int left = max(x - 1, 0) + y * w;
  const int right = min(x + 1, w - 1) + y * w;
  int curr = x + y * w;
  float4 currPixel = src[hook(0, left)] + src[hook(0, curr)] + src[hook(0, right)];

  const int ytop = max(y - 1, 0);
  const int topLeft = max(x - 1, 0) + ytop * w;
  const int topRight = min(x + 1, w - 1) + ytop * w;
  const int top = x + ytop * w;
  float4 topPixel = src[hook(0, topLeft)] + src[hook(0, top)] + src[hook(0, topRight)];

  const int maxBottom = x + (h - 1) * w;
  const int maxBottomLeft = max(x - 1, 0) + (h - 1) * w;
  const int maxBottomRight = min(x + 1, w - 1) + (h - 1) * w;

  const int ybottom = min(y + 1, h - 1);
  int bottomLeft = max(x - 1 + ybottom * w, ybottom * w);
  int bottomRight = min(x + 1 + ybottom * w, ybottom * w + w - 1);
  int bottom = x + ybottom * w;

  for (; y < yend; ++y, curr += w, bottom += w, bottomLeft += w, bottomRight += w) {
    const int center = min(bottom, maxBottom);
    const int left = min(bottomLeft, maxBottomLeft);
    const int right = min(bottomRight, maxBottomRight);
    const float4 bottomPixel = src[hook(0, left)] + src[hook(0, center)] + src[hook(0, right)];
    const float4 to = (bottomPixel + currPixel + topPixel) * (1.f / 9.f);
    dst[hook(1, curr)] = to;
    topPixel = currPixel;
    currPixel = bottomPixel;
  }
}
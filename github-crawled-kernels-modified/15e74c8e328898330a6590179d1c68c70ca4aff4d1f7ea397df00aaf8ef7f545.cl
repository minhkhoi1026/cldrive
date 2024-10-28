//{"height":2,"io":0,"lastlevel":4,"r":3,"width":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void darkCorner(global float* io, const int width, const int height, const int r, const int lastlevel) {
  unsigned int ix = get_global_id(0);
  unsigned int iy = get_global_id(1);
  unsigned int reali = iy * width + ix;
  float4 temp = (float4)(io[hook(0, reali * 4)], io[hook(0, reali * 4 + 1)], io[hook(0, reali * 4 + 2)], io[hook(0, reali * 4 + 3)]);
  float2 middlePoint = (float2)(width * 2 / 3.0, height / 2.0);
  float2 currPoint = (float2)(ix, iy);

  float maxdistance = length(middlePoint);
  float startdistance = maxdistance * (1 - r / 10.0);
  float dis = distance(currPoint, middlePoint);

  float currbilv = (dis - startdistance) / (maxdistance - startdistance);
  if (currbilv < 0)
    return;

  float bilv = 3 * 0.02 * currbilv * (1 - currbilv) * (1 - currbilv) + 3 * 0.3 * currbilv * currbilv * (1 - currbilv) + currbilv * currbilv * currbilv;
  temp -= bilv * lastlevel * temp / 255;
  io[hook(0, reali * 4)] = temp.x;
  io[hook(0, reali * 4 + 1)] = temp.y;
  io[hook(0, reali * 4 + 2)] = temp.z;
}
//{"Input":0,"clXFrequencies":1,"clYFrequencies":2,"height":4,"width":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void clGrad(global float2* Input, global float* restrict clXFrequencies, global float* restrict clYFrequencies, int width, int height) {
  int xid = get_global_id(0);
  int yid = get_global_id(1);
  int Index = xid + width * yid;

  if (xid < width && yid < height) {
    Input[hook(0, Index)].x *= -4.0f * 3.1415129f * 3.141592f * (clXFrequencies[hook(1, xid)] * clXFrequencies[hook(1, xid)] + clYFrequencies[hook(2, yid)] * clYFrequencies[hook(2, yid)]);
    Input[hook(0, Index)].y *= -4.0f * 3.1415129f * 3.141592f * (clXFrequencies[hook(1, xid)] * clXFrequencies[hook(1, xid)] + clYFrequencies[hook(2, yid)] * clYFrequencies[hook(2, yid)]);
  }
}
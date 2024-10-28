//{"In1":0,"In2":1,"Out":2,"height":4,"width":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void clComplexMultiply(global float2* In1, global float2* In2, global float2* Out, int width, int height) {
  int xid = get_global_id(0);
  int yid = get_global_id(1);
  if (xid < width && yid < height) {
    int Index = xid + width * yid;

    Out[hook(2, Index)].x = In1[hook(0, Index)].x * In2[hook(1, Index)].x - In1[hook(0, Index)].y * In2[hook(1, Index)].y;
    Out[hook(2, Index)].y = In1[hook(0, Index)].x * In2[hook(1, Index)].y + In1[hook(0, Index)].y * In2[hook(1, Index)].x;
  }
}
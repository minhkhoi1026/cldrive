//{"ImageHeight":5,"ImageWidth":4,"OffsetAct":3,"OffsetPrev":2,"ucDest":1,"ucSource":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void ckSub(global float* ucSource, global float* ucDest, int OffsetPrev, int OffsetAct, int ImageWidth, int ImageHeight) {
  int pozX = 0;
  int pozY = 0;
  int punktOffset = 0;
  int punktOffsetNext = 0;

  pozX = get_global_id(0) > ImageWidth ? ImageWidth : get_global_id(0);
  pozY = get_global_id(1) > ImageHeight ? ImageHeight : get_global_id(1);

  punktOffset = OffsetPrev + mul24(pozY, ImageWidth) + pozX;
  punktOffsetNext = OffsetAct + mul24(pozY, ImageWidth) + pozX;

  float res = ucSource[hook(0, punktOffsetNext)] - ucSource[hook(0, punktOffset)];

  if ((pozY <= ImageHeight) && (pozX <= ImageWidth)) {
    ucDest[hook(1, punktOffset)] = res;
  }
}
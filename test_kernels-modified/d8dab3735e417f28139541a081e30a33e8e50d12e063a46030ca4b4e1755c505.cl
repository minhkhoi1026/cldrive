//{"height":3,"newMapBool":1,"oldMapBool":0,"width":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline int getRealX(int x, int width);
inline int getRealY(int y, int height);
kernel void update(global const int* oldMapBool, global int* newMapBool, const int width, const int height) {
  int w = width, h = height;
  int gid = get_global_id(0);
  int x = gid / h, y = gid % h, neighbourCount = 0;
  int xm1 = getRealX(x - 1, w), xp1 = getRealX(x + 1, w), ym1 = getRealY(y - 1, h), yp1 = getRealY(y + 1, h), xm1Xh = xm1 * h, xXh = x * h, xp1Xh = xp1 * h;

  neighbourCount += oldMapBool[hook(0, xm1Xh + ym1)];
  neighbourCount += oldMapBool[hook(0, xXh + ym1)];
  neighbourCount += oldMapBool[hook(0, xp1Xh + ym1)];
  neighbourCount += oldMapBool[hook(0, xm1Xh + y)];
  neighbourCount += oldMapBool[hook(0, xp1Xh + y)];
  neighbourCount += oldMapBool[hook(0, xm1Xh + yp1)];
  neighbourCount += oldMapBool[hook(0, xXh + yp1)];
  neighbourCount += oldMapBool[hook(0, xp1Xh + yp1)];

  if (3 == neighbourCount)
    newMapBool[hook(1, gid)] = 1;
  else if (2 == neighbourCount)
    newMapBool[hook(1, gid)] = oldMapBool[hook(0, gid)];
  else
    newMapBool[hook(1, gid)] = 0;
}
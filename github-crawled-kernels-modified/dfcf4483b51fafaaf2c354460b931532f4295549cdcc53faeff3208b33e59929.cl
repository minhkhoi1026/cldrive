//{"cols":4,"data":9,"data[dr + 9]":11,"data[dr]":8,"data[y + 1]":13,"data[y + 2]":14,"data[y]":12,"dst":1,"dstOffset":3,"dstStep":7,"rows":5,"source":10,"src":0,"srcOffset":2,"srcStep":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void medianFilter3_C1_D0(global uchar* src, global uchar* dst, int srcOffset, int dstOffset, int cols, int rows, int srcStep, int dstStep) {
  local uchar data[18][18];
  global uchar* source = src + srcOffset;

  int dx = get_global_id(0) - get_local_id(0) - 1;
  int dy = get_global_id(1) - get_local_id(1) - 1;

  const int id = min((int)(get_local_id(0) * 16 + get_local_id(1)), 9 * 18 - 1);

  int dr = id / 18;
  int dc = id % 18;
  int r = clamp(dy + dr, 0, rows - 1);
  int c = clamp(dx + dc, 0, cols - 1);

  data[hook(9, dr)][hook(8, dc)] = source[hook(10, r * srcStep + c)];
  r = clamp(dy + dr + 9, 0, rows - 1);
  data[hook(9, dr + 9)][hook(11, dc)] = source[hook(10, r * srcStep + c)];

  barrier(0x01);

  int x = get_local_id(0);
  int y = get_local_id(1);
  uchar p0 = data[hook(9, y)][hook(12, x)], p1 = data[hook(9, y)][hook(12, x + 1)], p2 = data[hook(9, y)][hook(12, x + 2)];
  uchar p3 = data[hook(9, y + 1)][hook(13, x)], p4 = data[hook(9, y + 1)][hook(13, x + 1)], p5 = data[hook(9, y + 1)][hook(13, x + 2)];
  uchar p6 = data[hook(9, y + 2)][hook(14, x)], p7 = data[hook(9, y + 2)][hook(14, x + 1)], p8 = data[hook(9, y + 2)][hook(14, x + 2)];
  uchar mid;

  {
    mid = p1;
    p1 = min(p1, p2);
    p2 = max(mid, p2);
  };
  {
    mid = p4;
    p4 = min(p4, p5);
    p5 = max(mid, p5);
  };
  {
    mid = p7;
    p7 = min(p7, p8);
    p8 = max(mid, p8);
  };
  {
    mid = p0;
    p0 = min(p0, p1);
    p1 = max(mid, p1);
  };
  {
    mid = p3;
    p3 = min(p3, p4);
    p4 = max(mid, p4);
  };
  {
    mid = p6;
    p6 = min(p6, p7);
    p7 = max(mid, p7);
  };
  {
    mid = p1;
    p1 = min(p1, p2);
    p2 = max(mid, p2);
  };
  {
    mid = p4;
    p4 = min(p4, p5);
    p5 = max(mid, p5);
  };
  {
    mid = p7;
    p7 = min(p7, p8);
    p8 = max(mid, p8);
  };
  {
    mid = p0;
    p0 = min(p0, p3);
    p3 = max(mid, p3);
  };
  {
    mid = p5;
    p5 = min(p5, p8);
    p8 = max(mid, p8);
  };
  {
    mid = p4;
    p4 = min(p4, p7);
    p7 = max(mid, p7);
  };
  {
    mid = p3;
    p3 = min(p3, p6);
    p6 = max(mid, p6);
  };
  {
    mid = p1;
    p1 = min(p1, p4);
    p4 = max(mid, p4);
  };
  {
    mid = p2;
    p2 = min(p2, p5);
    p5 = max(mid, p5);
  };
  {
    mid = p4;
    p4 = min(p4, p7);
    p7 = max(mid, p7);
  };
  {
    mid = p4;
    p4 = min(p4, p2);
    p2 = max(mid, p2);
  };
  {
    mid = p6;
    p6 = min(p6, p4);
    p4 = max(mid, p4);
  };
  {
    mid = p4;
    p4 = min(p4, p2);
    p2 = max(mid, p2);
  };

  if ((int)get_global_id(1) < rows && (int)get_global_id(0) < cols)
    dst[hook(1, dstOffset + get_global_id(1) * dstStep + get_global_id(0))] = p4;
}
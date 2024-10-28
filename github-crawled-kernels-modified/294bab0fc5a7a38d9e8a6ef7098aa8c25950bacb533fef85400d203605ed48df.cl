//{"cols":4,"data":9,"data[dr + 10]":11,"data[dr]":8,"data[y + 1]":13,"data[y + 2]":14,"data[y + 3]":15,"data[y + 4]":16,"data[y]":12,"dst":1,"dstOffset":3,"dstStep":7,"rows":5,"source":10,"src":0,"srcOffset":2,"srcStep":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void medianFilter5_C4_D5(global float4* src, global float4* dst, int srcOffset, int dstOffset, int cols, int rows, int srcStep, int dstStep) {
  local float4 data[20][20];
  global float4* source = src + srcOffset;

  int dx = get_global_id(0) - get_local_id(0) - 2;
  int dy = get_global_id(1) - get_local_id(1) - 2;

  const int id = min((int)(get_local_id(0) * 16 + get_local_id(1)), 10 * 20 - 1);

  int dr = id / 20;
  int dc = id % 20;
  int r = clamp(dy + dr, 0, rows - 1);
  int c = clamp(dx + dc, 0, cols - 1);

  data[hook(9, dr)][hook(8, dc)] = source[hook(10, r * srcStep + c)];
  r = clamp(dy + dr + 10, 0, rows - 1);
  data[hook(9, dr + 10)][hook(11, dc)] = source[hook(10, r * srcStep + c)];

  barrier(0x01);

  int x = get_local_id(0);
  int y = get_local_id(1);
  float4 p0 = data[hook(9, y)][hook(12, x)], p1 = data[hook(9, y)][hook(12, x + 1)], p2 = data[hook(9, y)][hook(12, x + 2)], p3 = data[hook(9, y)][hook(12, x + 3)], p4 = data[hook(9, y)][hook(12, x + 4)];
  float4 p5 = data[hook(9, y + 1)][hook(13, x)], p6 = data[hook(9, y + 1)][hook(13, x + 1)], p7 = data[hook(9, y + 1)][hook(13, x + 2)], p8 = data[hook(9, y + 1)][hook(13, x + 3)], p9 = data[hook(9, y + 1)][hook(13, x + 4)];
  float4 p10 = data[hook(9, y + 2)][hook(14, x)], p11 = data[hook(9, y + 2)][hook(14, x + 1)], p12 = data[hook(9, y + 2)][hook(14, x + 2)], p13 = data[hook(9, y + 2)][hook(14, x + 3)], p14 = data[hook(9, y + 2)][hook(14, x + 4)];
  float4 p15 = data[hook(9, y + 3)][hook(15, x)], p16 = data[hook(9, y + 3)][hook(15, x + 1)], p17 = data[hook(9, y + 3)][hook(15, x + 2)], p18 = data[hook(9, y + 3)][hook(15, x + 3)], p19 = data[hook(9, y + 3)][hook(15, x + 4)];
  float4 p20 = data[hook(9, y + 4)][hook(16, x)], p21 = data[hook(9, y + 4)][hook(16, x + 1)], p22 = data[hook(9, y + 4)][hook(16, x + 2)], p23 = data[hook(9, y + 4)][hook(16, x + 3)], p24 = data[hook(9, y + 4)][hook(16, x + 4)];
  float4 mid;

  {
    mid = p1;
    p1 = min(p1, p2);
    p2 = max(mid, p2);
  };
  {
    mid = p0;
    p0 = min(p0, p1);
    p1 = max(mid, p1);
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
    mid = p3;
    p3 = min(p3, p4);
    p4 = max(mid, p4);
  };
  {
    mid = p4;
    p4 = min(p4, p5);
    p5 = max(mid, p5);
  };
  {
    mid = p0;
    p0 = min(p0, p3);
    p3 = max(mid, p3);
  };
  {
    mid = p2;
    p2 = min(p2, p5);
    p5 = max(mid, p5);
  };
  {
    mid = p2;
    p2 = min(p2, p3);
    p3 = max(mid, p3);
  };
  {
    mid = p1;
    p1 = min(p1, p4);
    p4 = max(mid, p4);
  };
  {
    mid = p1;
    p1 = min(p1, p2);
    p2 = max(mid, p2);
  };
  {
    mid = p3;
    p3 = min(p3, p4);
    p4 = max(mid, p4);
  };
  {
    mid = p7;
    p7 = min(p7, p8);
    p8 = max(mid, p8);
  };
  {
    mid = p6;
    p6 = min(p6, p7);
    p7 = max(mid, p7);
  };
  {
    mid = p7;
    p7 = min(p7, p8);
    p8 = max(mid, p8);
  };
  {
    mid = p10;
    p10 = min(p10, p11);
    p11 = max(mid, p11);
  };
  {
    mid = p9;
    p9 = min(p9, p10);
    p10 = max(mid, p10);
  };
  {
    mid = p10;
    p10 = min(p10, p11);
    p11 = max(mid, p11);
  };
  {
    mid = p6;
    p6 = min(p6, p9);
    p9 = max(mid, p9);
  };
  {
    mid = p8;
    p8 = min(p8, p11);
    p11 = max(mid, p11);
  };
  {
    mid = p8;
    p8 = min(p8, p9);
    p9 = max(mid, p9);
  };
  {
    mid = p7;
    p7 = min(p7, p10);
    p10 = max(mid, p10);
  };
  {
    mid = p7;
    p7 = min(p7, p8);
    p8 = max(mid, p8);
  };
  {
    mid = p9;
    p9 = min(p9, p10);
    p10 = max(mid, p10);
  };
  {
    mid = p0;
    p0 = min(p0, p6);
    p6 = max(mid, p6);
  };
  {
    mid = p4;
    p4 = min(p4, p10);
    p10 = max(mid, p10);
  };
  {
    mid = p4;
    p4 = min(p4, p6);
    p6 = max(mid, p6);
  };
  {
    mid = p2;
    p2 = min(p2, p8);
    p8 = max(mid, p8);
  };
  {
    mid = p2;
    p2 = min(p2, p4);
    p4 = max(mid, p4);
  };
  {
    mid = p6;
    p6 = min(p6, p8);
    p8 = max(mid, p8);
  };
  {
    mid = p1;
    p1 = min(p1, p7);
    p7 = max(mid, p7);
  };
  {
    mid = p5;
    p5 = min(p5, p11);
    p11 = max(mid, p11);
  };
  {
    mid = p5;
    p5 = min(p5, p7);
    p7 = max(mid, p7);
  };
  {
    mid = p3;
    p3 = min(p3, p9);
    p9 = max(mid, p9);
  };
  {
    mid = p3;
    p3 = min(p3, p5);
    p5 = max(mid, p5);
  };
  {
    mid = p7;
    p7 = min(p7, p9);
    p9 = max(mid, p9);
  };
  {
    mid = p1;
    p1 = min(p1, p2);
    p2 = max(mid, p2);
  };
  {
    mid = p3;
    p3 = min(p3, p4);
    p4 = max(mid, p4);
  };
  {
    mid = p5;
    p5 = min(p5, p6);
    p6 = max(mid, p6);
  };
  {
    mid = p7;
    p7 = min(p7, p8);
    p8 = max(mid, p8);
  };
  {
    mid = p9;
    p9 = min(p9, p10);
    p10 = max(mid, p10);
  };
  {
    mid = p13;
    p13 = min(p13, p14);
    p14 = max(mid, p14);
  };
  {
    mid = p12;
    p12 = min(p12, p13);
    p13 = max(mid, p13);
  };
  {
    mid = p13;
    p13 = min(p13, p14);
    p14 = max(mid, p14);
  };
  {
    mid = p16;
    p16 = min(p16, p17);
    p17 = max(mid, p17);
  };
  {
    mid = p15;
    p15 = min(p15, p16);
    p16 = max(mid, p16);
  };
  {
    mid = p16;
    p16 = min(p16, p17);
    p17 = max(mid, p17);
  };
  {
    mid = p12;
    p12 = min(p12, p15);
    p15 = max(mid, p15);
  };
  {
    mid = p14;
    p14 = min(p14, p17);
    p17 = max(mid, p17);
  };
  {
    mid = p14;
    p14 = min(p14, p15);
    p15 = max(mid, p15);
  };
  {
    mid = p13;
    p13 = min(p13, p16);
    p16 = max(mid, p16);
  };
  {
    mid = p13;
    p13 = min(p13, p14);
    p14 = max(mid, p14);
  };
  {
    mid = p15;
    p15 = min(p15, p16);
    p16 = max(mid, p16);
  };
  {
    mid = p19;
    p19 = min(p19, p20);
    p20 = max(mid, p20);
  };
  {
    mid = p18;
    p18 = min(p18, p19);
    p19 = max(mid, p19);
  };
  {
    mid = p19;
    p19 = min(p19, p20);
    p20 = max(mid, p20);
  };
  {
    mid = p21;
    p21 = min(p21, p22);
    p22 = max(mid, p22);
  };
  {
    mid = p23;
    p23 = min(p23, p24);
    p24 = max(mid, p24);
  };
  {
    mid = p21;
    p21 = min(p21, p23);
    p23 = max(mid, p23);
  };
  {
    mid = p22;
    p22 = min(p22, p24);
    p24 = max(mid, p24);
  };
  {
    mid = p22;
    p22 = min(p22, p23);
    p23 = max(mid, p23);
  };
  {
    mid = p18;
    p18 = min(p18, p21);
    p21 = max(mid, p21);
  };
  {
    mid = p20;
    p20 = min(p20, p23);
    p23 = max(mid, p23);
  };
  {
    mid = p20;
    p20 = min(p20, p21);
    p21 = max(mid, p21);
  };
  {
    mid = p19;
    p19 = min(p19, p22);
    p22 = max(mid, p22);
  };
  {
    mid = p22;
    p22 = min(p22, p24);
    p24 = max(mid, p24);
  };
  {
    mid = p19;
    p19 = min(p19, p20);
    p20 = max(mid, p20);
  };
  {
    mid = p21;
    p21 = min(p21, p22);
    p22 = max(mid, p22);
  };
  {
    mid = p23;
    p23 = min(p23, p24);
    p24 = max(mid, p24);
  };
  {
    mid = p12;
    p12 = min(p12, p18);
    p18 = max(mid, p18);
  };
  {
    mid = p16;
    p16 = min(p16, p22);
    p22 = max(mid, p22);
  };
  {
    mid = p16;
    p16 = min(p16, p18);
    p18 = max(mid, p18);
  };
  {
    mid = p14;
    p14 = min(p14, p20);
    p20 = max(mid, p20);
  };
  {
    mid = p20;
    p20 = min(p20, p24);
    p24 = max(mid, p24);
  };
  {
    mid = p14;
    p14 = min(p14, p16);
    p16 = max(mid, p16);
  };
  {
    mid = p18;
    p18 = min(p18, p20);
    p20 = max(mid, p20);
  };
  {
    mid = p22;
    p22 = min(p22, p24);
    p24 = max(mid, p24);
  };
  {
    mid = p13;
    p13 = min(p13, p19);
    p19 = max(mid, p19);
  };
  {
    mid = p17;
    p17 = min(p17, p23);
    p23 = max(mid, p23);
  };
  {
    mid = p17;
    p17 = min(p17, p19);
    p19 = max(mid, p19);
  };
  {
    mid = p15;
    p15 = min(p15, p21);
    p21 = max(mid, p21);
  };
  {
    mid = p15;
    p15 = min(p15, p17);
    p17 = max(mid, p17);
  };
  {
    mid = p19;
    p19 = min(p19, p21);
    p21 = max(mid, p21);
  };
  {
    mid = p13;
    p13 = min(p13, p14);
    p14 = max(mid, p14);
  };
  {
    mid = p15;
    p15 = min(p15, p16);
    p16 = max(mid, p16);
  };
  {
    mid = p17;
    p17 = min(p17, p18);
    p18 = max(mid, p18);
  };
  {
    mid = p19;
    p19 = min(p19, p20);
    p20 = max(mid, p20);
  };
  {
    mid = p21;
    p21 = min(p21, p22);
    p22 = max(mid, p22);
  };
  {
    mid = p23;
    p23 = min(p23, p24);
    p24 = max(mid, p24);
  };
  {
    mid = p0;
    p0 = min(p0, p12);
    p12 = max(mid, p12);
  };
  {
    mid = p8;
    p8 = min(p8, p20);
    p20 = max(mid, p20);
  };
  {
    mid = p8;
    p8 = min(p8, p12);
    p12 = max(mid, p12);
  };
  {
    mid = p4;
    p4 = min(p4, p16);
    p16 = max(mid, p16);
  };
  {
    mid = p16;
    p16 = min(p16, p24);
    p24 = max(mid, p24);
  };
  {
    mid = p12;
    p12 = min(p12, p16);
    p16 = max(mid, p16);
  };
  {
    mid = p2;
    p2 = min(p2, p14);
    p14 = max(mid, p14);
  };
  {
    mid = p10;
    p10 = min(p10, p22);
    p22 = max(mid, p22);
  };
  {
    mid = p10;
    p10 = min(p10, p14);
    p14 = max(mid, p14);
  };
  {
    mid = p6;
    p6 = min(p6, p18);
    p18 = max(mid, p18);
  };
  {
    mid = p6;
    p6 = min(p6, p10);
    p10 = max(mid, p10);
  };
  {
    mid = p10;
    p10 = min(p10, p12);
    p12 = max(mid, p12);
  };
  {
    mid = p1;
    p1 = min(p1, p13);
    p13 = max(mid, p13);
  };
  {
    mid = p9;
    p9 = min(p9, p21);
    p21 = max(mid, p21);
  };
  {
    mid = p9;
    p9 = min(p9, p13);
    p13 = max(mid, p13);
  };
  {
    mid = p5;
    p5 = min(p5, p17);
    p17 = max(mid, p17);
  };
  {
    mid = p13;
    p13 = min(p13, p17);
    p17 = max(mid, p17);
  };
  {
    mid = p3;
    p3 = min(p3, p15);
    p15 = max(mid, p15);
  };
  {
    mid = p11;
    p11 = min(p11, p23);
    p23 = max(mid, p23);
  };
  {
    mid = p11;
    p11 = min(p11, p15);
    p15 = max(mid, p15);
  };
  {
    mid = p7;
    p7 = min(p7, p19);
    p19 = max(mid, p19);
  };
  {
    mid = p7;
    p7 = min(p7, p11);
    p11 = max(mid, p11);
  };
  {
    mid = p11;
    p11 = min(p11, p13);
    p13 = max(mid, p13);
  };
  {
    mid = p11;
    p11 = min(p11, p12);
    p12 = max(mid, p12);
  };

  if ((int)get_global_id(1) < rows && (int)get_global_id(0) < cols)
    dst[hook(1, dstOffset + get_global_id(1) * dstStep + get_global_id(0))] = p12;
}
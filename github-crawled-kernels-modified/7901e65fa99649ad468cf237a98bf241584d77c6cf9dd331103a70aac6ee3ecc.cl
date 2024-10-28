//{"((__global unsigned int *)CAST_S_table)":4,"((__local unsigned int *)CAST_S_table0)":3,"((__local unsigned int *)CAST_S_table1)":5,"((__local unsigned int *)CAST_S_table2)":6,"((__local unsigned int *)CAST_S_table3)":7,"CAST_S_table":2,"CAST_S_table0":8,"CAST_S_table1":9,"CAST_S_table2":10,"CAST_S_table3":11,"data":0,"k":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void CASTencKernel(global unsigned long* data, constant unsigned int* k, global unsigned int* CAST_S_table) {
  local unsigned int CAST_S_table0[256], CAST_S_table1[256], CAST_S_table2[256], CAST_S_table3[256];
 private
  unsigned int l, r, t;

 private
  unsigned long block = data[hook(0, get_global_id(0))];

  l = ((block >> 24L) & 0x000000ff) | ((block >> 8L) & 0x0000ff00) | ((block << 8L) & 0x00ff0000) | ((block << 24L) & 0xff000000), r = ((block >> 56L) & 0x000000ff) | ((block >> 40L) & 0x0000ff00) | ((block >> 24L) & 0x00ff0000) | ((block >> 8L) & 0xff000000);

  ((local unsigned int*)CAST_S_table0)[hook(3, get_local_id(0))] = ((global unsigned int*)CAST_S_table)[hook(4, get_local_id(0))];
  ((local unsigned int*)CAST_S_table1)[hook(5, get_local_id(0))] = ((global unsigned int*)CAST_S_table)[hook(4, get_local_id(0) + 256)];
  ((local unsigned int*)CAST_S_table2)[hook(6, get_local_id(0))] = ((global unsigned int*)CAST_S_table)[hook(4, get_local_id(0) + 512)];
  ((local unsigned int*)CAST_S_table3)[hook(7, get_local_id(0))] = ((global unsigned int*)CAST_S_table)[hook(4, get_local_id(0) + 768)];

  barrier(0x01);

  {
    unsigned int a, b, c, d;
    t = (k[hook(1, 0 * 2)] + r) & 0xffffffff;
    t = ((((t) << ((k[hook(1, 0 * 2 + 1)]))) & 0xffffffffL) | ((t) >> (32 - ((k[hook(1, 0 * 2 + 1)])))));
    a = CAST_S_table0[hook(8, (t >> 8) & 255)];
    b = CAST_S_table1[hook(9, (t) & 255)];
    c = CAST_S_table2[hook(10, (t >> 24) & 255)];
    d = CAST_S_table3[hook(11, (t >> 16) & 255)];
    l ^= (((((a ^ b) & 0xffffffffL) - c) & 0xffffffffL) + d) & 0xffffffffL;
  };
  {
    unsigned int a, b, c, d;
    t = (k[hook(1, 1 * 2)] ^ l) & 0xffffffff;
    t = ((((t) << ((k[hook(1, 1 * 2 + 1)]))) & 0xffffffffL) | ((t) >> (32 - ((k[hook(1, 1 * 2 + 1)])))));
    a = CAST_S_table0[hook(8, (t >> 8) & 255)];
    b = CAST_S_table1[hook(9, (t) & 255)];
    c = CAST_S_table2[hook(10, (t >> 24) & 255)];
    d = CAST_S_table3[hook(11, (t >> 16) & 255)];
    r ^= (((((a - b) & 0xffffffffL) + c) & 0xffffffffL) ^ d) & 0xffffffffL;
  };
  {
    unsigned int a, b, c, d;
    t = (k[hook(1, 2 * 2)] - r) & 0xffffffff;
    t = ((((t) << ((k[hook(1, 2 * 2 + 1)]))) & 0xffffffffL) | ((t) >> (32 - ((k[hook(1, 2 * 2 + 1)])))));
    a = CAST_S_table0[hook(8, (t >> 8) & 255)];
    b = CAST_S_table1[hook(9, (t) & 255)];
    c = CAST_S_table2[hook(10, (t >> 24) & 255)];
    d = CAST_S_table3[hook(11, (t >> 16) & 255)];
    l ^= (((((a + b) & 0xffffffffL) ^ c) & 0xffffffffL) - d) & 0xffffffffL;
  };
  {
    unsigned int a, b, c, d;
    t = (k[hook(1, 3 * 2)] + l) & 0xffffffff;
    t = ((((t) << ((k[hook(1, 3 * 2 + 1)]))) & 0xffffffffL) | ((t) >> (32 - ((k[hook(1, 3 * 2 + 1)])))));
    a = CAST_S_table0[hook(8, (t >> 8) & 255)];
    b = CAST_S_table1[hook(9, (t) & 255)];
    c = CAST_S_table2[hook(10, (t >> 24) & 255)];
    d = CAST_S_table3[hook(11, (t >> 16) & 255)];
    r ^= (((((a ^ b) & 0xffffffffL) - c) & 0xffffffffL) + d) & 0xffffffffL;
  };
  {
    unsigned int a, b, c, d;
    t = (k[hook(1, 4 * 2)] ^ r) & 0xffffffff;
    t = ((((t) << ((k[hook(1, 4 * 2 + 1)]))) & 0xffffffffL) | ((t) >> (32 - ((k[hook(1, 4 * 2 + 1)])))));
    a = CAST_S_table0[hook(8, (t >> 8) & 255)];
    b = CAST_S_table1[hook(9, (t) & 255)];
    c = CAST_S_table2[hook(10, (t >> 24) & 255)];
    d = CAST_S_table3[hook(11, (t >> 16) & 255)];
    l ^= (((((a - b) & 0xffffffffL) + c) & 0xffffffffL) ^ d) & 0xffffffffL;
  };
  {
    unsigned int a, b, c, d;
    t = (k[hook(1, 5 * 2)] - l) & 0xffffffff;
    t = ((((t) << ((k[hook(1, 5 * 2 + 1)]))) & 0xffffffffL) | ((t) >> (32 - ((k[hook(1, 5 * 2 + 1)])))));
    a = CAST_S_table0[hook(8, (t >> 8) & 255)];
    b = CAST_S_table1[hook(9, (t) & 255)];
    c = CAST_S_table2[hook(10, (t >> 24) & 255)];
    d = CAST_S_table3[hook(11, (t >> 16) & 255)];
    r ^= (((((a + b) & 0xffffffffL) ^ c) & 0xffffffffL) - d) & 0xffffffffL;
  };
  {
    unsigned int a, b, c, d;
    t = (k[hook(1, 6 * 2)] + r) & 0xffffffff;
    t = ((((t) << ((k[hook(1, 6 * 2 + 1)]))) & 0xffffffffL) | ((t) >> (32 - ((k[hook(1, 6 * 2 + 1)])))));
    a = CAST_S_table0[hook(8, (t >> 8) & 255)];
    b = CAST_S_table1[hook(9, (t) & 255)];
    c = CAST_S_table2[hook(10, (t >> 24) & 255)];
    d = CAST_S_table3[hook(11, (t >> 16) & 255)];
    l ^= (((((a ^ b) & 0xffffffffL) - c) & 0xffffffffL) + d) & 0xffffffffL;
  };
  {
    unsigned int a, b, c, d;
    t = (k[hook(1, 7 * 2)] ^ l) & 0xffffffff;
    t = ((((t) << ((k[hook(1, 7 * 2 + 1)]))) & 0xffffffffL) | ((t) >> (32 - ((k[hook(1, 7 * 2 + 1)])))));
    a = CAST_S_table0[hook(8, (t >> 8) & 255)];
    b = CAST_S_table1[hook(9, (t) & 255)];
    c = CAST_S_table2[hook(10, (t >> 24) & 255)];
    d = CAST_S_table3[hook(11, (t >> 16) & 255)];
    r ^= (((((a - b) & 0xffffffffL) + c) & 0xffffffffL) ^ d) & 0xffffffffL;
  };
  {
    unsigned int a, b, c, d;
    t = (k[hook(1, 8 * 2)] - r) & 0xffffffff;
    t = ((((t) << ((k[hook(1, 8 * 2 + 1)]))) & 0xffffffffL) | ((t) >> (32 - ((k[hook(1, 8 * 2 + 1)])))));
    a = CAST_S_table0[hook(8, (t >> 8) & 255)];
    b = CAST_S_table1[hook(9, (t) & 255)];
    c = CAST_S_table2[hook(10, (t >> 24) & 255)];
    d = CAST_S_table3[hook(11, (t >> 16) & 255)];
    l ^= (((((a + b) & 0xffffffffL) ^ c) & 0xffffffffL) - d) & 0xffffffffL;
  };
  {
    unsigned int a, b, c, d;
    t = (k[hook(1, 9 * 2)] + l) & 0xffffffff;
    t = ((((t) << ((k[hook(1, 9 * 2 + 1)]))) & 0xffffffffL) | ((t) >> (32 - ((k[hook(1, 9 * 2 + 1)])))));
    a = CAST_S_table0[hook(8, (t >> 8) & 255)];
    b = CAST_S_table1[hook(9, (t) & 255)];
    c = CAST_S_table2[hook(10, (t >> 24) & 255)];
    d = CAST_S_table3[hook(11, (t >> 16) & 255)];
    r ^= (((((a ^ b) & 0xffffffffL) - c) & 0xffffffffL) + d) & 0xffffffffL;
  };
  {
    unsigned int a, b, c, d;
    t = (k[hook(1, 10 * 2)] ^ r) & 0xffffffff;
    t = ((((t) << ((k[hook(1, 10 * 2 + 1)]))) & 0xffffffffL) | ((t) >> (32 - ((k[hook(1, 10 * 2 + 1)])))));
    a = CAST_S_table0[hook(8, (t >> 8) & 255)];
    b = CAST_S_table1[hook(9, (t) & 255)];
    c = CAST_S_table2[hook(10, (t >> 24) & 255)];
    d = CAST_S_table3[hook(11, (t >> 16) & 255)];
    l ^= (((((a - b) & 0xffffffffL) + c) & 0xffffffffL) ^ d) & 0xffffffffL;
  };
  {
    unsigned int a, b, c, d;
    t = (k[hook(1, 11 * 2)] - l) & 0xffffffff;
    t = ((((t) << ((k[hook(1, 11 * 2 + 1)]))) & 0xffffffffL) | ((t) >> (32 - ((k[hook(1, 11 * 2 + 1)])))));
    a = CAST_S_table0[hook(8, (t >> 8) & 255)];
    b = CAST_S_table1[hook(9, (t) & 255)];
    c = CAST_S_table2[hook(10, (t >> 24) & 255)];
    d = CAST_S_table3[hook(11, (t >> 16) & 255)];
    r ^= (((((a + b) & 0xffffffffL) ^ c) & 0xffffffffL) - d) & 0xffffffffL;
  };
  {
    unsigned int a, b, c, d;
    t = (k[hook(1, 12 * 2)] + r) & 0xffffffff;
    t = ((((t) << ((k[hook(1, 12 * 2 + 1)]))) & 0xffffffffL) | ((t) >> (32 - ((k[hook(1, 12 * 2 + 1)])))));
    a = CAST_S_table0[hook(8, (t >> 8) & 255)];
    b = CAST_S_table1[hook(9, (t) & 255)];
    c = CAST_S_table2[hook(10, (t >> 24) & 255)];
    d = CAST_S_table3[hook(11, (t >> 16) & 255)];
    l ^= (((((a ^ b) & 0xffffffffL) - c) & 0xffffffffL) + d) & 0xffffffffL;
  };
  {
    unsigned int a, b, c, d;
    t = (k[hook(1, 13 * 2)] ^ l) & 0xffffffff;
    t = ((((t) << ((k[hook(1, 13 * 2 + 1)]))) & 0xffffffffL) | ((t) >> (32 - ((k[hook(1, 13 * 2 + 1)])))));
    a = CAST_S_table0[hook(8, (t >> 8) & 255)];
    b = CAST_S_table1[hook(9, (t) & 255)];
    c = CAST_S_table2[hook(10, (t >> 24) & 255)];
    d = CAST_S_table3[hook(11, (t >> 16) & 255)];
    r ^= (((((a - b) & 0xffffffffL) + c) & 0xffffffffL) ^ d) & 0xffffffffL;
  };
  {
    unsigned int a, b, c, d;
    t = (k[hook(1, 14 * 2)] - r) & 0xffffffff;
    t = ((((t) << ((k[hook(1, 14 * 2 + 1)]))) & 0xffffffffL) | ((t) >> (32 - ((k[hook(1, 14 * 2 + 1)])))));
    a = CAST_S_table0[hook(8, (t >> 8) & 255)];
    b = CAST_S_table1[hook(9, (t) & 255)];
    c = CAST_S_table2[hook(10, (t >> 24) & 255)];
    d = CAST_S_table3[hook(11, (t >> 16) & 255)];
    l ^= (((((a + b) & 0xffffffffL) ^ c) & 0xffffffffL) - d) & 0xffffffffL;
  };
  {
    unsigned int a, b, c, d;
    t = (k[hook(1, 15 * 2)] + l) & 0xffffffff;
    t = ((((t) << ((k[hook(1, 15 * 2 + 1)]))) & 0xffffffffL) | ((t) >> (32 - ((k[hook(1, 15 * 2 + 1)])))));
    a = CAST_S_table0[hook(8, (t >> 8) & 255)];
    b = CAST_S_table1[hook(9, (t) & 255)];
    c = CAST_S_table2[hook(10, (t >> 24) & 255)];
    d = CAST_S_table3[hook(11, (t >> 16) & 255)];
    r ^= (((((a ^ b) & 0xffffffffL) - c) & 0xffffffffL) + d) & 0xffffffffL;
  };

  block = ((unsigned long)r) << 32 | l;

  (block = block << 56 | ((block & 0x000000000000FF00) << 40) | ((block & 0x0000000000FF0000) << 24) | ((block & 0x00000000FF000000) << 8) | ((block & 0x000000FF00000000) >> 8) | ((block & 0x0000FF0000000000) >> 24) | ((block & 0x00FF000000000000) >> 40) | block >> 56);
  data[hook(0, get_global_id(0))] = block;
}
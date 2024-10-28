//{"cmp":3,"dest":0,"src1":1,"src2":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void select_int3_uint3(global int* dest, global int* src1, global int* src2, global unsigned int* cmp) {
  size_t tid = get_global_id(0);
  size_t size = get_global_size(0);
  if (tid + 1 < size)
    vstore3(select(vload3(tid, src1), vload3(tid, src2), vload3(tid, cmp)), tid, dest);
  else if (tid + 1 == size) {
    size_t leftovers = 1 + (size & 1);
    int3 a, b;
    uint3 c;
    switch (leftovers) {
      case 2:
        a.y = src1[hook(1, 3 * tid + 1)];
        b.y = src2[hook(2, 3 * tid + 1)];
        c.y = cmp[hook(3, 3 * tid + 1)];

      case 1:
        a.x = src1[hook(1, 3 * tid)];
        b.x = src2[hook(2, 3 * tid)];
        c.x = cmp[hook(3, 3 * tid)];
        break;
    }
    a = select(a, b, c);
    switch (leftovers) {
      case 2:
        dest[hook(0, 3 * tid + 1)] = a.y;

      case 1:
        dest[hook(0, 3 * tid)] = a.x;
        break;
    }
  }
}
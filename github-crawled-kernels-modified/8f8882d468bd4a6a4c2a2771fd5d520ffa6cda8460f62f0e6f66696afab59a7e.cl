//{"dst":0,"found":4,"found_ind":3,"input":1,"salt":6,"singlehash":5,"size":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void __attribute__((reqd_work_group_size(64, 1, 1))) final(global uint4* dst, global unsigned int* input, global unsigned int* size, global unsigned int* found_ind, global unsigned int* found, uint4 singlehash, uint16 salt) {
  uint4 a, b, c, d;

  a.s0 = input[hook(1, (get_global_id(0) * 16))];
  b.s0 = input[hook(1, (get_global_id(0) * 16) + 1)];
  c.s0 = input[hook(1, (get_global_id(0) * 16) + 2)];
  d.s0 = input[hook(1, (get_global_id(0) * 16) + 3)];
  a.s1 = input[hook(1, (get_global_id(0) * 16) + 4)];
  b.s1 = input[hook(1, (get_global_id(0) * 16) + 5)];
  c.s1 = input[hook(1, (get_global_id(0) * 16) + 6)];
  d.s1 = input[hook(1, (get_global_id(0) * 16) + 7)];
  a.s2 = input[hook(1, (get_global_id(0) * 16) + 8)];
  b.s2 = input[hook(1, (get_global_id(0) * 16) + 9)];
  c.s2 = input[hook(1, (get_global_id(0) * 16) + 10)];
  d.s2 = input[hook(1, (get_global_id(0) * 16) + 11)];
  a.s3 = input[hook(1, (get_global_id(0) * 16) + 12)];
  b.s3 = input[hook(1, (get_global_id(0) * 16) + 13)];
  c.s3 = input[hook(1, (get_global_id(0) * 16) + 14)];
  d.s3 = input[hook(1, (get_global_id(0) * 16) + 15)];

  if (all((uint4)singlehash.x != a))
    return;
  if (all((uint4)singlehash.y != b))
    return;

  found[hook(4, 0)] = 1;
  found_ind[hook(3, get_global_id(0))] = 1;

  dst[hook(0, (get_global_id(0) << 2))] = (uint4)(a.x, b.x, c.x, d.x);
  dst[hook(0, (get_global_id(0) << 2) + 1)] = (uint4)(a.y, b.y, c.y, d.y);
  dst[hook(0, (get_global_id(0) << 2) + 2)] = (uint4)(a.z, b.z, c.z, d.z);
  dst[hook(0, (get_global_id(0) << 2) + 3)] = (uint4)(a.w, b.w, c.w, d.w);
}
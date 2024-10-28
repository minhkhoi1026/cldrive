//{"dst":0,"found":4,"found_ind":3,"input":1,"salt":6,"singlehash":5,"size":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void __attribute__((reqd_work_group_size(64, 1, 1))) final(global uint4* dst, global unsigned int* input, global unsigned int* size, global unsigned int* found_ind, global unsigned int* found, uint4 singlehash, uint16 salt) {
  unsigned int a, b, c, d;

  a = input[hook(1, (get_global_id(0) * 4))];
  b = input[hook(1, (get_global_id(0) * 4) + 1)];
  c = input[hook(1, (get_global_id(0) * 4) + 2)];
  d = input[hook(1, (get_global_id(0) * 4) + 3)];

  if (((unsigned int)singlehash.x != a))
    return;
  if (((unsigned int)singlehash.y != b))
    return;

  found[hook(4, 0)] = 1;
  found_ind[hook(3, get_global_id(0))] = 1;

  dst[hook(0, (get_global_id(0)))] = (uint4)(a, b, c, d);
}
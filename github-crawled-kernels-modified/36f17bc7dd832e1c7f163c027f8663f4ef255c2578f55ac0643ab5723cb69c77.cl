//{"in":0,"in_char":2,"out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void ParallelSelection_byte_improved(global uchar4* in, global uchar* out) {
  unsigned i = get_global_id(0);
  unsigned n = get_global_size(0);
  global unsigned char* in_char = (global unsigned char*)in;
  unsigned ith = in_char[hook(2, i)];
  unsigned pos = 0, j = 0;
  do {
    uchar4 tmp = in[hook(0, j >> 2)];
    unsigned jth = tmp.x;
    bool smaller = (jth < ith);
    bool equal_and_smaller = (jth == ith && j < i);
    pos += smaller || equal_and_smaller;
    j++;
    jth = tmp.y;
    smaller = (jth < ith);
    equal_and_smaller = (jth == ith && j < i);
    pos += smaller || equal_and_smaller;
    j++;
    jth = tmp.z;
    smaller = (jth < ith);
    equal_and_smaller = (jth == ith && j < i);
    pos += smaller || equal_and_smaller;
    j++;
    jth = tmp.w;
    smaller = (jth < ith);
    equal_and_smaller = (jth == ith && j < i);
    pos += smaller || equal_and_smaller;
    j++;
  } while (j != n);
  out[hook(1, pos)] = ith;
}
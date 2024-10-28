//{"out1":1,"out2":2,"source":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
short4 custom_as_short4(int2 val) {
  return ((union {
           int2 src;
           short4 dst;
         }){.src = val})
      .dst;
}

uchar8 custom_as_uchar8(int2 val) {
  return ((union {
           int2 src;
           uchar8 dst;
         }){.src = val})
      .dst;
}

kernel void test_as_type(int2 source, global short4* out1, global uchar8* out2) {
  unsigned int gid = get_global_id(0) * 2;
  out1[hook(1, gid)] = __builtin_astype((source), short4);
  out2[hook(2, gid)] = __builtin_astype((source), uchar8);
  out1[hook(1, gid + 1)] = custom_as_short4(source);
  out2[hook(2, gid + 1)] = custom_as_uchar8(source);
}
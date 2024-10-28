//{"alignmentOffsets":2,"offsets":1,"results":3,"sPrivateStorage":4,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_fn3(global short2* src, global unsigned int* offsets, global unsigned int* alignmentOffsets, global short2* results) {
 private
  short2 sPrivateStorage[64];
  int tid = get_global_id(0);

  for (int i = 0; i < 64; i++)
    sPrivateStorage[hook(4, i)] = src[hook(0, i)];

  short2 tmp = vload2(offsets[hook(1, tid)], ((private short*)sPrivateStorage) + alignmentOffsets[hook(2, tid)]);
  results[hook(3, tid)] = tmp;
}
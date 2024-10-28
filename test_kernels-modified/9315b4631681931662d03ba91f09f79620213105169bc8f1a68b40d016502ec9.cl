//{"keySumArray":0,"keys":2,"postSumArray":1,"vals":3,"vecSize":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void perBlockAdditionByKey(global unsigned int* keySumArray, global int* postSumArray, global unsigned int* keys, global int* vals, const unsigned int vecSize) {
  size_t gloId = get_global_id(0);
  size_t groId = get_group_id(0);
  size_t locId = get_local_id(0);

  if (gloId >= vecSize)
    return;

  int scanResult = vals[hook(3, gloId)];

  unsigned int key1 = keySumArray[hook(0, groId - 1)];
  unsigned int key2 = keys[hook(2, gloId)];
  if (groId > 0 && (key1 == key2)) {
    int postBlockSum = postSumArray[hook(1, groId - 1)];
    int newResult = (scanResult + postBlockSum);
    vals[hook(3, gloId)] = newResult;
  }
}
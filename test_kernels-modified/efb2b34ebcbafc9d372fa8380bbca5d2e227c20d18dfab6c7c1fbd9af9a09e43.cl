//{"init":2,"keyBuffer":6,"keys":0,"ldsKeys":4,"ldsVals":5,"valBuffer":7,"vals":1,"vecSize":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void perBlockScanByKey(global unsigned int* keys, global int* vals, int init, const unsigned int vecSize, local unsigned int* ldsKeys, local int* ldsVals, global unsigned int* keyBuffer, global int* valBuffer) {
  size_t gloId = get_global_id(0);
  size_t groId = get_group_id(0);
  size_t locId = get_local_id(0);
  size_t wgSize = get_local_size(0);

  unsigned int key;
  int val;
  if (gloId < vecSize) {
    key = keys[hook(0, gloId)];
    val = vals[hook(1, gloId)];
    ldsKeys[hook(4, locId)] = key;
    ldsVals[hook(5, locId)] = val;
  }

  int sum = val;
  for (size_t offset = 1; offset < wgSize; offset *= 2) {
    barrier(0x01);
    if (locId >= offset) {
      unsigned int key2 = ldsKeys[hook(4, locId - offset)];
      if (key == key2) {
        int y = ldsVals[hook(5, locId - offset)];
        sum = (sum + y);
      }
    }
    barrier(0x01);
    ldsVals[hook(5, locId)] = sum;
  }

  barrier(0x01);

  if (gloId >= vecSize)
    return;

  unsigned int curkey, prekey;

  vals[hook(1, gloId)] = sum + init;

  if (locId == 0) {
    keyBuffer[hook(6, groId)] = ldsKeys[hook(4, wgSize - 1)];
    valBuffer[hook(7, groId)] = ldsVals[hook(5, wgSize - 1)];
  }
}
//{"bitRev":0,"logSize":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void reverse(global int* bitRev, int logSize) {
  int global_id = get_global_id(0);

  int powMaxLvl = 11;
  int powLevels, powRemain, powX, x;

  int i, j, andmask, sum = 0, k;
  for (i = logSize - 1, j = 0; i >= 0; i--, j++) {
    andmask = 1 << i;
    k = global_id & andmask;
    powLevels = j / powMaxLvl;
    powRemain = j % powMaxLvl;
    powX = 1;
    for (x = 0; x < powLevels; x++)
      powX *= pow(2.0f, powMaxLvl);
    powX *= pow(2.0f, powRemain);
    sum += k == 0 ? 0 : powX;
  }
  bitRev[hook(0, global_id)] = sum;
  bitRev[hook(0, global_id + get_global_size(0))] = sum + 1;
}
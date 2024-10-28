//{"dA":0,"dB":1,"dC":3,"prods":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void ArrayMultReduce(global const float* dA, const global float* dB, local float* prods, global float* dC) {
  int gid = get_global_id(0);
  int tnum = get_local_id(0);
  int wgnum = get_group_id(0);
  int numItems = get_local_size(0);

  prods[hook(2, tnum)] = dA[hook(0, gid)] * dB[hook(1, gid)];

  for (int offset = 1; offset < numItems; offset *= 2) {
    int mask = 2 * offset - 1;
    barrier(0x01);
    if ((tnum & mask) == 0) {
      prods[hook(2, tnum)] += prods[hook(2, tnum + offset)];
    }
  }

  barrier(0x01);

  if (tnum == 0) {
    dC[hook(3, wgnum)] = prods[hook(2, 0)];
  }
}
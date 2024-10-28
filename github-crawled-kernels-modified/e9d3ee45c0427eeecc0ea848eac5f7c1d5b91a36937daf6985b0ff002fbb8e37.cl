//{"currentBump":4,"out":2,"outSize":3,"spike":0,"spikeIndex":1,"tmp":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void buildSpikes(global float* spike, global int* spikeIndex, global float* out, int outSize, int currentBump, local int* tmp) {
  float accumulator = 0;
  int gtid = get_global_id(0);
  int ltid = get_local_id(0);
  int spikeLoop = 0;
  for (int groupLoop = 0; (groupLoop - 1) * (int)get_global_size(0) + 1 < outSize; groupLoop++) {
    spikeLoop = groupLoop * get_global_size(0) + ltid;
    if (spikeLoop < currentBump)
      tmp[hook(5, ltid)] = spikeIndex[hook(1, spikeLoop)];
    else
      tmp[hook(5, ltid)] = -1;
    barrier(0x01);
    if (gtid < outSize) {
      for (int offset = 0; offset < (int)get_local_size(0); offset++) {
        if (tmp[hook(5, offset)] == gtid) {
          accumulator += spike[hook(0, tmp[ohook(5, offset))];
        }
      }
    }
  }
  out[hook(2, gtid)] = accumulator;
}
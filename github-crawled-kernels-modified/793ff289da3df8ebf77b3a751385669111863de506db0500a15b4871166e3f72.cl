//{"block_sums":1,"count":2,"output":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void WriteScannedOutput(global int* output, global int* block_sums, const unsigned int count) {
  const unsigned int gid = get_global_id(0);
  const unsigned int block_id = get_group_id(0);

  if (gid < count) {
    output[hook(0, gid)] += block_sums[hook(1, block_id)];
  }
}
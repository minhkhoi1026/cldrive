//{"sum":0,"tmpSum":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void AtomicSum(global int* sum) {
  local int tmpSum[4];
  if (get_local_id(0) < 4) {
    tmpSum[hook(1, get_local_id(0))] = 0;
  }
  barrier(0x01);
  atomic_add(&tmpSum[hook(1, get_global_id(0) % 4)], 1);
  barrier(0x01);
  if (get_local_id(0) == (get_local_size(0) - 1)) {
    atomic_add(sum, tmpSum[hook(1, 0)] + tmpSum[hook(1, 1)] + tmpSum[hook(1, 2)] + tmpSum[hook(1, 3)]);
  }
}
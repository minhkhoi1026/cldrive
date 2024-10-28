//{"l_sum":2,"p":1,"result":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void local_sum(local long8* result, const long8 p) {
  local long8 l_sum[1024];

  size_t local_id = get_local_id(0);
  l_sum[hook(2, local_id)] = p;

  barrier(0x01);
  if (local_id < 256) {
    l_sum[hook(2, local_id)] += l_sum[hook(2, local_id + 256)];
  }

  barrier(0x01);
  if (local_id < 128) {
    l_sum[hook(2, local_id)] += l_sum[hook(2, local_id + 128)];
  }
  barrier(0x01);
  if (local_id < 64) {
    l_sum[hook(2, local_id)] += l_sum[hook(2, local_id + 64)];
  }
  barrier(0x01);
  if (local_id < 32) {
    l_sum[hook(2, local_id)] += l_sum[hook(2, local_id + 32)];
  }

  if (local_id < 16) {
    l_sum[hook(2, local_id)] += l_sum[hook(2, local_id + 16)];
  }

  if (local_id < 8) {
    l_sum[hook(2, local_id)] += l_sum[hook(2, local_id + 8)];
  }

  if (local_id < 4) {
    l_sum[hook(2, local_id)] += l_sum[hook(2, local_id + 4)];
  }

  if (local_id < 2) {
    l_sum[hook(2, local_id)] += l_sum[hook(2, local_id + 2)];
  }

  if (local_id < 1) {
    *result += l_sum[hook(2, local_id)] + l_sum[hook(2, local_id + 1)];
  }
  barrier(0x01);
}
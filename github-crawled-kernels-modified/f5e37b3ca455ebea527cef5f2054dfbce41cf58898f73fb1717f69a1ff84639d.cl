//{"l_sum":2,"p":1,"result":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
struct ResLine {
  long v0;
  long v1;
  long v2;
  long v3;
  long v4;
  long v5;
};

kernel void local_sum(local long* result, const long p) {
  local long l_sum[1024];
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
  barrier(0x01);
  if (local_id < 16) {
    l_sum[hook(2, local_id)] += l_sum[hook(2, local_id + 16)];
  }
  barrier(0x01);
  if (local_id < 8) {
    l_sum[hook(2, local_id)] += l_sum[hook(2, local_id + 8)];
  }
  barrier(0x01);
  if (local_id < 4) {
    l_sum[hook(2, local_id)] += l_sum[hook(2, local_id + 4)];
  }
  barrier(0x01);
  if (local_id < 2) {
    l_sum[hook(2, local_id)] += l_sum[hook(2, local_id + 2)];
  }
  barrier(0x01);
  if (local_id < 1) {
    *result += l_sum[hook(2, local_id)] + l_sum[hook(2, local_id + 1)];
  }
  barrier(0x01);
}
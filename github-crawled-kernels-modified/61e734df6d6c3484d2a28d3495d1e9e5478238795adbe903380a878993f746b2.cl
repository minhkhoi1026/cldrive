//{"buffer":2,"result":1,"x":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void sum8192Kernel(global const int* x, global int* result) {
  local int buffer[512];
  int gid = get_local_id(0);
  buffer[hook(2, gid)] = x[hook(0, gid)] + x[hook(0, gid + 512)] + x[hook(0, gid + 1024)] + x[hook(0, gid + 1536)] + x[hook(0, gid + 2048)] + x[hook(0, gid + 2560)] + x[hook(0, gid + 3072)] + x[hook(0, gid + 3584)] + x[hook(0, gid + 4096)] + x[hook(0, gid + 4608)] + x[hook(0, gid + 5120)] + x[hook(0, gid + 5632)] + x[hook(0, gid + 6144)] + x[hook(0, gid + 6656)] + x[hook(0, gid + 7168)] + x[hook(0, gid + 7680)];
  barrier(0x01);
  if (gid < 256)
    buffer[hook(2, gid)] = buffer[hook(2, gid)] + buffer[hook(2, gid + 256)];
  barrier(0x01);
  if (gid < 128)
    buffer[hook(2, gid)] = buffer[hook(2, gid)] + buffer[hook(2, gid + 128)];
  barrier(0x01);
  if (gid < 64)
    buffer[hook(2, gid)] = buffer[hook(2, gid)] + buffer[hook(2, gid + 64)];
  barrier(0x01);
  if (gid < 32)
    buffer[hook(2, gid)] = buffer[hook(2, gid)] + buffer[hook(2, gid + 32)];
  if (gid < 16)
    buffer[hook(2, gid)] = buffer[hook(2, gid)] + buffer[hook(2, gid + 16)];
  if (gid < 8)
    buffer[hook(2, gid)] = buffer[hook(2, gid)] + buffer[hook(2, gid + 8)];
  if (gid < 4)
    buffer[hook(2, gid)] = buffer[hook(2, gid)] + buffer[hook(2, gid + 4)];
  if (gid < 2)
    buffer[hook(2, gid)] = buffer[hook(2, gid)] + buffer[hook(2, gid + 2)];
  if (gid == 0)
    result[hook(1, 0)] = buffer[hook(2, 0)] + buffer[hook(2, 1)];
}
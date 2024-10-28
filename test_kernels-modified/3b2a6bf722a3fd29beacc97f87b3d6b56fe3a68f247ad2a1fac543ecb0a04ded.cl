//{"buffer":2,"globalData":3,"in":0,"out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void vc4cl_mutex_lock(void) __attribute__((overloadable));
void vc4cl_mutex_unlock(void) __attribute__((overloadable));
uint8 vc4cl_dma_read(volatile local uint8*) __attribute__((overloadable));
constant uint8 globalData[32] = {};

kernel void test_global_data(global const uint8* in, global uint8* out) {
  local uint8 buffer[32];

  buffer[hook(2, get_global_id(0))] = in[hook(0, get_global_id(0))];

  vc4cl_mutex_lock();
  vc4cl_dma_read(buffer + get_global_id(0));
  vc4cl_mutex_unlock();
  barrier(0x01);
  if (get_global_id(0) > 0)
    buffer[hook(2, get_global_id(0))] += buffer[hook(2, get_global_id(0) - 1)];
  barrier(0x01);
  out[hook(1, get_global_id(0))] = buffer[hook(2, get_global_id(0))] + globalData[hook(3, get_global_id(0))];
}
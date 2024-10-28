//{"frontier_length":0,"g_mutex":1,"g_mutex2":2,"g_q_offsets":3,"g_q_size":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void __gpu_sync(int blocks_to_synch, volatile global unsigned int* g_mutex) {
  barrier(0x01 | 0x02);
  int tid_in_block = get_local_id(0);

  if (tid_in_block == 0) {
    atomic_add(g_mutex, 1);

    while (g_mutex[hook(1, 0)] < blocks_to_synch) {
    }
  }
  barrier(0x01 | 0x02);
}
kernel void Reset_kernel_parameters(

    global unsigned int* frontier_length, global volatile int* g_mutex, global volatile int* g_mutex2, global volatile int* g_q_offsets, global volatile int* g_q_size) {
  g_mutex[hook(1, 0)] = 0;
  g_mutex2[hook(2, 0)] = 0;
  *frontier_length = 0;
  *g_q_offsets = 0;
  g_q_size[hook(4, 0)] = 0;
}
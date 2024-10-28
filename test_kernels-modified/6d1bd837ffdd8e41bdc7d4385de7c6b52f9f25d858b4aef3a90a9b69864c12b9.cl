//{"frontier":0,"frontier2":1,"frontier_length":2,"g_mutex":3,"g_mutex2":4,"g_q_offsets":5,"g_q_size":6}
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

    while (g_mutex[hook(3, 0)] < blocks_to_synch) {
    }
  }
  barrier(0x01 | 0x02);
}
kernel void Frontier_copy(global unsigned int* frontier, global unsigned int* frontier2, global unsigned int* frontier_length, global volatile int* g_mutex, global volatile int* g_mutex2, global volatile int* g_q_offsets, global volatile int* g_q_size) {
  unsigned int tid = get_global_id(0);

  if (tid < *frontier_length) {
    frontier[hook(0, tid)] = frontier2[hook(1, tid)];
  }
}
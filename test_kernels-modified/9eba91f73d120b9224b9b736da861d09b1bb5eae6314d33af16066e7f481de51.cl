//{"b_offset":14,"b_q":11,"b_q_length":13,"cost":4,"edgeArray":5,"edgeArrayAux":6,"frontier":0,"frontier2":2,"frontier_len":1,"frontier_length":9,"g_mutex":12,"max_local_mem":10,"numEdges":8,"numVertices":7,"visited":3}
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

    while (g_mutex[hook(12, 0)] < blocks_to_synch) {
    }
  }
  barrier(0x01 | 0x02);
}
kernel void BFS_kernel_multi_block(

    volatile global unsigned int* frontier, unsigned int frontier_len, volatile global unsigned int* frontier2, volatile global int* visited, volatile global unsigned int* cost, global unsigned int* edgeArray, global unsigned int* edgeArrayAux, unsigned int numVertices, unsigned int numEdges, volatile global unsigned int* frontier_length, const unsigned int max_local_mem,

    volatile local unsigned int* b_q) {
  volatile local unsigned int b_q_length[1];
  volatile local unsigned int b_offset[1];

  unsigned int tid = get_global_id(0);
  unsigned int lid = get_local_id(0);

  if (lid == 0) {
    b_q_length[hook(13, 0)] = 0;
    b_offset[hook(14, 0)] = 0;
  }

  barrier(0x01 | 0x02);
  if (tid < frontier_len) {
    unsigned int node_to_process = frontier[hook(0, tid)];
    visited[hook(3, node_to_process)] = 0;

    unsigned int offset = edgeArray[hook(5, node_to_process)];
    unsigned int next = edgeArray[hook(5, node_to_process + 1)];

    while (offset < next) {
      unsigned int nid = edgeArrayAux[hook(6, offset)];

      unsigned int v = atomic_min(&cost[hook(4, nid)], cost[hook(4, node_to_process)] + 1);

      if (v > cost[hook(4, node_to_process)] + 1) {
        int is_in_frontier = atomic_xchg(&visited[hook(3, nid)], 1);

        if (is_in_frontier == 0) {
          unsigned int t = atomic_add(&b_q_length[hook(13, 0)], 1);
          if (t < max_local_mem) {
            b_q[hook(11, t)] = nid;
          }

          else {
            int off = atomic_add(frontier_length, 1);
            frontier2[hook(2, off)] = nid;
          }
        }
      }
      offset++;
    }
  }
  barrier(0x01 | 0x02);

  if (lid == 0) {
    if (b_q_length[hook(13, 0)] > max_local_mem) {
      b_q_length[hook(13, 0)] = max_local_mem;
    }
    b_offset[hook(14, 0)] = atomic_add(frontier_length, b_q_length[hook(13, 0)]);
  }

  barrier(0x01 | 0x02);

  if (lid < b_q_length[hook(13, 0)])
    frontier2[hook(2, lid + b_offset[0hook(14, 0))] = b_q[hook(11, lid)];
}
//{"b_offset":14,"b_q":10,"b_q2":11,"b_q_length":13,"cost":3,"edgeArray":4,"edgeArrayAux":5,"frontier":0,"frontier_len":1,"frontier_length":8,"g_mutex":12,"max_local_mem":9,"numEdges":7,"numVertices":6,"visited":2}
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
kernel void BFS_kernel_one_block(

    volatile global unsigned int* frontier, unsigned int frontier_len, volatile global int* visited, volatile global unsigned int* cost, global unsigned int* edgeArray, global unsigned int* edgeArrayAux, unsigned int numVertices, unsigned int numEdges, volatile global unsigned int* frontier_length, const unsigned int max_local_mem,

    volatile local unsigned int* b_q, volatile local unsigned int* b_q2) {
  volatile local unsigned int b_offset[1];
  volatile local unsigned int b_q_length[1];

  unsigned int tid = get_local_id(0);

  if (tid < frontier_len) {
    b_q[hook(10, tid)] = frontier[hook(0, tid)];
  }

  unsigned int f_len = frontier_len;
  barrier(0x01 | 0x02);
  while (1) {
    if (tid == 0) {
      b_q_length[hook(13, 0)] = 0;
      b_offset[hook(14, 0)] = 0;
    }
    barrier(0x01 | 0x02);
    if (tid < f_len) {
      unsigned int node_to_process = b_q[hook(10, tid)];

      visited[hook(2, node_to_process)] = 0;

      unsigned int offset = edgeArray[hook(4, node_to_process)];
      unsigned int next = edgeArray[hook(4, node_to_process + 1)];

      while (offset < next) {
        unsigned int nid = edgeArrayAux[hook(5, offset)];

        unsigned int v = atomic_min(&cost[hook(3, nid)], cost[hook(3, node_to_process)] + 1);

        if (v > cost[hook(3, node_to_process)] + 1) {
          int is_in_frontier = atomic_xchg(&visited[hook(2, nid)], 1);

          if (is_in_frontier == 0) {
            unsigned int t = atomic_add(&b_q_length[hook(13, 0)], 1);
            if (t < max_local_mem) {
              b_q2[hook(11, t)] = nid;
            }

            else {
              int off = atomic_add(&b_offset[hook(14, 0)], 1);
              frontier[hook(0, off)] = nid;
            }
          }
        }
        offset++;
      }
    }
    barrier(0x01 | 0x02);

    if (tid < max_local_mem)
      b_q[hook(10, tid)] = b_q2[hook(11, tid)];
    barrier(0x01 | 0x02);

    if (b_q_length[hook(13, 0)] == 0) {
      if (tid == 0)
        frontier_length[hook(8, 0)] = 0;

      return;
    }

    else if (b_q_length[hook(13, 0)] > get_local_size(0) || b_q_length[hook(13, 0)] > max_local_mem) {
      if (tid < (b_q_length[hook(13, 0)] - b_offset[hook(14, 0)]))
        frontier[hook(0, b_offset[0hook(14, 0) + tid)] = b_q[hook(10, tid)];
      if (tid == 0) {
        frontier_length[hook(8, 0)] = b_q_length[hook(13, 0)];
      }
      return;
    }
    f_len = b_q_length[hook(13, 0)];
    barrier(0x01 | 0x02);
  }
}
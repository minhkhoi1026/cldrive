//{"b_offset":17,"b_q":15,"b_q_length":16,"cost":4,"edgeArray":5,"edgeArrayAux":6,"frontier":0,"frontier2":2,"frontier_len":1,"frontier_length":9,"g_mutex":10,"g_mutex2":11,"g_q_offsets":12,"g_q_size":13,"max_local_mem":14,"numEdges":8,"numVertices":7,"visited":3}
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

    while (g_mutex[hook(10, 0)] < blocks_to_synch) {
    }
  }
  barrier(0x01 | 0x02);
}
kernel void BFS_kernel_SM_block(

    volatile global unsigned int* frontier, unsigned int frontier_len, volatile global unsigned int* frontier2, volatile global int* visited, volatile global unsigned int* cost, global unsigned int* edgeArray, global unsigned int* edgeArrayAux, unsigned int numVertices, unsigned int numEdges, volatile global unsigned int* frontier_length, volatile global unsigned int* g_mutex, volatile global unsigned int* g_mutex2, volatile global unsigned int* g_q_offsets, volatile global unsigned int* g_q_size, const unsigned int max_local_mem,

    volatile local unsigned int* b_q) {
  volatile local unsigned int b_q_length[1];
  volatile local unsigned int b_offset[1];

  unsigned int tid = get_global_id(0);
  unsigned int lid = get_local_id(0);

  int loop_index = 0;
  unsigned int l_mutex = g_mutex2[hook(11, 0)];
  unsigned int f_len = frontier_len;
  barrier(0x01 | 0x02);
  while (1) {
    if (lid == 0) {
      b_q_length[hook(16, 0)] = 0;
      b_offset[hook(17, 0)] = 0;
    }
    barrier(0x01 | 0x02);
    if (tid < f_len) {
      unsigned int node_to_process;

      if (loop_index == 0)
        node_to_process = frontier[hook(0, tid)];
      else
        node_to_process = frontier2[hook(2, tid)];

      visited[hook(3, node_to_process)] = 0;

      unsigned int offset = edgeArray[hook(5, node_to_process)];
      unsigned int next = edgeArray[hook(5, node_to_process + 1)];

      while (offset < next) {
        unsigned int nid = edgeArrayAux[hook(6, offset)];

        unsigned int v = atomic_min(&cost[hook(4, nid)], cost[hook(4, node_to_process)] + 1);

        if (v > cost[hook(4, node_to_process)] + 1) {
          int is_in_frontier = atomic_xchg(&visited[hook(3, nid)], 1);

          if (is_in_frontier == 0) {
            unsigned int t = atomic_add(&b_q_length[hook(16, 0)], 1);
            if (t < max_local_mem) {
              b_q[hook(15, t)] = nid;
            }

            else {
              int off = atomic_add(g_q_offsets, 1);
              if (loop_index == 0)
                frontier2[hook(2, off)] = nid;
              else
                frontier[hook(0, off)] = nid;
            }
          }
        }
        offset++;
      }
    }

    barrier(0x01 | 0x02);

    if (lid == 0) {
      if (b_q_length[hook(16, 0)] > max_local_mem) {
        b_q_length[hook(16, 0)] = max_local_mem;
      }
      b_offset[hook(17, 0)] = atomic_add(g_q_offsets, b_q_length[hook(16, 0)]);
    }

    barrier(0x01 | 0x02);
    l_mutex += get_num_groups(0);
    __gpu_sync(l_mutex, g_mutex);

    if (tid == 0) {
      g_q_size[hook(13, 0)] = g_q_offsets[hook(12, 0)];
      g_q_offsets[hook(12, 0)] = 0;
    }

    if (lid < b_q_length[hook(16, 0)]) {
      if (loop_index == 0)
        frontier2[hook(2, lid + b_offset[0hook(17, 0))] = b_q[hook(15, lid)];
      else
        frontier[hook(0, lid + b_offset[0hook(17, 0))] = b_q[hook(15, lid)];
    }

    l_mutex += get_num_groups(0);
    __gpu_sync(l_mutex, g_mutex);

    if (g_q_size[hook(13, 0)] < get_local_size(0) || g_q_size[hook(13, 0)] > get_local_size(0) * get_num_groups(0))
      break;

    loop_index = (loop_index + 1) % 2;

    f_len = g_q_size[hook(13, 0)];
  }

  if (loop_index == 0) {
    for (int i = tid; i < g_q_size[hook(13, 0)]; i += get_global_size(0))
      frontier[hook(0, i)] = frontier2[hook(2, i)];
  }
  if (tid == 0) {
    frontier_length[hook(9, 0)] = g_q_size[hook(13, 0)];
  }
}
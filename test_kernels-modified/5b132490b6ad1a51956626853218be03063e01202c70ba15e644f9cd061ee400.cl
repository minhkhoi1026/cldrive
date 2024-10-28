//{"cell_indices_end":4,"cell_indices_start":3,"gp":5,"num":0,"sharedHash":6,"sort_hashes":1,"sort_indices":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
struct GridParams {
  float4 grid_size;
  float4 grid_min;
  float4 grid_max;
  float4 bnd_min;
  float4 bnd_max;

  float4 grid_res;
  float4 grid_delta;

  int nb_cells;
};

kernel void cellindices(int num, global unsigned int* sort_hashes, global unsigned int* sort_indices, global unsigned int* cell_indices_start, global unsigned int* cell_indices_end,

                        constant struct GridParams* gp, local unsigned int* sharedHash) {
  unsigned int index = get_global_id(0);

  unsigned int ncells = gp[hook(5, 0)].nb_cells;

  unsigned int hash = sort_hashes[hook(1, index)];

  if (hash > ncells) {
    return;
  }

  unsigned int tid = get_local_id(0);

  sharedHash[hook(6, tid + 1)] = hash;

  if (index > 0 && tid == 0) {
    unsigned int hashm1 = sort_hashes[hook(1, index - 1)] < ncells ? sort_hashes[hook(1, index - 1)] : ncells;
    sharedHash[hook(6, 0)] = hashm1;
  }

  barrier(0x01);
  if (index >= num)
    return;

  if (index == 0) {
    cell_indices_start[hook(3, hash)] = index;
  }

  if (index > 0) {
    if (sharedHash[hook(6, tid)] != hash) {
      cell_indices_start[hook(3, hash)] = index;
      cell_indices_end[hook(4, sharedHash[thook(6, tid))] = index;
    }
  }

  if (index == num - 1) {
    cell_indices_end[hook(4, hash)] = index + 1;
  }
}
//{"A":0,"B":1,"C":2,"K":5,"M":3,"N":4,"loadA":7,"loadB":8,"regA":11,"regB":12,"regC":6,"tileA":9,"tileB":10}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void gemm(const global float* A, const global float* B, global float* C, const int M, const int N, const int K) {
  int local_thread_id_x = get_local_id(0);
  int local_thread_id_y = get_local_id(1);
  int local_thread_id = get_local_size(0) * local_thread_id_y + local_thread_id_x;
  local_thread_id = 8 * local_thread_id_y + local_thread_id_x;

  int block_id_x = get_group_id(0);
  int block_id_y = get_group_id(1);

  int NUM_UNROLL = 8;

  int thread_task_x = 8;
  int thread_task_y = 8;
  int thread_task = thread_task_x * thread_task_y;

  int tile_dim_x = thread_task_x * get_local_size(0);
  tile_dim_x = 64;
  int tile_dim_y = thread_task_y * get_local_size(1);
  tile_dim_y = 64;

  local float tileA[64 * 8 * 2];

  local float tileB[64 * 8 * 2];

 private
  float loadA[8];
 private
  float loadB[8];

 private
  float regA[8], regB[8];

 private
  float regC[8 * 8];

  regC[hook(6, 0 * 8 + 0)] = 0;
  regC[hook(6, 0 * 8 + 1)] = 0;
  regC[hook(6, 0 * 8 + 2)] = 0;
  regC[hook(6, 0 * 8 + 3)] = 0;
  regC[hook(6, 0 * 8 + 4)] = 0;
  regC[hook(6, 0 * 8 + 5)] = 0;
  regC[hook(6, 0 * 8 + 6)] = 0;
  regC[hook(6, 0 * 8 + 7)] = 0;

  regC[hook(6, 1 * 8 + 0)] = 0;
  regC[hook(6, 1 * 8 + 1)] = 0;
  regC[hook(6, 1 * 8 + 2)] = 0;
  regC[hook(6, 1 * 8 + 3)] = 0;
  regC[hook(6, 1 * 8 + 4)] = 0;
  regC[hook(6, 1 * 8 + 5)] = 0;
  regC[hook(6, 1 * 8 + 6)] = 0;
  regC[hook(6, 1 * 8 + 7)] = 0;

  regC[hook(6, 2 * 8 + 0)] = 0;
  regC[hook(6, 2 * 8 + 1)] = 0;
  regC[hook(6, 2 * 8 + 2)] = 0;
  regC[hook(6, 2 * 8 + 3)] = 0;
  regC[hook(6, 2 * 8 + 4)] = 0;
  regC[hook(6, 2 * 8 + 5)] = 0;
  regC[hook(6, 2 * 8 + 6)] = 0;
  regC[hook(6, 2 * 8 + 7)] = 0;

  regC[hook(6, 3 * 8 + 0)] = 0;
  regC[hook(6, 3 * 8 + 1)] = 0;
  regC[hook(6, 3 * 8 + 2)] = 0;
  regC[hook(6, 3 * 8 + 3)] = 0;
  regC[hook(6, 3 * 8 + 4)] = 0;
  regC[hook(6, 3 * 8 + 5)] = 0;
  regC[hook(6, 3 * 8 + 6)] = 0;
  regC[hook(6, 3 * 8 + 7)] = 0;

  regC[hook(6, 4 * 8 + 0)] = 0;
  regC[hook(6, 4 * 8 + 1)] = 0;
  regC[hook(6, 4 * 8 + 2)] = 0;
  regC[hook(6, 4 * 8 + 3)] = 0;
  regC[hook(6, 4 * 8 + 4)] = 0;
  regC[hook(6, 4 * 8 + 5)] = 0;
  regC[hook(6, 4 * 8 + 6)] = 0;
  regC[hook(6, 4 * 8 + 7)] = 0;

  regC[hook(6, 5 * 8 + 0)] = 0;
  regC[hook(6, 5 * 8 + 1)] = 0;
  regC[hook(6, 5 * 8 + 2)] = 0;
  regC[hook(6, 5 * 8 + 3)] = 0;
  regC[hook(6, 5 * 8 + 4)] = 0;
  regC[hook(6, 5 * 8 + 5)] = 0;
  regC[hook(6, 5 * 8 + 6)] = 0;
  regC[hook(6, 5 * 8 + 7)] = 0;

  regC[hook(6, 6 * 8 + 0)] = 0;
  regC[hook(6, 6 * 8 + 1)] = 0;
  regC[hook(6, 6 * 8 + 2)] = 0;
  regC[hook(6, 6 * 8 + 3)] = 0;
  regC[hook(6, 6 * 8 + 4)] = 0;
  regC[hook(6, 6 * 8 + 5)] = 0;
  regC[hook(6, 6 * 8 + 6)] = 0;
  regC[hook(6, 6 * 8 + 7)] = 0;

  regC[hook(6, 7 * 8 + 0)] = 0;
  regC[hook(6, 7 * 8 + 1)] = 0;
  regC[hook(6, 7 * 8 + 2)] = 0;
  regC[hook(6, 7 * 8 + 3)] = 0;
  regC[hook(6, 7 * 8 + 4)] = 0;
  regC[hook(6, 7 * 8 + 5)] = 0;
  regC[hook(6, 7 * 8 + 6)] = 0;
  regC[hook(6, 7 * 8 + 7)] = 0;

  loadA[hook(7, 0)] = A[hook(0, (0 * NUM_UNROLL + local_thread_id_y) * M + block_id_x * tile_dim_x + local_thread_id_x * 8 + 0)];
  loadA[hook(7, 1)] = A[hook(0, (0 * NUM_UNROLL + local_thread_id_y) * M + block_id_x * tile_dim_x + local_thread_id_x * 8 + 1)];
  loadA[hook(7, 2)] = A[hook(0, (0 * NUM_UNROLL + local_thread_id_y) * M + block_id_x * tile_dim_x + local_thread_id_x * 8 + 2)];
  loadA[hook(7, 3)] = A[hook(0, (0 * NUM_UNROLL + local_thread_id_y) * M + block_id_x * tile_dim_x + local_thread_id_x * 8 + 3)];
  loadA[hook(7, 4)] = A[hook(0, (0 * NUM_UNROLL + local_thread_id_y) * M + block_id_x * tile_dim_x + local_thread_id_x * 8 + 4)];
  loadA[hook(7, 5)] = A[hook(0, (0 * NUM_UNROLL + local_thread_id_y) * M + block_id_x * tile_dim_x + local_thread_id_x * 8 + 5)];
  loadA[hook(7, 6)] = A[hook(0, (0 * NUM_UNROLL + local_thread_id_y) * M + block_id_x * tile_dim_x + local_thread_id_x * 8 + 6)];
  loadA[hook(7, 7)] = A[hook(0, (0 * NUM_UNROLL + local_thread_id_y) * M + block_id_x * tile_dim_x + local_thread_id_x * 8 + 7)];

  loadB[hook(8, 0)] = B[hook(1, (block_id_y * tile_dim_y + local_thread_id) * K + 0 * NUM_UNROLL + 0)];
  loadB[hook(8, 1)] = B[hook(1, (block_id_y * tile_dim_y + local_thread_id) * K + 0 * NUM_UNROLL + 1)];
  loadB[hook(8, 2)] = B[hook(1, (block_id_y * tile_dim_y + local_thread_id) * K + 0 * NUM_UNROLL + 2)];
  loadB[hook(8, 3)] = B[hook(1, (block_id_y * tile_dim_y + local_thread_id) * K + 0 * NUM_UNROLL + 3)];
  loadB[hook(8, 4)] = B[hook(1, (block_id_y * tile_dim_y + local_thread_id) * K + 0 * NUM_UNROLL + 4)];
  loadB[hook(8, 5)] = B[hook(1, (block_id_y * tile_dim_y + local_thread_id) * K + 0 * NUM_UNROLL + 5)];
  loadB[hook(8, 6)] = B[hook(1, (block_id_y * tile_dim_y + local_thread_id) * K + 0 * NUM_UNROLL + 6)];
  loadB[hook(8, 7)] = B[hook(1, (block_id_y * tile_dim_y + local_thread_id) * K + 0 * NUM_UNROLL + 7)];

  barrier(0x02);

 private
  int swap_index = 0;

  for (int i = 0; i < K / NUM_UNROLL; ++i) {
    tileA[hook(9, swap_index + local_thread_id_y * 64 + local_thread_id_x * 8 + 0)] = loadA[hook(7, 0)];
    tileA[hook(9, swap_index + local_thread_id_y * 64 + local_thread_id_x * 8 + 1)] = loadA[hook(7, 1)];
    tileA[hook(9, swap_index + local_thread_id_y * 64 + local_thread_id_x * 8 + 2)] = loadA[hook(7, 2)];
    tileA[hook(9, swap_index + local_thread_id_y * 64 + local_thread_id_x * 8 + 3)] = loadA[hook(7, 3)];
    tileA[hook(9, swap_index + local_thread_id_y * 64 + local_thread_id_x * 8 + 4)] = loadA[hook(7, 4)];
    tileA[hook(9, swap_index + local_thread_id_y * 64 + local_thread_id_x * 8 + 5)] = loadA[hook(7, 5)];
    tileA[hook(9, swap_index + local_thread_id_y * 64 + local_thread_id_x * 8 + 6)] = loadA[hook(7, 6)];
    tileA[hook(9, swap_index + local_thread_id_y * 64 + local_thread_id_x * 8 + 7)] = loadA[hook(7, 7)];

    tileB[hook(10, swap_index + local_thread_id + 0 * tile_dim_y)] = loadB[hook(8, 0)];
    tileB[hook(10, swap_index + local_thread_id + 1 * tile_dim_y)] = loadB[hook(8, 1)];
    tileB[hook(10, swap_index + local_thread_id + 2 * tile_dim_y)] = loadB[hook(8, 2)];
    tileB[hook(10, swap_index + local_thread_id + 3 * tile_dim_y)] = loadB[hook(8, 3)];
    tileB[hook(10, swap_index + local_thread_id + 4 * tile_dim_y)] = loadB[hook(8, 4)];
    tileB[hook(10, swap_index + local_thread_id + 5 * tile_dim_y)] = loadB[hook(8, 5)];
    tileB[hook(10, swap_index + local_thread_id + 6 * tile_dim_y)] = loadB[hook(8, 6)];
    tileB[hook(10, swap_index + local_thread_id + 7 * tile_dim_y)] = loadB[hook(8, 7)];

    barrier(0x01);

    if (i != (K / NUM_UNROLL - 1)) {
      loadA[hook(7, 0)] = A[hook(0, ((i + 1) * NUM_UNROLL + local_thread_id_y) * M + block_id_x * tile_dim_x + local_thread_id_x * 8 + 0)];
      loadA[hook(7, 1)] = A[hook(0, ((i + 1) * NUM_UNROLL + local_thread_id_y) * M + block_id_x * tile_dim_x + local_thread_id_x * 8 + 1)];
      loadA[hook(7, 2)] = A[hook(0, ((i + 1) * NUM_UNROLL + local_thread_id_y) * M + block_id_x * tile_dim_x + local_thread_id_x * 8 + 2)];
      loadA[hook(7, 3)] = A[hook(0, ((i + 1) * NUM_UNROLL + local_thread_id_y) * M + block_id_x * tile_dim_x + local_thread_id_x * 8 + 3)];
      loadA[hook(7, 4)] = A[hook(0, ((i + 1) * NUM_UNROLL + local_thread_id_y) * M + block_id_x * tile_dim_x + local_thread_id_x * 8 + 4)];
      loadA[hook(7, 5)] = A[hook(0, ((i + 1) * NUM_UNROLL + local_thread_id_y) * M + block_id_x * tile_dim_x + local_thread_id_x * 8 + 5)];
      loadA[hook(7, 6)] = A[hook(0, ((i + 1) * NUM_UNROLL + local_thread_id_y) * M + block_id_x * tile_dim_x + local_thread_id_x * 8 + 6)];
      loadA[hook(7, 7)] = A[hook(0, ((i + 1) * NUM_UNROLL + local_thread_id_y) * M + block_id_x * tile_dim_x + local_thread_id_x * 8 + 7)];

      loadB[hook(8, 0)] = B[hook(1, (block_id_y * tile_dim_y + local_thread_id) * K + (i + 1) * NUM_UNROLL + 0)];
      loadB[hook(8, 1)] = B[hook(1, (block_id_y * tile_dim_y + local_thread_id) * K + (i + 1) * NUM_UNROLL + 1)];
      loadB[hook(8, 2)] = B[hook(1, (block_id_y * tile_dim_y + local_thread_id) * K + (i + 1) * NUM_UNROLL + 2)];
      loadB[hook(8, 3)] = B[hook(1, (block_id_y * tile_dim_y + local_thread_id) * K + (i + 1) * NUM_UNROLL + 3)];
      loadB[hook(8, 4)] = B[hook(1, (block_id_y * tile_dim_y + local_thread_id) * K + (i + 1) * NUM_UNROLL + 4)];
      loadB[hook(8, 5)] = B[hook(1, (block_id_y * tile_dim_y + local_thread_id) * K + (i + 1) * NUM_UNROLL + 5)];
      loadB[hook(8, 6)] = B[hook(1, (block_id_y * tile_dim_y + local_thread_id) * K + (i + 1) * NUM_UNROLL + 6)];
      loadB[hook(8, 7)] = B[hook(1, (block_id_y * tile_dim_y + local_thread_id) * K + (i + 1) * NUM_UNROLL + 7)];
    }

    regA[hook(11, 0)] = tileA[hook(9, swap_index + 0 * tile_dim_x + local_thread_id_x * 4 + 0)];
    regA[hook(11, 1)] = tileA[hook(9, swap_index + 0 * tile_dim_x + local_thread_id_x * 4 + 1)];
    regA[hook(11, 2)] = tileA[hook(9, swap_index + 0 * tile_dim_x + local_thread_id_x * 4 + 2)];
    regA[hook(11, 3)] = tileA[hook(9, swap_index + 0 * tile_dim_x + local_thread_id_x * 4 + 3)];

    regA[hook(11, 4)] = tileA[hook(9, swap_index + 0 * tile_dim_x + tile_dim_x / 2 + local_thread_id_x * 4 + 0)];
    regA[hook(11, 5)] = tileA[hook(9, swap_index + 0 * tile_dim_x + tile_dim_x / 2 + local_thread_id_x * 4 + 1)];
    regA[hook(11, 6)] = tileA[hook(9, swap_index + 0 * tile_dim_x + tile_dim_x / 2 + local_thread_id_x * 4 + 2)];
    regA[hook(11, 7)] = tileA[hook(9, swap_index + 0 * tile_dim_x + tile_dim_x / 2 + local_thread_id_x * 4 + 3)];

    regB[hook(12, 0)] = tileB[hook(10, swap_index + 0 * tile_dim_y + local_thread_id_y * 4 + 0)];
    regB[hook(12, 1)] = tileB[hook(10, swap_index + 0 * tile_dim_y + local_thread_id_y * 4 + 1)];
    regB[hook(12, 2)] = tileB[hook(10, swap_index + 0 * tile_dim_y + local_thread_id_y * 4 + 2)];
    regB[hook(12, 3)] = tileB[hook(10, swap_index + 0 * tile_dim_y + local_thread_id_y * 4 + 3)];

    regB[hook(12, 4)] = tileB[hook(10, swap_index + 0 * tile_dim_y + tile_dim_y / 2 + local_thread_id_y * 4 + 0)];
    regB[hook(12, 5)] = tileB[hook(10, swap_index + 0 * tile_dim_y + tile_dim_y / 2 + local_thread_id_y * 4 + 1)];
    regB[hook(12, 6)] = tileB[hook(10, swap_index + 0 * tile_dim_y + tile_dim_y / 2 + local_thread_id_y * 4 + 2)];
    regB[hook(12, 7)] = tileB[hook(10, swap_index + 0 * tile_dim_y + tile_dim_y / 2 + local_thread_id_y * 4 + 3)];

    regC[hook(6, 0 * 8 + 0)] += regA[hook(11, 0)] * regB[hook(12, 0)];
    regC[hook(6, 0 * 8 + 1)] += regA[hook(11, 1)] * regB[hook(12, 0)];
    regC[hook(6, 0 * 8 + 2)] += regA[hook(11, 2)] * regB[hook(12, 0)];
    regC[hook(6, 0 * 8 + 3)] += regA[hook(11, 3)] * regB[hook(12, 0)];
    regC[hook(6, 0 * 8 + 4)] += regA[hook(11, 4)] * regB[hook(12, 0)];
    regC[hook(6, 0 * 8 + 5)] += regA[hook(11, 5)] * regB[hook(12, 0)];
    regC[hook(6, 0 * 8 + 6)] += regA[hook(11, 6)] * regB[hook(12, 0)];
    regC[hook(6, 0 * 8 + 7)] += regA[hook(11, 7)] * regB[hook(12, 0)];

    regC[hook(6, 1 * 8 + 0)] += regA[hook(11, 0)] * regB[hook(12, 1)];
    regC[hook(6, 1 * 8 + 1)] += regA[hook(11, 1)] * regB[hook(12, 1)];
    regC[hook(6, 1 * 8 + 2)] += regA[hook(11, 2)] * regB[hook(12, 1)];
    regC[hook(6, 1 * 8 + 3)] += regA[hook(11, 3)] * regB[hook(12, 1)];
    regC[hook(6, 1 * 8 + 4)] += regA[hook(11, 4)] * regB[hook(12, 1)];
    regC[hook(6, 1 * 8 + 5)] += regA[hook(11, 5)] * regB[hook(12, 1)];
    regC[hook(6, 1 * 8 + 6)] += regA[hook(11, 6)] * regB[hook(12, 1)];
    regC[hook(6, 1 * 8 + 7)] += regA[hook(11, 7)] * regB[hook(12, 1)];

    regC[hook(6, 2 * 8 + 0)] += regA[hook(11, 0)] * regB[hook(12, 2)];
    regC[hook(6, 2 * 8 + 1)] += regA[hook(11, 1)] * regB[hook(12, 2)];
    regC[hook(6, 2 * 8 + 2)] += regA[hook(11, 2)] * regB[hook(12, 2)];
    regC[hook(6, 2 * 8 + 3)] += regA[hook(11, 3)] * regB[hook(12, 2)];
    regC[hook(6, 2 * 8 + 4)] += regA[hook(11, 4)] * regB[hook(12, 2)];
    regC[hook(6, 2 * 8 + 5)] += regA[hook(11, 5)] * regB[hook(12, 2)];
    regC[hook(6, 2 * 8 + 6)] += regA[hook(11, 6)] * regB[hook(12, 2)];
    regC[hook(6, 2 * 8 + 7)] += regA[hook(11, 7)] * regB[hook(12, 2)];

    regC[hook(6, 3 * 8 + 0)] += regA[hook(11, 0)] * regB[hook(12, 3)];
    regC[hook(6, 3 * 8 + 1)] += regA[hook(11, 1)] * regB[hook(12, 3)];
    regC[hook(6, 3 * 8 + 2)] += regA[hook(11, 2)] * regB[hook(12, 3)];
    regC[hook(6, 3 * 8 + 3)] += regA[hook(11, 3)] * regB[hook(12, 3)];
    regC[hook(6, 3 * 8 + 4)] += regA[hook(11, 4)] * regB[hook(12, 3)];
    regC[hook(6, 3 * 8 + 5)] += regA[hook(11, 5)] * regB[hook(12, 3)];
    regC[hook(6, 3 * 8 + 6)] += regA[hook(11, 6)] * regB[hook(12, 3)];
    regC[hook(6, 3 * 8 + 7)] += regA[hook(11, 7)] * regB[hook(12, 3)];

    regC[hook(6, 4 * 8 + 0)] += regA[hook(11, 0)] * regB[hook(12, 4)];
    regC[hook(6, 4 * 8 + 1)] += regA[hook(11, 1)] * regB[hook(12, 4)];
    regC[hook(6, 4 * 8 + 2)] += regA[hook(11, 2)] * regB[hook(12, 4)];
    regC[hook(6, 4 * 8 + 3)] += regA[hook(11, 3)] * regB[hook(12, 4)];
    regC[hook(6, 4 * 8 + 4)] += regA[hook(11, 4)] * regB[hook(12, 4)];
    regC[hook(6, 4 * 8 + 5)] += regA[hook(11, 5)] * regB[hook(12, 4)];
    regC[hook(6, 4 * 8 + 6)] += regA[hook(11, 6)] * regB[hook(12, 4)];
    regC[hook(6, 4 * 8 + 7)] += regA[hook(11, 7)] * regB[hook(12, 4)];

    regC[hook(6, 5 * 8 + 0)] += regA[hook(11, 0)] * regB[hook(12, 5)];
    regC[hook(6, 5 * 8 + 1)] += regA[hook(11, 1)] * regB[hook(12, 5)];
    regC[hook(6, 5 * 8 + 2)] += regA[hook(11, 2)] * regB[hook(12, 5)];
    regC[hook(6, 5 * 8 + 3)] += regA[hook(11, 3)] * regB[hook(12, 5)];
    regC[hook(6, 5 * 8 + 4)] += regA[hook(11, 4)] * regB[hook(12, 5)];
    regC[hook(6, 5 * 8 + 5)] += regA[hook(11, 5)] * regB[hook(12, 5)];
    regC[hook(6, 5 * 8 + 6)] += regA[hook(11, 6)] * regB[hook(12, 5)];
    regC[hook(6, 5 * 8 + 7)] += regA[hook(11, 7)] * regB[hook(12, 5)];

    regC[hook(6, 6 * 8 + 0)] += regA[hook(11, 0)] * regB[hook(12, 6)];
    regC[hook(6, 6 * 8 + 1)] += regA[hook(11, 1)] * regB[hook(12, 6)];
    regC[hook(6, 6 * 8 + 2)] += regA[hook(11, 2)] * regB[hook(12, 6)];
    regC[hook(6, 6 * 8 + 3)] += regA[hook(11, 3)] * regB[hook(12, 6)];
    regC[hook(6, 6 * 8 + 4)] += regA[hook(11, 4)] * regB[hook(12, 6)];
    regC[hook(6, 6 * 8 + 5)] += regA[hook(11, 5)] * regB[hook(12, 6)];
    regC[hook(6, 6 * 8 + 6)] += regA[hook(11, 6)] * regB[hook(12, 6)];
    regC[hook(6, 6 * 8 + 7)] += regA[hook(11, 7)] * regB[hook(12, 6)];

    regC[hook(6, 7 * 8 + 0)] += regA[hook(11, 0)] * regB[hook(12, 7)];
    regC[hook(6, 7 * 8 + 1)] += regA[hook(11, 1)] * regB[hook(12, 7)];
    regC[hook(6, 7 * 8 + 2)] += regA[hook(11, 2)] * regB[hook(12, 7)];
    regC[hook(6, 7 * 8 + 3)] += regA[hook(11, 3)] * regB[hook(12, 7)];
    regC[hook(6, 7 * 8 + 4)] += regA[hook(11, 4)] * regB[hook(12, 7)];
    regC[hook(6, 7 * 8 + 5)] += regA[hook(11, 5)] * regB[hook(12, 7)];
    regC[hook(6, 7 * 8 + 6)] += regA[hook(11, 6)] * regB[hook(12, 7)];
    regC[hook(6, 7 * 8 + 7)] += regA[hook(11, 7)] * regB[hook(12, 7)];
    regA[hook(11, 0)] = tileA[hook(9, swap_index + 1 * tile_dim_x + local_thread_id_x * 4 + 0)];
    regA[hook(11, 1)] = tileA[hook(9, swap_index + 1 * tile_dim_x + local_thread_id_x * 4 + 1)];
    regA[hook(11, 2)] = tileA[hook(9, swap_index + 1 * tile_dim_x + local_thread_id_x * 4 + 2)];
    regA[hook(11, 3)] = tileA[hook(9, swap_index + 1 * tile_dim_x + local_thread_id_x * 4 + 3)];

    regA[hook(11, 4)] = tileA[hook(9, swap_index + 1 * tile_dim_x + tile_dim_x / 2 + local_thread_id_x * 4 + 0)];
    regA[hook(11, 5)] = tileA[hook(9, swap_index + 1 * tile_dim_x + tile_dim_x / 2 + local_thread_id_x * 4 + 1)];
    regA[hook(11, 6)] = tileA[hook(9, swap_index + 1 * tile_dim_x + tile_dim_x / 2 + local_thread_id_x * 4 + 2)];
    regA[hook(11, 7)] = tileA[hook(9, swap_index + 1 * tile_dim_x + tile_dim_x / 2 + local_thread_id_x * 4 + 3)];

    regB[hook(12, 0)] = tileB[hook(10, swap_index + 1 * tile_dim_y + local_thread_id_y * 4 + 0)];
    regB[hook(12, 1)] = tileB[hook(10, swap_index + 1 * tile_dim_y + local_thread_id_y * 4 + 1)];
    regB[hook(12, 2)] = tileB[hook(10, swap_index + 1 * tile_dim_y + local_thread_id_y * 4 + 2)];
    regB[hook(12, 3)] = tileB[hook(10, swap_index + 1 * tile_dim_y + local_thread_id_y * 4 + 3)];

    regB[hook(12, 4)] = tileB[hook(10, swap_index + 1 * tile_dim_y + tile_dim_y / 2 + local_thread_id_y * 4 + 0)];
    regB[hook(12, 5)] = tileB[hook(10, swap_index + 1 * tile_dim_y + tile_dim_y / 2 + local_thread_id_y * 4 + 1)];
    regB[hook(12, 6)] = tileB[hook(10, swap_index + 1 * tile_dim_y + tile_dim_y / 2 + local_thread_id_y * 4 + 2)];
    regB[hook(12, 7)] = tileB[hook(10, swap_index + 1 * tile_dim_y + tile_dim_y / 2 + local_thread_id_y * 4 + 3)];

    regC[hook(6, 0 * 8 + 0)] += regA[hook(11, 0)] * regB[hook(12, 0)];
    regC[hook(6, 0 * 8 + 1)] += regA[hook(11, 1)] * regB[hook(12, 0)];
    regC[hook(6, 0 * 8 + 2)] += regA[hook(11, 2)] * regB[hook(12, 0)];
    regC[hook(6, 0 * 8 + 3)] += regA[hook(11, 3)] * regB[hook(12, 0)];
    regC[hook(6, 0 * 8 + 4)] += regA[hook(11, 4)] * regB[hook(12, 0)];
    regC[hook(6, 0 * 8 + 5)] += regA[hook(11, 5)] * regB[hook(12, 0)];
    regC[hook(6, 0 * 8 + 6)] += regA[hook(11, 6)] * regB[hook(12, 0)];
    regC[hook(6, 0 * 8 + 7)] += regA[hook(11, 7)] * regB[hook(12, 0)];

    regC[hook(6, 1 * 8 + 0)] += regA[hook(11, 0)] * regB[hook(12, 1)];
    regC[hook(6, 1 * 8 + 1)] += regA[hook(11, 1)] * regB[hook(12, 1)];
    regC[hook(6, 1 * 8 + 2)] += regA[hook(11, 2)] * regB[hook(12, 1)];
    regC[hook(6, 1 * 8 + 3)] += regA[hook(11, 3)] * regB[hook(12, 1)];
    regC[hook(6, 1 * 8 + 4)] += regA[hook(11, 4)] * regB[hook(12, 1)];
    regC[hook(6, 1 * 8 + 5)] += regA[hook(11, 5)] * regB[hook(12, 1)];
    regC[hook(6, 1 * 8 + 6)] += regA[hook(11, 6)] * regB[hook(12, 1)];
    regC[hook(6, 1 * 8 + 7)] += regA[hook(11, 7)] * regB[hook(12, 1)];

    regC[hook(6, 2 * 8 + 0)] += regA[hook(11, 0)] * regB[hook(12, 2)];
    regC[hook(6, 2 * 8 + 1)] += regA[hook(11, 1)] * regB[hook(12, 2)];
    regC[hook(6, 2 * 8 + 2)] += regA[hook(11, 2)] * regB[hook(12, 2)];
    regC[hook(6, 2 * 8 + 3)] += regA[hook(11, 3)] * regB[hook(12, 2)];
    regC[hook(6, 2 * 8 + 4)] += regA[hook(11, 4)] * regB[hook(12, 2)];
    regC[hook(6, 2 * 8 + 5)] += regA[hook(11, 5)] * regB[hook(12, 2)];
    regC[hook(6, 2 * 8 + 6)] += regA[hook(11, 6)] * regB[hook(12, 2)];
    regC[hook(6, 2 * 8 + 7)] += regA[hook(11, 7)] * regB[hook(12, 2)];

    regC[hook(6, 3 * 8 + 0)] += regA[hook(11, 0)] * regB[hook(12, 3)];
    regC[hook(6, 3 * 8 + 1)] += regA[hook(11, 1)] * regB[hook(12, 3)];
    regC[hook(6, 3 * 8 + 2)] += regA[hook(11, 2)] * regB[hook(12, 3)];
    regC[hook(6, 3 * 8 + 3)] += regA[hook(11, 3)] * regB[hook(12, 3)];
    regC[hook(6, 3 * 8 + 4)] += regA[hook(11, 4)] * regB[hook(12, 3)];
    regC[hook(6, 3 * 8 + 5)] += regA[hook(11, 5)] * regB[hook(12, 3)];
    regC[hook(6, 3 * 8 + 6)] += regA[hook(11, 6)] * regB[hook(12, 3)];
    regC[hook(6, 3 * 8 + 7)] += regA[hook(11, 7)] * regB[hook(12, 3)];

    regC[hook(6, 4 * 8 + 0)] += regA[hook(11, 0)] * regB[hook(12, 4)];
    regC[hook(6, 4 * 8 + 1)] += regA[hook(11, 1)] * regB[hook(12, 4)];
    regC[hook(6, 4 * 8 + 2)] += regA[hook(11, 2)] * regB[hook(12, 4)];
    regC[hook(6, 4 * 8 + 3)] += regA[hook(11, 3)] * regB[hook(12, 4)];
    regC[hook(6, 4 * 8 + 4)] += regA[hook(11, 4)] * regB[hook(12, 4)];
    regC[hook(6, 4 * 8 + 5)] += regA[hook(11, 5)] * regB[hook(12, 4)];
    regC[hook(6, 4 * 8 + 6)] += regA[hook(11, 6)] * regB[hook(12, 4)];
    regC[hook(6, 4 * 8 + 7)] += regA[hook(11, 7)] * regB[hook(12, 4)];

    regC[hook(6, 5 * 8 + 0)] += regA[hook(11, 0)] * regB[hook(12, 5)];
    regC[hook(6, 5 * 8 + 1)] += regA[hook(11, 1)] * regB[hook(12, 5)];
    regC[hook(6, 5 * 8 + 2)] += regA[hook(11, 2)] * regB[hook(12, 5)];
    regC[hook(6, 5 * 8 + 3)] += regA[hook(11, 3)] * regB[hook(12, 5)];
    regC[hook(6, 5 * 8 + 4)] += regA[hook(11, 4)] * regB[hook(12, 5)];
    regC[hook(6, 5 * 8 + 5)] += regA[hook(11, 5)] * regB[hook(12, 5)];
    regC[hook(6, 5 * 8 + 6)] += regA[hook(11, 6)] * regB[hook(12, 5)];
    regC[hook(6, 5 * 8 + 7)] += regA[hook(11, 7)] * regB[hook(12, 5)];

    regC[hook(6, 6 * 8 + 0)] += regA[hook(11, 0)] * regB[hook(12, 6)];
    regC[hook(6, 6 * 8 + 1)] += regA[hook(11, 1)] * regB[hook(12, 6)];
    regC[hook(6, 6 * 8 + 2)] += regA[hook(11, 2)] * regB[hook(12, 6)];
    regC[hook(6, 6 * 8 + 3)] += regA[hook(11, 3)] * regB[hook(12, 6)];
    regC[hook(6, 6 * 8 + 4)] += regA[hook(11, 4)] * regB[hook(12, 6)];
    regC[hook(6, 6 * 8 + 5)] += regA[hook(11, 5)] * regB[hook(12, 6)];
    regC[hook(6, 6 * 8 + 6)] += regA[hook(11, 6)] * regB[hook(12, 6)];
    regC[hook(6, 6 * 8 + 7)] += regA[hook(11, 7)] * regB[hook(12, 6)];

    regC[hook(6, 7 * 8 + 0)] += regA[hook(11, 0)] * regB[hook(12, 7)];
    regC[hook(6, 7 * 8 + 1)] += regA[hook(11, 1)] * regB[hook(12, 7)];
    regC[hook(6, 7 * 8 + 2)] += regA[hook(11, 2)] * regB[hook(12, 7)];
    regC[hook(6, 7 * 8 + 3)] += regA[hook(11, 3)] * regB[hook(12, 7)];
    regC[hook(6, 7 * 8 + 4)] += regA[hook(11, 4)] * regB[hook(12, 7)];
    regC[hook(6, 7 * 8 + 5)] += regA[hook(11, 5)] * regB[hook(12, 7)];
    regC[hook(6, 7 * 8 + 6)] += regA[hook(11, 6)] * regB[hook(12, 7)];
    regC[hook(6, 7 * 8 + 7)] += regA[hook(11, 7)] * regB[hook(12, 7)];

    regA[hook(11, 0)] = tileA[hook(9, swap_index + 2 * tile_dim_x + local_thread_id_x * 4 + 0)];
    regA[hook(11, 1)] = tileA[hook(9, swap_index + 2 * tile_dim_x + local_thread_id_x * 4 + 1)];
    regA[hook(11, 2)] = tileA[hook(9, swap_index + 2 * tile_dim_x + local_thread_id_x * 4 + 2)];
    regA[hook(11, 3)] = tileA[hook(9, swap_index + 2 * tile_dim_x + local_thread_id_x * 4 + 3)];

    regA[hook(11, 4)] = tileA[hook(9, swap_index + 2 * tile_dim_x + tile_dim_x / 2 + local_thread_id_x * 4 + 0)];
    regA[hook(11, 5)] = tileA[hook(9, swap_index + 2 * tile_dim_x + tile_dim_x / 2 + local_thread_id_x * 4 + 1)];
    regA[hook(11, 6)] = tileA[hook(9, swap_index + 2 * tile_dim_x + tile_dim_x / 2 + local_thread_id_x * 4 + 2)];
    regA[hook(11, 7)] = tileA[hook(9, swap_index + 2 * tile_dim_x + tile_dim_x / 2 + local_thread_id_x * 4 + 3)];

    regB[hook(12, 0)] = tileB[hook(10, swap_index + 2 * tile_dim_y + local_thread_id_y * 4 + 0)];
    regB[hook(12, 1)] = tileB[hook(10, swap_index + 2 * tile_dim_y + local_thread_id_y * 4 + 1)];
    regB[hook(12, 2)] = tileB[hook(10, swap_index + 2 * tile_dim_y + local_thread_id_y * 4 + 2)];
    regB[hook(12, 3)] = tileB[hook(10, swap_index + 2 * tile_dim_y + local_thread_id_y * 4 + 3)];

    regB[hook(12, 4)] = tileB[hook(10, swap_index + 2 * tile_dim_y + tile_dim_y / 2 + local_thread_id_y * 4 + 0)];
    regB[hook(12, 5)] = tileB[hook(10, swap_index + 2 * tile_dim_y + tile_dim_y / 2 + local_thread_id_y * 4 + 1)];
    regB[hook(12, 6)] = tileB[hook(10, swap_index + 2 * tile_dim_y + tile_dim_y / 2 + local_thread_id_y * 4 + 2)];
    regB[hook(12, 7)] = tileB[hook(10, swap_index + 2 * tile_dim_y + tile_dim_y / 2 + local_thread_id_y * 4 + 3)];

    regC[hook(6, 0 * 8 + 0)] += regA[hook(11, 0)] * regB[hook(12, 0)];
    regC[hook(6, 0 * 8 + 1)] += regA[hook(11, 1)] * regB[hook(12, 0)];
    regC[hook(6, 0 * 8 + 2)] += regA[hook(11, 2)] * regB[hook(12, 0)];
    regC[hook(6, 0 * 8 + 3)] += regA[hook(11, 3)] * regB[hook(12, 0)];
    regC[hook(6, 0 * 8 + 4)] += regA[hook(11, 4)] * regB[hook(12, 0)];
    regC[hook(6, 0 * 8 + 5)] += regA[hook(11, 5)] * regB[hook(12, 0)];
    regC[hook(6, 0 * 8 + 6)] += regA[hook(11, 6)] * regB[hook(12, 0)];
    regC[hook(6, 0 * 8 + 7)] += regA[hook(11, 7)] * regB[hook(12, 0)];

    regC[hook(6, 1 * 8 + 0)] += regA[hook(11, 0)] * regB[hook(12, 1)];
    regC[hook(6, 1 * 8 + 1)] += regA[hook(11, 1)] * regB[hook(12, 1)];
    regC[hook(6, 1 * 8 + 2)] += regA[hook(11, 2)] * regB[hook(12, 1)];
    regC[hook(6, 1 * 8 + 3)] += regA[hook(11, 3)] * regB[hook(12, 1)];
    regC[hook(6, 1 * 8 + 4)] += regA[hook(11, 4)] * regB[hook(12, 1)];
    regC[hook(6, 1 * 8 + 5)] += regA[hook(11, 5)] * regB[hook(12, 1)];
    regC[hook(6, 1 * 8 + 6)] += regA[hook(11, 6)] * regB[hook(12, 1)];
    regC[hook(6, 1 * 8 + 7)] += regA[hook(11, 7)] * regB[hook(12, 1)];

    regC[hook(6, 2 * 8 + 0)] += regA[hook(11, 0)] * regB[hook(12, 2)];
    regC[hook(6, 2 * 8 + 1)] += regA[hook(11, 1)] * regB[hook(12, 2)];
    regC[hook(6, 2 * 8 + 2)] += regA[hook(11, 2)] * regB[hook(12, 2)];
    regC[hook(6, 2 * 8 + 3)] += regA[hook(11, 3)] * regB[hook(12, 2)];
    regC[hook(6, 2 * 8 + 4)] += regA[hook(11, 4)] * regB[hook(12, 2)];
    regC[hook(6, 2 * 8 + 5)] += regA[hook(11, 5)] * regB[hook(12, 2)];
    regC[hook(6, 2 * 8 + 6)] += regA[hook(11, 6)] * regB[hook(12, 2)];
    regC[hook(6, 2 * 8 + 7)] += regA[hook(11, 7)] * regB[hook(12, 2)];

    regC[hook(6, 3 * 8 + 0)] += regA[hook(11, 0)] * regB[hook(12, 3)];
    regC[hook(6, 3 * 8 + 1)] += regA[hook(11, 1)] * regB[hook(12, 3)];
    regC[hook(6, 3 * 8 + 2)] += regA[hook(11, 2)] * regB[hook(12, 3)];
    regC[hook(6, 3 * 8 + 3)] += regA[hook(11, 3)] * regB[hook(12, 3)];
    regC[hook(6, 3 * 8 + 4)] += regA[hook(11, 4)] * regB[hook(12, 3)];
    regC[hook(6, 3 * 8 + 5)] += regA[hook(11, 5)] * regB[hook(12, 3)];
    regC[hook(6, 3 * 8 + 6)] += regA[hook(11, 6)] * regB[hook(12, 3)];
    regC[hook(6, 3 * 8 + 7)] += regA[hook(11, 7)] * regB[hook(12, 3)];

    regC[hook(6, 4 * 8 + 0)] += regA[hook(11, 0)] * regB[hook(12, 4)];
    regC[hook(6, 4 * 8 + 1)] += regA[hook(11, 1)] * regB[hook(12, 4)];
    regC[hook(6, 4 * 8 + 2)] += regA[hook(11, 2)] * regB[hook(12, 4)];
    regC[hook(6, 4 * 8 + 3)] += regA[hook(11, 3)] * regB[hook(12, 4)];
    regC[hook(6, 4 * 8 + 4)] += regA[hook(11, 4)] * regB[hook(12, 4)];
    regC[hook(6, 4 * 8 + 5)] += regA[hook(11, 5)] * regB[hook(12, 4)];
    regC[hook(6, 4 * 8 + 6)] += regA[hook(11, 6)] * regB[hook(12, 4)];
    regC[hook(6, 4 * 8 + 7)] += regA[hook(11, 7)] * regB[hook(12, 4)];

    regC[hook(6, 5 * 8 + 0)] += regA[hook(11, 0)] * regB[hook(12, 5)];
    regC[hook(6, 5 * 8 + 1)] += regA[hook(11, 1)] * regB[hook(12, 5)];
    regC[hook(6, 5 * 8 + 2)] += regA[hook(11, 2)] * regB[hook(12, 5)];
    regC[hook(6, 5 * 8 + 3)] += regA[hook(11, 3)] * regB[hook(12, 5)];
    regC[hook(6, 5 * 8 + 4)] += regA[hook(11, 4)] * regB[hook(12, 5)];
    regC[hook(6, 5 * 8 + 5)] += regA[hook(11, 5)] * regB[hook(12, 5)];
    regC[hook(6, 5 * 8 + 6)] += regA[hook(11, 6)] * regB[hook(12, 5)];
    regC[hook(6, 5 * 8 + 7)] += regA[hook(11, 7)] * regB[hook(12, 5)];

    regC[hook(6, 6 * 8 + 0)] += regA[hook(11, 0)] * regB[hook(12, 6)];
    regC[hook(6, 6 * 8 + 1)] += regA[hook(11, 1)] * regB[hook(12, 6)];
    regC[hook(6, 6 * 8 + 2)] += regA[hook(11, 2)] * regB[hook(12, 6)];
    regC[hook(6, 6 * 8 + 3)] += regA[hook(11, 3)] * regB[hook(12, 6)];
    regC[hook(6, 6 * 8 + 4)] += regA[hook(11, 4)] * regB[hook(12, 6)];
    regC[hook(6, 6 * 8 + 5)] += regA[hook(11, 5)] * regB[hook(12, 6)];
    regC[hook(6, 6 * 8 + 6)] += regA[hook(11, 6)] * regB[hook(12, 6)];
    regC[hook(6, 6 * 8 + 7)] += regA[hook(11, 7)] * regB[hook(12, 6)];

    regC[hook(6, 7 * 8 + 0)] += regA[hook(11, 0)] * regB[hook(12, 7)];
    regC[hook(6, 7 * 8 + 1)] += regA[hook(11, 1)] * regB[hook(12, 7)];
    regC[hook(6, 7 * 8 + 2)] += regA[hook(11, 2)] * regB[hook(12, 7)];
    regC[hook(6, 7 * 8 + 3)] += regA[hook(11, 3)] * regB[hook(12, 7)];
    regC[hook(6, 7 * 8 + 4)] += regA[hook(11, 4)] * regB[hook(12, 7)];
    regC[hook(6, 7 * 8 + 5)] += regA[hook(11, 5)] * regB[hook(12, 7)];
    regC[hook(6, 7 * 8 + 6)] += regA[hook(11, 6)] * regB[hook(12, 7)];
    regC[hook(6, 7 * 8 + 7)] += regA[hook(11, 7)] * regB[hook(12, 7)];

    regA[hook(11, 0)] = tileA[hook(9, swap_index + 3 * tile_dim_x + local_thread_id_x * 4 + 0)];
    regA[hook(11, 1)] = tileA[hook(9, swap_index + 3 * tile_dim_x + local_thread_id_x * 4 + 1)];
    regA[hook(11, 2)] = tileA[hook(9, swap_index + 3 * tile_dim_x + local_thread_id_x * 4 + 2)];
    regA[hook(11, 3)] = tileA[hook(9, swap_index + 3 * tile_dim_x + local_thread_id_x * 4 + 3)];

    regA[hook(11, 4)] = tileA[hook(9, swap_index + 3 * tile_dim_x + tile_dim_x / 2 + local_thread_id_x * 4 + 0)];
    regA[hook(11, 5)] = tileA[hook(9, swap_index + 3 * tile_dim_x + tile_dim_x / 2 + local_thread_id_x * 4 + 1)];
    regA[hook(11, 6)] = tileA[hook(9, swap_index + 3 * tile_dim_x + tile_dim_x / 2 + local_thread_id_x * 4 + 2)];
    regA[hook(11, 7)] = tileA[hook(9, swap_index + 3 * tile_dim_x + tile_dim_x / 2 + local_thread_id_x * 4 + 3)];

    regB[hook(12, 0)] = tileB[hook(10, swap_index + 3 * tile_dim_y + local_thread_id_y * 4 + 0)];
    regB[hook(12, 1)] = tileB[hook(10, swap_index + 3 * tile_dim_y + local_thread_id_y * 4 + 1)];
    regB[hook(12, 2)] = tileB[hook(10, swap_index + 3 * tile_dim_y + local_thread_id_y * 4 + 2)];
    regB[hook(12, 3)] = tileB[hook(10, swap_index + 3 * tile_dim_y + local_thread_id_y * 4 + 3)];

    regB[hook(12, 4)] = tileB[hook(10, swap_index + 3 * tile_dim_y + tile_dim_y / 2 + local_thread_id_y * 4 + 0)];
    regB[hook(12, 5)] = tileB[hook(10, swap_index + 3 * tile_dim_y + tile_dim_y / 2 + local_thread_id_y * 4 + 1)];
    regB[hook(12, 6)] = tileB[hook(10, swap_index + 3 * tile_dim_y + tile_dim_y / 2 + local_thread_id_y * 4 + 2)];
    regB[hook(12, 7)] = tileB[hook(10, swap_index + 3 * tile_dim_y + tile_dim_y / 2 + local_thread_id_y * 4 + 3)];

    regC[hook(6, 0 * 8 + 0)] += regA[hook(11, 0)] * regB[hook(12, 0)];
    regC[hook(6, 0 * 8 + 1)] += regA[hook(11, 1)] * regB[hook(12, 0)];
    regC[hook(6, 0 * 8 + 2)] += regA[hook(11, 2)] * regB[hook(12, 0)];
    regC[hook(6, 0 * 8 + 3)] += regA[hook(11, 3)] * regB[hook(12, 0)];
    regC[hook(6, 0 * 8 + 4)] += regA[hook(11, 4)] * regB[hook(12, 0)];
    regC[hook(6, 0 * 8 + 5)] += regA[hook(11, 5)] * regB[hook(12, 0)];
    regC[hook(6, 0 * 8 + 6)] += regA[hook(11, 6)] * regB[hook(12, 0)];
    regC[hook(6, 0 * 8 + 7)] += regA[hook(11, 7)] * regB[hook(12, 0)];

    regC[hook(6, 1 * 8 + 0)] += regA[hook(11, 0)] * regB[hook(12, 1)];
    regC[hook(6, 1 * 8 + 1)] += regA[hook(11, 1)] * regB[hook(12, 1)];
    regC[hook(6, 1 * 8 + 2)] += regA[hook(11, 2)] * regB[hook(12, 1)];
    regC[hook(6, 1 * 8 + 3)] += regA[hook(11, 3)] * regB[hook(12, 1)];
    regC[hook(6, 1 * 8 + 4)] += regA[hook(11, 4)] * regB[hook(12, 1)];
    regC[hook(6, 1 * 8 + 5)] += regA[hook(11, 5)] * regB[hook(12, 1)];
    regC[hook(6, 1 * 8 + 6)] += regA[hook(11, 6)] * regB[hook(12, 1)];
    regC[hook(6, 1 * 8 + 7)] += regA[hook(11, 7)] * regB[hook(12, 1)];

    regC[hook(6, 2 * 8 + 0)] += regA[hook(11, 0)] * regB[hook(12, 2)];
    regC[hook(6, 2 * 8 + 1)] += regA[hook(11, 1)] * regB[hook(12, 2)];
    regC[hook(6, 2 * 8 + 2)] += regA[hook(11, 2)] * regB[hook(12, 2)];
    regC[hook(6, 2 * 8 + 3)] += regA[hook(11, 3)] * regB[hook(12, 2)];
    regC[hook(6, 2 * 8 + 4)] += regA[hook(11, 4)] * regB[hook(12, 2)];
    regC[hook(6, 2 * 8 + 5)] += regA[hook(11, 5)] * regB[hook(12, 2)];
    regC[hook(6, 2 * 8 + 6)] += regA[hook(11, 6)] * regB[hook(12, 2)];
    regC[hook(6, 2 * 8 + 7)] += regA[hook(11, 7)] * regB[hook(12, 2)];

    regC[hook(6, 3 * 8 + 0)] += regA[hook(11, 0)] * regB[hook(12, 3)];
    regC[hook(6, 3 * 8 + 1)] += regA[hook(11, 1)] * regB[hook(12, 3)];
    regC[hook(6, 3 * 8 + 2)] += regA[hook(11, 2)] * regB[hook(12, 3)];
    regC[hook(6, 3 * 8 + 3)] += regA[hook(11, 3)] * regB[hook(12, 3)];
    regC[hook(6, 3 * 8 + 4)] += regA[hook(11, 4)] * regB[hook(12, 3)];
    regC[hook(6, 3 * 8 + 5)] += regA[hook(11, 5)] * regB[hook(12, 3)];
    regC[hook(6, 3 * 8 + 6)] += regA[hook(11, 6)] * regB[hook(12, 3)];
    regC[hook(6, 3 * 8 + 7)] += regA[hook(11, 7)] * regB[hook(12, 3)];

    regC[hook(6, 4 * 8 + 0)] += regA[hook(11, 0)] * regB[hook(12, 4)];
    regC[hook(6, 4 * 8 + 1)] += regA[hook(11, 1)] * regB[hook(12, 4)];
    regC[hook(6, 4 * 8 + 2)] += regA[hook(11, 2)] * regB[hook(12, 4)];
    regC[hook(6, 4 * 8 + 3)] += regA[hook(11, 3)] * regB[hook(12, 4)];
    regC[hook(6, 4 * 8 + 4)] += regA[hook(11, 4)] * regB[hook(12, 4)];
    regC[hook(6, 4 * 8 + 5)] += regA[hook(11, 5)] * regB[hook(12, 4)];
    regC[hook(6, 4 * 8 + 6)] += regA[hook(11, 6)] * regB[hook(12, 4)];
    regC[hook(6, 4 * 8 + 7)] += regA[hook(11, 7)] * regB[hook(12, 4)];

    regC[hook(6, 5 * 8 + 0)] += regA[hook(11, 0)] * regB[hook(12, 5)];
    regC[hook(6, 5 * 8 + 1)] += regA[hook(11, 1)] * regB[hook(12, 5)];
    regC[hook(6, 5 * 8 + 2)] += regA[hook(11, 2)] * regB[hook(12, 5)];
    regC[hook(6, 5 * 8 + 3)] += regA[hook(11, 3)] * regB[hook(12, 5)];
    regC[hook(6, 5 * 8 + 4)] += regA[hook(11, 4)] * regB[hook(12, 5)];
    regC[hook(6, 5 * 8 + 5)] += regA[hook(11, 5)] * regB[hook(12, 5)];
    regC[hook(6, 5 * 8 + 6)] += regA[hook(11, 6)] * regB[hook(12, 5)];
    regC[hook(6, 5 * 8 + 7)] += regA[hook(11, 7)] * regB[hook(12, 5)];

    regC[hook(6, 6 * 8 + 0)] += regA[hook(11, 0)] * regB[hook(12, 6)];
    regC[hook(6, 6 * 8 + 1)] += regA[hook(11, 1)] * regB[hook(12, 6)];
    regC[hook(6, 6 * 8 + 2)] += regA[hook(11, 2)] * regB[hook(12, 6)];
    regC[hook(6, 6 * 8 + 3)] += regA[hook(11, 3)] * regB[hook(12, 6)];
    regC[hook(6, 6 * 8 + 4)] += regA[hook(11, 4)] * regB[hook(12, 6)];
    regC[hook(6, 6 * 8 + 5)] += regA[hook(11, 5)] * regB[hook(12, 6)];
    regC[hook(6, 6 * 8 + 6)] += regA[hook(11, 6)] * regB[hook(12, 6)];
    regC[hook(6, 6 * 8 + 7)] += regA[hook(11, 7)] * regB[hook(12, 6)];

    regC[hook(6, 7 * 8 + 0)] += regA[hook(11, 0)] * regB[hook(12, 7)];
    regC[hook(6, 7 * 8 + 1)] += regA[hook(11, 1)] * regB[hook(12, 7)];
    regC[hook(6, 7 * 8 + 2)] += regA[hook(11, 2)] * regB[hook(12, 7)];
    regC[hook(6, 7 * 8 + 3)] += regA[hook(11, 3)] * regB[hook(12, 7)];
    regC[hook(6, 7 * 8 + 4)] += regA[hook(11, 4)] * regB[hook(12, 7)];
    regC[hook(6, 7 * 8 + 5)] += regA[hook(11, 5)] * regB[hook(12, 7)];
    regC[hook(6, 7 * 8 + 6)] += regA[hook(11, 6)] * regB[hook(12, 7)];
    regC[hook(6, 7 * 8 + 7)] += regA[hook(11, 7)] * regB[hook(12, 7)];

    regA[hook(11, 0)] = tileA[hook(9, swap_index + 4 * tile_dim_x + local_thread_id_x * 4 + 0)];
    regA[hook(11, 1)] = tileA[hook(9, swap_index + 4 * tile_dim_x + local_thread_id_x * 4 + 1)];
    regA[hook(11, 2)] = tileA[hook(9, swap_index + 4 * tile_dim_x + local_thread_id_x * 4 + 2)];
    regA[hook(11, 3)] = tileA[hook(9, swap_index + 4 * tile_dim_x + local_thread_id_x * 4 + 3)];

    regA[hook(11, 4)] = tileA[hook(9, swap_index + 4 * tile_dim_x + tile_dim_x / 2 + local_thread_id_x * 4 + 0)];
    regA[hook(11, 5)] = tileA[hook(9, swap_index + 4 * tile_dim_x + tile_dim_x / 2 + local_thread_id_x * 4 + 1)];
    regA[hook(11, 6)] = tileA[hook(9, swap_index + 4 * tile_dim_x + tile_dim_x / 2 + local_thread_id_x * 4 + 2)];
    regA[hook(11, 7)] = tileA[hook(9, swap_index + 4 * tile_dim_x + tile_dim_x / 2 + local_thread_id_x * 4 + 3)];

    regB[hook(12, 0)] = tileB[hook(10, swap_index + 4 * tile_dim_y + local_thread_id_y * 4 + 0)];
    regB[hook(12, 1)] = tileB[hook(10, swap_index + 4 * tile_dim_y + local_thread_id_y * 4 + 1)];
    regB[hook(12, 2)] = tileB[hook(10, swap_index + 4 * tile_dim_y + local_thread_id_y * 4 + 2)];
    regB[hook(12, 3)] = tileB[hook(10, swap_index + 4 * tile_dim_y + local_thread_id_y * 4 + 3)];

    regB[hook(12, 4)] = tileB[hook(10, swap_index + 4 * tile_dim_y + tile_dim_y / 2 + local_thread_id_y * 4 + 0)];
    regB[hook(12, 5)] = tileB[hook(10, swap_index + 4 * tile_dim_y + tile_dim_y / 2 + local_thread_id_y * 4 + 1)];
    regB[hook(12, 6)] = tileB[hook(10, swap_index + 4 * tile_dim_y + tile_dim_y / 2 + local_thread_id_y * 4 + 2)];
    regB[hook(12, 7)] = tileB[hook(10, swap_index + 4 * tile_dim_y + tile_dim_y / 2 + local_thread_id_y * 4 + 3)];

    regC[hook(6, 0 * 8 + 0)] += regA[hook(11, 0)] * regB[hook(12, 0)];
    regC[hook(6, 0 * 8 + 1)] += regA[hook(11, 1)] * regB[hook(12, 0)];
    regC[hook(6, 0 * 8 + 2)] += regA[hook(11, 2)] * regB[hook(12, 0)];
    regC[hook(6, 0 * 8 + 3)] += regA[hook(11, 3)] * regB[hook(12, 0)];
    regC[hook(6, 0 * 8 + 4)] += regA[hook(11, 4)] * regB[hook(12, 0)];
    regC[hook(6, 0 * 8 + 5)] += regA[hook(11, 5)] * regB[hook(12, 0)];
    regC[hook(6, 0 * 8 + 6)] += regA[hook(11, 6)] * regB[hook(12, 0)];
    regC[hook(6, 0 * 8 + 7)] += regA[hook(11, 7)] * regB[hook(12, 0)];

    regC[hook(6, 1 * 8 + 0)] += regA[hook(11, 0)] * regB[hook(12, 1)];
    regC[hook(6, 1 * 8 + 1)] += regA[hook(11, 1)] * regB[hook(12, 1)];
    regC[hook(6, 1 * 8 + 2)] += regA[hook(11, 2)] * regB[hook(12, 1)];
    regC[hook(6, 1 * 8 + 3)] += regA[hook(11, 3)] * regB[hook(12, 1)];
    regC[hook(6, 1 * 8 + 4)] += regA[hook(11, 4)] * regB[hook(12, 1)];
    regC[hook(6, 1 * 8 + 5)] += regA[hook(11, 5)] * regB[hook(12, 1)];
    regC[hook(6, 1 * 8 + 6)] += regA[hook(11, 6)] * regB[hook(12, 1)];
    regC[hook(6, 1 * 8 + 7)] += regA[hook(11, 7)] * regB[hook(12, 1)];

    regC[hook(6, 2 * 8 + 0)] += regA[hook(11, 0)] * regB[hook(12, 2)];
    regC[hook(6, 2 * 8 + 1)] += regA[hook(11, 1)] * regB[hook(12, 2)];
    regC[hook(6, 2 * 8 + 2)] += regA[hook(11, 2)] * regB[hook(12, 2)];
    regC[hook(6, 2 * 8 + 3)] += regA[hook(11, 3)] * regB[hook(12, 2)];
    regC[hook(6, 2 * 8 + 4)] += regA[hook(11, 4)] * regB[hook(12, 2)];
    regC[hook(6, 2 * 8 + 5)] += regA[hook(11, 5)] * regB[hook(12, 2)];
    regC[hook(6, 2 * 8 + 6)] += regA[hook(11, 6)] * regB[hook(12, 2)];
    regC[hook(6, 2 * 8 + 7)] += regA[hook(11, 7)] * regB[hook(12, 2)];

    regC[hook(6, 3 * 8 + 0)] += regA[hook(11, 0)] * regB[hook(12, 3)];
    regC[hook(6, 3 * 8 + 1)] += regA[hook(11, 1)] * regB[hook(12, 3)];
    regC[hook(6, 3 * 8 + 2)] += regA[hook(11, 2)] * regB[hook(12, 3)];
    regC[hook(6, 3 * 8 + 3)] += regA[hook(11, 3)] * regB[hook(12, 3)];
    regC[hook(6, 3 * 8 + 4)] += regA[hook(11, 4)] * regB[hook(12, 3)];
    regC[hook(6, 3 * 8 + 5)] += regA[hook(11, 5)] * regB[hook(12, 3)];
    regC[hook(6, 3 * 8 + 6)] += regA[hook(11, 6)] * regB[hook(12, 3)];
    regC[hook(6, 3 * 8 + 7)] += regA[hook(11, 7)] * regB[hook(12, 3)];

    regC[hook(6, 4 * 8 + 0)] += regA[hook(11, 0)] * regB[hook(12, 4)];
    regC[hook(6, 4 * 8 + 1)] += regA[hook(11, 1)] * regB[hook(12, 4)];
    regC[hook(6, 4 * 8 + 2)] += regA[hook(11, 2)] * regB[hook(12, 4)];
    regC[hook(6, 4 * 8 + 3)] += regA[hook(11, 3)] * regB[hook(12, 4)];
    regC[hook(6, 4 * 8 + 4)] += regA[hook(11, 4)] * regB[hook(12, 4)];
    regC[hook(6, 4 * 8 + 5)] += regA[hook(11, 5)] * regB[hook(12, 4)];
    regC[hook(6, 4 * 8 + 6)] += regA[hook(11, 6)] * regB[hook(12, 4)];
    regC[hook(6, 4 * 8 + 7)] += regA[hook(11, 7)] * regB[hook(12, 4)];

    regC[hook(6, 5 * 8 + 0)] += regA[hook(11, 0)] * regB[hook(12, 5)];
    regC[hook(6, 5 * 8 + 1)] += regA[hook(11, 1)] * regB[hook(12, 5)];
    regC[hook(6, 5 * 8 + 2)] += regA[hook(11, 2)] * regB[hook(12, 5)];
    regC[hook(6, 5 * 8 + 3)] += regA[hook(11, 3)] * regB[hook(12, 5)];
    regC[hook(6, 5 * 8 + 4)] += regA[hook(11, 4)] * regB[hook(12, 5)];
    regC[hook(6, 5 * 8 + 5)] += regA[hook(11, 5)] * regB[hook(12, 5)];
    regC[hook(6, 5 * 8 + 6)] += regA[hook(11, 6)] * regB[hook(12, 5)];
    regC[hook(6, 5 * 8 + 7)] += regA[hook(11, 7)] * regB[hook(12, 5)];

    regC[hook(6, 6 * 8 + 0)] += regA[hook(11, 0)] * regB[hook(12, 6)];
    regC[hook(6, 6 * 8 + 1)] += regA[hook(11, 1)] * regB[hook(12, 6)];
    regC[hook(6, 6 * 8 + 2)] += regA[hook(11, 2)] * regB[hook(12, 6)];
    regC[hook(6, 6 * 8 + 3)] += regA[hook(11, 3)] * regB[hook(12, 6)];
    regC[hook(6, 6 * 8 + 4)] += regA[hook(11, 4)] * regB[hook(12, 6)];
    regC[hook(6, 6 * 8 + 5)] += regA[hook(11, 5)] * regB[hook(12, 6)];
    regC[hook(6, 6 * 8 + 6)] += regA[hook(11, 6)] * regB[hook(12, 6)];
    regC[hook(6, 6 * 8 + 7)] += regA[hook(11, 7)] * regB[hook(12, 6)];

    regC[hook(6, 7 * 8 + 0)] += regA[hook(11, 0)] * regB[hook(12, 7)];
    regC[hook(6, 7 * 8 + 1)] += regA[hook(11, 1)] * regB[hook(12, 7)];
    regC[hook(6, 7 * 8 + 2)] += regA[hook(11, 2)] * regB[hook(12, 7)];
    regC[hook(6, 7 * 8 + 3)] += regA[hook(11, 3)] * regB[hook(12, 7)];
    regC[hook(6, 7 * 8 + 4)] += regA[hook(11, 4)] * regB[hook(12, 7)];
    regC[hook(6, 7 * 8 + 5)] += regA[hook(11, 5)] * regB[hook(12, 7)];
    regC[hook(6, 7 * 8 + 6)] += regA[hook(11, 6)] * regB[hook(12, 7)];
    regC[hook(6, 7 * 8 + 7)] += regA[hook(11, 7)] * regB[hook(12, 7)];

    regA[hook(11, 0)] = tileA[hook(9, swap_index + 5 * tile_dim_x + local_thread_id_x * 4 + 0)];
    regA[hook(11, 1)] = tileA[hook(9, swap_index + 5 * tile_dim_x + local_thread_id_x * 4 + 1)];
    regA[hook(11, 2)] = tileA[hook(9, swap_index + 5 * tile_dim_x + local_thread_id_x * 4 + 2)];
    regA[hook(11, 3)] = tileA[hook(9, swap_index + 5 * tile_dim_x + local_thread_id_x * 4 + 3)];

    regA[hook(11, 4)] = tileA[hook(9, swap_index + 5 * tile_dim_x + tile_dim_x / 2 + local_thread_id_x * 4 + 0)];
    regA[hook(11, 5)] = tileA[hook(9, swap_index + 5 * tile_dim_x + tile_dim_x / 2 + local_thread_id_x * 4 + 1)];
    regA[hook(11, 6)] = tileA[hook(9, swap_index + 5 * tile_dim_x + tile_dim_x / 2 + local_thread_id_x * 4 + 2)];
    regA[hook(11, 7)] = tileA[hook(9, swap_index + 5 * tile_dim_x + tile_dim_x / 2 + local_thread_id_x * 4 + 3)];

    regB[hook(12, 0)] = tileB[hook(10, swap_index + 5 * tile_dim_y + local_thread_id_y * 4 + 0)];
    regB[hook(12, 1)] = tileB[hook(10, swap_index + 5 * tile_dim_y + local_thread_id_y * 4 + 1)];
    regB[hook(12, 2)] = tileB[hook(10, swap_index + 5 * tile_dim_y + local_thread_id_y * 4 + 2)];
    regB[hook(12, 3)] = tileB[hook(10, swap_index + 5 * tile_dim_y + local_thread_id_y * 4 + 3)];

    regB[hook(12, 4)] = tileB[hook(10, swap_index + 5 * tile_dim_y + tile_dim_y / 2 + local_thread_id_y * 4 + 0)];
    regB[hook(12, 5)] = tileB[hook(10, swap_index + 5 * tile_dim_y + tile_dim_y / 2 + local_thread_id_y * 4 + 1)];
    regB[hook(12, 6)] = tileB[hook(10, swap_index + 5 * tile_dim_y + tile_dim_y / 2 + local_thread_id_y * 4 + 2)];
    regB[hook(12, 7)] = tileB[hook(10, swap_index + 5 * tile_dim_y + tile_dim_y / 2 + local_thread_id_y * 4 + 3)];

    regC[hook(6, 0 * 8 + 0)] += regA[hook(11, 0)] * regB[hook(12, 0)];
    regC[hook(6, 0 * 8 + 1)] += regA[hook(11, 1)] * regB[hook(12, 0)];
    regC[hook(6, 0 * 8 + 2)] += regA[hook(11, 2)] * regB[hook(12, 0)];
    regC[hook(6, 0 * 8 + 3)] += regA[hook(11, 3)] * regB[hook(12, 0)];
    regC[hook(6, 0 * 8 + 4)] += regA[hook(11, 4)] * regB[hook(12, 0)];
    regC[hook(6, 0 * 8 + 5)] += regA[hook(11, 5)] * regB[hook(12, 0)];
    regC[hook(6, 0 * 8 + 6)] += regA[hook(11, 6)] * regB[hook(12, 0)];
    regC[hook(6, 0 * 8 + 7)] += regA[hook(11, 7)] * regB[hook(12, 0)];

    regC[hook(6, 1 * 8 + 0)] += regA[hook(11, 0)] * regB[hook(12, 1)];
    regC[hook(6, 1 * 8 + 1)] += regA[hook(11, 1)] * regB[hook(12, 1)];
    regC[hook(6, 1 * 8 + 2)] += regA[hook(11, 2)] * regB[hook(12, 1)];
    regC[hook(6, 1 * 8 + 3)] += regA[hook(11, 3)] * regB[hook(12, 1)];
    regC[hook(6, 1 * 8 + 4)] += regA[hook(11, 4)] * regB[hook(12, 1)];
    regC[hook(6, 1 * 8 + 5)] += regA[hook(11, 5)] * regB[hook(12, 1)];
    regC[hook(6, 1 * 8 + 6)] += regA[hook(11, 6)] * regB[hook(12, 1)];
    regC[hook(6, 1 * 8 + 7)] += regA[hook(11, 7)] * regB[hook(12, 1)];

    regC[hook(6, 2 * 8 + 0)] += regA[hook(11, 0)] * regB[hook(12, 2)];
    regC[hook(6, 2 * 8 + 1)] += regA[hook(11, 1)] * regB[hook(12, 2)];
    regC[hook(6, 2 * 8 + 2)] += regA[hook(11, 2)] * regB[hook(12, 2)];
    regC[hook(6, 2 * 8 + 3)] += regA[hook(11, 3)] * regB[hook(12, 2)];
    regC[hook(6, 2 * 8 + 4)] += regA[hook(11, 4)] * regB[hook(12, 2)];
    regC[hook(6, 2 * 8 + 5)] += regA[hook(11, 5)] * regB[hook(12, 2)];
    regC[hook(6, 2 * 8 + 6)] += regA[hook(11, 6)] * regB[hook(12, 2)];
    regC[hook(6, 2 * 8 + 7)] += regA[hook(11, 7)] * regB[hook(12, 2)];

    regC[hook(6, 3 * 8 + 0)] += regA[hook(11, 0)] * regB[hook(12, 3)];
    regC[hook(6, 3 * 8 + 1)] += regA[hook(11, 1)] * regB[hook(12, 3)];
    regC[hook(6, 3 * 8 + 2)] += regA[hook(11, 2)] * regB[hook(12, 3)];
    regC[hook(6, 3 * 8 + 3)] += regA[hook(11, 3)] * regB[hook(12, 3)];
    regC[hook(6, 3 * 8 + 4)] += regA[hook(11, 4)] * regB[hook(12, 3)];
    regC[hook(6, 3 * 8 + 5)] += regA[hook(11, 5)] * regB[hook(12, 3)];
    regC[hook(6, 3 * 8 + 6)] += regA[hook(11, 6)] * regB[hook(12, 3)];
    regC[hook(6, 3 * 8 + 7)] += regA[hook(11, 7)] * regB[hook(12, 3)];

    regC[hook(6, 4 * 8 + 0)] += regA[hook(11, 0)] * regB[hook(12, 4)];
    regC[hook(6, 4 * 8 + 1)] += regA[hook(11, 1)] * regB[hook(12, 4)];
    regC[hook(6, 4 * 8 + 2)] += regA[hook(11, 2)] * regB[hook(12, 4)];
    regC[hook(6, 4 * 8 + 3)] += regA[hook(11, 3)] * regB[hook(12, 4)];
    regC[hook(6, 4 * 8 + 4)] += regA[hook(11, 4)] * regB[hook(12, 4)];
    regC[hook(6, 4 * 8 + 5)] += regA[hook(11, 5)] * regB[hook(12, 4)];
    regC[hook(6, 4 * 8 + 6)] += regA[hook(11, 6)] * regB[hook(12, 4)];
    regC[hook(6, 4 * 8 + 7)] += regA[hook(11, 7)] * regB[hook(12, 4)];

    regC[hook(6, 5 * 8 + 0)] += regA[hook(11, 0)] * regB[hook(12, 5)];
    regC[hook(6, 5 * 8 + 1)] += regA[hook(11, 1)] * regB[hook(12, 5)];
    regC[hook(6, 5 * 8 + 2)] += regA[hook(11, 2)] * regB[hook(12, 5)];
    regC[hook(6, 5 * 8 + 3)] += regA[hook(11, 3)] * regB[hook(12, 5)];
    regC[hook(6, 5 * 8 + 4)] += regA[hook(11, 4)] * regB[hook(12, 5)];
    regC[hook(6, 5 * 8 + 5)] += regA[hook(11, 5)] * regB[hook(12, 5)];
    regC[hook(6, 5 * 8 + 6)] += regA[hook(11, 6)] * regB[hook(12, 5)];
    regC[hook(6, 5 * 8 + 7)] += regA[hook(11, 7)] * regB[hook(12, 5)];

    regC[hook(6, 6 * 8 + 0)] += regA[hook(11, 0)] * regB[hook(12, 6)];
    regC[hook(6, 6 * 8 + 1)] += regA[hook(11, 1)] * regB[hook(12, 6)];
    regC[hook(6, 6 * 8 + 2)] += regA[hook(11, 2)] * regB[hook(12, 6)];
    regC[hook(6, 6 * 8 + 3)] += regA[hook(11, 3)] * regB[hook(12, 6)];
    regC[hook(6, 6 * 8 + 4)] += regA[hook(11, 4)] * regB[hook(12, 6)];
    regC[hook(6, 6 * 8 + 5)] += regA[hook(11, 5)] * regB[hook(12, 6)];
    regC[hook(6, 6 * 8 + 6)] += regA[hook(11, 6)] * regB[hook(12, 6)];
    regC[hook(6, 6 * 8 + 7)] += regA[hook(11, 7)] * regB[hook(12, 6)];

    regC[hook(6, 7 * 8 + 0)] += regA[hook(11, 0)] * regB[hook(12, 7)];
    regC[hook(6, 7 * 8 + 1)] += regA[hook(11, 1)] * regB[hook(12, 7)];
    regC[hook(6, 7 * 8 + 2)] += regA[hook(11, 2)] * regB[hook(12, 7)];
    regC[hook(6, 7 * 8 + 3)] += regA[hook(11, 3)] * regB[hook(12, 7)];
    regC[hook(6, 7 * 8 + 4)] += regA[hook(11, 4)] * regB[hook(12, 7)];
    regC[hook(6, 7 * 8 + 5)] += regA[hook(11, 5)] * regB[hook(12, 7)];
    regC[hook(6, 7 * 8 + 6)] += regA[hook(11, 6)] * regB[hook(12, 7)];
    regC[hook(6, 7 * 8 + 7)] += regA[hook(11, 7)] * regB[hook(12, 7)];

    regA[hook(11, 0)] = tileA[hook(9, swap_index + 6 * tile_dim_x + local_thread_id_x * 4 + 0)];
    regA[hook(11, 1)] = tileA[hook(9, swap_index + 6 * tile_dim_x + local_thread_id_x * 4 + 1)];
    regA[hook(11, 2)] = tileA[hook(9, swap_index + 6 * tile_dim_x + local_thread_id_x * 4 + 2)];
    regA[hook(11, 3)] = tileA[hook(9, swap_index + 6 * tile_dim_x + local_thread_id_x * 4 + 3)];

    regA[hook(11, 4)] = tileA[hook(9, swap_index + 6 * tile_dim_x + tile_dim_x / 2 + local_thread_id_x * 4 + 0)];
    regA[hook(11, 5)] = tileA[hook(9, swap_index + 6 * tile_dim_x + tile_dim_x / 2 + local_thread_id_x * 4 + 1)];
    regA[hook(11, 6)] = tileA[hook(9, swap_index + 6 * tile_dim_x + tile_dim_x / 2 + local_thread_id_x * 4 + 2)];
    regA[hook(11, 7)] = tileA[hook(9, swap_index + 6 * tile_dim_x + tile_dim_x / 2 + local_thread_id_x * 4 + 3)];

    regB[hook(12, 0)] = tileB[hook(10, swap_index + 6 * tile_dim_y + local_thread_id_y * 4 + 0)];
    regB[hook(12, 1)] = tileB[hook(10, swap_index + 6 * tile_dim_y + local_thread_id_y * 4 + 1)];
    regB[hook(12, 2)] = tileB[hook(10, swap_index + 6 * tile_dim_y + local_thread_id_y * 4 + 2)];
    regB[hook(12, 3)] = tileB[hook(10, swap_index + 6 * tile_dim_y + local_thread_id_y * 4 + 3)];

    regB[hook(12, 4)] = tileB[hook(10, swap_index + 6 * tile_dim_y + tile_dim_y / 2 + local_thread_id_y * 4 + 0)];
    regB[hook(12, 5)] = tileB[hook(10, swap_index + 6 * tile_dim_y + tile_dim_y / 2 + local_thread_id_y * 4 + 1)];
    regB[hook(12, 6)] = tileB[hook(10, swap_index + 6 * tile_dim_y + tile_dim_y / 2 + local_thread_id_y * 4 + 2)];
    regB[hook(12, 7)] = tileB[hook(10, swap_index + 6 * tile_dim_y + tile_dim_y / 2 + local_thread_id_y * 4 + 3)];

    regC[hook(6, 0 * 8 + 0)] += regA[hook(11, 0)] * regB[hook(12, 0)];
    regC[hook(6, 0 * 8 + 1)] += regA[hook(11, 1)] * regB[hook(12, 0)];
    regC[hook(6, 0 * 8 + 2)] += regA[hook(11, 2)] * regB[hook(12, 0)];
    regC[hook(6, 0 * 8 + 3)] += regA[hook(11, 3)] * regB[hook(12, 0)];
    regC[hook(6, 0 * 8 + 4)] += regA[hook(11, 4)] * regB[hook(12, 0)];
    regC[hook(6, 0 * 8 + 5)] += regA[hook(11, 5)] * regB[hook(12, 0)];
    regC[hook(6, 0 * 8 + 6)] += regA[hook(11, 6)] * regB[hook(12, 0)];
    regC[hook(6, 0 * 8 + 7)] += regA[hook(11, 7)] * regB[hook(12, 0)];

    regC[hook(6, 1 * 8 + 0)] += regA[hook(11, 0)] * regB[hook(12, 1)];
    regC[hook(6, 1 * 8 + 1)] += regA[hook(11, 1)] * regB[hook(12, 1)];
    regC[hook(6, 1 * 8 + 2)] += regA[hook(11, 2)] * regB[hook(12, 1)];
    regC[hook(6, 1 * 8 + 3)] += regA[hook(11, 3)] * regB[hook(12, 1)];
    regC[hook(6, 1 * 8 + 4)] += regA[hook(11, 4)] * regB[hook(12, 1)];
    regC[hook(6, 1 * 8 + 5)] += regA[hook(11, 5)] * regB[hook(12, 1)];
    regC[hook(6, 1 * 8 + 6)] += regA[hook(11, 6)] * regB[hook(12, 1)];
    regC[hook(6, 1 * 8 + 7)] += regA[hook(11, 7)] * regB[hook(12, 1)];

    regC[hook(6, 2 * 8 + 0)] += regA[hook(11, 0)] * regB[hook(12, 2)];
    regC[hook(6, 2 * 8 + 1)] += regA[hook(11, 1)] * regB[hook(12, 2)];
    regC[hook(6, 2 * 8 + 2)] += regA[hook(11, 2)] * regB[hook(12, 2)];
    regC[hook(6, 2 * 8 + 3)] += regA[hook(11, 3)] * regB[hook(12, 2)];
    regC[hook(6, 2 * 8 + 4)] += regA[hook(11, 4)] * regB[hook(12, 2)];
    regC[hook(6, 2 * 8 + 5)] += regA[hook(11, 5)] * regB[hook(12, 2)];
    regC[hook(6, 2 * 8 + 6)] += regA[hook(11, 6)] * regB[hook(12, 2)];
    regC[hook(6, 2 * 8 + 7)] += regA[hook(11, 7)] * regB[hook(12, 2)];

    regC[hook(6, 3 * 8 + 0)] += regA[hook(11, 0)] * regB[hook(12, 3)];
    regC[hook(6, 3 * 8 + 1)] += regA[hook(11, 1)] * regB[hook(12, 3)];
    regC[hook(6, 3 * 8 + 2)] += regA[hook(11, 2)] * regB[hook(12, 3)];
    regC[hook(6, 3 * 8 + 3)] += regA[hook(11, 3)] * regB[hook(12, 3)];
    regC[hook(6, 3 * 8 + 4)] += regA[hook(11, 4)] * regB[hook(12, 3)];
    regC[hook(6, 3 * 8 + 5)] += regA[hook(11, 5)] * regB[hook(12, 3)];
    regC[hook(6, 3 * 8 + 6)] += regA[hook(11, 6)] * regB[hook(12, 3)];
    regC[hook(6, 3 * 8 + 7)] += regA[hook(11, 7)] * regB[hook(12, 3)];

    regC[hook(6, 4 * 8 + 0)] += regA[hook(11, 0)] * regB[hook(12, 4)];
    regC[hook(6, 4 * 8 + 1)] += regA[hook(11, 1)] * regB[hook(12, 4)];
    regC[hook(6, 4 * 8 + 2)] += regA[hook(11, 2)] * regB[hook(12, 4)];
    regC[hook(6, 4 * 8 + 3)] += regA[hook(11, 3)] * regB[hook(12, 4)];
    regC[hook(6, 4 * 8 + 4)] += regA[hook(11, 4)] * regB[hook(12, 4)];
    regC[hook(6, 4 * 8 + 5)] += regA[hook(11, 5)] * regB[hook(12, 4)];
    regC[hook(6, 4 * 8 + 6)] += regA[hook(11, 6)] * regB[hook(12, 4)];
    regC[hook(6, 4 * 8 + 7)] += regA[hook(11, 7)] * regB[hook(12, 4)];

    regC[hook(6, 5 * 8 + 0)] += regA[hook(11, 0)] * regB[hook(12, 5)];
    regC[hook(6, 5 * 8 + 1)] += regA[hook(11, 1)] * regB[hook(12, 5)];
    regC[hook(6, 5 * 8 + 2)] += regA[hook(11, 2)] * regB[hook(12, 5)];
    regC[hook(6, 5 * 8 + 3)] += regA[hook(11, 3)] * regB[hook(12, 5)];
    regC[hook(6, 5 * 8 + 4)] += regA[hook(11, 4)] * regB[hook(12, 5)];
    regC[hook(6, 5 * 8 + 5)] += regA[hook(11, 5)] * regB[hook(12, 5)];
    regC[hook(6, 5 * 8 + 6)] += regA[hook(11, 6)] * regB[hook(12, 5)];
    regC[hook(6, 5 * 8 + 7)] += regA[hook(11, 7)] * regB[hook(12, 5)];

    regC[hook(6, 6 * 8 + 0)] += regA[hook(11, 0)] * regB[hook(12, 6)];
    regC[hook(6, 6 * 8 + 1)] += regA[hook(11, 1)] * regB[hook(12, 6)];
    regC[hook(6, 6 * 8 + 2)] += regA[hook(11, 2)] * regB[hook(12, 6)];
    regC[hook(6, 6 * 8 + 3)] += regA[hook(11, 3)] * regB[hook(12, 6)];
    regC[hook(6, 6 * 8 + 4)] += regA[hook(11, 4)] * regB[hook(12, 6)];
    regC[hook(6, 6 * 8 + 5)] += regA[hook(11, 5)] * regB[hook(12, 6)];
    regC[hook(6, 6 * 8 + 6)] += regA[hook(11, 6)] * regB[hook(12, 6)];
    regC[hook(6, 6 * 8 + 7)] += regA[hook(11, 7)] * regB[hook(12, 6)];

    regC[hook(6, 7 * 8 + 0)] += regA[hook(11, 0)] * regB[hook(12, 7)];
    regC[hook(6, 7 * 8 + 1)] += regA[hook(11, 1)] * regB[hook(12, 7)];
    regC[hook(6, 7 * 8 + 2)] += regA[hook(11, 2)] * regB[hook(12, 7)];
    regC[hook(6, 7 * 8 + 3)] += regA[hook(11, 3)] * regB[hook(12, 7)];
    regC[hook(6, 7 * 8 + 4)] += regA[hook(11, 4)] * regB[hook(12, 7)];
    regC[hook(6, 7 * 8 + 5)] += regA[hook(11, 5)] * regB[hook(12, 7)];
    regC[hook(6, 7 * 8 + 6)] += regA[hook(11, 6)] * regB[hook(12, 7)];
    regC[hook(6, 7 * 8 + 7)] += regA[hook(11, 7)] * regB[hook(12, 7)];

    regA[hook(11, 0)] = tileA[hook(9, swap_index + 7 * tile_dim_x + local_thread_id_x * 4 + 0)];
    regA[hook(11, 1)] = tileA[hook(9, swap_index + 7 * tile_dim_x + local_thread_id_x * 4 + 1)];
    regA[hook(11, 2)] = tileA[hook(9, swap_index + 7 * tile_dim_x + local_thread_id_x * 4 + 2)];
    regA[hook(11, 3)] = tileA[hook(9, swap_index + 7 * tile_dim_x + local_thread_id_x * 4 + 3)];

    regA[hook(11, 4)] = tileA[hook(9, swap_index + 7 * tile_dim_x + tile_dim_x / 2 + local_thread_id_x * 4 + 0)];
    regA[hook(11, 5)] = tileA[hook(9, swap_index + 7 * tile_dim_x + tile_dim_x / 2 + local_thread_id_x * 4 + 1)];
    regA[hook(11, 6)] = tileA[hook(9, swap_index + 7 * tile_dim_x + tile_dim_x / 2 + local_thread_id_x * 4 + 2)];
    regA[hook(11, 7)] = tileA[hook(9, swap_index + 7 * tile_dim_x + tile_dim_x / 2 + local_thread_id_x * 4 + 3)];

    regB[hook(12, 0)] = tileB[hook(10, swap_index + 7 * tile_dim_y + local_thread_id_y * 4 + 0)];
    regB[hook(12, 1)] = tileB[hook(10, swap_index + 7 * tile_dim_y + local_thread_id_y * 4 + 1)];
    regB[hook(12, 2)] = tileB[hook(10, swap_index + 7 * tile_dim_y + local_thread_id_y * 4 + 2)];
    regB[hook(12, 3)] = tileB[hook(10, swap_index + 7 * tile_dim_y + local_thread_id_y * 4 + 3)];

    regB[hook(12, 4)] = tileB[hook(10, swap_index + 7 * tile_dim_y + tile_dim_y / 2 + local_thread_id_y * 4 + 0)];
    regB[hook(12, 5)] = tileB[hook(10, swap_index + 7 * tile_dim_y + tile_dim_y / 2 + local_thread_id_y * 4 + 1)];
    regB[hook(12, 6)] = tileB[hook(10, swap_index + 7 * tile_dim_y + tile_dim_y / 2 + local_thread_id_y * 4 + 2)];
    regB[hook(12, 7)] = tileB[hook(10, swap_index + 7 * tile_dim_y + tile_dim_y / 2 + local_thread_id_y * 4 + 3)];

    regC[hook(6, 0 * 8 + 0)] += regA[hook(11, 0)] * regB[hook(12, 0)];
    regC[hook(6, 0 * 8 + 1)] += regA[hook(11, 1)] * regB[hook(12, 0)];
    regC[hook(6, 0 * 8 + 2)] += regA[hook(11, 2)] * regB[hook(12, 0)];
    regC[hook(6, 0 * 8 + 3)] += regA[hook(11, 3)] * regB[hook(12, 0)];
    regC[hook(6, 0 * 8 + 4)] += regA[hook(11, 4)] * regB[hook(12, 0)];
    regC[hook(6, 0 * 8 + 5)] += regA[hook(11, 5)] * regB[hook(12, 0)];
    regC[hook(6, 0 * 8 + 6)] += regA[hook(11, 6)] * regB[hook(12, 0)];
    regC[hook(6, 0 * 8 + 7)] += regA[hook(11, 7)] * regB[hook(12, 0)];

    regC[hook(6, 1 * 8 + 0)] += regA[hook(11, 0)] * regB[hook(12, 1)];
    regC[hook(6, 1 * 8 + 1)] += regA[hook(11, 1)] * regB[hook(12, 1)];
    regC[hook(6, 1 * 8 + 2)] += regA[hook(11, 2)] * regB[hook(12, 1)];
    regC[hook(6, 1 * 8 + 3)] += regA[hook(11, 3)] * regB[hook(12, 1)];
    regC[hook(6, 1 * 8 + 4)] += regA[hook(11, 4)] * regB[hook(12, 1)];
    regC[hook(6, 1 * 8 + 5)] += regA[hook(11, 5)] * regB[hook(12, 1)];
    regC[hook(6, 1 * 8 + 6)] += regA[hook(11, 6)] * regB[hook(12, 1)];
    regC[hook(6, 1 * 8 + 7)] += regA[hook(11, 7)] * regB[hook(12, 1)];

    regC[hook(6, 2 * 8 + 0)] += regA[hook(11, 0)] * regB[hook(12, 2)];
    regC[hook(6, 2 * 8 + 1)] += regA[hook(11, 1)] * regB[hook(12, 2)];
    regC[hook(6, 2 * 8 + 2)] += regA[hook(11, 2)] * regB[hook(12, 2)];
    regC[hook(6, 2 * 8 + 3)] += regA[hook(11, 3)] * regB[hook(12, 2)];
    regC[hook(6, 2 * 8 + 4)] += regA[hook(11, 4)] * regB[hook(12, 2)];
    regC[hook(6, 2 * 8 + 5)] += regA[hook(11, 5)] * regB[hook(12, 2)];
    regC[hook(6, 2 * 8 + 6)] += regA[hook(11, 6)] * regB[hook(12, 2)];
    regC[hook(6, 2 * 8 + 7)] += regA[hook(11, 7)] * regB[hook(12, 2)];

    regC[hook(6, 3 * 8 + 0)] += regA[hook(11, 0)] * regB[hook(12, 3)];
    regC[hook(6, 3 * 8 + 1)] += regA[hook(11, 1)] * regB[hook(12, 3)];
    regC[hook(6, 3 * 8 + 2)] += regA[hook(11, 2)] * regB[hook(12, 3)];
    regC[hook(6, 3 * 8 + 3)] += regA[hook(11, 3)] * regB[hook(12, 3)];
    regC[hook(6, 3 * 8 + 4)] += regA[hook(11, 4)] * regB[hook(12, 3)];
    regC[hook(6, 3 * 8 + 5)] += regA[hook(11, 5)] * regB[hook(12, 3)];
    regC[hook(6, 3 * 8 + 6)] += regA[hook(11, 6)] * regB[hook(12, 3)];
    regC[hook(6, 3 * 8 + 7)] += regA[hook(11, 7)] * regB[hook(12, 3)];

    regC[hook(6, 4 * 8 + 0)] += regA[hook(11, 0)] * regB[hook(12, 4)];
    regC[hook(6, 4 * 8 + 1)] += regA[hook(11, 1)] * regB[hook(12, 4)];
    regC[hook(6, 4 * 8 + 2)] += regA[hook(11, 2)] * regB[hook(12, 4)];
    regC[hook(6, 4 * 8 + 3)] += regA[hook(11, 3)] * regB[hook(12, 4)];
    regC[hook(6, 4 * 8 + 4)] += regA[hook(11, 4)] * regB[hook(12, 4)];
    regC[hook(6, 4 * 8 + 5)] += regA[hook(11, 5)] * regB[hook(12, 4)];
    regC[hook(6, 4 * 8 + 6)] += regA[hook(11, 6)] * regB[hook(12, 4)];
    regC[hook(6, 4 * 8 + 7)] += regA[hook(11, 7)] * regB[hook(12, 4)];

    regC[hook(6, 5 * 8 + 0)] += regA[hook(11, 0)] * regB[hook(12, 5)];
    regC[hook(6, 5 * 8 + 1)] += regA[hook(11, 1)] * regB[hook(12, 5)];
    regC[hook(6, 5 * 8 + 2)] += regA[hook(11, 2)] * regB[hook(12, 5)];
    regC[hook(6, 5 * 8 + 3)] += regA[hook(11, 3)] * regB[hook(12, 5)];
    regC[hook(6, 5 * 8 + 4)] += regA[hook(11, 4)] * regB[hook(12, 5)];
    regC[hook(6, 5 * 8 + 5)] += regA[hook(11, 5)] * regB[hook(12, 5)];
    regC[hook(6, 5 * 8 + 6)] += regA[hook(11, 6)] * regB[hook(12, 5)];
    regC[hook(6, 5 * 8 + 7)] += regA[hook(11, 7)] * regB[hook(12, 5)];

    regC[hook(6, 6 * 8 + 0)] += regA[hook(11, 0)] * regB[hook(12, 6)];
    regC[hook(6, 6 * 8 + 1)] += regA[hook(11, 1)] * regB[hook(12, 6)];
    regC[hook(6, 6 * 8 + 2)] += regA[hook(11, 2)] * regB[hook(12, 6)];
    regC[hook(6, 6 * 8 + 3)] += regA[hook(11, 3)] * regB[hook(12, 6)];
    regC[hook(6, 6 * 8 + 4)] += regA[hook(11, 4)] * regB[hook(12, 6)];
    regC[hook(6, 6 * 8 + 5)] += regA[hook(11, 5)] * regB[hook(12, 6)];
    regC[hook(6, 6 * 8 + 6)] += regA[hook(11, 6)] * regB[hook(12, 6)];
    regC[hook(6, 6 * 8 + 7)] += regA[hook(11, 7)] * regB[hook(12, 6)];

    regC[hook(6, 7 * 8 + 0)] += regA[hook(11, 0)] * regB[hook(12, 7)];
    regC[hook(6, 7 * 8 + 1)] += regA[hook(11, 1)] * regB[hook(12, 7)];
    regC[hook(6, 7 * 8 + 2)] += regA[hook(11, 2)] * regB[hook(12, 7)];
    regC[hook(6, 7 * 8 + 3)] += regA[hook(11, 3)] * regB[hook(12, 7)];
    regC[hook(6, 7 * 8 + 4)] += regA[hook(11, 4)] * regB[hook(12, 7)];
    regC[hook(6, 7 * 8 + 5)] += regA[hook(11, 5)] * regB[hook(12, 7)];
    regC[hook(6, 7 * 8 + 6)] += regA[hook(11, 6)] * regB[hook(12, 7)];
    regC[hook(6, 7 * 8 + 7)] += regA[hook(11, 7)] * regB[hook(12, 7)];

    swap_index = (swap_index + 512) % 1024;
  }

  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * (thread_task_y / 2) + 0) * M + block_id_x * tile_dim_x + local_thread_id_x * (thread_task_x / 2) + 0)] = regC[hook(6, 0 * 8 + 0)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * (thread_task_y / 2) + 0) * M + block_id_x * tile_dim_x + local_thread_id_x * (thread_task_x / 2) + 1)] = regC[hook(6, 0 * 8 + 1)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * (thread_task_y / 2) + 0) * M + block_id_x * tile_dim_x + local_thread_id_x * (thread_task_x / 2) + 2)] = regC[hook(6, 0 * 8 + 2)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * (thread_task_y / 2) + 0) * M + block_id_x * tile_dim_x + local_thread_id_x * (thread_task_x / 2) + 3)] = regC[hook(6, 0 * 8 + 3)];

  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * (thread_task_y / 2) + 0) * M + block_id_x * tile_dim_x + tile_dim_x / 2 + local_thread_id_x * (thread_task_x / 2) + 0)] = regC[hook(6, 0 * 8 + 4)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * (thread_task_y / 2) + 0) * M + block_id_x * tile_dim_x + tile_dim_x / 2 + local_thread_id_x * (thread_task_x / 2) + 1)] = regC[hook(6, 0 * 8 + 5)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * (thread_task_y / 2) + 0) * M + block_id_x * tile_dim_x + tile_dim_x / 2 + local_thread_id_x * (thread_task_x / 2) + 2)] = regC[hook(6, 0 * 8 + 6)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * (thread_task_y / 2) + 0) * M + block_id_x * tile_dim_x + tile_dim_x / 2 + local_thread_id_x * (thread_task_x / 2) + 3)] = regC[hook(6, 0 * 8 + 7)];

  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * (thread_task_y / 2) + 1) * M + block_id_x * tile_dim_x + local_thread_id_x * (thread_task_x / 2) + 0)] = regC[hook(6, 1 * 8 + 0)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * (thread_task_y / 2) + 1) * M + block_id_x * tile_dim_x + local_thread_id_x * (thread_task_x / 2) + 1)] = regC[hook(6, 1 * 8 + 1)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * (thread_task_y / 2) + 1) * M + block_id_x * tile_dim_x + local_thread_id_x * (thread_task_x / 2) + 2)] = regC[hook(6, 1 * 8 + 2)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * (thread_task_y / 2) + 1) * M + block_id_x * tile_dim_x + local_thread_id_x * (thread_task_x / 2) + 3)] = regC[hook(6, 1 * 8 + 3)];

  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * (thread_task_y / 2) + 1) * M + block_id_x * tile_dim_x + tile_dim_x / 2 + local_thread_id_x * (thread_task_x / 2) + 0)] = regC[hook(6, 1 * 8 + 4)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * (thread_task_y / 2) + 1) * M + block_id_x * tile_dim_x + tile_dim_x / 2 + local_thread_id_x * (thread_task_x / 2) + 1)] = regC[hook(6, 1 * 8 + 5)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * (thread_task_y / 2) + 1) * M + block_id_x * tile_dim_x + tile_dim_x / 2 + local_thread_id_x * (thread_task_x / 2) + 2)] = regC[hook(6, 1 * 8 + 6)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * (thread_task_y / 2) + 1) * M + block_id_x * tile_dim_x + tile_dim_x / 2 + local_thread_id_x * (thread_task_x / 2) + 3)] = regC[hook(6, 1 * 8 + 7)];

  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * (thread_task_y / 2) + 2) * M + block_id_x * tile_dim_x + local_thread_id_x * (thread_task_x / 2) + 0)] = regC[hook(6, 2 * 8 + 0)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * (thread_task_y / 2) + 2) * M + block_id_x * tile_dim_x + local_thread_id_x * (thread_task_x / 2) + 1)] = regC[hook(6, 2 * 8 + 1)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * (thread_task_y / 2) + 2) * M + block_id_x * tile_dim_x + local_thread_id_x * (thread_task_x / 2) + 2)] = regC[hook(6, 2 * 8 + 2)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * (thread_task_y / 2) + 2) * M + block_id_x * tile_dim_x + local_thread_id_x * (thread_task_x / 2) + 3)] = regC[hook(6, 2 * 8 + 3)];

  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * (thread_task_y / 2) + 2) * M + block_id_x * tile_dim_x + tile_dim_x / 2 + local_thread_id_x * (thread_task_x / 2) + 0)] = regC[hook(6, 2 * 8 + 4)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * (thread_task_y / 2) + 2) * M + block_id_x * tile_dim_x + tile_dim_x / 2 + local_thread_id_x * (thread_task_x / 2) + 1)] = regC[hook(6, 2 * 8 + 5)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * (thread_task_y / 2) + 2) * M + block_id_x * tile_dim_x + tile_dim_x / 2 + local_thread_id_x * (thread_task_x / 2) + 2)] = regC[hook(6, 2 * 8 + 6)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * (thread_task_y / 2) + 2) * M + block_id_x * tile_dim_x + tile_dim_x / 2 + local_thread_id_x * (thread_task_x / 2) + 3)] = regC[hook(6, 2 * 8 + 7)];

  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * (thread_task_y / 2) + 3) * M + block_id_x * tile_dim_x + local_thread_id_x * (thread_task_x / 2) + 0)] = regC[hook(6, 3 * 8 + 0)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * (thread_task_y / 2) + 3) * M + block_id_x * tile_dim_x + local_thread_id_x * (thread_task_x / 2) + 1)] = regC[hook(6, 3 * 8 + 1)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * (thread_task_y / 2) + 3) * M + block_id_x * tile_dim_x + local_thread_id_x * (thread_task_x / 2) + 2)] = regC[hook(6, 3 * 8 + 2)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * (thread_task_y / 2) + 3) * M + block_id_x * tile_dim_x + local_thread_id_x * (thread_task_x / 2) + 3)] = regC[hook(6, 3 * 8 + 3)];

  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * (thread_task_y / 2) + 3) * M + block_id_x * tile_dim_x + tile_dim_x / 2 + local_thread_id_x * (thread_task_x / 2) + 0)] = regC[hook(6, 3 * 8 + 4)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * (thread_task_y / 2) + 3) * M + block_id_x * tile_dim_x + tile_dim_x / 2 + local_thread_id_x * (thread_task_x / 2) + 1)] = regC[hook(6, 3 * 8 + 5)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * (thread_task_y / 2) + 3) * M + block_id_x * tile_dim_x + tile_dim_x / 2 + local_thread_id_x * (thread_task_x / 2) + 2)] = regC[hook(6, 3 * 8 + 6)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * (thread_task_y / 2) + 3) * M + block_id_x * tile_dim_x + tile_dim_x / 2 + local_thread_id_x * (thread_task_x / 2) + 3)] = regC[hook(6, 3 * 8 + 7)];

  C[hook(2, (block_id_y * tile_dim_y + tile_dim_y / 2 + local_thread_id_y * (thread_task_y / 2) + 0) * M + block_id_x * tile_dim_x + local_thread_id_x * (thread_task_x / 2) + 0)] = regC[hook(6, 4 * 8 + 0)];
  C[hook(2, (block_id_y * tile_dim_y + tile_dim_y / 2 + local_thread_id_y * (thread_task_y / 2) + 0) * M + block_id_x * tile_dim_x + local_thread_id_x * (thread_task_x / 2) + 1)] = regC[hook(6, 4 * 8 + 1)];
  C[hook(2, (block_id_y * tile_dim_y + tile_dim_y / 2 + local_thread_id_y * (thread_task_y / 2) + 0) * M + block_id_x * tile_dim_x + local_thread_id_x * (thread_task_x / 2) + 2)] = regC[hook(6, 4 * 8 + 2)];
  C[hook(2, (block_id_y * tile_dim_y + tile_dim_y / 2 + local_thread_id_y * (thread_task_y / 2) + 0) * M + block_id_x * tile_dim_x + local_thread_id_x * (thread_task_x / 2) + 3)] = regC[hook(6, 4 * 8 + 3)];

  C[hook(2, (block_id_y * tile_dim_y + tile_dim_y / 2 + local_thread_id_y * (thread_task_y / 2) + 0) * M + block_id_x * tile_dim_x + tile_dim_x / 2 + local_thread_id_x * (thread_task_x / 2) + 0)] = regC[hook(6, 4 * 8 + 4)];
  C[hook(2, (block_id_y * tile_dim_y + tile_dim_y / 2 + local_thread_id_y * (thread_task_y / 2) + 0) * M + block_id_x * tile_dim_x + tile_dim_x / 2 + local_thread_id_x * (thread_task_x / 2) + 1)] = regC[hook(6, 4 * 8 + 5)];
  C[hook(2, (block_id_y * tile_dim_y + tile_dim_y / 2 + local_thread_id_y * (thread_task_y / 2) + 0) * M + block_id_x * tile_dim_x + tile_dim_x / 2 + local_thread_id_x * (thread_task_x / 2) + 2)] = regC[hook(6, 4 * 8 + 6)];
  C[hook(2, (block_id_y * tile_dim_y + tile_dim_y / 2 + local_thread_id_y * (thread_task_y / 2) + 0) * M + block_id_x * tile_dim_x + tile_dim_x / 2 + local_thread_id_x * (thread_task_x / 2) + 3)] = regC[hook(6, 4 * 8 + 7)];

  C[hook(2, (block_id_y * tile_dim_y + tile_dim_y / 2 + local_thread_id_y * (thread_task_y / 2) + 1) * M + block_id_x * tile_dim_x + local_thread_id_x * (thread_task_x / 2) + 0)] = regC[hook(6, 5 * 8 + 0)];
  C[hook(2, (block_id_y * tile_dim_y + tile_dim_y / 2 + local_thread_id_y * (thread_task_y / 2) + 1) * M + block_id_x * tile_dim_x + local_thread_id_x * (thread_task_x / 2) + 1)] = regC[hook(6, 5 * 8 + 1)];
  C[hook(2, (block_id_y * tile_dim_y + tile_dim_y / 2 + local_thread_id_y * (thread_task_y / 2) + 1) * M + block_id_x * tile_dim_x + local_thread_id_x * (thread_task_x / 2) + 2)] = regC[hook(6, 5 * 8 + 2)];
  C[hook(2, (block_id_y * tile_dim_y + tile_dim_y / 2 + local_thread_id_y * (thread_task_y / 2) + 1) * M + block_id_x * tile_dim_x + local_thread_id_x * (thread_task_x / 2) + 3)] = regC[hook(6, 5 * 8 + 3)];

  C[hook(2, (block_id_y * tile_dim_y + tile_dim_y / 2 + local_thread_id_y * (thread_task_y / 2) + 1) * M + block_id_x * tile_dim_x + tile_dim_x / 2 + local_thread_id_x * (thread_task_x / 2) + 0)] = regC[hook(6, 5 * 8 + 4)];
  C[hook(2, (block_id_y * tile_dim_y + tile_dim_y / 2 + local_thread_id_y * (thread_task_y / 2) + 1) * M + block_id_x * tile_dim_x + tile_dim_x / 2 + local_thread_id_x * (thread_task_x / 2) + 1)] = regC[hook(6, 5 * 8 + 5)];
  C[hook(2, (block_id_y * tile_dim_y + tile_dim_y / 2 + local_thread_id_y * (thread_task_y / 2) + 1) * M + block_id_x * tile_dim_x + tile_dim_x / 2 + local_thread_id_x * (thread_task_x / 2) + 2)] = regC[hook(6, 5 * 8 + 6)];
  C[hook(2, (block_id_y * tile_dim_y + tile_dim_y / 2 + local_thread_id_y * (thread_task_y / 2) + 1) * M + block_id_x * tile_dim_x + tile_dim_x / 2 + local_thread_id_x * (thread_task_x / 2) + 3)] = regC[hook(6, 5 * 8 + 7)];

  C[hook(2, (block_id_y * tile_dim_y + tile_dim_y / 2 + local_thread_id_y * (thread_task_y / 2) + 2) * M + block_id_x * tile_dim_x + local_thread_id_x * (thread_task_x / 2) + 0)] = regC[hook(6, 6 * 8 + 0)];
  C[hook(2, (block_id_y * tile_dim_y + tile_dim_y / 2 + local_thread_id_y * (thread_task_y / 2) + 2) * M + block_id_x * tile_dim_x + local_thread_id_x * (thread_task_x / 2) + 1)] = regC[hook(6, 6 * 8 + 1)];
  C[hook(2, (block_id_y * tile_dim_y + tile_dim_y / 2 + local_thread_id_y * (thread_task_y / 2) + 2) * M + block_id_x * tile_dim_x + local_thread_id_x * (thread_task_x / 2) + 2)] = regC[hook(6, 6 * 8 + 2)];
  C[hook(2, (block_id_y * tile_dim_y + tile_dim_y / 2 + local_thread_id_y * (thread_task_y / 2) + 2) * M + block_id_x * tile_dim_x + local_thread_id_x * (thread_task_x / 2) + 3)] = regC[hook(6, 6 * 8 + 3)];

  C[hook(2, (block_id_y * tile_dim_y + tile_dim_y / 2 + local_thread_id_y * (thread_task_y / 2) + 2) * M + block_id_x * tile_dim_x + tile_dim_x / 2 + local_thread_id_x * (thread_task_x / 2) + 0)] = regC[hook(6, 6 * 8 + 4)];
  C[hook(2, (block_id_y * tile_dim_y + tile_dim_y / 2 + local_thread_id_y * (thread_task_y / 2) + 2) * M + block_id_x * tile_dim_x + tile_dim_x / 2 + local_thread_id_x * (thread_task_x / 2) + 1)] = regC[hook(6, 6 * 8 + 5)];
  C[hook(2, (block_id_y * tile_dim_y + tile_dim_y / 2 + local_thread_id_y * (thread_task_y / 2) + 2) * M + block_id_x * tile_dim_x + tile_dim_x / 2 + local_thread_id_x * (thread_task_x / 2) + 2)] = regC[hook(6, 6 * 8 + 6)];
  C[hook(2, (block_id_y * tile_dim_y + tile_dim_y / 2 + local_thread_id_y * (thread_task_y / 2) + 2) * M + block_id_x * tile_dim_x + tile_dim_x / 2 + local_thread_id_x * (thread_task_x / 2) + 3)] = regC[hook(6, 6 * 8 + 7)];

  C[hook(2, (block_id_y * tile_dim_y + tile_dim_y / 2 + local_thread_id_y * (thread_task_y / 2) + 3) * M + block_id_x * tile_dim_x + local_thread_id_x * (thread_task_x / 2) + 0)] = regC[hook(6, 7 * 8 + 0)];
  C[hook(2, (block_id_y * tile_dim_y + tile_dim_y / 2 + local_thread_id_y * (thread_task_y / 2) + 3) * M + block_id_x * tile_dim_x + local_thread_id_x * (thread_task_x / 2) + 1)] = regC[hook(6, 7 * 8 + 1)];
  C[hook(2, (block_id_y * tile_dim_y + tile_dim_y / 2 + local_thread_id_y * (thread_task_y / 2) + 3) * M + block_id_x * tile_dim_x + local_thread_id_x * (thread_task_x / 2) + 2)] = regC[hook(6, 7 * 8 + 2)];
  C[hook(2, (block_id_y * tile_dim_y + tile_dim_y / 2 + local_thread_id_y * (thread_task_y / 2) + 3) * M + block_id_x * tile_dim_x + local_thread_id_x * (thread_task_x / 2) + 3)] = regC[hook(6, 7 * 8 + 3)];

  C[hook(2, (block_id_y * tile_dim_y + tile_dim_y / 2 + local_thread_id_y * (thread_task_y / 2) + 3) * M + block_id_x * tile_dim_x + tile_dim_x / 2 + local_thread_id_x * (thread_task_x / 2) + 0)] = regC[hook(6, 7 * 8 + 4)];
  C[hook(2, (block_id_y * tile_dim_y + tile_dim_y / 2 + local_thread_id_y * (thread_task_y / 2) + 3) * M + block_id_x * tile_dim_x + tile_dim_x / 2 + local_thread_id_x * (thread_task_x / 2) + 1)] = regC[hook(6, 7 * 8 + 5)];
  C[hook(2, (block_id_y * tile_dim_y + tile_dim_y / 2 + local_thread_id_y * (thread_task_y / 2) + 3) * M + block_id_x * tile_dim_x + tile_dim_x / 2 + local_thread_id_x * (thread_task_x / 2) + 2)] = regC[hook(6, 7 * 8 + 6)];
  C[hook(2, (block_id_y * tile_dim_y + tile_dim_y / 2 + local_thread_id_y * (thread_task_y / 2) + 3) * M + block_id_x * tile_dim_x + tile_dim_x / 2 + local_thread_id_x * (thread_task_x / 2) + 3)] = regC[hook(6, 7 * 8 + 7)];
}
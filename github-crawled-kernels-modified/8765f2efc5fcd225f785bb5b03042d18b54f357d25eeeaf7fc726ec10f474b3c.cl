//{"A":0,"B":1,"C":2,"K":5,"M":3,"N":4,"regA":10,"regA_bak":13,"regB":11,"regB_bak":16,"regC":7,"regC[0]":12,"regC[1]":14,"regC[2]":15,"regC[3]":17,"regC[4]":18,"regC[5]":19,"regC[6]":20,"regC[7]":21,"regC[i]":6,"tileA":8,"tileB":9}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void gemm(const global float* A, const global float* B, global float* C, const int M, const int N, const int K) {
  int global_thread_id_x = get_group_id(0) * get_local_size(0) + get_local_id(0);
  int global_thread_id_y = get_group_id(1) * get_local_size(1) + get_local_id(1);

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

  local float tileA[64 * 8];
  local float tileA_bak[64 * 8];
  local float tileB[64 * 8];
  local float tileB_bak[64 * 8];

  float regA[8], regB[8];
  float regA_bak[8], regB_bak[8];
  float regC[8][8];

  for (int i = 0; i < thread_task_y; ++i) {
    for (int j = 0; j < thread_task_x; ++j) {
      regC[hook(7, i)][hook(6, j)] = 0;
    }
  }

  for (int i = 0; i < K / NUM_UNROLL; ++i) {
    for (int t = 0; t < 8; ++t) {
      tileA[hook(8, local_thread_id_y * 64 + local_thread_id_x * 8 + t)] = A[hook(0, (i * NUM_UNROLL + local_thread_id_y) * M + block_id_x * tile_dim_x + local_thread_id_x * 8 + t)];

      tileB[hook(9, local_thread_id + t * tile_dim_y)] = B[hook(1, (block_id_y * tile_dim_y + local_thread_id) * K + i * NUM_UNROLL + t)];
    }

    barrier(0x01);

    regA[hook(10, 0)] = tileA[hook(8, 0 * tile_dim_x + local_thread_id_x * 8 + 0)];
    regA[hook(10, 1)] = tileA[hook(8, 0 * tile_dim_x + local_thread_id_x * 8 + 1)];
    regA[hook(10, 2)] = tileA[hook(8, 0 * tile_dim_x + local_thread_id_x * 8 + 2)];
    regA[hook(10, 3)] = tileA[hook(8, 0 * tile_dim_x + local_thread_id_x * 8 + 3)];
    regA[hook(10, 4)] = tileA[hook(8, 0 * tile_dim_x + local_thread_id_x * 8 + 4)];
    regA[hook(10, 5)] = tileA[hook(8, 0 * tile_dim_x + local_thread_id_x * 8 + 5)];
    regA[hook(10, 6)] = tileA[hook(8, 0 * tile_dim_x + local_thread_id_x * 8 + 6)];
    regA[hook(10, 7)] = tileA[hook(8, 0 * tile_dim_x + local_thread_id_x * 8 + 7)];

    regB[hook(11, 0)] = tileB[hook(9, 0 * tile_dim_y + local_thread_id_y * 8 + 0)];
    regB[hook(11, 1)] = tileB[hook(9, 0 * tile_dim_y + local_thread_id_y * 8 + 1)];
    regB[hook(11, 2)] = tileB[hook(9, 0 * tile_dim_y + local_thread_id_y * 8 + 2)];
    regB[hook(11, 3)] = tileB[hook(9, 0 * tile_dim_y + local_thread_id_y * 8 + 3)];
    regB[hook(11, 4)] = tileB[hook(9, 0 * tile_dim_y + local_thread_id_y * 8 + 4)];
    regB[hook(11, 5)] = tileB[hook(9, 0 * tile_dim_y + local_thread_id_y * 8 + 5)];
    regB[hook(11, 6)] = tileB[hook(9, 0 * tile_dim_y + local_thread_id_y * 8 + 6)];
    regB[hook(11, 7)] = tileB[hook(9, 0 * tile_dim_y + local_thread_id_y * 8 + 7)];

    for (int k = 0; k < NUM_UNROLL; ++k) {
      if (k % 2 == 0) {
        regC[hook(7, 0)][hook(12, 0)] += regA[hook(10, 0)] * regB[hook(11, 0)];
        regA_bak[hook(13, 0)] = tileA[hook(8, (k + 1) * tile_dim_x + local_thread_id_x * 8 + 0)];
        regC[hook(7, 0)][hook(12, 1)] += regA[hook(10, 0)] * regB[hook(11, 1)];
        regC[hook(7, 0)][hook(12, 2)] += regA[hook(10, 0)] * regB[hook(11, 2)];
        regA_bak[hook(13, 1)] = tileA[hook(8, (k + 1) * tile_dim_x + local_thread_id_x * 8 + 1)];
        regC[hook(7, 0)][hook(12, 3)] += regA[hook(10, 0)] * regB[hook(11, 3)];
        regC[hook(7, 0)][hook(12, 4)] += regA[hook(10, 0)] * regB[hook(11, 4)];
        regA_bak[hook(13, 2)] = tileA[hook(8, (k + 1) * tile_dim_x + local_thread_id_x * 8 + 2)];
        regC[hook(7, 0)][hook(12, 5)] += regA[hook(10, 0)] * regB[hook(11, 5)];
        regC[hook(7, 0)][hook(12, 6)] += regA[hook(10, 0)] * regB[hook(11, 6)];
        regA_bak[hook(13, 3)] = tileA[hook(8, (k + 1) * tile_dim_x + local_thread_id_x * 8 + 3)];
        regC[hook(7, 0)][hook(12, 7)] += regA[hook(10, 0)] * regB[hook(11, 7)];

        regC[hook(7, 1)][hook(14, 0)] += regA[hook(10, 1)] * regB[hook(11, 0)];
        regA_bak[hook(13, 4)] = tileA[hook(8, (k + 1) * tile_dim_x + local_thread_id_x * 8 + 4)];
        regC[hook(7, 1)][hook(14, 1)] += regA[hook(10, 1)] * regB[hook(11, 1)];
        regC[hook(7, 1)][hook(14, 2)] += regA[hook(10, 1)] * regB[hook(11, 2)];
        regA_bak[hook(13, 5)] = tileA[hook(8, (k + 1) * tile_dim_x + local_thread_id_x * 8 + 5)];
        regC[hook(7, 1)][hook(14, 3)] += regA[hook(10, 1)] * regB[hook(11, 3)];
        regC[hook(7, 1)][hook(14, 4)] += regA[hook(10, 1)] * regB[hook(11, 4)];
        regA_bak[hook(13, 6)] = tileA[hook(8, (k + 1) * tile_dim_x + local_thread_id_x * 8 + 6)];
        regC[hook(7, 1)][hook(14, 5)] += regA[hook(10, 1)] * regB[hook(11, 5)];
        regC[hook(7, 1)][hook(14, 6)] += regA[hook(10, 1)] * regB[hook(11, 6)];
        regA_bak[hook(13, 7)] = tileA[hook(8, (k + 1) * tile_dim_x + local_thread_id_x * 8 + 7)];
        regC[hook(7, 1)][hook(14, 7)] += regA[hook(10, 1)] * regB[hook(11, 7)];

        regC[hook(7, 2)][hook(15, 0)] += regA[hook(10, 2)] * regB[hook(11, 0)];
        regB_bak[hook(16, 0)] = tileB[hook(9, (k + 1) * tile_dim_y + local_thread_id_y * 8 + 0)];
        regC[hook(7, 2)][hook(15, 1)] += regA[hook(10, 2)] * regB[hook(11, 1)];
        regC[hook(7, 2)][hook(15, 2)] += regA[hook(10, 2)] * regB[hook(11, 2)];
        regB_bak[hook(16, 1)] = tileB[hook(9, (k + 1) * tile_dim_y + local_thread_id_y * 8 + 1)];
        regC[hook(7, 2)][hook(15, 3)] += regA[hook(10, 2)] * regB[hook(11, 3)];
        regC[hook(7, 2)][hook(15, 4)] += regA[hook(10, 2)] * regB[hook(11, 4)];
        regB_bak[hook(16, 2)] = tileB[hook(9, (k + 1) * tile_dim_y + local_thread_id_y * 8 + 2)];
        regC[hook(7, 2)][hook(15, 5)] += regA[hook(10, 2)] * regB[hook(11, 5)];
        regC[hook(7, 2)][hook(15, 6)] += regA[hook(10, 2)] * regB[hook(11, 6)];
        regB_bak[hook(16, 3)] = tileB[hook(9, (k + 1) * tile_dim_y + local_thread_id_y * 8 + 3)];
        regC[hook(7, 2)][hook(15, 7)] += regA[hook(10, 2)] * regB[hook(11, 7)];

        regC[hook(7, 3)][hook(17, 0)] += regA[hook(10, 3)] * regB[hook(11, 0)];
        regB_bak[hook(16, 4)] = tileB[hook(9, (k + 1) * tile_dim_y + local_thread_id_y * 8 + 4)];
        regC[hook(7, 3)][hook(17, 1)] += regA[hook(10, 3)] * regB[hook(11, 1)];
        regC[hook(7, 3)][hook(17, 2)] += regA[hook(10, 3)] * regB[hook(11, 2)];
        regB_bak[hook(16, 5)] = tileB[hook(9, (k + 1) * tile_dim_y + local_thread_id_y * 8 + 5)];
        regC[hook(7, 3)][hook(17, 3)] += regA[hook(10, 3)] * regB[hook(11, 3)];
        regC[hook(7, 3)][hook(17, 4)] += regA[hook(10, 3)] * regB[hook(11, 4)];
        regB_bak[hook(16, 6)] = tileB[hook(9, (k + 1) * tile_dim_y + local_thread_id_y * 8 + 6)];
        regC[hook(7, 3)][hook(17, 5)] += regA[hook(10, 3)] * regB[hook(11, 5)];
        regC[hook(7, 3)][hook(17, 6)] += regA[hook(10, 3)] * regB[hook(11, 6)];
        regB_bak[hook(16, 7)] = tileB[hook(9, (k + 1) * tile_dim_y + local_thread_id_y * 8 + 7)];
        regC[hook(7, 3)][hook(17, 7)] += regA[hook(10, 3)] * regB[hook(11, 7)];

        regC[hook(7, 4)][hook(18, 0)] += regA[hook(10, 4)] * regB[hook(11, 0)];
        regC[hook(7, 4)][hook(18, 1)] += regA[hook(10, 4)] * regB[hook(11, 1)];
        regC[hook(7, 4)][hook(18, 2)] += regA[hook(10, 4)] * regB[hook(11, 2)];
        regC[hook(7, 4)][hook(18, 3)] += regA[hook(10, 4)] * regB[hook(11, 3)];
        regC[hook(7, 4)][hook(18, 4)] += regA[hook(10, 4)] * regB[hook(11, 4)];
        regC[hook(7, 4)][hook(18, 5)] += regA[hook(10, 4)] * regB[hook(11, 5)];
        regC[hook(7, 4)][hook(18, 6)] += regA[hook(10, 4)] * regB[hook(11, 6)];
        regC[hook(7, 4)][hook(18, 7)] += regA[hook(10, 4)] * regB[hook(11, 7)];

        regC[hook(7, 5)][hook(19, 0)] += regA[hook(10, 5)] * regB[hook(11, 0)];
        regC[hook(7, 5)][hook(19, 1)] += regA[hook(10, 5)] * regB[hook(11, 1)];
        regC[hook(7, 5)][hook(19, 2)] += regA[hook(10, 5)] * regB[hook(11, 2)];
        regC[hook(7, 5)][hook(19, 3)] += regA[hook(10, 5)] * regB[hook(11, 3)];
        regC[hook(7, 5)][hook(19, 4)] += regA[hook(10, 5)] * regB[hook(11, 4)];
        regC[hook(7, 5)][hook(19, 5)] += regA[hook(10, 5)] * regB[hook(11, 5)];
        regC[hook(7, 5)][hook(19, 6)] += regA[hook(10, 5)] * regB[hook(11, 6)];
        regC[hook(7, 5)][hook(19, 7)] += regA[hook(10, 5)] * regB[hook(11, 7)];

        regC[hook(7, 6)][hook(20, 0)] += regA[hook(10, 6)] * regB[hook(11, 0)];
        regC[hook(7, 6)][hook(20, 1)] += regA[hook(10, 6)] * regB[hook(11, 1)];
        regC[hook(7, 6)][hook(20, 2)] += regA[hook(10, 6)] * regB[hook(11, 2)];
        regC[hook(7, 6)][hook(20, 3)] += regA[hook(10, 6)] * regB[hook(11, 3)];
        regC[hook(7, 6)][hook(20, 4)] += regA[hook(10, 6)] * regB[hook(11, 4)];
        regC[hook(7, 6)][hook(20, 5)] += regA[hook(10, 6)] * regB[hook(11, 5)];
        regC[hook(7, 6)][hook(20, 6)] += regA[hook(10, 6)] * regB[hook(11, 6)];
        regC[hook(7, 6)][hook(20, 7)] += regA[hook(10, 6)] * regB[hook(11, 7)];

        regC[hook(7, 7)][hook(21, 0)] += regA[hook(10, 7)] * regB[hook(11, 0)];
        regC[hook(7, 7)][hook(21, 1)] += regA[hook(10, 7)] * regB[hook(11, 1)];
        regC[hook(7, 7)][hook(21, 2)] += regA[hook(10, 7)] * regB[hook(11, 2)];
        regC[hook(7, 7)][hook(21, 3)] += regA[hook(10, 7)] * regB[hook(11, 3)];
        regC[hook(7, 7)][hook(21, 4)] += regA[hook(10, 7)] * regB[hook(11, 4)];
        regC[hook(7, 7)][hook(21, 5)] += regA[hook(10, 7)] * regB[hook(11, 5)];
        regC[hook(7, 7)][hook(21, 6)] += regA[hook(10, 7)] * regB[hook(11, 6)];
        regC[hook(7, 7)][hook(21, 7)] += regA[hook(10, 7)] * regB[hook(11, 7)];

      } else {
        regC[hook(7, 0)][hook(12, 0)] += regA_bak[hook(13, 0)] * regB_bak[hook(16, 0)];
        regA[hook(10, 0)] = tileA[hook(8, (k + 1) * tile_dim_x + local_thread_id_x * 8 + 0)];
        regC[hook(7, 0)][hook(12, 1)] += regA_bak[hook(13, 0)] * regB_bak[hook(16, 1)];
        regC[hook(7, 0)][hook(12, 2)] += regA_bak[hook(13, 0)] * regB_bak[hook(16, 2)];
        regA[hook(10, 1)] = tileA[hook(8, (k + 1) * tile_dim_x + local_thread_id_x * 8 + 1)];
        regC[hook(7, 0)][hook(12, 3)] += regA_bak[hook(13, 0)] * regB_bak[hook(16, 3)];
        regC[hook(7, 0)][hook(12, 4)] += regA_bak[hook(13, 0)] * regB_bak[hook(16, 4)];
        regA[hook(10, 2)] = tileA[hook(8, (k + 1) * tile_dim_x + local_thread_id_x * 8 + 2)];
        regC[hook(7, 0)][hook(12, 5)] += regA_bak[hook(13, 0)] * regB_bak[hook(16, 5)];
        regC[hook(7, 0)][hook(12, 6)] += regA_bak[hook(13, 0)] * regB_bak[hook(16, 6)];
        regA[hook(10, 3)] = tileA[hook(8, (k + 1) * tile_dim_x + local_thread_id_x * 8 + 3)];
        regC[hook(7, 0)][hook(12, 7)] += regA_bak[hook(13, 0)] * regB_bak[hook(16, 7)];

        regC[hook(7, 1)][hook(14, 0)] += regA_bak[hook(13, 1)] * regB_bak[hook(16, 0)];
        regA[hook(10, 4)] = tileA[hook(8, (k + 1) * tile_dim_x + local_thread_id_x * 8 + 4)];
        regC[hook(7, 1)][hook(14, 1)] += regA_bak[hook(13, 1)] * regB_bak[hook(16, 1)];
        regC[hook(7, 1)][hook(14, 2)] += regA_bak[hook(13, 1)] * regB_bak[hook(16, 2)];
        regA[hook(10, 5)] = tileA[hook(8, (k + 1) * tile_dim_x + local_thread_id_x * 8 + 5)];
        regC[hook(7, 1)][hook(14, 3)] += regA_bak[hook(13, 1)] * regB_bak[hook(16, 3)];
        regC[hook(7, 1)][hook(14, 4)] += regA_bak[hook(13, 1)] * regB_bak[hook(16, 4)];
        regA[hook(10, 6)] = tileA[hook(8, (k + 1) * tile_dim_x + local_thread_id_x * 8 + 6)];
        regC[hook(7, 1)][hook(14, 5)] += regA_bak[hook(13, 1)] * regB_bak[hook(16, 5)];
        regC[hook(7, 1)][hook(14, 6)] += regA_bak[hook(13, 1)] * regB_bak[hook(16, 6)];
        regA[hook(10, 7)] = tileA[hook(8, (k + 1) * tile_dim_x + local_thread_id_x * 8 + 7)];
        regC[hook(7, 1)][hook(14, 7)] += regA_bak[hook(13, 1)] * regB_bak[hook(16, 7)];

        regC[hook(7, 2)][hook(15, 0)] += regA_bak[hook(13, 2)] * regB_bak[hook(16, 0)];
        regB[hook(11, 0)] = tileB[hook(9, (k + 1) * tile_dim_y + local_thread_id_y * 8 + 0)];
        regC[hook(7, 2)][hook(15, 1)] += regA_bak[hook(13, 2)] * regB_bak[hook(16, 1)];
        regC[hook(7, 2)][hook(15, 2)] += regA_bak[hook(13, 2)] * regB_bak[hook(16, 2)];
        regB[hook(11, 1)] = tileB[hook(9, (k + 1) * tile_dim_y + local_thread_id_y * 8 + 1)];
        regC[hook(7, 2)][hook(15, 3)] += regA_bak[hook(13, 2)] * regB_bak[hook(16, 3)];
        regC[hook(7, 2)][hook(15, 4)] += regA_bak[hook(13, 2)] * regB_bak[hook(16, 4)];
        regB[hook(11, 2)] = tileB[hook(9, (k + 1) * tile_dim_y + local_thread_id_y * 8 + 2)];
        regC[hook(7, 2)][hook(15, 5)] += regA_bak[hook(13, 2)] * regB_bak[hook(16, 5)];
        regC[hook(7, 2)][hook(15, 6)] += regA_bak[hook(13, 2)] * regB_bak[hook(16, 6)];
        regB[hook(11, 3)] = tileB[hook(9, (k + 1) * tile_dim_y + local_thread_id_y * 8 + 3)];
        regC[hook(7, 2)][hook(15, 7)] += regA_bak[hook(13, 2)] * regB_bak[hook(16, 7)];

        regC[hook(7, 3)][hook(17, 0)] += regA_bak[hook(13, 3)] * regB_bak[hook(16, 0)];
        regB[hook(11, 4)] = tileB[hook(9, (k + 1) * tile_dim_y + local_thread_id_y * 8 + 4)];
        regC[hook(7, 3)][hook(17, 1)] += regA_bak[hook(13, 3)] * regB_bak[hook(16, 1)];
        regC[hook(7, 3)][hook(17, 2)] += regA_bak[hook(13, 3)] * regB_bak[hook(16, 2)];
        regB[hook(11, 5)] = tileB[hook(9, (k + 1) * tile_dim_y + local_thread_id_y * 8 + 5)];
        regC[hook(7, 3)][hook(17, 3)] += regA_bak[hook(13, 3)] * regB_bak[hook(16, 3)];
        regC[hook(7, 3)][hook(17, 4)] += regA_bak[hook(13, 3)] * regB_bak[hook(16, 4)];
        regB[hook(11, 6)] = tileB[hook(9, (k + 1) * tile_dim_y + local_thread_id_y * 8 + 6)];
        regC[hook(7, 3)][hook(17, 5)] += regA_bak[hook(13, 3)] * regB_bak[hook(16, 5)];
        regC[hook(7, 3)][hook(17, 6)] += regA_bak[hook(13, 3)] * regB_bak[hook(16, 6)];
        regB[hook(11, 7)] = tileB[hook(9, (k + 1) * tile_dim_y + local_thread_id_y * 8 + 7)];
        regC[hook(7, 3)][hook(17, 7)] += regA_bak[hook(13, 3)] * regB_bak[hook(16, 7)];

        regC[hook(7, 4)][hook(18, 0)] += regA_bak[hook(13, 4)] * regB_bak[hook(16, 0)];
        regC[hook(7, 4)][hook(18, 1)] += regA_bak[hook(13, 4)] * regB_bak[hook(16, 1)];
        regC[hook(7, 4)][hook(18, 2)] += regA_bak[hook(13, 4)] * regB_bak[hook(16, 2)];
        regC[hook(7, 4)][hook(18, 3)] += regA_bak[hook(13, 4)] * regB_bak[hook(16, 3)];
        regC[hook(7, 4)][hook(18, 4)] += regA_bak[hook(13, 4)] * regB_bak[hook(16, 4)];
        regC[hook(7, 4)][hook(18, 5)] += regA_bak[hook(13, 4)] * regB_bak[hook(16, 5)];
        regC[hook(7, 4)][hook(18, 6)] += regA_bak[hook(13, 4)] * regB_bak[hook(16, 6)];
        regC[hook(7, 4)][hook(18, 7)] += regA_bak[hook(13, 4)] * regB_bak[hook(16, 7)];

        regC[hook(7, 5)][hook(19, 0)] += regA_bak[hook(13, 5)] * regB_bak[hook(16, 0)];
        regC[hook(7, 5)][hook(19, 1)] += regA_bak[hook(13, 5)] * regB_bak[hook(16, 1)];
        regC[hook(7, 5)][hook(19, 2)] += regA_bak[hook(13, 5)] * regB_bak[hook(16, 2)];
        regC[hook(7, 5)][hook(19, 3)] += regA_bak[hook(13, 5)] * regB_bak[hook(16, 3)];
        regC[hook(7, 5)][hook(19, 4)] += regA_bak[hook(13, 5)] * regB_bak[hook(16, 4)];
        regC[hook(7, 5)][hook(19, 5)] += regA_bak[hook(13, 5)] * regB_bak[hook(16, 5)];
        regC[hook(7, 5)][hook(19, 6)] += regA_bak[hook(13, 5)] * regB_bak[hook(16, 6)];
        regC[hook(7, 5)][hook(19, 7)] += regA_bak[hook(13, 5)] * regB_bak[hook(16, 7)];

        regC[hook(7, 6)][hook(20, 0)] += regA_bak[hook(13, 6)] * regB_bak[hook(16, 0)];
        regC[hook(7, 6)][hook(20, 1)] += regA_bak[hook(13, 6)] * regB_bak[hook(16, 1)];
        regC[hook(7, 6)][hook(20, 2)] += regA_bak[hook(13, 6)] * regB_bak[hook(16, 2)];
        regC[hook(7, 6)][hook(20, 3)] += regA_bak[hook(13, 6)] * regB_bak[hook(16, 3)];
        regC[hook(7, 6)][hook(20, 4)] += regA_bak[hook(13, 6)] * regB_bak[hook(16, 4)];
        regC[hook(7, 6)][hook(20, 5)] += regA_bak[hook(13, 6)] * regB_bak[hook(16, 5)];
        regC[hook(7, 6)][hook(20, 6)] += regA_bak[hook(13, 6)] * regB_bak[hook(16, 6)];
        regC[hook(7, 6)][hook(20, 7)] += regA_bak[hook(13, 6)] * regB_bak[hook(16, 7)];

        regC[hook(7, 7)][hook(21, 0)] += regA_bak[hook(13, 7)] * regB_bak[hook(16, 0)];
        regC[hook(7, 7)][hook(21, 1)] += regA_bak[hook(13, 7)] * regB_bak[hook(16, 1)];
        regC[hook(7, 7)][hook(21, 2)] += regA_bak[hook(13, 7)] * regB_bak[hook(16, 2)];
        regC[hook(7, 7)][hook(21, 3)] += regA_bak[hook(13, 7)] * regB_bak[hook(16, 3)];
        regC[hook(7, 7)][hook(21, 4)] += regA_bak[hook(13, 7)] * regB_bak[hook(16, 4)];
        regC[hook(7, 7)][hook(21, 5)] += regA_bak[hook(13, 7)] * regB_bak[hook(16, 5)];
        regC[hook(7, 7)][hook(21, 6)] += regA_bak[hook(13, 7)] * regB_bak[hook(16, 6)];
        regC[hook(7, 7)][hook(21, 7)] += regA_bak[hook(13, 7)] * regB_bak[hook(16, 7)];
      }
    }

    barrier(0x01);
  }

  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 0) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 0)] = regC[hook(7, 0)][hook(12, 0)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 0) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 1)] = regC[hook(7, 1)][hook(14, 0)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 0) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 2)] = regC[hook(7, 2)][hook(15, 0)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 0) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 3)] = regC[hook(7, 3)][hook(17, 0)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 0) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 4)] = regC[hook(7, 4)][hook(18, 0)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 0) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 5)] = regC[hook(7, 5)][hook(19, 0)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 0) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 6)] = regC[hook(7, 6)][hook(20, 0)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 0) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 7)] = regC[hook(7, 7)][hook(21, 0)];

  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 1) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 0)] = regC[hook(7, 0)][hook(12, 1)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 1) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 1)] = regC[hook(7, 1)][hook(14, 1)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 1) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 2)] = regC[hook(7, 2)][hook(15, 1)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 1) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 3)] = regC[hook(7, 3)][hook(17, 1)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 1) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 4)] = regC[hook(7, 4)][hook(18, 1)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 1) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 5)] = regC[hook(7, 5)][hook(19, 1)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 1) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 6)] = regC[hook(7, 6)][hook(20, 1)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 1) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 7)] = regC[hook(7, 7)][hook(21, 1)];

  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 2) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 0)] = regC[hook(7, 0)][hook(12, 2)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 2) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 1)] = regC[hook(7, 1)][hook(14, 2)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 2) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 2)] = regC[hook(7, 2)][hook(15, 2)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 2) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 3)] = regC[hook(7, 3)][hook(17, 2)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 2) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 4)] = regC[hook(7, 4)][hook(18, 2)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 2) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 5)] = regC[hook(7, 5)][hook(19, 2)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 2) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 6)] = regC[hook(7, 6)][hook(20, 2)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 2) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 7)] = regC[hook(7, 7)][hook(21, 2)];

  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 3) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 0)] = regC[hook(7, 0)][hook(12, 3)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 3) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 1)] = regC[hook(7, 1)][hook(14, 3)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 3) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 2)] = regC[hook(7, 2)][hook(15, 3)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 3) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 3)] = regC[hook(7, 3)][hook(17, 3)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 3) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 4)] = regC[hook(7, 4)][hook(18, 3)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 3) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 5)] = regC[hook(7, 5)][hook(19, 3)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 3) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 6)] = regC[hook(7, 6)][hook(20, 3)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 3) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 7)] = regC[hook(7, 7)][hook(21, 3)];

  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 4) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 0)] = regC[hook(7, 0)][hook(12, 4)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 4) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 1)] = regC[hook(7, 1)][hook(14, 4)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 4) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 2)] = regC[hook(7, 2)][hook(15, 4)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 4) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 3)] = regC[hook(7, 3)][hook(17, 4)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 4) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 4)] = regC[hook(7, 4)][hook(18, 4)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 4) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 5)] = regC[hook(7, 5)][hook(19, 4)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 4) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 6)] = regC[hook(7, 6)][hook(20, 4)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 4) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 7)] = regC[hook(7, 7)][hook(21, 4)];

  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 5) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 0)] = regC[hook(7, 0)][hook(12, 5)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 5) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 1)] = regC[hook(7, 1)][hook(14, 5)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 5) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 2)] = regC[hook(7, 2)][hook(15, 5)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 5) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 3)] = regC[hook(7, 3)][hook(17, 5)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 5) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 4)] = regC[hook(7, 4)][hook(18, 5)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 5) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 5)] = regC[hook(7, 5)][hook(19, 5)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 5) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 6)] = regC[hook(7, 6)][hook(20, 5)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 5) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 7)] = regC[hook(7, 7)][hook(21, 5)];

  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 6) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 0)] = regC[hook(7, 0)][hook(12, 6)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 6) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 1)] = regC[hook(7, 1)][hook(14, 6)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 6) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 2)] = regC[hook(7, 2)][hook(15, 6)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 6) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 3)] = regC[hook(7, 3)][hook(17, 6)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 6) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 4)] = regC[hook(7, 4)][hook(18, 6)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 6) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 5)] = regC[hook(7, 5)][hook(19, 6)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 6) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 6)] = regC[hook(7, 6)][hook(20, 6)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 6) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 7)] = regC[hook(7, 7)][hook(21, 6)];

  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 7) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 0)] = regC[hook(7, 0)][hook(12, 7)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 7) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 1)] = regC[hook(7, 1)][hook(14, 7)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 7) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 2)] = regC[hook(7, 2)][hook(15, 7)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 7) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 3)] = regC[hook(7, 3)][hook(17, 7)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 7) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 4)] = regC[hook(7, 4)][hook(18, 7)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 7) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 5)] = regC[hook(7, 5)][hook(19, 7)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 7) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 6)] = regC[hook(7, 6)][hook(20, 7)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 7) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 7)] = regC[hook(7, 7)][hook(21, 7)];
}
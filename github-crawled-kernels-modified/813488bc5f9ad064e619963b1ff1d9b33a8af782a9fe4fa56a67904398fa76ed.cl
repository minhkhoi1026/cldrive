//{"A":0,"B":1,"C":2,"K":5,"M":3,"N":4,"regA":9,"regB":10,"regC":6,"tileA":7,"tileB":8}
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

  local float tileA[64 * 8];
  local float tileB[64 * 8];

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

  for (int i = 0; i < K / NUM_UNROLL; ++i) {
    tileA[hook(7, local_thread_id_y * 64 + local_thread_id_x * 8 + 0)] = A[hook(0, (i * NUM_UNROLL + local_thread_id_y) * M + block_id_x * tile_dim_x + local_thread_id_x * 8 + 0)];
    tileA[hook(7, local_thread_id_y * 64 + local_thread_id_x * 8 + 1)] = A[hook(0, (i * NUM_UNROLL + local_thread_id_y) * M + block_id_x * tile_dim_x + local_thread_id_x * 8 + 1)];
    tileA[hook(7, local_thread_id_y * 64 + local_thread_id_x * 8 + 2)] = A[hook(0, (i * NUM_UNROLL + local_thread_id_y) * M + block_id_x * tile_dim_x + local_thread_id_x * 8 + 2)];
    tileA[hook(7, local_thread_id_y * 64 + local_thread_id_x * 8 + 3)] = A[hook(0, (i * NUM_UNROLL + local_thread_id_y) * M + block_id_x * tile_dim_x + local_thread_id_x * 8 + 3)];
    tileA[hook(7, local_thread_id_y * 64 + local_thread_id_x * 8 + 4)] = A[hook(0, (i * NUM_UNROLL + local_thread_id_y) * M + block_id_x * tile_dim_x + local_thread_id_x * 8 + 4)];
    tileA[hook(7, local_thread_id_y * 64 + local_thread_id_x * 8 + 5)] = A[hook(0, (i * NUM_UNROLL + local_thread_id_y) * M + block_id_x * tile_dim_x + local_thread_id_x * 8 + 5)];
    tileA[hook(7, local_thread_id_y * 64 + local_thread_id_x * 8 + 6)] = A[hook(0, (i * NUM_UNROLL + local_thread_id_y) * M + block_id_x * tile_dim_x + local_thread_id_x * 8 + 6)];
    tileA[hook(7, local_thread_id_y * 64 + local_thread_id_x * 8 + 7)] = A[hook(0, (i * NUM_UNROLL + local_thread_id_y) * M + block_id_x * tile_dim_x + local_thread_id_x * 8 + 7)];

    tileB[hook(8, local_thread_id_x * 64 + local_thread_id_y * 8 + 0)] = B[hook(1, (i * NUM_UNROLL + local_thread_id_x) * N + block_id_y * tile_dim_y + local_thread_id_y * 8 + 0)];
    tileB[hook(8, local_thread_id_x * 64 + local_thread_id_y * 8 + 1)] = B[hook(1, (i * NUM_UNROLL + local_thread_id_x) * N + block_id_y * tile_dim_y + local_thread_id_y * 8 + 1)];
    tileB[hook(8, local_thread_id_x * 64 + local_thread_id_y * 8 + 2)] = B[hook(1, (i * NUM_UNROLL + local_thread_id_x) * N + block_id_y * tile_dim_y + local_thread_id_y * 8 + 2)];
    tileB[hook(8, local_thread_id_x * 64 + local_thread_id_y * 8 + 3)] = B[hook(1, (i * NUM_UNROLL + local_thread_id_x) * N + block_id_y * tile_dim_y + local_thread_id_y * 8 + 3)];
    tileB[hook(8, local_thread_id_x * 64 + local_thread_id_y * 8 + 4)] = B[hook(1, (i * NUM_UNROLL + local_thread_id_x) * N + block_id_y * tile_dim_y + local_thread_id_y * 8 + 4)];
    tileB[hook(8, local_thread_id_x * 64 + local_thread_id_y * 8 + 5)] = B[hook(1, (i * NUM_UNROLL + local_thread_id_x) * N + block_id_y * tile_dim_y + local_thread_id_y * 8 + 5)];
    tileB[hook(8, local_thread_id_x * 64 + local_thread_id_y * 8 + 6)] = B[hook(1, (i * NUM_UNROLL + local_thread_id_x) * N + block_id_y * tile_dim_y + local_thread_id_y * 8 + 6)];
    tileB[hook(8, local_thread_id_x * 64 + local_thread_id_y * 8 + 7)] = B[hook(1, (i * NUM_UNROLL + local_thread_id_x) * N + block_id_y * tile_dim_y + local_thread_id_y * 8 + 7)];

    barrier(0x01);

    for (int k = 0; k < NUM_UNROLL; ++k) {
      regA[hook(9, 0)] = tileA[hook(7, k * tile_dim_x + local_thread_id_x * 8 + 0)];
      regA[hook(9, 1)] = tileA[hook(7, k * tile_dim_x + local_thread_id_x * 8 + 1)];
      regA[hook(9, 2)] = tileA[hook(7, k * tile_dim_x + local_thread_id_x * 8 + 2)];
      regA[hook(9, 3)] = tileA[hook(7, k * tile_dim_x + local_thread_id_x * 8 + 3)];
      regA[hook(9, 4)] = tileA[hook(7, k * tile_dim_x + local_thread_id_x * 8 + 4)];
      regA[hook(9, 5)] = tileA[hook(7, k * tile_dim_x + local_thread_id_x * 8 + 5)];
      regA[hook(9, 6)] = tileA[hook(7, k * tile_dim_x + local_thread_id_x * 8 + 6)];
      regA[hook(9, 7)] = tileA[hook(7, k * tile_dim_x + local_thread_id_x * 8 + 7)];

      regB[hook(10, 0)] = tileB[hook(8, k * tile_dim_y + local_thread_id_y * 8 + 0)];
      regB[hook(10, 1)] = tileB[hook(8, k * tile_dim_y + local_thread_id_y * 8 + 1)];
      regB[hook(10, 2)] = tileB[hook(8, k * tile_dim_y + local_thread_id_y * 8 + 2)];
      regB[hook(10, 3)] = tileB[hook(8, k * tile_dim_y + local_thread_id_y * 8 + 3)];
      regB[hook(10, 4)] = tileB[hook(8, k * tile_dim_y + local_thread_id_y * 8 + 4)];
      regB[hook(10, 5)] = tileB[hook(8, k * tile_dim_y + local_thread_id_y * 8 + 5)];
      regB[hook(10, 6)] = tileB[hook(8, k * tile_dim_y + local_thread_id_y * 8 + 6)];
      regB[hook(10, 7)] = tileB[hook(8, k * tile_dim_y + local_thread_id_y * 8 + 7)];

      regC[hook(6, 0 * 8 + 0)] += regA[hook(9, 0)] * regB[hook(10, 0)];
      regC[hook(6, 0 * 8 + 1)] += regA[hook(9, 1)] * regB[hook(10, 0)];
      regC[hook(6, 0 * 8 + 2)] += regA[hook(9, 2)] * regB[hook(10, 0)];
      regC[hook(6, 0 * 8 + 3)] += regA[hook(9, 3)] * regB[hook(10, 0)];
      regC[hook(6, 0 * 8 + 4)] += regA[hook(9, 4)] * regB[hook(10, 0)];
      regC[hook(6, 0 * 8 + 5)] += regA[hook(9, 5)] * regB[hook(10, 0)];
      regC[hook(6, 0 * 8 + 6)] += regA[hook(9, 6)] * regB[hook(10, 0)];
      regC[hook(6, 0 * 8 + 7)] += regA[hook(9, 7)] * regB[hook(10, 0)];

      regC[hook(6, 1 * 8 + 0)] += regA[hook(9, 0)] * regB[hook(10, 1)];
      regC[hook(6, 1 * 8 + 1)] += regA[hook(9, 1)] * regB[hook(10, 1)];
      regC[hook(6, 1 * 8 + 2)] += regA[hook(9, 2)] * regB[hook(10, 1)];
      regC[hook(6, 1 * 8 + 3)] += regA[hook(9, 3)] * regB[hook(10, 1)];
      regC[hook(6, 1 * 8 + 4)] += regA[hook(9, 4)] * regB[hook(10, 1)];
      regC[hook(6, 1 * 8 + 5)] += regA[hook(9, 5)] * regB[hook(10, 1)];
      regC[hook(6, 1 * 8 + 6)] += regA[hook(9, 6)] * regB[hook(10, 1)];
      regC[hook(6, 1 * 8 + 7)] += regA[hook(9, 7)] * regB[hook(10, 1)];

      regC[hook(6, 2 * 8 + 0)] += regA[hook(9, 0)] * regB[hook(10, 2)];
      regC[hook(6, 2 * 8 + 1)] += regA[hook(9, 1)] * regB[hook(10, 2)];
      regC[hook(6, 2 * 8 + 2)] += regA[hook(9, 2)] * regB[hook(10, 2)];
      regC[hook(6, 2 * 8 + 3)] += regA[hook(9, 3)] * regB[hook(10, 2)];
      regC[hook(6, 2 * 8 + 4)] += regA[hook(9, 4)] * regB[hook(10, 2)];
      regC[hook(6, 2 * 8 + 5)] += regA[hook(9, 5)] * regB[hook(10, 2)];
      regC[hook(6, 2 * 8 + 6)] += regA[hook(9, 6)] * regB[hook(10, 2)];
      regC[hook(6, 2 * 8 + 7)] += regA[hook(9, 7)] * regB[hook(10, 2)];

      regC[hook(6, 3 * 8 + 0)] += regA[hook(9, 0)] * regB[hook(10, 3)];
      regC[hook(6, 3 * 8 + 1)] += regA[hook(9, 1)] * regB[hook(10, 3)];
      regC[hook(6, 3 * 8 + 2)] += regA[hook(9, 2)] * regB[hook(10, 3)];
      regC[hook(6, 3 * 8 + 3)] += regA[hook(9, 3)] * regB[hook(10, 3)];
      regC[hook(6, 3 * 8 + 4)] += regA[hook(9, 4)] * regB[hook(10, 3)];
      regC[hook(6, 3 * 8 + 5)] += regA[hook(9, 5)] * regB[hook(10, 3)];
      regC[hook(6, 3 * 8 + 6)] += regA[hook(9, 6)] * regB[hook(10, 3)];
      regC[hook(6, 3 * 8 + 7)] += regA[hook(9, 7)] * regB[hook(10, 3)];

      regC[hook(6, 4 * 8 + 0)] += regA[hook(9, 0)] * regB[hook(10, 4)];
      regC[hook(6, 4 * 8 + 1)] += regA[hook(9, 1)] * regB[hook(10, 4)];
      regC[hook(6, 4 * 8 + 2)] += regA[hook(9, 2)] * regB[hook(10, 4)];
      regC[hook(6, 4 * 8 + 3)] += regA[hook(9, 3)] * regB[hook(10, 4)];
      regC[hook(6, 4 * 8 + 4)] += regA[hook(9, 4)] * regB[hook(10, 4)];
      regC[hook(6, 4 * 8 + 5)] += regA[hook(9, 5)] * regB[hook(10, 4)];
      regC[hook(6, 4 * 8 + 6)] += regA[hook(9, 6)] * regB[hook(10, 4)];
      regC[hook(6, 4 * 8 + 7)] += regA[hook(9, 7)] * regB[hook(10, 4)];

      regC[hook(6, 5 * 8 + 0)] += regA[hook(9, 0)] * regB[hook(10, 5)];
      regC[hook(6, 5 * 8 + 1)] += regA[hook(9, 1)] * regB[hook(10, 5)];
      regC[hook(6, 5 * 8 + 2)] += regA[hook(9, 2)] * regB[hook(10, 5)];
      regC[hook(6, 5 * 8 + 3)] += regA[hook(9, 3)] * regB[hook(10, 5)];
      regC[hook(6, 5 * 8 + 4)] += regA[hook(9, 4)] * regB[hook(10, 5)];
      regC[hook(6, 5 * 8 + 5)] += regA[hook(9, 5)] * regB[hook(10, 5)];
      regC[hook(6, 5 * 8 + 6)] += regA[hook(9, 6)] * regB[hook(10, 5)];
      regC[hook(6, 5 * 8 + 7)] += regA[hook(9, 7)] * regB[hook(10, 5)];

      regC[hook(6, 6 * 8 + 0)] += regA[hook(9, 0)] * regB[hook(10, 6)];
      regC[hook(6, 6 * 8 + 1)] += regA[hook(9, 1)] * regB[hook(10, 6)];
      regC[hook(6, 6 * 8 + 2)] += regA[hook(9, 2)] * regB[hook(10, 6)];
      regC[hook(6, 6 * 8 + 3)] += regA[hook(9, 3)] * regB[hook(10, 6)];
      regC[hook(6, 6 * 8 + 4)] += regA[hook(9, 4)] * regB[hook(10, 6)];
      regC[hook(6, 6 * 8 + 5)] += regA[hook(9, 5)] * regB[hook(10, 6)];
      regC[hook(6, 6 * 8 + 6)] += regA[hook(9, 6)] * regB[hook(10, 6)];
      regC[hook(6, 6 * 8 + 7)] += regA[hook(9, 7)] * regB[hook(10, 6)];

      regC[hook(6, 7 * 8 + 0)] += regA[hook(9, 0)] * regB[hook(10, 7)];
      regC[hook(6, 7 * 8 + 1)] += regA[hook(9, 1)] * regB[hook(10, 7)];
      regC[hook(6, 7 * 8 + 2)] += regA[hook(9, 2)] * regB[hook(10, 7)];
      regC[hook(6, 7 * 8 + 3)] += regA[hook(9, 3)] * regB[hook(10, 7)];
      regC[hook(6, 7 * 8 + 4)] += regA[hook(9, 4)] * regB[hook(10, 7)];
      regC[hook(6, 7 * 8 + 5)] += regA[hook(9, 5)] * regB[hook(10, 7)];
      regC[hook(6, 7 * 8 + 6)] += regA[hook(9, 6)] * regB[hook(10, 7)];
      regC[hook(6, 7 * 8 + 7)] += regA[hook(9, 7)] * regB[hook(10, 7)];
    }

    barrier(0x01);
  }

  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 0) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 0)] = regC[hook(6, 0 * 8 + 0)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 0) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 1)] = regC[hook(6, 0 * 8 + 1)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 0) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 2)] = regC[hook(6, 0 * 8 + 2)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 0) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 3)] = regC[hook(6, 0 * 8 + 3)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 0) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 4)] = regC[hook(6, 0 * 8 + 4)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 0) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 5)] = regC[hook(6, 0 * 8 + 5)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 0) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 6)] = regC[hook(6, 0 * 8 + 6)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 0) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 7)] = regC[hook(6, 0 * 8 + 7)];

  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 1) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 0)] = regC[hook(6, 1 * 8 + 0)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 1) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 1)] = regC[hook(6, 1 * 8 + 1)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 1) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 2)] = regC[hook(6, 1 * 8 + 2)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 1) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 3)] = regC[hook(6, 1 * 8 + 3)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 1) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 4)] = regC[hook(6, 1 * 8 + 4)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 1) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 5)] = regC[hook(6, 1 * 8 + 5)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 1) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 6)] = regC[hook(6, 1 * 8 + 6)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 1) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 7)] = regC[hook(6, 1 * 8 + 7)];

  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 2) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 0)] = regC[hook(6, 2 * 8 + 0)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 2) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 1)] = regC[hook(6, 2 * 8 + 1)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 2) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 2)] = regC[hook(6, 2 * 8 + 2)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 2) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 3)] = regC[hook(6, 2 * 8 + 3)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 2) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 4)] = regC[hook(6, 2 * 8 + 4)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 2) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 5)] = regC[hook(6, 2 * 8 + 5)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 2) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 6)] = regC[hook(6, 2 * 8 + 6)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 2) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 7)] = regC[hook(6, 2 * 8 + 7)];

  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 3) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 0)] = regC[hook(6, 3 * 8 + 0)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 3) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 1)] = regC[hook(6, 3 * 8 + 1)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 3) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 2)] = regC[hook(6, 3 * 8 + 2)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 3) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 3)] = regC[hook(6, 3 * 8 + 3)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 3) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 4)] = regC[hook(6, 3 * 8 + 4)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 3) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 5)] = regC[hook(6, 3 * 8 + 5)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 3) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 6)] = regC[hook(6, 3 * 8 + 6)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 3) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 7)] = regC[hook(6, 3 * 8 + 7)];

  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 4) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 0)] = regC[hook(6, 4 * 8 + 0)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 4) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 1)] = regC[hook(6, 4 * 8 + 1)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 4) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 2)] = regC[hook(6, 4 * 8 + 2)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 4) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 3)] = regC[hook(6, 4 * 8 + 3)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 4) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 4)] = regC[hook(6, 4 * 8 + 4)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 4) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 5)] = regC[hook(6, 4 * 8 + 5)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 4) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 6)] = regC[hook(6, 4 * 8 + 6)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 4) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 7)] = regC[hook(6, 4 * 8 + 7)];

  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 5) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 0)] = regC[hook(6, 5 * 8 + 0)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 5) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 1)] = regC[hook(6, 5 * 8 + 1)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 5) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 2)] = regC[hook(6, 5 * 8 + 2)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 5) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 3)] = regC[hook(6, 5 * 8 + 3)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 5) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 4)] = regC[hook(6, 5 * 8 + 4)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 5) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 5)] = regC[hook(6, 5 * 8 + 5)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 5) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 6)] = regC[hook(6, 5 * 8 + 6)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 5) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 7)] = regC[hook(6, 5 * 8 + 7)];

  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 6) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 0)] = regC[hook(6, 6 * 8 + 0)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 6) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 1)] = regC[hook(6, 6 * 8 + 1)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 6) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 2)] = regC[hook(6, 6 * 8 + 2)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 6) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 3)] = regC[hook(6, 6 * 8 + 3)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 6) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 4)] = regC[hook(6, 6 * 8 + 4)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 6) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 5)] = regC[hook(6, 6 * 8 + 5)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 6) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 6)] = regC[hook(6, 6 * 8 + 6)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 6) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 7)] = regC[hook(6, 6 * 8 + 7)];

  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 7) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 0)] = regC[hook(6, 7 * 8 + 0)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 7) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 1)] = regC[hook(6, 7 * 8 + 1)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 7) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 2)] = regC[hook(6, 7 * 8 + 2)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 7) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 3)] = regC[hook(6, 7 * 8 + 3)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 7) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 4)] = regC[hook(6, 7 * 8 + 4)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 7) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 5)] = regC[hook(6, 7 * 8 + 5)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 7) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 6)] = regC[hook(6, 7 * 8 + 6)];
  C[hook(2, (block_id_y * tile_dim_y + local_thread_id_y * thread_task_y + 7) * M + block_id_x * tile_dim_x + local_thread_id_x * thread_task_x + 7)] = regC[hook(6, 7 * 8 + 7)];
}
//{"I":12,"IMGVF":10,"IMGVF_array":0,"IMGVF_global":11,"I_array":1,"I_offsets":2,"buffer":13,"cutoff":9,"e":7,"m_array":3,"max_iterations":8,"n_array":4,"vx":5,"vy":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float heaviside(float x) {
  return (atan(x) * (1.0f / 3.14159f)) + 0.5f;
}

kernel void IMGVF_kernel(global float* IMGVF_array, global float* I_array, constant int* I_offsets, int constant* m_array, constant int* n_array, float vx, float vy, float e, int max_iterations, float cutoff) {
  local float IMGVF[41 * 81];

  local float buffer[256];

  int cell_num = get_global_id(0) / get_local_size(0);

  int I_offset = I_offsets[hook(2, cell_num)];
  global float* IMGVF_global = &(IMGVF_array[hook(0, I_offset)]);
  global float* I = &(I_array[hook(1, I_offset)]);

  int m = m_array[hook(3, cell_num)];
  int n = n_array[hook(4, cell_num)];

  int max = (m * n + 256 - 1) / 256;

  int thread_id = get_local_id(0);
  int thread_block, i, j;
  for (thread_block = 0; thread_block < max; thread_block++) {
    int offset = thread_block * 256;
    i = (thread_id + offset) / n;
    j = (thread_id + offset) % n;
    if (i < m)
      IMGVF[hook(10, (i * n) + j)] = IMGVF_global[hook(11, (i * n) + j)];
  }
  barrier(0x01);

  local int cell_converged;
  if (thread_id == 0)
    cell_converged = 0;
  barrier(0x01);

  const float one_nth = 1.0f / (float)n;
  const int tid_mod = thread_id % n;
  const int tbsize_mod = 256 % n;

  float one_over_e = 1.0f / e;

  int iterations = 0;
  while ((!cell_converged) && (iterations < max_iterations)) {
    float total_diff = 0.0f;

    int old_i = 0, old_j = 0;
    j = tid_mod - tbsize_mod;

    for (thread_block = 0; thread_block < max; thread_block++) {
      old_i = i;
      old_j = j;

      int offset = thread_block * 256;
      i = (thread_id + offset) * one_nth;
      j += tbsize_mod;
      if (j >= n)
        j -= n;

      float new_val = 0.0f, old_val = 0.0f;

      if (i < m) {
        int rowU = (i == 0) ? 0 : i - 1;
        int rowD = (i == m - 1) ? m - 1 : i + 1;
        int colL = (j == 0) ? 0 : j - 1;
        int colR = (j == n - 1) ? n - 1 : j + 1;

        old_val = IMGVF[hook(10, (i * n) + j)];
        float U = IMGVF[hook(10, (rowU * n) + j)] - old_val;
        float D = IMGVF[hook(10, (rowD * n) + j)] - old_val;
        float L = IMGVF[hook(10, (i * n) + colL)] - old_val;
        float R = IMGVF[hook(10, (i * n) + colR)] - old_val;
        float UR = IMGVF[hook(10, (rowU * n) + colR)] - old_val;
        float DR = IMGVF[hook(10, (rowD * n) + colR)] - old_val;
        float UL = IMGVF[hook(10, (rowU * n) + colL)] - old_val;
        float DL = IMGVF[hook(10, (rowD * n) + colL)] - old_val;

        float UHe = heaviside((U * -vy) * one_over_e);
        float DHe = heaviside((D * vy) * one_over_e);
        float LHe = heaviside((L * -vx) * one_over_e);
        float RHe = heaviside((R * vx) * one_over_e);
        float URHe = heaviside((UR * (vx - vy)) * one_over_e);
        float DRHe = heaviside((DR * (vx + vy)) * one_over_e);
        float ULHe = heaviside((UL * (-vx - vy)) * one_over_e);
        float DLHe = heaviside((DL * (-vx + vy)) * one_over_e);

        new_val = old_val + (0.5f / (8.0f * 0.5f + 1.0f)) * (UHe * U + DHe * D + LHe * L + RHe * R + URHe * UR + DRHe * DR + ULHe * UL + DLHe * DL);

        float vI = I[hook(12, (i * n) + j)];
        new_val -= ((1.0f / (8.0f * 0.5f + 1.0f)) * vI * (new_val - vI));
      }

      if (thread_block > 0) {
        offset = (thread_block - 1) * 256;
        if (old_i < m)
          IMGVF[hook(10, (old_i * n) + old_j)] = buffer[hook(13, thread_id)];
      }
      if (thread_block < max - 1) {
        buffer[hook(13, thread_id)] = new_val;
      } else {
        if (i < m)
          IMGVF[hook(10, (i * n) + j)] = new_val;
      }

      total_diff += fabs(new_val - old_val);

      barrier(0x01);
    }

    buffer[hook(13, thread_id)] = total_diff;
    barrier(0x01);

    if (thread_id >= 256) {
      buffer[hook(13, thread_id - 256)] += buffer[hook(13, thread_id)];
    }
    barrier(0x01);

    int th;
    for (th = 256 / 2; th > 0; th /= 2) {
      if (thread_id < th) {
        buffer[hook(13, thread_id)] += buffer[hook(13, thread_id + th)];
      }
      barrier(0x01);
    }

    if (thread_id == 0) {
      float mean = buffer[hook(13, thread_id)] / (float)(m * n);
      if (mean < cutoff) {
        cell_converged = 1;
      }
    }

    barrier(0x01);

    iterations++;
  }

  for (thread_block = 0; thread_block < max; thread_block++) {
    int offset = thread_block * 256;
    i = (thread_id + offset) / n;
    j = (thread_id + offset) % n;
    if (i < m)
      IMGVF_global[hook(11, (i * n) + j)] = IMGVF[hook(10, (i * n) + j)];
  }
}
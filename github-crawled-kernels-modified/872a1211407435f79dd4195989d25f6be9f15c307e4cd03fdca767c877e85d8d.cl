//{"MAX_D":3,"disp_block":4,"disp_im":2,"left_im":0,"right_im":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void BM_Disparity(global unsigned char* restrict left_im, global unsigned char* restrict right_im, global unsigned int* restrict disp_im, unsigned int MAX_D) {
  int2 globalSize = (int2)(get_global_size(0), get_global_size(1));
  int2 groupId = (int2)(get_group_id(0), get_group_id(1));
  int2 localId = (int2)(get_local_id(0), get_local_id(1));
  int2 localSize = (int2)(get_local_size(0), get_local_size(1));

  unsigned int idx = groupId.x * localSize.x + localId.x;
  unsigned int idy = groupId.y * localSize.y + localId.y;

  if ((idy >= 7 / 2) && (idy < (globalSize.y - 7 / 2))) {
    if ((idx >= 7 / 2) && (idx < (globalSize.x - 7 / 2))) {
      int idx_disp = 0;
      int disp_block[256];
      for (int idx_col = idx; (idx_col >= 7 / 2) && (idx_disp < MAX_D); idx_col--) {
        unsigned int match_cost = 0;
        for (int ky = idy - 7 / 2; ky <= (idy + 7 / 2); ky++) {
          for (int kx = idx_col - 7 / 2; kx <= (idx_col + 7 / 2); kx++)
            match_cost += abs(left_im[hook(0, ky * globalSize.x + kx + (idx - idx_col))] - right_im[hook(1, ky * globalSize.x + kx)]);
        }

        disp_block[hook(4, idx_disp++)] = match_cost;
      }

      int min = disp_block[hook(4, 0)];
      int disp = 0;
      for (int k = 0; k < idx_disp; k++) {
        if (disp_block[hook(4, k)] < min) {
          min = disp_block[hook(4, k)];
          disp = k;
        }
      }

      disp_im[hook(2, idy * globalSize.x + idx)] = disp;
    }
  }
}
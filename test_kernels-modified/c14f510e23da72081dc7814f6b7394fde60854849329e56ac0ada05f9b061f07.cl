//{"MAX_D":3,"disp_block":7,"disp_im":2,"left_im":0,"right_im":1,"right_patch":5,"right_patch[(kx + idx_col) % 1024]":6,"right_patch[(rx) % 1024]":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
__attribute((max_global_work_dim(0))) kernel void BM_Disparity_WorkGroup(global unsigned char* restrict left_im, global unsigned char* restrict right_im, global unsigned int* restrict disp_im, unsigned int MAX_D) {
  local unsigned char right_patch[1024][8];

  for (int glIdy = 3; glIdy < (480 - 3); glIdy++) {
    for (int rx = 0; rx < 640; rx++) {
      for (int ry = 0; ry < 7; ry++) {
        int offset_y = glIdy + ry - 3;
        right_patch[hook(5, (rx) % 1024)][hook(4, ry)] = right_im[hook(1, offset_y * 640 + rx)];
      }
    }

    for (int glIdx = 3; glIdx < (640 - 3); glIdx++) {
      int idx_disp = 0;
      int disp_block[128];
      for (int idx_col = glIdx; (idx_col >= 3) && (idx_disp < MAX_D); idx_col--) {
        int match_cost = 0;

        for (int ky = -3; ky <= 3; ky++) {
          for (int kx = -3; kx <= 3; kx++) {
            match_cost += abs(left_im[hook(0, (glIdy + ky) * 640 + (glIdx + kx))] - right_patch[hook(5, (kx + idx_col) % 1024)][hook(6, ky + 3)]);
          }
        }

        disp_block[hook(7, idx_disp++)] = match_cost;
      }

      int min = disp_block[hook(7, 0)];
      int disp = 0;

      for (int k = 0; k < idx_disp; k++) {
        if (disp_block[hook(7, k)] < min) {
          min = disp_block[hook(7, k)];
          disp = k;
        }
      }

      disp_im[hook(2, glIdy * 640 + glIdx)] = disp;
    }
  }
}
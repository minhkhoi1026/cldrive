//{"R":2,"disp_block":5,"left_im":0,"left_patch":3,"right_im":1,"right_patch":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
__attribute((reqd_work_group_size(32, 32, 1))) kernel void BM_Disparity_WorkGroup(global unsigned char* restrict left_im, global unsigned char* restrict right_im, global unsigned int* restrict R) {
  int glId = get_global_id(0);
  int glIdy = get_global_id(1);
  int glSizex = get_global_size(0);
  int glSizey = get_global_size(1);
  int grIdx = get_group_id(0);
  int grIdy = get_group_id(1);
  int lIdx = get_local_id(0);
  int lIdy = get_local_id(1);
  int lSizex = get_local_size(0);
  int lSizey = get_local_size(1);

  int idx = grIdx * lSizex + lIdx;
  int idy = grIdy * lSizey + lIdy;

  local unsigned char left_patch[3 * 3];
  local unsigned char right_patch[3 * 3];
  local unsigned int match_cost;
  local int disp_block[16];

  if ((idy > 1) && (idy < (glSizey - 1))) {
    if ((idx > 1) && (idx < (glSizex - 1))) {
      for (int ky = 0; ky < 3; ky++) {
        int offset_y = idy - 1 + ky;

        for (int kx = 0; kx < 3; kx++) {
          int offset_x = idx - 1 + kx;
          left_patch[hook(3, ky * 3 + kx)] = left_im[hook(0, offset_y * glSizex + offset_x)];
          barrier(0x01);
        }
      }

      unsigned int idx_disp = 0;

      for (int idx_col = idx; (idx_col > 1) && (idx_disp < 16); idx_col--) {
        int shift = idx - idx_col;

        unsigned int idk_blocks = 0;

        for (int ky = 0; ky < 3; ky++) {
          int offset_y = idy - 1 + ky;

          for (int kx = 0; kx < 3; kx++) {
            int offset_x = idx - 1 + kx;
            right_patch[hook(4, ky * 3 + kx)] = right_im[hook(1, offset_y * glSizex + offset_x)];
            barrier(0x01);
          }
        }

        match_cost = 0;
        barrier(0x01);
        for (int k = 0; k < 3 * 3; k++) {
          match_cost += abs(left_patch[hook(3, k)] - right_patch[hook(4, k)]);
          barrier(0x01);
        }
        disp_block[hook(5, idx_disp++)] = match_cost;
        barrier(0x01);
      }

      int min = disp_block[hook(5, 0)];
      int disp = 0;

      for (int k = 0; k < idx_disp; k++) {
        if (disp_block[hook(5, k)] < min) {
          min = disp_block[hook(5, k)];
          disp = k;
        }
      }

      R[hook(2, idy * glSizex + idx)] = disp;
    }
  }
}
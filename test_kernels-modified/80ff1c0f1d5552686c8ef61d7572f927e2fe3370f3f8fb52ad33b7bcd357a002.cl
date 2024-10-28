//{"<recovery-expr>().in2_rows * (jb - 1) + ib - 1":62,"<recovery-expr>().in_rows * (ja - 1) + ia - 1":61,"<recovery-expr>().tMask_rows * (ja - 1) + ia - 1":85,"bx * <recovery-expr>().conv_elem":36,"bx * <recovery-expr>().in2_elem":35,"bx * <recovery-expr>().in2_pad_cumv_elem":37,"bx * <recovery-expr>().in2_pad_cumv_sel_elem":38,"bx * <recovery-expr>().in2_sqr_elem":42,"bx * <recovery-expr>().in2_sqr_sub2_elem":43,"bx * <recovery-expr>().in2_sub2_elem":41,"bx * <recovery-expr>().in2_sub_cumh_elem":39,"bx * <recovery-expr>().in2_sub_cumh_sel_elem":40,"bx * <recovery-expr>().in_cols":48,"bx * <recovery-expr>().in_elem":47,"bx * <recovery-expr>().in_sqr_elem":44,"bx * <recovery-expr>().in_sqr_rows":49,"bx * <recovery-expr>().mask_conv_elem":46,"bx * <recovery-expr>().mask_conv_rows":50,"bx * <recovery-expr>().tMask_elem":45,"checksum":33,"col * <recovery-expr>().in_rows + row":55,"d_common":0,"d_common_change_d_frame":56,"d_conv_all":14,"d_endoCol":4,"d_endoRow":3,"d_endoT":11,"d_epiCol":8,"d_epiRow":7,"d_epiT":12,"d_frame":1,"d_frame_no":2,"d_in":75,"d_in2_all":13,"d_in2_pad_cumv_all":15,"d_in2_pad_cumv_sel_all":16,"d_in2_sqr_all":20,"d_in2_sqr_sub2_all":21,"d_in2_sub2_all":19,"d_in2_sub_cumh_all":17,"d_in2_sub_cumh_sel_all":18,"d_in_mod_temp":59,"d_in_mod_temp_all":25,"d_in_sqr_all":22,"d_mask_conv_all":24,"d_tEndoColLoc":6,"d_tEndoRowLoc":5,"d_tEpiColLoc":10,"d_tEpiRowLoc":9,"d_tMask_all":23,"d_unique_d_Col":54,"d_unique_d_Row":52,"d_unique_d_conv":63,"d_unique_d_in2":57,"d_unique_d_in2_pad_cumv":64,"d_unique_d_in2_pad_cumv_sel":66,"d_unique_d_in2_sqr":72,"d_unique_d_in2_sqr_sub2":74,"d_unique_d_in2_sub2":71,"d_unique_d_in2_sub_cumh":68,"d_unique_d_in2_sub_cumh_sel":69,"d_unique_d_in_sqr":76,"d_unique_d_mask_conv":86,"d_unique_d_tColLoc":53,"d_unique_d_tMask":84,"d_unique_d_tRowLoc":51,"d_unique_point_no * <recovery-expr>().in_elem":34,"denomT":83,"denomT_all":32,"ei_new * <recovery-expr>().in_rows + i":77,"ei_new + <recovery-expr>().in_sqr_rows * i":79,"in_final_sum":81,"in_final_sum_all":30,"in_partial_sum":78,"in_partial_sum_all":26,"in_sqr_final_sum":82,"in_sqr_final_sum_all":31,"in_sqr_partial_sum":80,"in_sqr_partial_sum_all":27,"ori_col * <recovery-expr>().frame_rows + ori_row":58,"ori_col * <recovery-expr>().in2_pad_cumv_rows + ori_row":67,"ori_col * <recovery-expr>().in2_rows + ori_row":65,"ori_col * <recovery-expr>().in2_sqr_rows + ori_row":73,"ori_col * <recovery-expr>().in2_sub_cumh_rows + ori_row":70,"par_max_coo":87,"par_max_coo_all":29,"par_max_val":88,"par_max_val_all":28,"rot_col * <recovery-expr>().in_rows + rot_row":60}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_gpu_opencl(params_common d_common, global float* d_frame, int d_frame_no, global int* d_endoRow, global int* d_endoCol, global int* d_tEndoRowLoc, global int* d_tEndoColLoc, global int* d_epiRow, global int* d_epiCol, global int* d_tEpiRowLoc, global int* d_tEpiColLoc, global float* d_endoT, global float* d_epiT, global float* d_in2_all, global float* d_conv_all, global float* d_in2_pad_cumv_all, global float* d_in2_pad_cumv_sel_all, global float* d_in2_sub_cumh_all, global float* d_in2_sub_cumh_sel_all, global float* d_in2_sub2_all, global float* d_in2_sqr_all, global float* d_in2_sqr_sub2_all, global float* d_in_sqr_all, global float* d_tMask_all, global float* d_mask_conv_all, global float* d_in_mod_temp_all, global float* in_partial_sum_all, global float* in_sqr_partial_sum_all, global float* par_max_val_all, global int* par_max_coo_all, global float* in_final_sum_all, global float* in_sqr_final_sum_all, global float* denomT_all, global float* checksum) {
  int rot_row;
  int rot_col;
  int in2_rowlow;
  int in2_collow;
  int ic;
  int jc;
  int jp1;
  int ja1, ja2;
  int ip1;
  int ia1, ia2;
  int ja, jb;
  int ia, ib;
  float s;
  int i;
  int j;
  int row;
  int col;
  int ori_row;
  int ori_col;
  int position;
  float sum;
  int pos_ori;
  float temp;
  float temp2;
  int location;
  int cent;
  int tMask_row;
  int tMask_col;
  float largest_value_current = 0;
  float largest_value = 0;
  int largest_coordinate_current = 0;
  int largest_coordinate = 0;
  float fin_max_val = 0;
  int fin_max_coo = 0;
  int largest_row;
  int largest_col;
  int offset_row;
  int offset_col;
  float mean;
  float mean_sqr;
  float variance;
  float deviation;
  int pointer;
  int ori_pointer;
  int loc_pointer;
  int bx = get_group_id(0);
  int tx = get_local_id(0);
  int ei_new;

  global float* d_common_change_d_frame = &d_frame[hook(1, 0)];

  int d_unique_point_no;
  global int* d_unique_d_Row;
  global int* d_unique_d_Col;
  global int* d_unique_d_tRowLoc;
  global int* d_unique_d_tColLoc;
  global float* d_in;
  if (bx < d_common.endoPoints) {
    d_unique_point_no = bx;
    d_unique_d_Row = d_endoRow;
    d_unique_d_Col = d_endoCol;
    d_unique_d_tRowLoc = d_tEndoRowLoc;
    d_unique_d_tColLoc = d_tEndoColLoc;
    d_in = &hook(34, d_endoT)];
  } else {
    d_unique_point_no = bx - d_common.endoPoints;
    d_unique_d_Row = d_epiRow;
    d_unique_d_Col = d_epiCol;
    d_unique_d_tRowLoc = d_tEpiRowLoc;
    d_unique_d_tColLoc = d_tEpiColLoc;
    d_in = &hook(34, d_epiT)];
  }

  global float* d_unique_d_in2 = &hook(35, d_in2_all)];
  global float* d_unique_d_conv = &hook(36, d_conv_all)];
  global float* d_unique_d_in2_pad_cumv = &hook(37, d_in2_pad_cumv_all)];
  global float* d_unique_d_in2_pad_cumv_sel = &hook(38, d_in2_pad_cumv_sel_all)];
  global float* d_unique_d_in2_sub_cumh = &hook(39, d_in2_sub_cumh_all)];
  global float* d_unique_d_in2_sub_cumh_sel = &hook(40, d_in2_sub_cumh_sel_all)];
  global float* d_unique_d_in2_sub2 = &hook(41, d_in2_sub2_all)];
  global float* d_unique_d_in2_sqr = &hook(42, d_in2_sqr_all)];
  global float* d_unique_d_in2_sqr_sub2 = &hook(43, d_in2_sqr_sub2_all)];
  global float* d_unique_d_in_sqr = &hook(44, d_in_sqr_all)];
  global float* d_unique_d_tMask = &hook(45, d_tMask_all)];
  global float* d_unique_d_mask_conv = &hook(46, d_mask_conv_all)];

  global float* d_in_mod_temp = &hook(47, d_in_mod_temp_all)];
  global float* in_partial_sum = &hook(48, in_partial_sum_all)];
  global float* in_sqr_partial_sum = &hook(49, in_sqr_partial_sum_all)];
  global float* par_max_val = &hook(50, par_max_val_all)];
  global int* par_max_coo = &hook(50, par_max_coo_all)];

  global float* in_final_sum = &in_final_sum_all[hook(30, bx)];
  global float* in_sqr_final_sum = &in_sqr_final_sum_all[hook(31, bx)];
  global float* denomT = &denomT_all[hook(32, bx)];
  if (d_frame_no == 0) {
    barrier(0x01 | 0x02);

    ei_new = tx;
    if (ei_new == 0) {
      pointer = d_unique_point_no * d_common.no_frames + d_frame_no;
      d_unique_d_tRowLoc[hook(51, pointer)] = d_unique_d_Row[hook(52, d_unique_point_no)];
      d_unique_d_tColLoc[hook(53, pointer)] = d_unique_d_Col[hook(54, d_unique_point_no)];
    }

    ei_new = tx;
    while (ei_new < d_common.in_elem) {
      row = (ei_new + 1) % d_common.in_rows - 1;
      col = (ei_new + 1) / d_common.in_rows + 1 - 1;
      if ((ei_new + 1) % d_common.in_rows == 0) {
        row = d_common.in_rows - 1;
        col = col - 1;
      }

      ori_row = d_unique_d_Row[hook(52, d_unique_point_no)] - 25 + row - 1;
      ori_col = d_unique_d_Col[hook(54, d_unique_point_no)] - 25 + col - 1;
      ori_pointer = ori_col * d_common.frame_rows + ori_row;

      hook(55, d_in)] = d_common_change_d_frame[hook(56, ori_pointer)];

      ei_new = ei_new + 32;
    }

    barrier(0x01 | 0x02);
  }

  if (d_frame_no != 0) {
    barrier(0x01 | 0x02);

    in2_rowlow = d_unique_d_Row[hook(52, d_unique_point_no)] - d_common.sSize;
    in2_collow = d_unique_d_Col[hook(54, d_unique_point_no)] - d_common.sSize;

    ei_new = tx;
    while (ei_new < d_common.in2_elem) {
      row = (ei_new + 1) % d_common.in2_rows - 1;
      col = (ei_new + 1) / d_common.in2_rows + 1 - 1;
      if ((ei_new + 1) % d_common.in2_rows == 0) {
        row = d_common.in2_rows - 1;
        col = col - 1;
      }

      ori_row = row + in2_rowlow - 1;
      ori_col = col + in2_collow - 1;
      d_unique_d_in2[hook(57, ei_new)] = hook(58, d_common_change_d_frame)];

      ei_new = ei_new + 32;
    }

    barrier(0x01 | 0x02);
    ei_new = tx;
    while (ei_new < d_common.in_elem) {
      row = (ei_new + 1) % d_common.in_rows - 1;
      col = (ei_new + 1) / d_common.in_rows + 1 - 1;
      if ((ei_new + 1) % d_common.in_rows == 0) {
        row = d_common.in_rows - 1;
        col = col - 1;
      }

      rot_row = (d_common.in_rows - 1) - row;
      rot_col = (d_common.in_rows - 1) - col;
      d_in_mod_temp[hook(59, ei_new)] = hook(60, d_in)];
      ei_new = ei_new + 32;
    }

    barrier(0x01 | 0x02);
    ei_new = tx;
    while (ei_new < d_common.conv_elem) {
      ic = (ei_new + 1) % d_common.conv_rows;
      jc = (ei_new + 1) / d_common.conv_rows + 1;
      if ((ei_new + 1) % d_common.conv_rows == 0) {
        ic = d_common.conv_rows;
        jc = jc - 1;
      }

      j = jc + d_common.joffset;
      jp1 = j + 1;
      if (d_common.in2_cols < jp1) {
        ja1 = jp1 - d_common.in2_cols;
      } else {
        ja1 = 1;
      }
      if (d_common.in_cols < j) {
        ja2 = d_common.in_cols;
      } else {
        ja2 = j;
      }

      i = ic + d_common.ioffset;
      ip1 = i + 1;

      if (d_common.in2_rows < ip1) {
        ia1 = ip1 - d_common.in2_rows;
      } else {
        ia1 = 1;
      }
      if (d_common.in_rows < i) {
        ia2 = d_common.in_rows;
      } else {
        ia2 = i;
      }

      s = 0;

      for (ja = ja1; ja <= ja2; ja++) {
        jb = jp1 - ja;
        for (ia = ia1; ia <= ia2; ia++) {
          ib = ip1 - ia;
          s = s + hook(61, d_in_mod_temp)] * hook(62, d_unique_d_in2)];
        }
      }

      d_unique_d_conv[hook(63, ei_new)] = s;

      ei_new = ei_new + 32;
    }

    barrier(0x01 | 0x02);
    ei_new = tx;
    while (ei_new < d_common.in2_pad_cumv_elem) {
      row = (ei_new + 1) % d_common.in2_pad_cumv_rows - 1;
      col = (ei_new + 1) / d_common.in2_pad_cumv_rows + 1 - 1;
      if ((ei_new + 1) % d_common.in2_pad_cumv_rows == 0) {
        row = d_common.in2_pad_cumv_rows - 1;
        col = col - 1;
      }

      if (row > (d_common.in2_pad_add_rows - 1) && row < (d_common.in2_pad_add_rows + d_common.in2_rows) && col > (d_common.in2_pad_add_cols - 1) && col < (d_common.in2_pad_add_cols + d_common.in2_cols)) {
        ori_row = row - d_common.in2_pad_add_rows;
        ori_col = col - d_common.in2_pad_add_cols;
        d_unique_d_in2_pad_cumv[hook(64, ei_new)] = hook(65, d_unique_d_in2)];
      } else {
        d_unique_d_in2_pad_cumv[hook(64, ei_new)] = 0;
      }

      ei_new = ei_new + 32;
    }

    barrier(0x01 | 0x02);
    ei_new = tx;
    while (ei_new < d_common.in2_pad_cumv_cols) {
      pos_ori = ei_new * d_common.in2_pad_cumv_rows;

      sum = 0;

      for (position = pos_ori; position < pos_ori + d_common.in2_pad_cumv_rows; position = position + 1) {
        d_unique_d_in2_pad_cumv[hook(64, position)] = d_unique_d_in2_pad_cumv[hook(64, position)] + sum;
        sum = d_unique_d_in2_pad_cumv[hook(64, position)];
      }

      ei_new = ei_new + 32;
    }

    barrier(0x01 | 0x02);
    ei_new = tx;
    while (ei_new < d_common.in2_pad_cumv_sel_elem) {
      row = (ei_new + 1) % d_common.in2_pad_cumv_sel_rows - 1;
      col = (ei_new + 1) / d_common.in2_pad_cumv_sel_rows + 1 - 1;
      if ((ei_new + 1) % d_common.in2_pad_cumv_sel_rows == 0) {
        row = d_common.in2_pad_cumv_sel_rows - 1;
        col = col - 1;
      }

      ori_row = row + d_common.in2_pad_cumv_sel_rowlow - 1;
      ori_col = col + d_common.in2_pad_cumv_sel_collow - 1;
      d_unique_d_in2_pad_cumv_sel[hook(66, ei_new)] = hook(67, d_unique_d_in2_pad_cumv)];

      ei_new = ei_new + 32;
    }

    barrier(0x01 | 0x02);
    ei_new = tx;
    while (ei_new < d_common.in2_sub_cumh_elem) {
      row = (ei_new + 1) % d_common.in2_sub_cumh_rows - 1;
      col = (ei_new + 1) / d_common.in2_sub_cumh_rows + 1 - 1;
      if ((ei_new + 1) % d_common.in2_sub_cumh_rows == 0) {
        row = d_common.in2_sub_cumh_rows - 1;
        col = col - 1;
      }

      ori_row = row + d_common.in2_pad_cumv_sel2_rowlow - 1;
      ori_col = col + d_common.in2_pad_cumv_sel2_collow - 1;
      d_unique_d_in2_sub_cumh[hook(68, ei_new)] = hook(67, d_unique_d_in2_pad_cumv)];

      ei_new = ei_new + 32;
    }

    barrier(0x01 | 0x02);
    barrier(0x01 | 0x02);

    ei_new = tx;
    while (ei_new < d_common.in2_sub_cumh_elem) {
      d_unique_d_in2_sub_cumh[hook(68, ei_new)] = d_unique_d_in2_pad_cumv_sel[hook(66, ei_new)] - d_unique_d_in2_sub_cumh[hook(68, ei_new)];

      ei_new = ei_new + 32;
    }

    barrier(0x01 | 0x02);
    ei_new = tx;
    while (ei_new < d_common.in2_sub_cumh_rows) {
      pos_ori = ei_new;

      sum = 0;

      for (position = pos_ori; position < pos_ori + d_common.in2_sub_cumh_elem; position = position + d_common.in2_sub_cumh_rows) {
        d_unique_d_in2_sub_cumh[hook(68, position)] = d_unique_d_in2_sub_cumh[hook(68, position)] + sum;
        sum = d_unique_d_in2_sub_cumh[hook(68, position)];
      }

      ei_new = ei_new + 32;
    }

    barrier(0x01 | 0x02);
    ei_new = tx;
    while (ei_new < d_common.in2_sub_cumh_sel_elem) {
      row = (ei_new + 1) % d_common.in2_sub_cumh_sel_rows - 1;
      col = (ei_new + 1) / d_common.in2_sub_cumh_sel_rows + 1 - 1;
      if ((ei_new + 1) % d_common.in2_sub_cumh_sel_rows == 0) {
        row = d_common.in2_sub_cumh_sel_rows - 1;
        col = col - 1;
      }

      ori_row = row + d_common.in2_sub_cumh_sel_rowlow - 1;
      ori_col = col + d_common.in2_sub_cumh_sel_collow - 1;
      d_unique_d_in2_sub_cumh_sel[hook(69, ei_new)] = hook(70, d_unique_d_in2_sub_cumh)];

      ei_new = ei_new + 32;
    }

    barrier(0x01 | 0x02);
    ei_new = tx;
    while (ei_new < d_common.in2_sub2_elem) {
      row = (ei_new + 1) % d_common.in2_sub2_rows - 1;
      col = (ei_new + 1) / d_common.in2_sub2_rows + 1 - 1;
      if ((ei_new + 1) % d_common.in2_sub2_rows == 0) {
        row = d_common.in2_sub2_rows - 1;
        col = col - 1;
      }

      ori_row = row + d_common.in2_sub_cumh_sel2_rowlow - 1;
      ori_col = col + d_common.in2_sub_cumh_sel2_collow - 1;
      d_unique_d_in2_sub2[hook(71, ei_new)] = hook(70, d_unique_d_in2_sub_cumh)];

      ei_new = ei_new + 32;
    }

    barrier(0x01 | 0x02);
    ei_new = tx;
    while (ei_new < d_common.in2_sub2_elem) {
      d_unique_d_in2_sub2[hook(71, ei_new)] = d_unique_d_in2_sub_cumh_sel[hook(69, ei_new)] - d_unique_d_in2_sub2[hook(71, ei_new)];

      ei_new = ei_new + 32;
    }

    barrier(0x01 | 0x02);
    ei_new = tx;
    while (ei_new < d_common.in2_sqr_elem) {
      temp = d_unique_d_in2[hook(57, ei_new)];
      d_unique_d_in2_sqr[hook(72, ei_new)] = temp * temp;

      ei_new = ei_new + 32;
    }

    barrier(0x01 | 0x02);
    ei_new = tx;
    while (ei_new < d_common.in2_pad_cumv_elem) {
      row = (ei_new + 1) % d_common.in2_pad_cumv_rows - 1;
      col = (ei_new + 1) / d_common.in2_pad_cumv_rows + 1 - 1;
      if ((ei_new + 1) % d_common.in2_pad_cumv_rows == 0) {
        row = d_common.in2_pad_cumv_rows - 1;
        col = col - 1;
      }

      if (row > (d_common.in2_pad_add_rows - 1) && row < (d_common.in2_pad_add_rows + d_common.in2_sqr_rows) && col > (d_common.in2_pad_add_cols - 1) && col < (d_common.in2_pad_add_cols + d_common.in2_sqr_cols)) {
        ori_row = row - d_common.in2_pad_add_rows;
        ori_col = col - d_common.in2_pad_add_cols;
        d_unique_d_in2_pad_cumv[hook(64, ei_new)] = hook(73, d_unique_d_in2_sqr)];
      } else {
        d_unique_d_in2_pad_cumv[hook(64, ei_new)] = 0;
      }

      ei_new = ei_new + 32;
    }

    barrier(0x01 | 0x02);
    ei_new = tx;
    while (ei_new < d_common.in2_pad_cumv_cols) {
      pos_ori = ei_new * d_common.in2_pad_cumv_rows;

      sum = 0;

      for (position = pos_ori; position < pos_ori + d_common.in2_pad_cumv_rows; position = position + 1) {
        d_unique_d_in2_pad_cumv[hook(64, position)] = d_unique_d_in2_pad_cumv[hook(64, position)] + sum;
        sum = d_unique_d_in2_pad_cumv[hook(64, position)];
      }

      ei_new = ei_new + 32;
    }

    barrier(0x01 | 0x02);
    ei_new = tx;
    while (ei_new < d_common.in2_pad_cumv_sel_elem) {
      row = (ei_new + 1) % d_common.in2_pad_cumv_sel_rows - 1;
      col = (ei_new + 1) / d_common.in2_pad_cumv_sel_rows + 1 - 1;
      if ((ei_new + 1) % d_common.in2_pad_cumv_sel_rows == 0) {
        row = d_common.in2_pad_cumv_sel_rows - 1;
        col = col - 1;
      }

      ori_row = row + d_common.in2_pad_cumv_sel_rowlow - 1;
      ori_col = col + d_common.in2_pad_cumv_sel_collow - 1;
      d_unique_d_in2_pad_cumv_sel[hook(66, ei_new)] = hook(67, d_unique_d_in2_pad_cumv)];

      ei_new = ei_new + 32;
    }

    barrier(0x01 | 0x02);
    ei_new = tx;
    while (ei_new < d_common.in2_sub_cumh_elem) {
      row = (ei_new + 1) % d_common.in2_sub_cumh_rows - 1;
      col = (ei_new + 1) / d_common.in2_sub_cumh_rows + 1 - 1;
      if ((ei_new + 1) % d_common.in2_sub_cumh_rows == 0) {
        row = d_common.in2_sub_cumh_rows - 1;
        col = col - 1;
      }

      ori_row = row + d_common.in2_pad_cumv_sel2_rowlow - 1;
      ori_col = col + d_common.in2_pad_cumv_sel2_collow - 1;
      d_unique_d_in2_sub_cumh[hook(68, ei_new)] = hook(67, d_unique_d_in2_pad_cumv)];

      ei_new = ei_new + 32;
    }

    barrier(0x01 | 0x02);
    ei_new = tx;
    while (ei_new < d_common.in2_sub_cumh_elem) {
      d_unique_d_in2_sub_cumh[hook(68, ei_new)] = d_unique_d_in2_pad_cumv_sel[hook(66, ei_new)] - d_unique_d_in2_sub_cumh[hook(68, ei_new)];

      ei_new = ei_new + 32;
    }

    barrier(0x01 | 0x02);
    ei_new = tx;
    while (ei_new < d_common.in2_sub_cumh_rows) {
      pos_ori = ei_new;

      sum = 0;

      for (position = pos_ori; position < pos_ori + d_common.in2_sub_cumh_elem; position = position + d_common.in2_sub_cumh_rows) {
        d_unique_d_in2_sub_cumh[hook(68, position)] = d_unique_d_in2_sub_cumh[hook(68, position)] + sum;
        sum = d_unique_d_in2_sub_cumh[hook(68, position)];
      }

      ei_new = ei_new + 32;
    }

    barrier(0x01 | 0x02);
    ei_new = tx;
    while (ei_new < d_common.in2_sub_cumh_sel_elem) {
      row = (ei_new + 1) % d_common.in2_sub_cumh_sel_rows - 1;
      col = (ei_new + 1) / d_common.in2_sub_cumh_sel_rows + 1 - 1;
      if ((ei_new + 1) % d_common.in2_sub_cumh_sel_rows == 0) {
        row = d_common.in2_sub_cumh_sel_rows - 1;
        col = col - 1;
      }

      ori_row = row + d_common.in2_sub_cumh_sel_rowlow - 1;
      ori_col = col + d_common.in2_sub_cumh_sel_collow - 1;
      d_unique_d_in2_sub_cumh_sel[hook(69, ei_new)] = hook(70, d_unique_d_in2_sub_cumh)];

      ei_new = ei_new + 32;
    }

    barrier(0x01 | 0x02);
    ei_new = tx;
    while (ei_new < d_common.in2_sub2_elem) {
      row = (ei_new + 1) % d_common.in2_sub2_rows - 1;
      col = (ei_new + 1) / d_common.in2_sub2_rows + 1 - 1;
      if ((ei_new + 1) % d_common.in2_sub2_rows == 0) {
        row = d_common.in2_sub2_rows - 1;
        col = col - 1;
      }

      ori_row = row + d_common.in2_sub_cumh_sel2_rowlow - 1;
      ori_col = col + d_common.in2_sub_cumh_sel2_collow - 1;
      d_unique_d_in2_sqr_sub2[hook(74, ei_new)] = hook(70, d_unique_d_in2_sub_cumh)];

      ei_new = ei_new + 32;
    }

    barrier(0x01 | 0x02);
    ei_new = tx;
    while (ei_new < d_common.in2_sub2_elem) {
      d_unique_d_in2_sqr_sub2[hook(74, ei_new)] = d_unique_d_in2_sub_cumh_sel[hook(69, ei_new)] - d_unique_d_in2_sqr_sub2[hook(74, ei_new)];

      ei_new = ei_new + 32;
    }

    barrier(0x01 | 0x02);
    ei_new = tx;
    while (ei_new < d_common.in2_sub2_elem) {
      temp = d_unique_d_in2_sub2[hook(71, ei_new)];
      temp2 = d_unique_d_in2_sqr_sub2[hook(74, ei_new)] - (temp * temp / d_common.in_elem);
      if (temp2 < 0) {
        temp2 = 0;
      }
      d_unique_d_in2_sqr_sub2[hook(74, ei_new)] = sqrt(temp2);

      ei_new = ei_new + 32;
    }

    barrier(0x01 | 0x02);
    ei_new = tx;
    while (ei_new < d_common.in_sqr_elem) {
      temp = d_in[hook(75, ei_new)];
      d_unique_d_in_sqr[hook(76, ei_new)] = temp * temp;

      ei_new = ei_new + 32;
    }

    barrier(0x01 | 0x02);
    ei_new = tx;
    while (ei_new < d_common.in_cols) {
      sum = 0;
      for (i = 0; i < d_common.in_rows; i++) {
        sum = sum + hook(77, d_in)];
      }
      in_partial_sum[hook(78, ei_new)] = sum;

      ei_new = ei_new + 32;
    }

    barrier(0x01 | 0x02);
    ei_new = tx;
    while (ei_new < d_common.in_sqr_rows) {
      sum = 0;
      for (i = 0; i < d_common.in_sqr_cols; i++) {
        sum = sum + hook(79, d_unique_d_in_sqr)];
      }
      in_sqr_partial_sum[hook(80, ei_new)] = sum;

      ei_new = ei_new + 32;
    }

    barrier(0x01 | 0x02);
    if (tx == 0) {
      in_final_sum[hook(81, 0)] = 0;
      for (i = 0; i < d_common.in_cols; i++) {
        in_final_sum[hook(81, 0)] = in_final_sum[hook(81, 0)] + in_partial_sum[hook(78, i)];
      }

    } else if (tx == 1) {
      in_sqr_final_sum[hook(82, 0)] = 0;
      for (i = 0; i < d_common.in_sqr_cols; i++) {
        in_sqr_final_sum[hook(82, 0)] = in_sqr_final_sum[hook(82, 0)] + in_sqr_partial_sum[hook(80, i)];
      }
    }

    barrier(0x01 | 0x02);
    if (tx == 0) {
      mean = in_final_sum[hook(81, 0)] / d_common.in_elem;
      mean_sqr = mean * mean;

      variance = (in_sqr_final_sum[hook(82, 0)] / d_common.in_elem) - mean_sqr;
      deviation = sqrt(variance);

      denomT[hook(83, 0)] = sqrt((float)(d_common.in_elem - 1)) * deviation;
    }

    barrier(0x01 | 0x02);
    ei_new = tx;
    while (ei_new < d_common.in2_sub2_elem) {
      d_unique_d_in2_sqr_sub2[hook(74, ei_new)] = d_unique_d_in2_sqr_sub2[hook(74, ei_new)] * denomT[hook(83, 0)];

      ei_new = ei_new + 32;
    }

    barrier(0x01 | 0x02);
    ei_new = tx;
    while (ei_new < d_common.conv_elem) {
      d_unique_d_conv[hook(63, ei_new)] = d_unique_d_conv[hook(63, ei_new)] - d_unique_d_in2_sub2[hook(71, ei_new)] * in_final_sum[hook(81, 0)] / d_common.in_elem;

      ei_new = ei_new + 32;
    }

    barrier(0x01 | 0x02);
    ei_new = tx;
    while (ei_new < d_common.in2_sub2_elem) {
      d_unique_d_in2_sqr_sub2[hook(74, ei_new)] = d_unique_d_conv[hook(63, ei_new)] / d_unique_d_in2_sqr_sub2[hook(74, ei_new)];

      ei_new = ei_new + 32;
    }

    barrier(0x01 | 0x02);
    cent = d_common.sSize + d_common.tSize + 1;
    if (d_frame_no == 0) {
      tMask_row = cent + d_unique_d_Row[hook(52, d_unique_point_no)] - d_unique_d_Row[hook(52, d_unique_point_no)] - 1;
      tMask_col = cent + d_unique_d_Col[hook(54, d_unique_point_no)] - d_unique_d_Col[hook(54, d_unique_point_no)] - 1;
    } else {
      pointer = d_unique_point_no * d_common.no_frames + d_frame_no - 1;
      tMask_row = cent + d_unique_d_tRowLoc[hook(51, pointer)] - d_unique_d_Row[hook(52, d_unique_point_no)] - 1;
      tMask_col = cent + d_unique_d_tColLoc[hook(53, pointer)] - d_unique_d_Col[hook(54, d_unique_point_no)] - 1;
    }

    ei_new = tx;
    while (ei_new < d_common.tMask_elem) {
      location = tMask_col * d_common.tMask_rows + tMask_row;

      if (ei_new == location) {
        d_unique_d_tMask[hook(84, ei_new)] = 1;
      } else {
        d_unique_d_tMask[hook(84, ei_new)] = 0;
      }

      ei_new = ei_new + 32;
    }

    barrier(0x01 | 0x02);
    ei_new = tx;
    while (ei_new < d_common.mask_conv_elem) {
      ic = (ei_new + 1) % d_common.mask_conv_rows;
      jc = (ei_new + 1) / d_common.mask_conv_rows + 1;
      if ((ei_new + 1) % d_common.mask_conv_rows == 0) {
        ic = d_common.mask_conv_rows;
        jc = jc - 1;
      }

      j = jc + d_common.mask_conv_joffset;
      jp1 = j + 1;
      if (d_common.mask_cols < jp1) {
        ja1 = jp1 - d_common.mask_cols;
      } else {
        ja1 = 1;
      }
      if (d_common.tMask_cols < j) {
        ja2 = d_common.tMask_cols;
      } else {
        ja2 = j;
      }

      i = ic + d_common.mask_conv_ioffset;
      ip1 = i + 1;

      if (d_common.mask_rows < ip1) {
        ia1 = ip1 - d_common.mask_rows;
      } else {
        ia1 = 1;
      }
      if (d_common.tMask_rows < i) {
        ia2 = d_common.tMask_rows;
      } else {
        ia2 = i;
      }

      s = 0;

      for (ja = ja1; ja <= ja2; ja++) {
        jb = jp1 - ja;
        for (ia = ia1; ia <= ia2; ia++) {
          ib = ip1 - ia;
          s = s + hook(85, d_unique_d_tMask)] * 1;
        }
      }

      d_unique_d_mask_conv[hook(86, ei_new)] = d_unique_d_in2_sqr_sub2[hook(74, ei_new)] * s;

      ei_new = ei_new + 32;
    }

    barrier(0x01 | 0x02);
    ei_new = tx;
    while (ei_new < d_common.mask_conv_rows) {
      for (i = 0; i < d_common.mask_conv_cols; i++) {
        largest_coordinate_current = ei_new * d_common.mask_conv_rows + i;
        largest_value_current = fabs(d_unique_d_mask_conv[hook(86, largest_coordinate_current)]);
        if (largest_value_current > largest_value) {
          largest_coordinate = largest_coordinate_current;
          largest_value = largest_value_current;
        }
      }
      par_max_coo[hook(87, ei_new)] = largest_coordinate;
      par_max_val[hook(88, ei_new)] = largest_value;

      ei_new = ei_new + 32;
    }

    barrier(0x01 | 0x02);
    if (tx == 0) {
      for (i = 0; i < d_common.mask_conv_rows; i++) {
        if (par_max_val[hook(88, i)] > fin_max_val) {
          fin_max_val = par_max_val[hook(88, i)];
          fin_max_coo = par_max_coo[hook(87, i)];
        }
      }

      largest_row = (fin_max_coo + 1) % d_common.mask_conv_rows - 1;
      largest_col = (fin_max_coo + 1) / d_common.mask_conv_rows;
      if ((fin_max_coo + 1) % d_common.mask_conv_rows == 0) {
        largest_row = d_common.mask_conv_rows - 1;
        largest_col = largest_col - 1;
      }

      largest_row = largest_row + 1;
      largest_col = largest_col + 1;
      offset_row = largest_row - d_common.in_rows - (d_common.sSize - d_common.tSize);
      offset_col = largest_col - d_common.in_cols - (d_common.sSize - d_common.tSize);
      pointer = d_unique_point_no * d_common.no_frames + d_frame_no;
      d_unique_d_tRowLoc[hook(51, pointer)] = d_unique_d_Row[hook(52, d_unique_point_no)] + offset_row;
      d_unique_d_tColLoc[hook(53, pointer)] = d_unique_d_Col[hook(54, d_unique_point_no)] + offset_col;
    }

    barrier(0x01 | 0x02);
  }

  if (d_frame_no != 0 && (d_frame_no) % 10 == 0) {
    barrier(0x01 | 0x02);

    loc_pointer = d_unique_point_no * d_common.no_frames + d_frame_no;

    d_unique_d_Row[hook(52, d_unique_point_no)] = d_unique_d_tRowLoc[hook(51, loc_pointer)];
    d_unique_d_Col[hook(54, d_unique_point_no)] = d_unique_d_tColLoc[hook(53, loc_pointer)];

    ei_new = tx;
    while (ei_new < d_common.in_elem) {
      row = (ei_new + 1) % d_common.in_rows - 1;
      col = (ei_new + 1) / d_common.in_rows + 1 - 1;
      if ((ei_new + 1) % d_common.in_rows == 0) {
        row = d_common.in_rows - 1;
        col = col - 1;
      }

      ori_row = d_unique_d_Row[hook(52, d_unique_point_no)] - 25 + row - 1;
      ori_col = d_unique_d_Col[hook(54, d_unique_point_no)] - 25 + col - 1;
      ori_pointer = ori_col * d_common.frame_rows + ori_row;

      d_in[hook(75, ei_new)] = d_common.alpha * d_in[hook(75, ei_new)] + (1 - d_common.alpha) * d_common_change_d_frame[hook(56, ori_pointer)];

      ei_new = ei_new + 32;
    }

    barrier(0x01 | 0x02);
  }
}
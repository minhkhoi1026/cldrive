//{"block_offset":6,"data":1,"data_h_SR":15,"data_h_SR[i]":14,"dim":3,"input_v":2,"input_v_SR":16,"last_chunk_col_SR":9,"loop_exit":5,"out_SR":8,"out_SR[i - 1]":17,"out_SR[i]":7,"penalty":4,"ref_SR":13,"ref_SR[i]":12,"reference":0,"write_SR":11,"write_SR[i]":10}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
__attribute__((max_global_work_dim(0))) kernel void nw_kernel1(global int* restrict reference, global int* restrict data, global int* restrict input_v, int dim, int penalty, int loop_exit, int block_offset) {
  int out_SR[4 - 1][3];
  int last_chunk_col_SR[16 - (4 - 1) + 2];
  int ref_SR[4][4];
  int data_h_SR[4][4];
  int write_SR[4][4];
  int input_v_SR[2];

  for (int i = 0; i < 4 - 1; i++) {
    for (int j = 0; j < 3; j++) {
      out_SR[hook(8, i)][hook(7, j)] = 0;
    }
  }
  for (int i = 0; i < 16 - 4 + 3; i++) {
    last_chunk_col_SR[hook(9, i)] = 0;
  }
  for (int i = 0; i < 4; i++) {
    for (int j = 0; j < 4; j++) {
      write_SR[hook(11, i)][hook(10, j)] = 0;
    }
  }
  for (int i = 0; i < 4; i++) {
    for (int j = 0; j < 4; j++) {
      ref_SR[hook(13, i)][hook(12, j)] = 0;
    }
  }
  for (int i = 0; i < 4; i++) {
    for (int j = 0; j < 4; j++) {
      data_h_SR[hook(15, i)][hook(14, j)] = 0;
    }
  }
  for (int i = 0; i < 2; i++) {
    input_v_SR[hook(16, i)] = 0;
  }

  int comp_col_offset = 0;
  int write_col_offset = -4;
  int block_row = 0;
  int loop_index = 0;

  while (loop_index != loop_exit) {
    loop_index++;

    for (int i = 0; i < 4 - 1; i++) {
      for (int j = 0; j < 2; j++) {
        out_SR[hook(8, i)][hook(7, j)] = out_SR[hook(8, i)][hook(7, j + 1)];
      }
    }
    for (int i = 0; i < 16 - 4 + 2; i++) {
      last_chunk_col_SR[hook(9, i)] = last_chunk_col_SR[hook(9, i + 1)];
    }
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4 - 1; j++) {
        write_SR[hook(11, i)][hook(10, j)] = write_SR[hook(11, i)][hook(10, j + 1)];
      }
    }
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4 - 1; j++) {
        ref_SR[hook(13, i)][hook(12, j)] = ref_SR[hook(13, i)][hook(12, j + 1)];
      }
    }
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4 - 1; j++) {
        data_h_SR[hook(15, i)][hook(14, j)] = data_h_SR[hook(15, i)][hook(14, j + 1)];
      }
    }
    for (int i = 0; i < 1; i++) {
      input_v_SR[hook(16, i)] = input_v_SR[hook(16, i + 1)];
    }

    int read_block_row = block_row;
    int read_row = block_offset + read_block_row;

    if (comp_col_offset == 0 && read_row < dim - 1) {
      input_v_SR[hook(16, 1)] = input_v[hook(2, read_row)];
    }

    if (block_row == 0) {
      for (int i = 0; i < 4; i++) {
        int read_col = comp_col_offset + i;
        int read_index = read_row * dim + read_col;

        if (read_col < dim - 1 && read_row < dim - 1) {
          data_h_SR[hook(15, i)][hook(14, i)] = data[hook(1, read_index)];
        }
      }
    }

    for (int i = 4 - 1; i >= 0; i--) {
      int comp_block_row = (16 + block_row - i) & (16 - 1);
      int comp_row = block_offset + comp_block_row;
      int comp_col = comp_col_offset + i;

      int read_col = comp_col_offset + i;
      int read_index = read_row * dim + read_col;

      if (read_row > 0 && read_col < dim - 1 && read_row < dim - 1) {
        ref_SR[hook(13, i)][hook(12, i)] = reference[hook(0, read_index)];
      }

      int top = (i == 4 - 1) ? last_chunk_col_SR[hook(9, 16 - 4 + 1)] : out_SR[hook(8, i)][hook(7, 1)];
      int top_left = (comp_col_offset == 0 && i == 0) ? input_v_SR[hook(16, 0)] : ((i == 0) ? last_chunk_col_SR[hook(9, 0)] : out_SR[hook(8, i - 1)][hook(17, 0)]);
      int left = (comp_col_offset == 0 && i == 0) ? input_v_SR[hook(16, 1)] : ((i == 0) ? last_chunk_col_SR[hook(9, 1)] : out_SR[hook(8, i - 1)][hook(17, 1)]);

      int out1 = top_left + ref_SR[hook(13, i)][hook(12, 0)];
      int out2 = left - penalty;
      int out3 = top - penalty;
      int max_temp = (out1 > out2) ? out1 : out2;
      int max = (out3 > max_temp) ? out3 : max_temp;

      int out = (comp_block_row == 0) ? data_h_SR[hook(15, i)][hook(14, 0)] : max;

      if (i == 4 - 1) {
        last_chunk_col_SR[hook(9, 16 - 4 + 2)] = out;
      } else {
        out_SR[hook(8, i)][hook(7, 2)] = out;
      }

      write_SR[hook(11, i)][hook(10, 4 - i - 1)] = out;

      int write_col = write_col_offset + i;
      int write_block_row = (16 + block_row - (4 - 1)) & (16 - 1);
      int write_row = block_offset + write_block_row;
      int write_index = write_row * dim + write_col;

      if (write_block_row > 0 && write_col < dim - 1 && write_row < dim - 1) {
        data[hook(1, write_index)] = write_SR[hook(11, i)][hook(10, 0)];
      }
    }

    block_row = (block_row + 1) & (16 - 1);
    if (block_row == 4 - 1) {
      write_col_offset += 4;
    }
    if (block_row == 0) {
      comp_col_offset += 4;
    }
  }
}
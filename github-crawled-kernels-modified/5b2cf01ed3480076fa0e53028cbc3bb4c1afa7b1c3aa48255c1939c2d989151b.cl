//{"((__global ushort4 *)((__global char4 *)srcData + (src_y + 1) * srcStep / 4))":10,"((__global ushort4 *)((__global char4 *)srcData + (src_y + 2) * srcStep / 4))":11,"((__global ushort4 *)((__global char4 *)srcData + (src_y - 1) * srcStep / 4))":8,"((__global ushort4 *)((__global char4 *)srcData + (src_y - 2) * srcStep / 4))":7,"((__global ushort4 *)((__global char4 *)srcData + (src_y) * srcStep / 4))":9,"((__global ushort4 *)((__global char4 *)srcData + idx_row(src_y + 1, last_row) * srcStep / 4))":16,"((__global ushort4 *)((__global char4 *)srcData + idx_row(src_y + 2, last_row) * srcStep / 4))":17,"((__global ushort4 *)((__global char4 *)srcData + idx_row(src_y - 1, last_row) * srcStep / 4))":14,"((__global ushort4 *)((__global char4 *)srcData + idx_row(src_y - 2, last_row) * srcStep / 4))":13,"((__global ushort4 *)((__global char4 *)srcData + idx_row(src_y, last_row) * srcStep / 4))":15,"dst":4,"dstCols":6,"dstStep":5,"smem":12,"srcCols":3,"srcData":0,"srcRows":2,"srcStep":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline int idx_row_low(int y, int last_row) {
  return abs(y) % (last_row + 1);
}

inline int idx_row_high(int y, int last_row) {
  return abs(last_row - (int)abs(last_row - y)) % (last_row + 1);
}

inline int idx_row(int y, int last_row) {
  return idx_row_low(idx_row_high(y, last_row), last_row);
}

inline int idx_col_low(int x, int last_col) {
  return abs(x) % (last_col + 1);
}

inline int idx_col_high(int x, int last_col) {
  return abs(last_col - (int)abs(last_col - x)) % (last_col + 1);
}

inline int idx_col(int x, int last_col) {
  return idx_col_low(idx_col_high(x, last_col), last_col);
}

kernel void pyrDown_C4_D2(global ushort4* srcData, int srcStep, int srcRows, int srcCols, global ushort4* dst, int dstStep, int dstCols) {
  const int x = get_global_id(0);
  const int y = get_group_id(1);

  local float4 smem[256 + 4];

  float4 sum;

  const int src_y = 2 * y;
  const int last_row = srcRows - 1;
  const int last_col = srcCols - 1;

  float4 co1 = 0.375f;
  float4 co2 = 0.25f;
  float4 co3 = 0.0625f;

  if (src_y >= 2 && src_y < srcRows - 2 && x >= 2 && x < srcCols - 2) {
    sum = co3 * convert_float4(((global ushort4*)((global char4*)srcData + (src_y - 2) * srcStep / 4))[hook(7, x)]);
    sum = sum + co2 * convert_float4(((global ushort4*)((global char4*)srcData + (src_y - 1) * srcStep / 4))[hook(8, x)]);
    sum = sum + co1 * convert_float4(((global ushort4*)((global char4*)srcData + (src_y)*srcStep / 4))[hook(9, x)]);
    sum = sum + co2 * convert_float4(((global ushort4*)((global char4*)srcData + (src_y + 1) * srcStep / 4))[hook(10, x)]);
    sum = sum + co3 * convert_float4(((global ushort4*)((global char4*)srcData + (src_y + 2) * srcStep / 4))[hook(11, x)]);

    smem[hook(12, 2 + get_local_id(0))] = sum;

    if (get_local_id(0) < 2) {
      const int left_x = x - 2;

      sum = co3 * convert_float4(((global ushort4*)((global char4*)srcData + (src_y - 2) * srcStep / 4))[hook(7, left_x)]);
      sum = sum + co2 * convert_float4(((global ushort4*)((global char4*)srcData + (src_y - 1) * srcStep / 4))[hook(8, left_x)]);
      sum = sum + co1 * convert_float4(((global ushort4*)((global char4*)srcData + (src_y)*srcStep / 4))[hook(9, left_x)]);
      sum = sum + co2 * convert_float4(((global ushort4*)((global char4*)srcData + (src_y + 1) * srcStep / 4))[hook(10, left_x)]);
      sum = sum + co3 * convert_float4(((global ushort4*)((global char4*)srcData + (src_y + 2) * srcStep / 4))[hook(11, left_x)]);

      smem[hook(12, get_local_id(0))] = sum;
    }

    if (get_local_id(0) > 253) {
      const int right_x = x + 2;

      sum = co3 * convert_float4(((global ushort4*)((global char4*)srcData + (src_y - 2) * srcStep / 4))[hook(7, right_x)]);
      sum = sum + co2 * convert_float4(((global ushort4*)((global char4*)srcData + (src_y - 1) * srcStep / 4))[hook(8, right_x)]);
      sum = sum + co1 * convert_float4(((global ushort4*)((global char4*)srcData + (src_y)*srcStep / 4))[hook(9, right_x)]);
      sum = sum + co2 * convert_float4(((global ushort4*)((global char4*)srcData + (src_y + 1) * srcStep / 4))[hook(10, right_x)]);
      sum = sum + co3 * convert_float4(((global ushort4*)((global char4*)srcData + (src_y + 2) * srcStep / 4))[hook(11, right_x)]);

      smem[hook(12, 4 + get_local_id(0))] = sum;
    }
  } else {
    int col = idx_col(x, last_col);

    sum = co3 * convert_float4(((global ushort4*)((global char4*)srcData + idx_row(src_y - 2, last_row) * srcStep / 4))[hook(13, col)]);
    sum = sum + co2 * convert_float4(((global ushort4*)((global char4*)srcData + idx_row(src_y - 1, last_row) * srcStep / 4))[hook(14, col)]);
    sum = sum + co1 * convert_float4(((global ushort4*)((global char4*)srcData + idx_row(src_y, last_row) * srcStep / 4))[hook(15, col)]);
    sum = sum + co2 * convert_float4(((global ushort4*)((global char4*)srcData + idx_row(src_y + 1, last_row) * srcStep / 4))[hook(16, col)]);
    sum = sum + co3 * convert_float4(((global ushort4*)((global char4*)srcData + idx_row(src_y + 2, last_row) * srcStep / 4))[hook(17, col)]);

    smem[hook(12, 2 + get_local_id(0))] = sum;

    if (get_local_id(0) < 2) {
      const int left_x = x - 2;

      col = idx_col(left_x, last_col);

      sum = co3 * convert_float4(((global ushort4*)((global char4*)srcData + idx_row(src_y - 2, last_row) * srcStep / 4))[hook(13, col)]);
      sum = sum + co2 * convert_float4(((global ushort4*)((global char4*)srcData + idx_row(src_y - 1, last_row) * srcStep / 4))[hook(14, col)]);
      sum = sum + co1 * convert_float4(((global ushort4*)((global char4*)srcData + idx_row(src_y, last_row) * srcStep / 4))[hook(15, col)]);
      sum = sum + co2 * convert_float4(((global ushort4*)((global char4*)srcData + idx_row(src_y + 1, last_row) * srcStep / 4))[hook(16, col)]);
      sum = sum + co3 * convert_float4(((global ushort4*)((global char4*)srcData + idx_row(src_y + 2, last_row) * srcStep / 4))[hook(17, col)]);

      smem[hook(12, get_local_id(0))] = sum;
    }

    if (get_local_id(0) > 253) {
      const int right_x = x + 2;

      col = idx_col(right_x, last_col);

      sum = co3 * convert_float4(((global ushort4*)((global char4*)srcData + idx_row(src_y - 2, last_row) * srcStep / 4))[hook(13, col)]);
      sum = sum + co2 * convert_float4(((global ushort4*)((global char4*)srcData + idx_row(src_y - 1, last_row) * srcStep / 4))[hook(14, col)]);
      sum = sum + co1 * convert_float4(((global ushort4*)((global char4*)srcData + idx_row(src_y, last_row) * srcStep / 4))[hook(15, col)]);
      sum = sum + co2 * convert_float4(((global ushort4*)((global char4*)srcData + idx_row(src_y + 1, last_row) * srcStep / 4))[hook(16, col)]);
      sum = sum + co3 * convert_float4(((global ushort4*)((global char4*)srcData + idx_row(src_y + 2, last_row) * srcStep / 4))[hook(17, col)]);

      smem[hook(12, 4 + get_local_id(0))] = sum;
    }
  }

  barrier(0x01);

  if (get_local_id(0) < 128) {
    const int tid2 = get_local_id(0) * 2;

    sum = co3 * smem[hook(12, 2 + tid2 - 2)];
    sum = sum + co2 * smem[hook(12, 2 + tid2 - 1)];
    sum = sum + co1 * smem[hook(12, 2 + tid2)];
    sum = sum + co2 * smem[hook(12, 2 + tid2 + 1)];
    sum = sum + co3 * smem[hook(12, 2 + tid2 + 2)];

    const int dst_x = (get_group_id(0) * get_local_size(0) + tid2) / 2;

    if (dst_x < dstCols)
      dst[hook(4, y * dstStep / 8 + dst_x)] = convert_ushort4_sat_rte(sum);
  }
}
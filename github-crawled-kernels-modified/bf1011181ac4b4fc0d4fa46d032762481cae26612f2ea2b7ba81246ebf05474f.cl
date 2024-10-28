//{"arr":11,"dst":5,"dst_cols":9,"dst_offset":7,"dst_rows":8,"dst_step":6,"kx":14,"ky":13,"line":10,"src":0,"src_cols":4,"src_offset":2,"src_rows":3,"src_step":1,"sum":12}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant float kx[] = {0.125, 0.5, 0.75, 0.5, 0.125};
constant float ky[] = {0.125, 0.5, 0.75, 0.5, 0.125};

kernel void pyrUp_cols2(global const uchar* src, int src_step, int src_offset, int src_rows, int src_cols, global uchar* dst, int dst_step, int dst_offset, int dst_rows, int dst_cols) {
  int block_x = get_global_id(0);
  int y = get_global_id(1) * 2;

  if ((block_x * 4) >= dst_cols || y >= dst_rows)
    return;

  uchar8 line[6];
  uchar4 line_out;

  int offset, src_index;
  src_index = block_x * 2 + (y / 2 - 1) * src_step - 1 + src_offset;

  uchar4 tmp;

  line[hook(10, 0)] = line[hook(10, 2)] = line[hook(10, 4)] = (uchar8)0;
  line[hook(10, 1)] = line[hook(10, 3)] = line[hook(10, 5)] = (uchar8)0;

  offset = max(0, src_index + 1 * src_step);
  tmp = vload4(0, src + offset);
  if (offset == 0)
    tmp = (uchar4)(0, tmp.s012);
  line[hook(10, 2)].even = tmp;

  offset = max(0, src_index + ((y == 0) ? 2 : 0) * src_step);
  tmp = vload4(0, src + offset);
  if (offset == 0)
    tmp = (uchar4)(0, tmp.s012);
  line[hook(10, 0)].even = tmp;

  if (y == (dst_rows - 2))
    line[hook(10, 4)] = line[hook(10, 2)];
  else
    line[hook(10, 4)].even = vload4(0, src + src_index + 2 * src_step);

  bool row_s = (block_x == 0);
  bool row_e = ((block_x + 1) * 4 == dst_cols);
  uchar4 arr[30];
  uchar s, e;

  s = line[hook(10, 0)].s4;
  e = line[hook(10, 0)].s3;
  arr[hook(11, 0)] = row_s ? (uchar4)(s, e, line[hook(10, 0)].s23) : (uchar4)(line[hook(10, 0)].s0123);
  arr[hook(11, 1)] = row_s ? (uchar4)(e, line[hook(10, 0)].s234) : (uchar4)(line[hook(10, 0)].s1234);
  arr[hook(11, 2)] = (uchar4)(line[hook(10, 0)].s2345);
  arr[hook(11, 3)] = row_e ? (uchar4)(line[hook(10, 0)].s345, s) : (uchar4)(line[hook(10, 0)].s3456);
  arr[hook(11, 4)] = row_e ? (uchar4)(line[hook(10, 0)].s45, s, e) : (uchar4)(line[hook(10, 0)].s4567);

  s = line[hook(10, 1)].s4;
  e = line[hook(10, 1)].s3;
  arr[hook(11, 5)] = row_s ? (uchar4)(s, e, line[hook(10, 1)].s23) : (uchar4)(line[hook(10, 1)].s0123);
  arr[hook(11, 6)] = row_s ? (uchar4)(e, line[hook(10, 1)].s234) : (uchar4)(line[hook(10, 1)].s1234);
  arr[hook(11, 7)] = (uchar4)(line[hook(10, 1)].s2345);
  arr[hook(11, 8)] = row_e ? (uchar4)(line[hook(10, 1)].s345, s) : (uchar4)(line[hook(10, 1)].s3456);
  arr[hook(11, 9)] = row_e ? (uchar4)(line[hook(10, 1)].s45, s, e) : (uchar4)(line[hook(10, 1)].s4567);

  s = line[hook(10, 2)].s4;
  e = line[hook(10, 2)].s3;
  arr[hook(11, 10)] = row_s ? (uchar4)(s, e, line[hook(10, 2)].s23) : (uchar4)(line[hook(10, 2)].s0123);
  arr[hook(11, 11)] = row_s ? (uchar4)(e, line[hook(10, 2)].s234) : (uchar4)(line[hook(10, 2)].s1234);
  arr[hook(11, 12)] = (uchar4)(line[hook(10, 2)].s2345);
  arr[hook(11, 13)] = row_e ? (uchar4)(line[hook(10, 2)].s345, s) : (uchar4)(line[hook(10, 2)].s3456);
  arr[hook(11, 14)] = row_e ? (uchar4)(line[hook(10, 2)].s45, s, e) : (uchar4)(line[hook(10, 2)].s4567);

  s = line[hook(10, 3)].s4;
  e = line[hook(10, 3)].s3;
  arr[hook(11, 15)] = row_s ? (uchar4)(s, e, line[hook(10, 3)].s23) : (uchar4)(line[hook(10, 3)].s0123);
  arr[hook(11, 16)] = row_s ? (uchar4)(e, line[hook(10, 3)].s234) : (uchar4)(line[hook(10, 3)].s1234);
  arr[hook(11, 17)] = (uchar4)(line[hook(10, 3)].s2345);
  arr[hook(11, 18)] = row_e ? (uchar4)(line[hook(10, 3)].s345, s) : (uchar4)(line[hook(10, 3)].s3456);
  arr[hook(11, 19)] = row_e ? (uchar4)(line[hook(10, 3)].s45, s, e) : (uchar4)(line[hook(10, 3)].s4567);

  s = line[hook(10, 4)].s4;
  e = line[hook(10, 4)].s3;
  arr[hook(11, 20)] = row_s ? (uchar4)(s, e, line[hook(10, 4)].s23) : (uchar4)(line[hook(10, 4)].s0123);
  arr[hook(11, 21)] = row_s ? (uchar4)(e, line[hook(10, 4)].s234) : (uchar4)(line[hook(10, 4)].s1234);
  arr[hook(11, 22)] = (uchar4)(line[hook(10, 4)].s2345);
  arr[hook(11, 23)] = row_e ? (uchar4)(line[hook(10, 4)].s345, s) : (uchar4)(line[hook(10, 4)].s3456);
  arr[hook(11, 24)] = row_e ? (uchar4)(line[hook(10, 4)].s45, s, e) : (uchar4)(line[hook(10, 4)].s4567);

  s = line[hook(10, 5)].s4;
  e = line[hook(10, 5)].s3;
  arr[hook(11, 25)] = row_s ? (uchar4)(s, e, line[hook(10, 5)].s23) : (uchar4)(line[hook(10, 5)].s0123);
  arr[hook(11, 26)] = row_s ? (uchar4)(e, line[hook(10, 5)].s234) : (uchar4)(line[hook(10, 5)].s1234);
  arr[hook(11, 27)] = (uchar4)(line[hook(10, 5)].s2345);
  arr[hook(11, 28)] = row_e ? (uchar4)(line[hook(10, 5)].s345, s) : (uchar4)(line[hook(10, 5)].s3456);
  arr[hook(11, 29)] = row_e ? (uchar4)(line[hook(10, 5)].s45, s, e) : (uchar4)(line[hook(10, 5)].s4567);

  float4 sum[2];

  sum[hook(12, 0)] = (convert_float4(arr[hook(11, (0 + 0) * 5 + 0)]) * ky[hook(13, 0)] * kx[hook(14, 0)]) + (convert_float4(arr[hook(11, (0 + 0) * 5 + 1)]) * ky[hook(13, 0)] * kx[hook(14, 1)]) + (convert_float4(arr[hook(11, (0 + 0) * 5 + 2)]) * ky[hook(13, 0)] * kx[hook(14, 2)]) + (convert_float4(arr[hook(11, (0 + 0) * 5 + 3)]) * ky[hook(13, 0)] * kx[hook(14, 3)]) + (convert_float4(arr[hook(11, (0 + 0) * 5 + 4)]) * ky[hook(13, 0)] * kx[hook(14, 4)]) + (convert_float4(arr[hook(11, (1 + 0) * 5 + 0)]) * ky[hook(13, 1)] * kx[hook(14, 0)]) + (convert_float4(arr[hook(11, (1 + 0) * 5 + 1)]) * ky[hook(13, 1)] * kx[hook(14, 1)]) + (convert_float4(arr[hook(11, (1 + 0) * 5 + 2)]) * ky[hook(13, 1)] * kx[hook(14, 2)]) + (convert_float4(arr[hook(11, (1 + 0) * 5 + 3)]) * ky[hook(13, 1)] * kx[hook(14, 3)]) + (convert_float4(arr[hook(11, (1 + 0) * 5 + 4)]) * ky[hook(13, 1)] * kx[hook(14, 4)]) + (convert_float4(arr[hook(11, (2 + 0) * 5 + 0)]) * ky[hook(13, 2)] * kx[hook(14, 0)]) + (convert_float4(arr[hook(11, (2 + 0) * 5 + 1)]) * ky[hook(13, 2)] * kx[hook(14, 1)]) + (convert_float4(arr[hook(11, (2 + 0) * 5 + 2)]) * ky[hook(13, 2)] * kx[hook(14, 2)]) + (convert_float4(arr[hook(11, (2 + 0) * 5 + 3)]) * ky[hook(13, 2)] * kx[hook(14, 3)]) + (convert_float4(arr[hook(11, (2 + 0) * 5 + 4)]) * ky[hook(13, 2)] * kx[hook(14, 4)]) + (convert_float4(arr[hook(11, (3 + 0) * 5 + 0)]) * ky[hook(13, 3)] * kx[hook(14, 0)]) + (convert_float4(arr[hook(11, (3 + 0) * 5 + 1)]) * ky[hook(13, 3)] * kx[hook(14, 1)]) + (convert_float4(arr[hook(11, (3 + 0) * 5 + 2)]) * ky[hook(13, 3)] * kx[hook(14, 2)]) + (convert_float4(arr[hook(11, (3 + 0) * 5 + 3)]) * ky[hook(13, 3)] * kx[hook(14, 3)]) + (convert_float4(arr[hook(11, (3 + 0) * 5 + 4)]) * ky[hook(13, 3)] * kx[hook(14, 4)]) + (convert_float4(arr[hook(11, (4 + 0) * 5 + 0)]) * ky[hook(13, 4)] * kx[hook(14, 0)]) + (convert_float4(arr[hook(11, (4 + 0) * 5 + 1)]) * ky[hook(13, 4)] * kx[hook(14, 1)]) + (convert_float4(arr[hook(11, (4 + 0) * 5 + 2)]) * ky[hook(13, 4)] * kx[hook(14, 2)]) + (convert_float4(arr[hook(11, (4 + 0) * 5 + 3)]) * ky[hook(13, 4)] * kx[hook(14, 3)]) + (convert_float4(arr[hook(11, (4 + 0) * 5 + 4)]) * ky[hook(13, 4)] * kx[hook(14, 4)]);

  sum[hook(12, 1)] = (convert_float4(arr[hook(11, (0 + 1) * 5 + 0)]) * ky[hook(13, 0)] * kx[hook(14, 0)]) + (convert_float4(arr[hook(11, (0 + 1) * 5 + 1)]) * ky[hook(13, 0)] * kx[hook(14, 1)]) + (convert_float4(arr[hook(11, (0 + 1) * 5 + 2)]) * ky[hook(13, 0)] * kx[hook(14, 2)]) + (convert_float4(arr[hook(11, (0 + 1) * 5 + 3)]) * ky[hook(13, 0)] * kx[hook(14, 3)]) + (convert_float4(arr[hook(11, (0 + 1) * 5 + 4)]) * ky[hook(13, 0)] * kx[hook(14, 4)]) + (convert_float4(arr[hook(11, (1 + 1) * 5 + 0)]) * ky[hook(13, 1)] * kx[hook(14, 0)]) + (convert_float4(arr[hook(11, (1 + 1) * 5 + 1)]) * ky[hook(13, 1)] * kx[hook(14, 1)]) + (convert_float4(arr[hook(11, (1 + 1) * 5 + 2)]) * ky[hook(13, 1)] * kx[hook(14, 2)]) + (convert_float4(arr[hook(11, (1 + 1) * 5 + 3)]) * ky[hook(13, 1)] * kx[hook(14, 3)]) + (convert_float4(arr[hook(11, (1 + 1) * 5 + 4)]) * ky[hook(13, 1)] * kx[hook(14, 4)]) + (convert_float4(arr[hook(11, (2 + 1) * 5 + 0)]) * ky[hook(13, 2)] * kx[hook(14, 0)]) + (convert_float4(arr[hook(11, (2 + 1) * 5 + 1)]) * ky[hook(13, 2)] * kx[hook(14, 1)]) + (convert_float4(arr[hook(11, (2 + 1) * 5 + 2)]) * ky[hook(13, 2)] * kx[hook(14, 2)]) + (convert_float4(arr[hook(11, (2 + 1) * 5 + 3)]) * ky[hook(13, 2)] * kx[hook(14, 3)]) + (convert_float4(arr[hook(11, (2 + 1) * 5 + 4)]) * ky[hook(13, 2)] * kx[hook(14, 4)]) + (convert_float4(arr[hook(11, (3 + 1) * 5 + 0)]) * ky[hook(13, 3)] * kx[hook(14, 0)]) + (convert_float4(arr[hook(11, (3 + 1) * 5 + 1)]) * ky[hook(13, 3)] * kx[hook(14, 1)]) + (convert_float4(arr[hook(11, (3 + 1) * 5 + 2)]) * ky[hook(13, 3)] * kx[hook(14, 2)]) + (convert_float4(arr[hook(11, (3 + 1) * 5 + 3)]) * ky[hook(13, 3)] * kx[hook(14, 3)]) + (convert_float4(arr[hook(11, (3 + 1) * 5 + 4)]) * ky[hook(13, 3)] * kx[hook(14, 4)]) + (convert_float4(arr[hook(11, (4 + 1) * 5 + 0)]) * ky[hook(13, 4)] * kx[hook(14, 0)]) + (convert_float4(arr[hook(11, (4 + 1) * 5 + 1)]) * ky[hook(13, 4)] * kx[hook(14, 1)]) + (convert_float4(arr[hook(11, (4 + 1) * 5 + 2)]) * ky[hook(13, 4)] * kx[hook(14, 2)]) + (convert_float4(arr[hook(11, (4 + 1) * 5 + 3)]) * ky[hook(13, 4)] * kx[hook(14, 3)]) + (convert_float4(arr[hook(11, (4 + 1) * 5 + 4)]) * ky[hook(13, 4)] * kx[hook(14, 4)]);

  int dst_index = block_x * 4 + y * dst_step + dst_offset;
  vstore4(convert_uchar4_sat_rte(sum[hook(12, 0)]), 0, dst + dst_index);
  vstore4(convert_uchar4_sat_rte(sum[hook(12, 1)]), 0, dst + dst_index + dst_step);
}
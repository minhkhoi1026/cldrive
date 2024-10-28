//{"SumX":7,"TmpSumX":6,"dest":1,"dst_step":3,"height":5,"source":0,"src_step":2,"width":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
__attribute__((reqd_work_group_size(8, 8, 1))) __attribute__((reqd_work_group_size(8, 8, 1))) kernel void scan1_F32(global const uchar* source, global float* dest, int src_step, int dst_step, int width, int height) {
  src_step /= sizeof(uchar);
  dst_step /= sizeof(float);
  const int gx = get_global_id(0) * 8;
  const int gy = get_global_id(1);
  const int local_x = get_local_id(0) * 8;
  const int local_y = get_local_id(1);
  const int buf_index = local_x + local_y * 8 * 8;

  local float TmpSumX[(8 * 8) * 8];
  local float SumX[(8 * 8) * 8];

  float Sum = 0;
  for (int i = 0; i < 8; i++) {
    Sum += convert_float(source[hook(0, gy * src_step + gx + i)]);
    TmpSumX[hook(6, buf_index + i)] = Sum;
  }

  barrier(0x01);

  Sum = 0;
  for (int x = 8 - 1; x < local_x; x += 8)
    Sum += TmpSumX[hook(6, local_y * 8 * 8 + x)];

  for (int i = 0; i < 8; i++) {
    float Val = Sum + TmpSumX[hook(6, buf_index + i)];
    SumX[hook(7, buf_index + i)] = Val;
  }

  barrier(0x01);

  const int gx2 = gx + local_y;

  if (gx2 >= width)
    return;

  Sum = 0;
  for (int i = 0; i < 8; i++) {
    int2 Pos = {gx2, get_group_id(1) * 8 + i};

    Sum += SumX[hook(7, i * 8 * 8 + local_x + local_y)];

    if (Pos.y < height)
      dest[hook(1, (get_group_id(1) * 8 + i) * dst_step + gx2)] = Sum;
  }
}
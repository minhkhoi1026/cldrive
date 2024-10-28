//{"l_data":5,"l_rowid":4,"result":3,"tmp_data":1,"tmp_rowid":0,"warp_num":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void gpu_coo_s2(global int* tmp_rowid, global float* tmp_data, int warp_num, global float* result) {
  local int l_rowid[64 * 2 + 1];
  local float l_data[64 * 2 + 1];

  int localid = get_local_id(0);
  if (localid == 0) {
    l_rowid[hook(4, 64 * 2)] = -1;
    l_data[hook(5, 64 * 2)] = 0.0f;
  }
  int blocknum = warp_num / (64 * 2);

  barrier(0x01);

  int tmpid = localid;
  for (int i = 0; i < blocknum; i++) {
    l_rowid[hook(4, localid)] = tmp_rowid[hook(0, tmpid)];
    l_data[hook(5, localid)] = tmp_data[hook(1, tmpid)];
    barrier(0x01);

    float left = 0.0f;
    if (localid >= 1 && l_rowid[hook(4, localid)] == l_rowid[hook(4, localid - 1)])
      left = l_data[hook(5, localid - 1)];
    barrier(0x01);
    l_data[hook(5, localid)] += left;
    left = 0.0f;
    barrier(0x01);
    if (localid >= 2 && l_rowid[hook(4, localid)] == l_rowid[hook(4, localid - 2)])
      left = l_data[hook(5, localid - 2)];
    barrier(0x01);
    l_data[hook(5, localid)] += left;
    left = 0.0f;
    barrier(0x01);
    if (localid >= 4 && l_rowid[hook(4, localid)] == l_rowid[hook(4, localid - 4)])
      left = l_data[hook(5, localid - 4)];
    barrier(0x01);
    l_data[hook(5, localid)] += left;
    left = 0.0f;
    barrier(0x01);
    if (localid >= 8 && l_rowid[hook(4, localid)] == l_rowid[hook(4, localid - 8)])
      left = l_data[hook(5, localid - 8)];
    barrier(0x01);
    l_data[hook(5, localid)] += left;
    left = 0.0f;
    barrier(0x01);
    if (localid >= 16 && l_rowid[hook(4, localid)] == l_rowid[hook(4, localid - 16)])
      left = l_data[hook(5, localid - 16)];
    barrier(0x01);
    l_data[hook(5, localid)] += left;
    left = 0.0f;
    barrier(0x01);
    if (localid >= 32 && l_rowid[hook(4, localid)] == l_rowid[hook(4, localid - 32)])
      left = l_data[hook(5, localid - 32)];
    barrier(0x01);
    l_data[hook(5, localid)] += left;
    left = 0.0f;
    barrier(0x01);
    if (localid >= 64 && l_rowid[hook(4, localid)] == l_rowid[hook(4, localid - 64)])
      left = l_data[hook(5, localid - 64)];
    barrier(0x01);
    l_data[hook(5, localid)] += left;
    left = 0.0f;
    barrier(0x01);

    if (l_rowid[hook(4, localid)] != l_rowid[hook(4, localid + 1)]) {
      int row = l_rowid[hook(4, localid)];
      result[hook(3, row)] += l_data[hook(5, localid)];
    }
    barrier(0x01);
    tmpid += 64 * 2;
  }

  if (warp_num % (64 * 2) != 0) {
    if (tmpid < warp_num) {
      l_rowid[hook(4, localid)] = tmp_rowid[hook(0, tmpid)];
      l_data[hook(5, localid)] = tmp_data[hook(1, tmpid)];
    } else {
      l_rowid[hook(4, localid)] = -1;
      l_data[hook(5, localid)] = 0.0f;
    }
    barrier(0x01);

    float left = 0.0f;
    if (localid >= 1 && l_rowid[hook(4, localid)] == l_rowid[hook(4, localid - 1)])
      left = l_data[hook(5, localid - 1)];
    barrier(0x01);
    l_data[hook(5, localid)] += left;
    left = 0.0f;
    barrier(0x01);
    if (localid >= 2 && l_rowid[hook(4, localid)] == l_rowid[hook(4, localid - 2)])
      left = l_data[hook(5, localid - 2)];
    barrier(0x01);
    l_data[hook(5, localid)] += left;
    left = 0.0f;
    barrier(0x01);
    if (localid >= 4 && l_rowid[hook(4, localid)] == l_rowid[hook(4, localid - 4)])
      left = l_data[hook(5, localid - 4)];
    barrier(0x01);
    l_data[hook(5, localid)] += left;
    left = 0.0f;
    barrier(0x01);
    if (localid >= 8 && l_rowid[hook(4, localid)] == l_rowid[hook(4, localid - 8)])
      left = l_data[hook(5, localid - 8)];
    barrier(0x01);
    l_data[hook(5, localid)] += left;
    left = 0.0f;
    barrier(0x01);
    if (localid >= 16 && l_rowid[hook(4, localid)] == l_rowid[hook(4, localid - 16)])
      left = l_data[hook(5, localid - 16)];
    barrier(0x01);
    l_data[hook(5, localid)] += left;
    left = 0.0f;
    barrier(0x01);
    if (localid >= 32 && l_rowid[hook(4, localid)] == l_rowid[hook(4, localid - 32)])
      left = l_data[hook(5, localid - 32)];
    barrier(0x01);
    l_data[hook(5, localid)] += left;
    left = 0.0f;
    barrier(0x01);
    if (localid >= 64 && l_rowid[hook(4, localid)] == l_rowid[hook(4, localid - 64)])
      left = l_data[hook(5, localid - 64)];
    barrier(0x01);
    l_data[hook(5, localid)] += left;
    left = 0.0f;
    barrier(0x01);

    if (tmpid < warp_num) {
      if (l_rowid[hook(4, localid)] != l_rowid[hook(4, localid + 1)]) {
        int row = l_rowid[hook(4, localid)];
        result[hook(3, row)] += l_data[hook(5, localid)];
      }
    }
  }
}
//{"col_id":1,"data":2,"l_data":10,"l_rowid":9,"nnz":4,"process_size":3,"result":6,"row_id":0,"tmp_data":8,"tmp_rowid":7,"vec":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void gpu_coo_s1(global int* row_id, global int* col_id, global float* data, int process_size, int nnz, global float* vec, global float* result, global int* tmp_rowid, global float* tmp_data) {
  local int l_rowid[64];
  local float l_data[64];
  int localid = get_local_id(0);
  int global_warpid = get_group_id(0);
  int start = global_warpid * process_size;
  int gsize = get_local_size(0);
  int end = start + process_size;
  if (end > nnz)
    end = nnz;
  int iter_num = (end - start) / gsize;

  if (localid == gsize - 1) {
    l_rowid[hook(9, localid)] = row_id[hook(0, start)];
    l_data[hook(10, localid)] = 0.0f;
  }
  barrier(0x01);

  int lastlocalid = localid + gsize - 1;
  int i = start + localid;
  for (int iter = 0; iter < iter_num; iter++) {
    int nzrow = 0;
    float val = 0.0f;
    if (i < nnz) {
      nzrow = row_id[hook(0, i)];
      val = data[hook(2, i)] * vec[hook(5, col_id[ihook(1, i))];
    }
    if (localid == 0) {
      if (nzrow == l_rowid[hook(9, lastlocalid)]) {
        val += l_data[hook(10, lastlocalid)];
      } else {
        result[hook(6, l_rowid[lhook(9, lastlocalid))] += l_data[hook(10, lastlocalid)];
      }
    }
    l_rowid[hook(9, localid)] = nzrow;
    l_data[hook(10, localid)] = val;
    barrier(0x01);
    if (localid >= 1 && nzrow == l_rowid[hook(9, localid - 1)])
      l_data[hook(10, localid)] = val = val + l_data[hook(10, localid - 1)];
    barrier(0x01);
    if (localid >= 2 && nzrow == l_rowid[hook(9, localid - 2)])
      l_data[hook(10, localid)] = val = val + l_data[hook(10, localid - 2)];
    barrier(0x01);
    if (localid >= 4 && nzrow == l_rowid[hook(9, localid - 4)])
      l_data[hook(10, localid)] = val = val + l_data[hook(10, localid - 4)];
    barrier(0x01);
    if (localid >= 8 && nzrow == l_rowid[hook(9, localid - 8)])
      l_data[hook(10, localid)] = val = val + l_data[hook(10, localid - 8)];
    barrier(0x01);
    if (localid >= 16 && nzrow == l_rowid[hook(9, localid - 16)])
      l_data[hook(10, localid)] = val = val + l_data[hook(10, localid - 16)];
    barrier(0x01);
    if (localid >= 32 && nzrow == l_rowid[hook(9, localid - 32)])
      l_data[hook(10, localid)] = val = val + l_data[hook(10, localid - 32)];
    barrier(0x01);

    if (localid < (gsize - 1) && nzrow != l_rowid[hook(9, localid + 1)])
      result[hook(6, nzrow)] += val;
    barrier(0x01);

    i += gsize;
  }

  if (localid == gsize - 1) {
    tmp_rowid[hook(7, global_warpid)] = l_rowid[hook(9, localid)];
    tmp_data[hook(8, global_warpid)] = l_data[hook(10, localid)];
  }
}
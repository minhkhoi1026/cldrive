//{"colid":1,"data":2,"data_align":5,"localrowptr":7,"localsum":6,"result":4,"rowptr":0,"s_ptr":8,"vec":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void gpu_bcsr_red_44(global int* rowptr, global int* colid, global float4* data, global float4* vec, global float4* result, int data_align) {
  local int localrowptr[2];
  local float localsum[128 + 64 / 2];
  int row = get_group_id(0);
  int localid = get_local_id(0);

  localsum[hook(6, localid)] = 0.0f;
  if (localid < 2) {
    localrowptr[hook(7, localid)] = rowptr[hook(0, row + localid)];
  }
  barrier(0x01);

  {
    int start = localrowptr[hook(7, 0)];
    int end = localrowptr[hook(7, 1)];
    float4 sum = {0.0f, 0.0f, 0.0f, 0.0f};
    for (int i = start + localid; i < end; i += 128) {
      int col = colid[hook(1, i)];
      int matoffset = i;
      float4 matelem = data[hook(2, matoffset)];
      float4 vecelem = vec[hook(3, col)];
      float4 tmp = matelem * vecelem;
      sum.x = sum.x + tmp.x + tmp.y + tmp.z + tmp.w;
      matoffset += data_align;
      matelem = data[hook(2, matoffset)];
      tmp = matelem * vecelem;
      sum.y = sum.y + tmp.x + tmp.y + tmp.z + tmp.w;
      matoffset += data_align;
      matelem = data[hook(2, matoffset)];
      tmp = matelem * vecelem;
      sum.z = sum.z + tmp.x + tmp.y + tmp.z + tmp.w;
      matoffset += data_align;
      matelem = data[hook(2, matoffset)];
      tmp = matelem * vecelem;
      sum.w = sum.w + tmp.x + tmp.y + tmp.z + tmp.w;
    }
    volatile local float* s_ptr = localsum;
    s_ptr[hook(8, localid)] = sum.x;
    barrier(0x01);
    if (localid < 64)
      s_ptr[hook(8, localid)] = sum.x = sum.x + s_ptr[hook(8, localid + 64)];
    barrier(0x01);
    s_ptr[hook(8, localid)] = sum.x = sum.x + s_ptr[hook(8, localid + 32)];
    s_ptr[hook(8, localid)] = sum.x = sum.x + s_ptr[hook(8, localid + 16)];
    s_ptr[hook(8, localid)] = sum.x = sum.x + s_ptr[hook(8, localid + 8)];
    s_ptr[hook(8, localid)] = sum.x = sum.x + s_ptr[hook(8, localid + 4)];
    s_ptr[hook(8, localid)] = sum.x = sum.x + s_ptr[hook(8, localid + 2)];
    sum.x = sum.x + s_ptr[hook(8, localid + 1)];

    s_ptr[hook(8, localid)] = sum.y;
    barrier(0x01);
    if (localid < 64)
      s_ptr[hook(8, localid)] = sum.y = sum.y + s_ptr[hook(8, localid + 64)];
    barrier(0x01);
    s_ptr[hook(8, localid)] = sum.y = sum.y + s_ptr[hook(8, localid + 32)];
    s_ptr[hook(8, localid)] = sum.y = sum.y + s_ptr[hook(8, localid + 16)];
    s_ptr[hook(8, localid)] = sum.y = sum.y + s_ptr[hook(8, localid + 8)];
    s_ptr[hook(8, localid)] = sum.y = sum.y + s_ptr[hook(8, localid + 4)];
    s_ptr[hook(8, localid)] = sum.y = sum.y + s_ptr[hook(8, localid + 2)];
    sum.y = sum.y + s_ptr[hook(8, localid + 1)];

    s_ptr[hook(8, localid)] = sum.z;
    barrier(0x01);
    if (localid < 64)
      s_ptr[hook(8, localid)] = sum.z = sum.z + s_ptr[hook(8, localid + 64)];
    barrier(0x01);
    s_ptr[hook(8, localid)] = sum.z = sum.z + s_ptr[hook(8, localid + 32)];
    s_ptr[hook(8, localid)] = sum.z = sum.z + s_ptr[hook(8, localid + 16)];
    s_ptr[hook(8, localid)] = sum.z = sum.z + s_ptr[hook(8, localid + 8)];
    s_ptr[hook(8, localid)] = sum.z = sum.z + s_ptr[hook(8, localid + 4)];
    s_ptr[hook(8, localid)] = sum.z = sum.z + s_ptr[hook(8, localid + 2)];
    sum.z = sum.z + s_ptr[hook(8, localid + 1)];

    s_ptr[hook(8, localid)] = sum.w;
    barrier(0x01);
    if (localid < 64)
      s_ptr[hook(8, localid)] = sum.w = sum.w + s_ptr[hook(8, localid + 64)];
    barrier(0x01);
    s_ptr[hook(8, localid)] = sum.w = sum.w + s_ptr[hook(8, localid + 32)];
    s_ptr[hook(8, localid)] = sum.w = sum.w + s_ptr[hook(8, localid + 16)];
    s_ptr[hook(8, localid)] = sum.w = sum.w + s_ptr[hook(8, localid + 8)];
    s_ptr[hook(8, localid)] = sum.w = sum.w + s_ptr[hook(8, localid + 4)];
    s_ptr[hook(8, localid)] = sum.w = sum.w + s_ptr[hook(8, localid + 2)];
    sum.w = sum.w + s_ptr[hook(8, localid + 1)];

    if (localid == 0)
      result[hook(4, row)] += sum;
  }
}
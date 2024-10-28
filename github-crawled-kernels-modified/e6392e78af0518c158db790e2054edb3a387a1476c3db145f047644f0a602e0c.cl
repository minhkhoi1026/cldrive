//{"A":5,"A[idX]":4,"B":7,"B[idX]":6,"B[k2 + 1]":9,"B[k2 + 2]":10,"B[k2 + 3]":11,"B[k2]":8,"mat1":0,"mat2":1,"pitch":3,"result":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void matrix_multiply_block(global float* mat1, global float* mat2, global float* result, unsigned int pitch) {
  const int i = get_group_id(0);
  const int j = get_group_id(1);

  const int idX = get_local_id(0);
  const int idY = get_local_id(1);

  int p = get_global_size(0);
  int r = get_global_size(1);

  const int numSubMat = pitch / 16;
  float4 resp = (float4)(0, 0, 0, 0);
  local float A[16][16];
  local float B[16][16];
  for (int k = 0; k < numSubMat; k++) {
    A[hook(5, idX)][hook(4, idY)] = mat1[hook(0, 16 * i + idX + p * (16 * k + idY))];
    B[hook(7, idX)][hook(6, idY)] = mat2[hook(1, 16 * k + idX + pitch * (16 * j + idY))];
    barrier(0x01);
    for (int k2 = 0; k2 < 16; k2 += 4) {
      float4 temp1 = (float4)(A[hook(5, idX)][hook(4, k2)], A[hook(5, idX)][hook(4, k2 + 1)], A[hook(5, idX)][hook(4, k2 + 2)], A[hook(5, idX)][hook(4, k2 + 3)]);
      float4 temp2 = (float4)(B[hook(7, k2)][hook(8, idY)], B[hook(7, k2 + 1)][hook(9, idY)], B[hook(7, k2 + 2)][hook(10, idY)], B[hook(7, k2 + 3)][hook(11, idY)]);
      resp += temp1 * temp2;
    }
    barrier(0x01);
  }
  result[hook(2, 16 * i + idX + p * (16 * j + idY))] = resp.x + resp.y + resp.z + resp.w;
}
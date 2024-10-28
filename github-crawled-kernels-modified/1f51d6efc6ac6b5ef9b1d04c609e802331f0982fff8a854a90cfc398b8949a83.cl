//{"a":0,"aTile":4,"b":1,"bTile":5,"c":2,"size":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void MultBlockLocalTransposed(global const float4* a, global const float4* b, global float4* c, unsigned int size, local float4* aTile, local float4* bTile) {
  int tilePos = get_local_id(0) + (get_local_id(1) * 64) * get_local_size(0);

  int globalPosC = (get_global_id(1) * 64) * get_global_size(0) + get_global_id(0);

  float4 sum0 = (float4)(0);
  float4 sum1 = (float4)(0);
  float4 sum2 = (float4)(0);
  float4 sum3 = (float4)(0);

  int size4 = size / 4;

  for (int tileIndex = 0; tileIndex < (size4 / get_local_size(0)); tileIndex++) {
    int globalPosA = (get_global_id(1) * 64) * get_global_size(0) + tileIndex * get_local_size(0) + get_local_id(0);

    int globalPosB = ((tileIndex * get_local_size(1) + get_local_id(1)) * 64) * get_global_size(0) + get_global_id(0);

    aTile[hook(4, tilePos + 0 * get_local_size(0))] = a[hook(0, globalPosA + 0 * size4)];
    aTile[hook(4, tilePos + 1 * get_local_size(0))] = a[hook(0, globalPosA + 1 * size4)];
    aTile[hook(4, tilePos + 2 * get_local_size(0))] = a[hook(0, globalPosA + 2 * size4)];
    aTile[hook(4, tilePos + 3 * get_local_size(0))] = a[hook(0, globalPosA + 3 * size4)];

    float4 bFromGlobal0 = b[hook(1, globalPosB + 0 * size4)];
    float4 bFromGlobal1 = b[hook(1, globalPosB + 1 * size4)];
    float4 bFromGlobal2 = b[hook(1, globalPosB + 2 * size4)];
    float4 bFromGlobal3 = b[hook(1, globalPosB + 3 * size4)];

    bTile[hook(5, tilePos + 0 * get_local_size(0))] = (float4)(bFromGlobal0.s0, bFromGlobal1.s0, bFromGlobal2.s0, bFromGlobal3.s0);
    bTile[hook(5, tilePos + 1 * get_local_size(0))] = (float4)(bFromGlobal0.s1, bFromGlobal1.s1, bFromGlobal2.s1, bFromGlobal3.s1);
    bTile[hook(5, tilePos + 2 * get_local_size(0))] = (float4)(bFromGlobal0.s2, bFromGlobal1.s2, bFromGlobal2.s2, bFromGlobal3.s2);
    bTile[hook(5, tilePos + 3 * get_local_size(0))] = (float4)(bFromGlobal0.s3, bFromGlobal1.s3, bFromGlobal2.s3, bFromGlobal3.s3);

    barrier(0x01);

    for (int j = 0; j < get_local_size(0); j++) {
      float4 tempA0 = aTile[hook(4, j + (get_local_id(1) * 64 + 0) * get_local_size(0))];
      float4 tempA1 = aTile[hook(4, j + (get_local_id(1) * 64 + 1) * get_local_size(0))];
      float4 tempA2 = aTile[hook(4, j + (get_local_id(1) * 64 + 2) * get_local_size(0))];
      float4 tempA3 = aTile[hook(4, j + (get_local_id(1) * 64 + 3) * get_local_size(0))];

      float4 tempB0 = bTile[hook(5, get_local_id(0) + (j * 64 + 0) * get_local_size(0))];
      float4 tempB1 = bTile[hook(5, get_local_id(0) + (j * 64 + 1) * get_local_size(0))];
      float4 tempB2 = bTile[hook(5, get_local_id(0) + (j * 64 + 2) * get_local_size(0))];
      float4 tempB3 = bTile[hook(5, get_local_id(0) + (j * 64 + 3) * get_local_size(0))];

      sum0.s0 += dot(tempA0, tempB0);
      sum0.s1 += dot(tempA0, tempB1);
      sum0.s2 += dot(tempA0, tempB2);
      sum0.s3 += dot(tempA0, tempB3);

      sum1.s0 += dot(tempA1, tempB0);
      sum1.s1 += dot(tempA1, tempB1);
      sum1.s2 += dot(tempA1, tempB2);
      sum1.s3 += dot(tempA1, tempB3);

      sum2.s0 += dot(tempA2, tempB0);
      sum2.s1 += dot(tempA2, tempB1);
      sum2.s2 += dot(tempA2, tempB2);
      sum2.s3 += dot(tempA2, tempB3);

      sum3.s0 += dot(tempA3, tempB0);
      sum3.s1 += dot(tempA3, tempB1);
      sum3.s2 += dot(tempA3, tempB2);
      sum3.s3 += dot(tempA3, tempB3);
    }
    barrier(0x01);
  }

  c[hook(2, globalPosC + 0 * get_global_size(0))] = sum0;
  c[hook(2, globalPosC + 1 * get_global_size(0))] = sum1;
  c[hook(2, globalPosC + 2 * get_global_size(0))] = sum2;
  c[hook(2, globalPosC + 3 * get_global_size(0))] = sum3;
}
//{"a":0,"b":1,"c":2,"n":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void MultBlocks(global float4* a, global float4* b, global float4* c, unsigned int n) {
  unsigned int col = get_global_id(0);
  unsigned int row = get_global_id(1);
  unsigned int n4 = n / 4;

  if (row >= n4 || col >= n4)
    return;

  float4 sum0 = (float4)(0.0f);
  float4 sum1 = (float4)(0.0f);
  float4 sum2 = (float4)(0.0f);
  float4 sum3 = (float4)(0.0f);

  for (unsigned int i = 0; i < n4; i++) {
    float4 blA0 = a[hook(0, (row * 4 + 0) * n4 + i)];
    float4 blA1 = a[hook(0, (row * 4 + 1) * n4 + i)];
    float4 blA2 = a[hook(0, (row * 4 + 2) * n4 + i)];
    float4 blA3 = a[hook(0, (row * 4 + 3) * n4 + i)];
    float4 blB0 = b[hook(1, (i * 4 + 0) * n4 + col)];
    float4 blB1 = b[hook(1, (i * 4 + 1) * n4 + col)];
    float4 blB2 = b[hook(1, (i * 4 + 2) * n4 + col)];
    float4 blB3 = b[hook(1, (i * 4 + 3) * n4 + col)];

    sum0.x += blA0.x * blB0.x + blA0.y * blB1.x + blA0.z * blB2.x + blA0.w * blB3.x;
    sum0.y += blA0.x * blB0.y + blA0.y * blB1.y + blA0.z * blB2.y + blA0.w * blB3.y;
    sum0.z += blA0.x * blB0.z + blA0.y * blB1.z + blA0.z * blB2.z + blA0.w * blB3.z;
    sum0.w += blA0.x * blB0.w + blA0.y * blB1.w + blA0.z * blB2.w + blA0.w * blB3.w;
    sum1.x += blA1.x * blB0.x + blA1.y * blB1.x + blA1.z * blB2.x + blA1.w * blB3.x;
    sum1.y += blA1.x * blB0.y + blA1.y * blB1.y + blA1.z * blB2.y + blA1.w * blB3.y;
    sum1.z += blA1.x * blB0.z + blA1.y * blB1.z + blA1.z * blB2.z + blA1.w * blB3.z;
    sum1.w += blA1.x * blB0.w + blA1.y * blB1.w + blA1.z * blB2.w + blA1.w * blB3.w;
    sum2.x += blA2.x * blB0.x + blA2.y * blB1.x + blA2.z * blB2.x + blA2.w * blB3.x;
    sum2.y += blA2.x * blB0.y + blA2.y * blB1.y + blA2.z * blB2.y + blA2.w * blB3.y;
    sum2.z += blA2.x * blB0.z + blA2.y * blB1.z + blA2.z * blB2.z + blA2.w * blB3.z;
    sum2.w += blA2.x * blB0.w + blA2.y * blB1.w + blA2.z * blB2.w + blA2.w * blB3.w;
    sum3.x += blA3.x * blB0.x + blA3.y * blB1.x + blA3.z * blB2.x + blA3.w * blB3.x;
    sum3.y += blA3.x * blB0.y + blA3.y * blB1.y + blA3.z * blB2.y + blA3.w * blB3.y;
    sum3.z += blA3.x * blB0.z + blA3.y * blB1.z + blA3.z * blB2.z + blA3.w * blB3.z;
    sum3.w += blA3.x * blB0.w + blA3.y * blB1.w + blA3.z * blB2.w + blA3.w * blB3.w;
  }

  unsigned int posC = (row * 4) * n4 + col;

  c[hook(2, posC + 0 * n4)] = sum0;
  c[hook(2, posC + 1 * n4)] = sum1;
  c[hook(2, posC + 2 * n4)] = sum2;
  c[hook(2, posC + 3 * n4)] = sum3;
}
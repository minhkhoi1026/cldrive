//{"a":0,"b":1,"c":2,"size":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void MultBlock(global const float4* a, global const float4* b, global float4* c, unsigned int size) {
  int2 pos = (int2)(get_global_id(0), get_global_id(1));

  unsigned int size4 = size / 64;

  if (pos.x >= size4 || pos.y >= size4)
    return;

  float4 sum0 = (float4)(0);
  float4 sum1 = (float4)(0);
  float4 sum2 = (float4)(0);
  float4 sum3 = (float4)(0);

  for (int i = 0; i < size; i = i + 64) {
    float4 aBlock0 = a[hook(0, i / 64 + ((pos.y * 64) + 0) * size4)];
    float4 aBlock1 = a[hook(0, i / 64 + ((pos.y * 64) + 1) * size4)];
    float4 aBlock2 = a[hook(0, i / 64 + ((pos.y * 64) + 2) * size4)];
    float4 aBlock3 = a[hook(0, i / 64 + ((pos.y * 64) + 3) * size4)];

    float4 bBlock0 = b[hook(1, pos.x + (i + 0) * size4)];
    float4 bBlock1 = b[hook(1, pos.x + (i + 1) * size4)];
    float4 bBlock2 = b[hook(1, pos.x + (i + 2) * size4)];
    float4 bBlock3 = b[hook(1, pos.x + (i + 3) * size4)];

    sum0.x += aBlock0.x * bBlock0.x + aBlock0.y * bBlock1.x + aBlock0.z * bBlock2.x + aBlock0.w * bBlock3.x;
    sum0.y += aBlock0.x * bBlock0.y + aBlock0.y * bBlock1.y + aBlock0.z * bBlock2.y + aBlock0.w * bBlock3.y;
    sum0.z += aBlock0.x * bBlock0.z + aBlock0.y * bBlock1.z + aBlock0.z * bBlock2.z + aBlock0.w * bBlock3.z;
    sum0.w += aBlock0.x * bBlock0.w + aBlock0.y * bBlock1.w + aBlock0.z * bBlock2.w + aBlock0.w * bBlock3.w;

    sum1.x += aBlock1.x * bBlock0.x + aBlock1.y * bBlock1.x + aBlock1.z * bBlock2.x + aBlock1.w * bBlock3.x;
    sum1.y += aBlock1.x * bBlock0.y + aBlock1.y * bBlock1.y + aBlock1.z * bBlock2.y + aBlock1.w * bBlock3.y;
    sum1.z += aBlock1.x * bBlock0.z + aBlock1.y * bBlock1.z + aBlock1.z * bBlock2.z + aBlock1.w * bBlock3.z;
    sum1.w += aBlock1.x * bBlock0.w + aBlock1.y * bBlock1.w + aBlock1.z * bBlock2.w + aBlock1.w * bBlock3.w;

    sum2.x += aBlock2.x * bBlock0.x + aBlock2.y * bBlock1.x + aBlock2.z * bBlock2.x + aBlock2.w * bBlock3.x;
    sum2.y += aBlock2.x * bBlock0.y + aBlock2.y * bBlock1.y + aBlock2.z * bBlock2.y + aBlock2.w * bBlock3.y;
    sum2.z += aBlock2.x * bBlock0.z + aBlock2.y * bBlock1.z + aBlock2.z * bBlock2.z + aBlock2.w * bBlock3.z;
    sum2.w += aBlock2.x * bBlock0.w + aBlock2.y * bBlock1.w + aBlock2.z * bBlock2.w + aBlock2.w * bBlock3.w;

    sum3.x += aBlock3.x * bBlock0.x + aBlock3.y * bBlock1.x + aBlock3.z * bBlock2.x + aBlock3.w * bBlock3.x;
    sum3.y += aBlock3.x * bBlock0.y + aBlock3.y * bBlock1.y + aBlock3.z * bBlock2.y + aBlock3.w * bBlock3.y;
    sum3.z += aBlock3.x * bBlock0.z + aBlock3.y * bBlock1.z + aBlock3.z * bBlock2.z + aBlock3.w * bBlock3.z;
    sum3.w += aBlock3.x * bBlock0.w + aBlock3.y * bBlock1.w + aBlock3.z * bBlock2.w + aBlock3.w * bBlock3.w;
  }

  c[hook(2, pos.x + ((pos.y * 64) + 0) * size4)] = sum0;
  c[hook(2, pos.x + ((pos.y * 64) + 1) * size4)] = sum1;
  c[hook(2, pos.x + ((pos.y * 64) + 2) * size4)] = sum2;
  c[hook(2, pos.x + ((pos.y * 64) + 3) * size4)] = sum3;
}
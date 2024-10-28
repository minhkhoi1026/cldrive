//{"float4":1,"mat4":0,"outvec4":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kern(global float* mat4, global float* float4, global float* outvec4) {
  outvec4[hook(2, 0)] = float4[hook(1, 3)] * mat4[hook(0, 12)];
  outvec4[hook(2, 1)] = float4[hook(1, 3)] * mat4[hook(0, 13)];
  outvec4[hook(2, 2)] = float4[hook(1, 3)] * mat4[hook(0, 14)];
  outvec4[hook(2, 3)] = float4[hook(1, 3)] * mat4[hook(0, 15)];

  outvec4[hook(2, 0)] += float4[hook(1, 2)] * mat4[hook(0, 8)];
  outvec4[hook(2, 1)] += float4[hook(1, 2)] * mat4[hook(0, 9)];
  outvec4[hook(2, 2)] += float4[hook(1, 2)] * mat4[hook(0, 10)];
  outvec4[hook(2, 3)] += float4[hook(1, 2)] * mat4[hook(0, 11)];

  outvec4[hook(2, 0)] += float4[hook(1, 1)] * mat4[hook(0, 4)];
  outvec4[hook(2, 1)] += float4[hook(1, 1)] * mat4[hook(0, 5)];
  outvec4[hook(2, 2)] += float4[hook(1, 1)] * mat4[hook(0, 6)];
  outvec4[hook(2, 3)] += float4[hook(1, 1)] * mat4[hook(0, 7)];

  outvec4[hook(2, 0)] += float4[hook(1, 0)] * mat4[hook(0, 0)];
  outvec4[hook(2, 1)] += float4[hook(1, 0)] * mat4[hook(0, 1)];
  outvec4[hook(2, 2)] += float4[hook(1, 0)] * mat4[hook(0, 2)];
  outvec4[hook(2, 3)] += float4[hook(1, 0)] * mat4[hook(0, 3)];
}
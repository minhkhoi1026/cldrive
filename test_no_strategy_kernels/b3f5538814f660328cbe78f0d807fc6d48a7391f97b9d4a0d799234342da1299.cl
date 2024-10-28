//{"matrix":1,"numElements":2,"outputBuffer":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void applyTransform(global float* outputBuffer, global float* matrix, int numElements) {
  int iGID = get_global_id(0);

  if (iGID >= numElements) {
    return;
  }
  float4 point = (float4){outputBuffer[hook(0, (iGID * 3))], outputBuffer[hook(0, (iGID * 3) + 1)], outputBuffer[hook(0, (iGID * 3) + 2)], 1.0f};
  float4 row1 = (float4){matrix[hook(1, 0)], matrix[hook(1, 1)], matrix[hook(1, 2)], matrix[hook(1, 3)]};
  float4 row2 = (float4){matrix[hook(1, 4)], matrix[hook(1, 5)], matrix[hook(1, 6)], matrix[hook(1, 7)]};
  float4 row3 = (float4){matrix[hook(1, 8)], matrix[hook(1, 9)], matrix[hook(1, 10)], matrix[hook(1, 11)]};
  float4 row4 = (float4){matrix[hook(1, 12)], matrix[hook(1, 13)], matrix[hook(1, 14)], matrix[hook(1, 15)]};
  float h = dot(row4, point);
  outputBuffer[hook(0, (iGID * 3))] = (dot(row1, point) / h);
  outputBuffer[hook(0, (iGID * 3) + 1)] = (dot(row2, point) / h);
  outputBuffer[hook(0, (iGID * 3) + 2)] = (dot(row3, point) / h);
}
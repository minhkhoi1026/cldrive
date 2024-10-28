//{"buffer":1,"bufferSize":2,"longBuffer":0,"numBuffers":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void reduceForces(global long* restrict longBuffer, global float4* restrict buffer, int bufferSize, int numBuffers) {
  int totalSize = bufferSize * numBuffers;
  float scale = 1 / (float)0x100000000;
  for (int index = get_global_id(0); index < bufferSize; index += get_global_size(0)) {
    float4 sum = (float4)0;

    for (int i = index; i < totalSize; i += bufferSize)
      sum += buffer[hook(1, i)];
    buffer[hook(1, index)] = sum;
    longBuffer[hook(0, index)] = (long)(sum.x * 0x100000000);
    longBuffer[hook(0, index + bufferSize)] = (long)(sum.y * 0x100000000);
    longBuffer[hook(0, index + 2 * bufferSize)] = (long)(sum.z * 0x100000000);
  }
}
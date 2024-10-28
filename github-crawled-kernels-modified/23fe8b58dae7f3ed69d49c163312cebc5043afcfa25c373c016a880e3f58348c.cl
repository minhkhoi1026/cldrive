//{"buffer":0,"bufferSize":1,"numBuffers":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void reduceReal4Buffer(global float4* restrict buffer, int bufferSize, int numBuffers) {
  int index = get_global_id(0);
  int totalSize = bufferSize * numBuffers;
  while (index < bufferSize) {
    float4 sum = buffer[hook(0, index)];
    for (int i = index + bufferSize; i < totalSize; i += bufferSize)
      sum += buffer[hook(0, i)];
    buffer[hook(0, index)] = sum;
    index += get_global_size(0);
  }
}
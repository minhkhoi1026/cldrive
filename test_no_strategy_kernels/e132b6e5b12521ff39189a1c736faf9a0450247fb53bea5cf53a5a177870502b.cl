//{"currentPos":0,"filterOrder":1,"output":3,"workBuffer":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void mapToOutput(int currentPos, int filterOrder, global float* workBuffer, global float* output) {
  int idx = get_global_id(0);
  int dataIndex = (currentPos % filterOrder) + idx * filterOrder;
  output[hook(3, idx)] = workBuffer[hook(2, dataIndex)];
}
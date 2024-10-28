//{"filterOrder":2,"inputBuff":0,"output":5,"outputLen":6,"posBuff":1,"table":3,"workBuffer":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void bufferedFilter2(global float* inputBuff, global int* posBuff, int filterOrder, global float* table, global float* workBuffer, global float* output, int outputLen) {
  int idx = get_global_id(0);
  int flt = idx / filterOrder;
  int pos = idx % filterOrder;
  int currentPos = posBuff[hook(1, 0)];
  int outputPos = posBuff[hook(1, 1)];
  int index = (pos + currentPos) % filterOrder;
  float input = inputBuff[hook(0, outputPos)];
  float value = table[hook(3, pos)] * input;
  index = flt * filterOrder + index;
  float oldval = workBuffer[hook(4, index)];
  if (pos != (filterOrder - 1))
    value += oldval;
  workBuffer[hook(4, index)] = value;
  if (pos == 0)
    output[hook(5, flt * outputLen + outputPos)] = workBuffer[hook(4, index)];
}
//{"currentPos":1,"filterOrder":2,"input":0,"output":5,"outputLen":7,"outputPos":6,"table":3,"workBuffer":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void bufferedFilter(float input, int currentPos, int filterOrder, global float* table, global float* workBuffer, global float* output, int outputPos, int outputLen) {
  int idx = get_global_id(0);
  int flt = idx / filterOrder;
  int pos = idx % filterOrder;
  int index = (pos + currentPos) % filterOrder;
  float value = table[hook(3, flt * filterOrder + pos)] * input;
  index = flt * filterOrder + index;
  float oldval = workBuffer[hook(4, index)];
  if (pos != (filterOrder - 1))
    value += oldval;
  workBuffer[hook(4, index)] = value;
  if (pos == 0)
    output[hook(5, flt * outputLen + outputPos)] = workBuffer[hook(4, index)];
}
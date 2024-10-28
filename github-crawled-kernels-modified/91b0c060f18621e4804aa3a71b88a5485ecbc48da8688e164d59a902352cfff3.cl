//{"currentPos":1,"filterOrder":2,"input":0,"output":5,"table":3,"workBuffer":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void filter(float input, int currentPos, int filterOrder, global float* table, global float* workBuffer, global float* output) {
  int idx = get_global_id(0);
  int flt = idx / filterOrder;
  int pos = idx % filterOrder;
  int index = (pos + currentPos) % filterOrder;
  float value = table[hook(3, flt * filterOrder + pos)] * input;
  if (pos == (filterOrder - 1))
    workBuffer[hook(4, flt * filterOrder + index)] = value;
  else
    workBuffer[hook(4, flt * filterOrder + index)] += value;
  if (pos == 0)
    output[hook(5, flt)] = workBuffer[hook(4, flt * filterOrder + index)];
}
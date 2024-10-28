//{"currentPos":2,"filterOrder":3,"table":1,"workBuffer":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void stage2(global float* workBuffer, global float* table, int currentPos, int filterOrder) {
  int idx = get_global_id(0);
  int flt = idx / (filterOrder - 1);
  int pos = idx % (filterOrder - 1);
  pos += 1;
  int index = (pos + currentPos) % filterOrder;
  float y = workBuffer[hook(0, flt * filterOrder + currentPos)];
  int ind = flt * filterOrder + index;
  workBuffer[hook(0, ind)] -= y * table[hook(1, flt * filterOrder + pos)];
}
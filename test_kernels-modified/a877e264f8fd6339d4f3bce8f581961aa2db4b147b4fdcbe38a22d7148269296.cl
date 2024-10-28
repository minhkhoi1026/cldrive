//{"N":6,"currentPos":1,"filterOrder":2,"input":0,"lock":7,"output":5,"table":3,"workBuffer":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void waitOthers(volatile global int* lock, int itemCount, bool even) {
  if (even) {
    atomic_inc(lock);
    while (*lock < itemCount)
      ;
  } else {
    atomic_dec(lock);
    while (*lock > 0)
      ;
  }
}

kernel void filter(global float* input, int currentPos, int filterOrder, global float* table, global float* workBuffer, global float* output, int N, volatile global int* lock) {
  int idx = get_global_id(0);
  int flt = idx / filterOrder;
  int pos = idx % filterOrder;
  lock[hook(7, flt)] = 0;
  bool even = true;
  for (int i = 0; i < N; i++) {
    int index = (pos + currentPos + i) % filterOrder;
    float value = table[hook(3, pos)] * input[hook(0, flt * N + i)];
    if (pos == (filterOrder - 1))
      workBuffer[hook(4, flt * filterOrder + index)] = value;
    else
      workBuffer[hook(4, flt * filterOrder + index)] += value;
    if (pos == 0)
      output[hook(5, flt * N + i)] = workBuffer[hook(4, flt * filterOrder + index)];

    waitOthers(&lock[hook(7, flt)], filterOrder, even);

    even = !even;
  }
}
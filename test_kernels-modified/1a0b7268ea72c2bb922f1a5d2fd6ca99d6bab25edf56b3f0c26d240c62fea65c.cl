//{"N":5,"filterOrder":2,"input":1,"lastInput":0,"output":4,"table":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void bufferedFilter2(global float* lastInput, global float* input, int filterOrder, global float* table, global float* output, int N) {
  int idx = get_global_id(0);
  int flt = idx / N;
  int ind = idx % N;
  float val = 0;
  for (int i = 0; i < filterOrder; i++) {
    int index = ind - i;
    float b = table[hook(3, flt * filterOrder + i)];
    if (index < 0) {
      index += N;
      val += b * lastInput[hook(0, index)];
    } else
      val += b * input[hook(1, index)];
    index = ind + i;
    if (index < N && i > 0)
      val += b * input[hook(1, index)];
  }
  output[hook(4, idx)] = val;
}
//{"pdata":0,"prob":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
__attribute__((max_work_group_size(1000))) kernel void softmax(global float* pdata) {
  local float sum, prob[1000];
  const int x = get_global_id(0);
  prob[hook(1, x)] = exp(pdata[hook(0, x)]);

  barrier(0x01);
  if (x == 0) {
    sum = 0;
    for (int i = 0; i < get_global_size(0); i++) {
      sum += prob[hook(1, i)];
    }
  }
  barrier(0x01);

  pdata[hook(0, x)] = prob[hook(1, x)] / sum;
}
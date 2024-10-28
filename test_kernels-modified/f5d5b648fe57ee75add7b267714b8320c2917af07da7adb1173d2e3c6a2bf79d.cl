//{"pdata":0,"temp":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void softmax(global float* pdata) {
  local float sum, temp[10];
  const int x = get_local_id(0);
  temp[hook(1, x)] = exp(pdata[hook(0, x)]);

  barrier(0x01);
  if (get_local_id(0) == 0) {
    for (int i = 0; i < get_local_size(0); i++)
      sum += temp[hook(1, i)];
  }
  barrier(0x01);

  pdata[hook(0, x)] = temp[hook(1, x)] / sum;
}
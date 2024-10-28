//{"a":4,"b":3,"iLen":0,"ia":1,"w":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Softmax_fprop(int iLen, global const float* ia, global const float* w, global const float* b, global float* a) {
  int o = get_global_id(0);
  a[hook(4, o)] = 0;
  for (int i = 0; i < iLen; i++)
    a[hook(4, o)] += w[hook(2, o * iLen + i)] * ia[hook(1, i)];
  a[hook(4, o)] += b[hook(3, o)];
}
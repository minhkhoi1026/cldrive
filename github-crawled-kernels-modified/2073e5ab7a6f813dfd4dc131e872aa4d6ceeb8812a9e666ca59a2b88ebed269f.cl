//{"vert":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test(global float4* vert) {
  unsigned int n = get_global_id(0);

  if (n == 0)
    vert[hook(0, n)] = (float4)(-0.5f, 0.5f, 0.0f, 1.0f);
  else if (n == 1)
    vert[hook(0, n)] = (float4)(-0.5f, 0.0f, 0.0f, 1.0f);
  else if (n == 2)
    vert[hook(0, n)] = (float4)(0.0f, 0.0f, 0.0f, 1.0f);
}
//{"inputA":0,"inputB":1,"output":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void hello_world_vector(global int* restrict inputA, global int* restrict inputB, global int* restrict output) {
  int i = get_global_id(0);

  int4 a = vload4(i, inputA);

  int4 b = vload4(i, inputB);

  vstore4(a + b, i, output);
}
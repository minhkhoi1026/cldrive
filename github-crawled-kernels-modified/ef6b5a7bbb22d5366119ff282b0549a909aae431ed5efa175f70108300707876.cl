//{"result":0,"t.g":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
struct S0 {
  uchar f[1];
  ulong g[4];
};

kernel void entry(global ulong* result) {
  struct S0 s = {{1}, {2, 3, 4, 5}};
  struct S0 t = s;

  volatile int i = 0;
  *result = t.g[hook(1, i)];
}
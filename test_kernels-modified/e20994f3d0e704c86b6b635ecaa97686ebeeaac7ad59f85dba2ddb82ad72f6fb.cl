//{"output":0,"s.b":3,"s.b[i]":2,"s.b[i][j]":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
struct S0 {
  uchar a;
  ulong b[2][3][1];
};

kernel void multidim_array_in_struct(global ulong* output) {
  struct S0 s = {
      1UL,
      {{{1L}, {1L}, {1L}}, {{1L}, {1L}, {1L}}},
  };

  ulong c = 0UL;
  for (int i = 0; i < 2; i++)
    for (int j = 0; j < 3; j++)
      for (int k = 0; k < 1; k++)
        c += s.b[hook(3, i)][hook(2, j)][hook(1, k)];

  *output = c;
}
//{"p1":0,"p_863->g_75":3,"p_863->g_75[i]":2,"p_863->g_75[i][j]":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void transparent_crc_no_string(ulong* p1, ulong p2) {
  *p1 += p2;
}
int get_linear_global_id() {
  return (get_global_id(2) * get_global_size(1) + get_global_id(1)) * get_global_size(0) + get_global_id(0);
}
union U5 {
  short f0;
  int f3;
};
struct S6 {
  union U5 g_75[5][7][2];
  union U5** g_91[78];
};
kernel void casted_static_array(global ulong* p1) {
  int i, j, k;
  struct S6 c_864;
  struct S6* p_863 = &c_864;
  union U5* p_863_6;
  struct S6 c_865 = {{{{{0xD54EL}}}}, {&p_863_6}};
  c_864 = c_865;
  ulong crc64_context = i = 0;
  for (; i < 9; i++) {
    j = 0;
    {
      k = 0;
      { transparent_crc_no_string(&crc64_context, p_863->g_75[hook(3, i)][hook(2, j)][hook(1, k)].f0); }
    }
  }
  p1[hook(0, get_linear_global_id())] = crc64_context;
}
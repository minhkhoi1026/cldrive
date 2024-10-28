//{"M":0,"M_LEN":2,"N":1,"p_next":5,"u_next":3,"v_next":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void sw_update1(const unsigned M, const unsigned N, const unsigned M_LEN, global double* u_next, global double* v_next, global double* p_next) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  if (x < N) {
    u_next[hook(3, x)] = u_next[hook(3, M * M_LEN + x)];
    v_next[hook(4, M * M_LEN + x + 1)] = v_next[hook(4, x + 1)];
    p_next[hook(5, M * M_LEN + x)] = p_next[hook(5, x)];
  }

  if (y < M) {
    u_next[hook(3, (y + 1) * M_LEN + N)] = u_next[hook(3, (y + 1) * M_LEN)];
    v_next[hook(4, y * M_LEN)] = v_next[hook(4, y * M_LEN + N)];
    p_next[hook(5, y * M_LEN + N)] = p_next[hook(5, y * M_LEN)];
  }

  u_next[hook(3, N)] = u_next[hook(3, M * M_LEN)];
  v_next[hook(4, M * M_LEN)] = v_next[hook(4, N)];
  p_next[hook(5, M * M_LEN + N)] = p_next[hook(5, 0)];
}
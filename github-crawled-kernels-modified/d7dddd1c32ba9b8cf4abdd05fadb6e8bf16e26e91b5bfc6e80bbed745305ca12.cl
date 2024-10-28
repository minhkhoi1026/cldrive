//{"g_answer":2,"g_num":0,"g_table":1,"num_size":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compute(global unsigned char* g_num, global unsigned char* g_table, global unsigned char* g_answer, const unsigned int num_size) {
  unsigned int tid = get_global_id(0);
  if (tid < num_size) {
    unsigned char loc = g_num[hook(0, tid)];
    for (int i = 0; i < num_size - tid; i++) {
      loc = g_table[hook(1, loc)];
    }
    g_answer[hook(2, tid)] = loc;
  }
}
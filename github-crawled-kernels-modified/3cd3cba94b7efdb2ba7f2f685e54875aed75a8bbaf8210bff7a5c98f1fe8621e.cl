//{"g_answer":3,"g_num":0,"g_tables":1,"numTables":2,"num_size":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compute(global unsigned char* g_num, global unsigned char* g_tables, const unsigned int numTables, global unsigned char* g_answer, const unsigned int num_size) {
  unsigned int tid = get_global_id(0);
  if (tid < num_size) {
    int val = num_size - tid;
    int i = 0;
    unsigned char temp = g_num[hook(0, tid)];
    for (i = 0; i < numTables; i++) {
      if ((val >> i) % 2 == 1)
        temp = g_tables[hook(1, i * 256 + temp)];
    }
    g_answer[hook(3, tid)] = temp;
  }
}
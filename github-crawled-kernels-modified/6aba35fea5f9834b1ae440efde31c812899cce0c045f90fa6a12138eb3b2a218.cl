//{"a":1,"a_cols":3,"a_rows":2,"b":4,"b_cols":6,"b_rows":5,"dst":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void search_simple(global int* dst, global const char* a, int a_rows, int a_cols, global const char* b, int b_rows, int b_cols) {
  int px = get_global_id(0);
  int py = get_global_id(1);
  if (px > a_cols - b_cols || py > a_rows - b_rows)
    return;

  int have_match = 1;
  for (int r = 0; r < b_rows; ++r) {
    for (int c = 0; c < b_cols; ++c) {
      have_match &= (a[hook(1, (py + r) * a_cols + px + c)] == b[hook(4, r * b_cols + c)]);
    }
  }
  dst[hook(0, py * a_cols + px)] = have_match;
}
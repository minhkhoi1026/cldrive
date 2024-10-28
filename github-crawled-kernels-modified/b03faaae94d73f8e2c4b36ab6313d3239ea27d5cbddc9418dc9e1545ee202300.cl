//{"A":0,"ncols":2,"nrows":1,"pitch_el":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void matinit_pitch(global int* A, int nrows, int ncols, pitch_el) {
  int r = get_global_id(1);
  int c = get_global_id(0);

  if (c >= ncols)
    return;

  A[hook(0, r * pitch_el + c)] = r - c;
}
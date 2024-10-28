//{"out":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compiler_insert_vector(global int4* out) {
  int tid = get_global_id(0);
  int4 output = (int4)(0, 0, 0, 1);
  if (tid > 16) {
    output = (int4)(tid, tid, 1, 1);
  }
  out[hook(0, tid)] = output;
}
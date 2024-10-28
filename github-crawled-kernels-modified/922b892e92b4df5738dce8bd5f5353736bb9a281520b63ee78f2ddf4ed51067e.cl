//{"array":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void initializer_in_for_statement(global int* array) {
  for (int i = 0, k = 100; i < 1; i++) {
    int* ptr = (&k);
    ptr++;
  }
}
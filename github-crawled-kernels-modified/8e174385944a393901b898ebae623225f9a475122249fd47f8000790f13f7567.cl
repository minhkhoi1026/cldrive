//{}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void dummy(float (^const op)(float)) {
}

kernel void test_block() {
  float (^const X)(float) = ^(float x) {
    return x + 42.0f;
  };
  dummy(X);
}
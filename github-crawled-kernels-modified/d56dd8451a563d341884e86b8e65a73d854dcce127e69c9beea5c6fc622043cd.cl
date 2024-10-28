//{"gf1":0,"gf2":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant float cf1[] = {1, 2, 3};
constant float cf2[] = {4, 5, 6};
kernel void compiler_address_space(global float* gf1, global float* gf2) {
  local float lf1[4];
  local float lf2[4];
 private
  float pf1[4];
 private
  float pf2[4];
}
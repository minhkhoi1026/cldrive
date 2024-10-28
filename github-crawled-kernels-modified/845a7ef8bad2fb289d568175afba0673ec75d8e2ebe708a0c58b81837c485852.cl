//{"completion_code":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void ccode(global uint32_t* completion_code);
kernel void wrapper(global uint32_t* completion_code) {
  ccode(completion_code);
}
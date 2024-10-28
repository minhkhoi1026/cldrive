//{"completion_code":1,"qid":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void ccode(uint32_t qid, global uint32_t* completion_code);
kernel void wrapper(uint32_t qid, global uint32_t* completion_code) {
  ccode(qid, completion_code);
}
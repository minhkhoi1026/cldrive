//{"q1":0,"q2":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void k1(queue_t q1, queue_t q2) {
  queue_t q[] = {q1, q2};
}
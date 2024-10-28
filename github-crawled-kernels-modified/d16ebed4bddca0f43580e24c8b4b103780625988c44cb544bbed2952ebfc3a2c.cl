//{"data":0,"pred":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compact_predicate(global int* data, global int* pred) {
  int id = get_global_id(0);
  int predVal = data[hook(0, id)] < 50 ? 1 : 0;
  pred[hook(1, id)] = predVal;
}
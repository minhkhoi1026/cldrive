//{"firstPlayerHasWon":2,"nextResultIndex":1,"resultVector":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void set_results(global char* resultVector, unsigned int nextResultIndex, global bool* firstPlayerHasWon) {
  if (get_global_id(0) == 0) {
    resultVector[hook(0, nextResultIndex)] = *firstPlayerHasWon;
    resultVector[hook(0, nextResultIndex + 1)] = !*firstPlayerHasWon;
  }
}
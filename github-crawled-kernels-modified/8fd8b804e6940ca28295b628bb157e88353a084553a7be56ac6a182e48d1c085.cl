//{"inputMatrix":0,"power":2,"resultMatrix":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kPown(global const float* inputMatrix, global float* resultMatrix, int power) {
  int id = get_global_id(0);
  resultMatrix[hook(1, id)] = pown(inputMatrix[hook(0, id)], power);
}
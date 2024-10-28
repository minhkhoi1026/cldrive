//{"inputMatrix":0,"resultMatrix":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kExp2(global const float* inputMatrix, global float* resultMatrix) {
  int id = get_global_id(0);
  resultMatrix[hook(1, id)] = native_exp2(inputMatrix[hook(0, id)]);
}
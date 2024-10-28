//{"inputMatrix":0,"power":2,"resultMatrix":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kPow2(global const float* inputMatrix, global float* resultMatrix, float power) {
  int id = get_global_id(0);
  resultMatrix[hook(1, id)] = pow(power, inputMatrix[hook(0, id)]);
}
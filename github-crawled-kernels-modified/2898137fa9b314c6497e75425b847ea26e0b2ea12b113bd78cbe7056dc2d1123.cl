//{"dev_ptrA":0,"dev_ptrB":1,"dev_ptrC":2,"hA":3,"wA":4,"wB":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void matmul(global float* dev_ptrA, global float* dev_ptrB, global float* dev_ptrC, unsigned hA, unsigned wA, unsigned wB) {
  float sum = 0;
  for (unsigned k = 0; k < wA; ++k) {
    sum += dev_ptrA[hook(0, get_global_id(1) * wA + k)] * dev_ptrB[hook(1, k * wB + get_global_id(0))];
  }
  dev_ptrC[hook(2, get_global_id(1) * wB + get_global_id(0))] = sum;
}
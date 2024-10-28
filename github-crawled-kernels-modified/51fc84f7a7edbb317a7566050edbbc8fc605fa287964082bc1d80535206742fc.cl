//{"inputA":1,"inputB":2,"output":3,"widthA":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void matrix_multiplication(unsigned int widthA, global const float* inputA, global const float* inputB, global float* output) {
  int i = get_global_id(0);
  int j = get_global_id(1);

  int outputWidth = get_global_size(0);
  int outputHeight = get_global_size(1);
  int widthB = outputWidth;

  float total = 0.0;
  for (int k = 0; k < widthA; ++k) {
    total += inputA[hook(1, j * widthA + k)] * inputB[hook(2, k * widthB + i)];
  }
  output[hook(3, j * outputWidth + i)] = total;
}
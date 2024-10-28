//{"heightA":2,"heightB":4,"inputA":5,"inputB":6,"outputC":0,"widthA":1,"widthB":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void simpleMultiply(global float* outputC, int widthA, int heightA, int widthB, int heightB, global float* inputA, global float* inputB) {
  int row = get_global_id(1);

  int col = get_global_id(0);

  float sum = 0.0f;

  for (int i = 0; i < widthA; i++) {
    sum += inputA[hook(5, row * widthA + i)] * inputB[hook(6, i * widthB + col)];
  }

  outputC[hook(0, row * widthB + col)] = sum;
}
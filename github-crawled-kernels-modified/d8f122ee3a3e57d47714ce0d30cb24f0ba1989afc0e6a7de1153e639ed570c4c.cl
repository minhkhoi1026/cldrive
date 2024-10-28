//{"A":0,"B":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void avg_filterND(global const uchar* A, global uchar* B) {
  int width = get_global_size(0);
  int height = get_global_size(1);
  int image_size = width * height;
  int channels = get_global_size(2);

  int x = get_global_id(0);
  int y = get_global_id(1);
  int c = get_global_id(2);

  int id = x + y * width + c * image_size;

  unsigned int result = 0;

  if ((x == 0) || (x == width - 1) || (y == 0) || (y == height - 1)) {
    result = A[hook(0, id)];
  } else {
    for (int i = (x - 1); i <= (x + 1); i++)
      for (int j = (y - 1); j <= (y + 1); j++)
        result += A[hook(0, i + j * width + c * image_size)];

    result /= 9;
  }

  B[hook(1, id)] = (uchar)result;
}
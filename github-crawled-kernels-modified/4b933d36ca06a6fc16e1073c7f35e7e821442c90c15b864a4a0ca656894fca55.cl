//{"columns":1,"matrix":2,"result":3,"rows":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline int modulo(int a, int b) {
  const int result = a % b;
  return result >= 0 ? result : result + b;
}

kernel void gameOfLifeKernel(int rows, int columns, global int* matrix, global int* result) {
  int globalId = get_global_id(0);

  short neighbors = 0;

  int x = globalId % columns;
  int y = globalId / columns;

  if (matrix[hook(2, modulo(x - 1, columns) + y * columns)] == 1)
    neighbors++;
  if (matrix[hook(2, modulo(x + 1, columns) + y * columns)] == 1)
    neighbors++;
  if (matrix[hook(2, x + modulo(y - 1, rows) * columns)] == 1)
    neighbors++;
  if (matrix[hook(2, x + modulo(y + 1, rows) * columns)] == 1)
    neighbors++;
  if (matrix[hook(2, modulo(x + 1, columns) + modulo(y + 1, rows) * columns)] == 1)
    neighbors++;
  if (matrix[hook(2, modulo(x + 1, columns) + modulo(y - 1, rows) * columns)] == 1)
    neighbors++;
  if (matrix[hook(2, modulo(x - 1, columns) + modulo(y + 1, rows) * columns)] == 1)
    neighbors++;
  if (matrix[hook(2, modulo(x - 1, columns) + modulo(y - 1, rows) * columns)] == 1)
    neighbors++;

  if (matrix[hook(2, globalId)] == 0) {
    if (neighbors == 3)
      result[hook(3, globalId)] = 1;
    else
      result[hook(3, globalId)] = 0;
  } else if (matrix[hook(2, globalId)] == 1) {
    if (neighbors < 2)
      result[hook(3, globalId)] = 0;
    else if (neighbors == 2 || neighbors == 3)
      result[hook(3, globalId)] = 1;
    else if (neighbors > 3)
      result[hook(3, globalId)] = 0;
    ;
  }
}
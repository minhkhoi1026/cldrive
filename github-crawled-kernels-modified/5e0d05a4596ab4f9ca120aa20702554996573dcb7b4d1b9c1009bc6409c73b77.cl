//{"rij":5,"string_x":1,"string_x_length":3,"string_y":2,"string_y_length":4,"table":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel1(global int* table, global char* string_x, global char* string_y, int string_x_length, int string_y_length, int rij) {
  const int id = get_global_id(0);
  int x, y, width;
  width = string_y_length + 1;
  if ((rij < string_x_length) && (rij < string_y_length)) {
    x = id;
    y = rij - id;
  } else {
    x = string_y_length - id;
    y = (rij)-x;
  }
  if (x != 0 && y != 00) {
    if (string_x[hook(1, x - 1)] == string_y[hook(2, y - 1)]) {
      table[hook(0, x + y * width)] = table[hook(0, (x - 1) + (y - 1) * width)] + 1;
    } else {
      if (table[hook(0, (x - 1) + (y) * width)] > table[hook(0, (x) + (y - 1) * width)]) {
        table[hook(0, (x) + (y) * width)] = table[hook(0, (x - 1) + (y) * width)];
      } else {
        table[hook(0, (x) + (y) * width)] = table[hook(0, (x) + (y - 1) * width)];
      }
    }
  }
}
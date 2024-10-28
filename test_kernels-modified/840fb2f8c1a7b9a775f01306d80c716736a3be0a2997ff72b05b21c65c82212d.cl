//{"length1":7,"length2":8,"max1":5,"max2":6,"min1":3,"min2":4,"string_1":1,"string_2":2,"table":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel2(global int* table, global char* string_1, global char* string_2, int min1, int min2, int max1, int max2, int length1, int length2) {
  const int id = get_global_id(0);

  int x = min1 + 1 + id;
  int y = min2 + 1 - id;
  for (int i = 0; i < (2 * (max1 - min1)); i++) {
    if ((x > min1) && (x <= max1) && (y > min2) && (y <= max2)) {
      if (string_1[hook(1, x - 1)] == string_2[hook(2, y - 1)]) {
        table[hook(0, x + y * (length1 + 1))] = table[hook(0, (x - 1) + (y - 1) * (length1 + 1))] + 1;

      } else {
        if (table[hook(0, (x - 1) + (y) * (length1 + 1))] > table[hook(0, (x) + (y - 1) * (length1 + 1))]) {
          table[hook(0, (x) + (y) * (length1 + 1))] = table[hook(0, (x - 1) + (y) * (length1 + 1))];

        } else {
          table[hook(0, (x) + (y) * (length1 + 1))] = table[hook(0, (x) + (y - 1) * (length1 + 1))];
        }
      }
    }
    y++;
    barrier(0x01 | 0x02);
  }
}
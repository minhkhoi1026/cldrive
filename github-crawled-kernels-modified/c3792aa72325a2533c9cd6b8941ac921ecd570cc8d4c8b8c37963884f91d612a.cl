//{"chars_per_item":2,"global_result":4,"local_result":3,"pattern":0,"text":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void string_search(char16 pattern, global char* text, int chars_per_item, local int* local_result, global int* global_result) {
  char16 text_vector, check_vector;

  local_result[hook(3, 0)] = 0;
  local_result[hook(3, 1)] = 0;
  local_result[hook(3, 2)] = 0;
  local_result[hook(3, 3)] = 0;

  barrier(0x01);

  int item_offset = get_global_id(0) * chars_per_item;

  for (int i = item_offset; i < item_offset + chars_per_item; i++) {
    text_vector = vload16(0, text + i);

    check_vector = text_vector == pattern;

    if (all(check_vector.s0123))
      atomic_inc(local_result);

    if (all(check_vector.s4567))
      atomic_inc(local_result + 1);

    if (all(check_vector.s89AB))
      atomic_inc(local_result + 2);

    if (all(check_vector.sCDEF))
      atomic_inc(local_result + 3);
  }

  barrier(0x02);

  if (get_local_id(0) == 0) {
    atomic_add(global_result, local_result[hook(3, 0)]);
    atomic_add(global_result + 1, local_result[hook(3, 1)]);
    atomic_add(global_result + 2, local_result[hook(3, 2)]);
    atomic_add(global_result + 3, local_result[hook(3, 3)]);
  }
}
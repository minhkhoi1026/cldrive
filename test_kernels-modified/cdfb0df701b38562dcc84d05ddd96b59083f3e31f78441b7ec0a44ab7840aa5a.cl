//{"binary_length":6,"infected_str":2,"local_symbol":9,"node_state":1,"node_symbol":0,"result_group_wb":4,"result_wb":5,"search_length_wg":8,"symbol":10,"symbol_length":7,"symbol_wb":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
int compare(global const uchar* infected_str, local const uchar* symbol, unsigned int length) {
  for (unsigned int count_length = 0; count_length < length; ++count_length) {
    if (infected_str[hook(2, count_length)] != symbol[hook(10, count_length)])
      return 0;
  }
  return 1;
}

kernel void actire_search(global uchar* node_symbol, global int* node_state, global uchar* infected_str, global uchar* symbol_wb, global int* result_group_wb, global int* result_wb, const int binary_length, const int symbol_length, const int search_length_wg, local uchar* local_symbol) {
  local volatile unsigned int group_success_counter;

  int local_idx = get_local_id(0);
  int local_size = get_local_size(0);
  int group_idx = get_group_id(0);

  unsigned int last_search_idx = binary_length - search_length_wg + 1;

  unsigned int begin_search_idx = group_idx * search_length_wg;
  unsigned int end_search_idx = begin_search_idx + search_length_wg;

  if (begin_search_idx > last_search_idx)
    return;
  if (end_search_idx > last_search_idx)
    end_search_idx = last_search_idx;

  for (int idx = local_idx; idx < symbol_length; idx += local_size) {
    local_symbol[hook(9, idx)] = node_symbol[hook(0, idx)];
  }

  if (local_idx == 0)
    group_success_counter = 0;

  barrier(0x01);

  for (unsigned int string_pos = begin_search_idx + local_idx; string_pos < end_search_idx; string_pos += local_size) {
    if (compare(infected_str + string_pos, local_symbol, symbol_length) == 1) {
      int count = atomic_inc(&group_success_counter);
      result_wb[hook(5, begin_search_idx + count)] = string_pos;
    }
  }

  barrier(0x01);
  if (local_idx == 0)
    result_group_wb[hook(4, group_idx)] = group_success_counter;
}
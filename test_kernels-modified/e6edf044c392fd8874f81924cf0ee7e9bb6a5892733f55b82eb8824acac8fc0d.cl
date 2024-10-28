//{"coords":0,"elements":1,"group_boundaries":2,"inter_results":6,"option":4,"result":3,"shared_rows":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void row_info_extractor(global const uint2* coords, global const float* elements, global const unsigned int* group_boundaries, global float* result, unsigned int option, local unsigned int* shared_rows, local float* inter_results) {
  uint2 tmp;
  float val;
  unsigned int last_index = get_local_size(0) - 1;
  unsigned int group_start = group_boundaries[hook(2, get_group_id(0))];
  unsigned int group_end = group_boundaries[hook(2, get_group_id(0) + 1)];
  unsigned int k_end = (group_end > group_start) ? 1 + (group_end - group_start - 1) / get_local_size(0) : 0;

  unsigned int local_index = 0;

  for (unsigned int k = 0; k < k_end; ++k) {
    local_index = group_start + k * get_local_size(0) + get_local_id(0);

    tmp = (local_index < group_end) ? coords[hook(0, local_index)] : (uint2)0;
    val = (local_index < group_end && (option != 3 || tmp.x == tmp.y)) ? elements[hook(1, local_index)] : 0;

    if (get_local_id(0) == 0 && k > 0) {
      if (tmp.x == shared_rows[hook(5, last_index)]) {
        switch (option) {
          case 0:
          case 3:
            val = max(val, fabs(inter_results[hook(6, last_index)]));
            break;

          case 1:
            val = fabs(val) + inter_results[hook(6, last_index)];
            break;

          case 2:
            val = sqrt(val * val + inter_results[hook(6, last_index)]);
            break;

          default:
            break;
        }
      } else {
        switch (option) {
          case 0:
          case 1:
          case 3:
            result[hook(3, shared_rows[lhook(5, last_index))] = inter_results[hook(6, last_index)];
            break;

          case 2:
            result[hook(3, shared_rows[lhook(5, last_index))] = sqrt(inter_results[hook(6, last_index)]);
          default:
            break;
        }
      }
    }

    barrier(0x01);
    shared_rows[hook(5, get_local_id(0))] = tmp.x;
    switch (option) {
      case 0:
      case 3:
        inter_results[hook(6, get_local_id(0))] = val;
        break;
      case 1:
        inter_results[hook(6, get_local_id(0))] = fabs(val);
        break;
      case 2:
        inter_results[hook(6, get_local_id(0))] = val * val;
      default:
        break;
    }
    float left = 0;
    barrier(0x01);

    for (unsigned int stride = 1; stride < get_local_size(0); stride *= 2) {
      left = (get_local_id(0) >= stride && tmp.x == shared_rows[hook(5, get_local_id(0) - stride)]) ? inter_results[hook(6, get_local_id(0) - stride)] : 0;
      barrier(0x01);
      switch (option) {
        case 0:
        case 3:
          inter_results[hook(6, get_local_id(0))] = max(inter_results[hook(6, get_local_id(0))], left);
          break;

        case 1:
          inter_results[hook(6, get_local_id(0))] += left;
          break;

        case 2:
          inter_results[hook(6, get_local_id(0))] += left;
          break;

        default:
          break;
      }
      barrier(0x01);
    }

    if (get_local_id(0) != last_index && shared_rows[hook(5, get_local_id(0))] != shared_rows[hook(5, get_local_id(0) + 1)] && inter_results[hook(6, get_local_id(0))] != 0) {
      result[hook(3, tmp.x)] = (option == 2) ? sqrt(inter_results[hook(6, get_local_id(0))]) : inter_results[hook(6, get_local_id(0))];
    }

    barrier(0x01);
  }

  if (get_local_id(0) == last_index && inter_results[hook(6, last_index)] != 0)
    result[hook(3, tmp.x)] = (option == 2) ? sqrt(inter_results[hook(6, last_index)]) : inter_results[hook(6, last_index)];
}
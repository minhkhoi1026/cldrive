//{"globalResult":1,"interimResult":0,"l_key":0,"l_thread_data":4,"noOfInterimResults":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
struct restype_q3 {
  long v0;
  unsigned k0;
};

inline void ComparatorLocal(local struct restype_q3* keyA, local struct restype_q3* keyB, unsigned int arrowDir) {
  if ((keyA->v0 > keyB->v0) == arrowDir) {
    struct restype_q3 t;
    t = *keyA;
    *keyA = *keyB;
    *keyB = t;
  }
}

kernel __attribute__((reqd_work_group_size(1024 * 2 / 2, 1, 1))) void local_sort(local struct restype_q3* l_key) {
  unsigned int arrayLength = 1024 * 2;
  unsigned int sortDir = 0;

  for (unsigned int size = 2; size < arrayLength; size <<= 1) {
    unsigned int dir = ((get_local_id(0) & (size / 2)) != 0);
    for (unsigned int stride = size / 2; stride > 0; stride >>= 1) {
      barrier(0x01);
      unsigned int pos = 2 * get_local_id(0) - (get_local_id(0) & (stride - 1));
      ComparatorLocal(&l_key[hook(0, pos + 0)], &l_key[hook(0, pos + stride)], dir);
    }
  }

  {
    for (unsigned int stride = arrayLength / 2; stride > 0; stride >>= 1) {
      barrier(0x01);
      unsigned int pos = 2 * get_local_id(0) - (get_local_id(0) & (stride - 1));
      ComparatorLocal(&l_key[hook(0, pos + 0)], &l_key[hook(0, pos + stride)], sortDir);
    }
  }

  barrier(0x01);
}

kernel void q_reduce(global struct restype_q3* interimResult, global struct restype_q3* globalResult, unsigned noOfInterimResults) {
  local struct restype_q3 l_thread_data[1024 * 2];

  unsigned lim = noOfInterimResults / get_local_size(0);
  lim = get_local_size(0) * (lim + 1);

  if (get_local_id(0) < 512) {
    l_thread_data[hook(4, get_local_id(0))] = interimResult[hook(0, get_local_id(0))];
  }

  for (short j = get_local_id(0); j - get_local_id(0) < noOfInterimResults * 512; j += 1024 * 2 - 512) {
    if (get_local_id(0) >= 512) {
      if (j < noOfInterimResults * 512) {
        l_thread_data[hook(4, get_local_id(0))] = interimResult[hook(0, j)];
      } else {
        l_thread_data[hook(4, get_local_id(0))].v0 = -9223372036854775806;
      }
    }
    if ((j + 1024 < noOfInterimResults * 512)) {
      l_thread_data[hook(4, 1024 + get_local_id(0))] = interimResult[hook(0, 1024 + j)];
    } else {
      l_thread_data[hook(4, 1024 + get_local_id(0))].v0 = -9223372036854775806;
    }

    barrier(0x01);
    local_sort(l_thread_data);
  }

  for (unsigned short result_pos = get_local_id(0); result_pos < 512; result_pos += get_local_size(0)) {
    globalResult[hook(1, result_pos)] = l_thread_data[hook(4, result_pos)];
  }
}
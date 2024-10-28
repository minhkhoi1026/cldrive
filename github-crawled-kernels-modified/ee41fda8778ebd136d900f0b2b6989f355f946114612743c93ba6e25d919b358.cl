//{"gend":8,"globalResult":10,"l_key":0,"l_thread_data":13,"mo_t0_to_t2":4,"p_c0":3,"p_c1":0,"p_c3":6,"p_c4":7,"p_c5":2,"p_c6":5,"p_thread_data":12,"rounds_per_thread":9,"t0_to_t1":1}
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

kernel void q(global const unsigned short* p_c1, global const unsigned* t0_to_t1, global const unsigned* p_c5, global const int* p_c0,

              global const unsigned* mo_t0_to_t2, global const unsigned short* p_c6, global const int* p_c3, global const char* p_c4, unsigned gend, unsigned rounds_per_thread, global struct restype_q3* globalResult) {
  local struct restype_q3 l_thread_data[1024 * 2];
  struct restype_q3 p_thread_data[512];

  for (int i = 0; i < 512; ++i) {
    p_thread_data[hook(12, i)].v0 = -9223372036854775806;
    ;
  }

  unsigned lstart = (get_group_id(0) * get_local_size(0) * rounds_per_thread) + get_local_id(0);
  unsigned lend = lstart + get_local_size(0) * rounds_per_thread;
  if (lend > gend)
    lend = gend;

  short res_number = 0;
  short smallest_res = 0;

  for (unsigned i0 = lstart; i0 < lend; i0 += get_local_size(0)) {
    unsigned short c1 = p_c1[hook(0, i0)];
    if (!(c1 < 9204))
      continue;
    unsigned i1 = t0_to_t1[hook(1, i0)];
    unsigned c5 = p_c5[hook(2, i1)];
    if (!(c5 == 1))
      continue;
    int c0 = p_c0[hook(3, i0)];
    unsigned mo2rend = mo_t0_to_t2[hook(4, i0 + 1)];
    long agg0 = 0;
    for (unsigned i2 = mo_t0_to_t2[hook(4, i0)]; i2 < mo2rend; ++i2) {
      unsigned short c6 = p_c6[hook(5, i2)];
      if (!(c6 > 9204))
        continue;
      int c3 = p_c3[hook(6, i2)];
      char c4 = p_c4[hook(7, i2)];
      agg0 += (c3 * (100 - c4));
    }
    if (res_number < 512) {
      p_thread_data[hook(12, res_number)].v0 = agg0;
      p_thread_data[hook(12, res_number)].k0 = i0;
      if (agg0 < p_thread_data[hook(12, smallest_res)].v0) {
        smallest_res = res_number;
      }
      ++res_number;
    } else {
      if (agg0 > p_thread_data[hook(12, smallest_res)].v0) {
        p_thread_data[hook(12, smallest_res)].v0 = agg0;
        p_thread_data[hook(12, smallest_res)].k0 = i0;
        for (short i = 0; i < 512; ++i) {
          if (p_thread_data[hook(12, i)].v0 < p_thread_data[hook(12, smallest_res)].v0) {
            smallest_res = i;
          }
        }
      }
    }
  }

  l_thread_data[hook(13, get_local_id(0))] = p_thread_data[hook(12, 0)];
  for (short j = 1; j < 512; j++) {
    l_thread_data[hook(13, get_local_id(0) + 1024)] = p_thread_data[hook(12, j)];

    barrier(0x01);
    local_sort(l_thread_data);
  }

  for (int i = get_local_id(0); i < 512; i += get_local_size(0)) {
    unsigned result_pos = i + get_group_id(0) * 512;
    globalResult[hook(10, result_pos)] = l_thread_data[hook(13, i)];
  }
}
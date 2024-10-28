//{"flags":7,"histo":4,"histo_s":6,"iter":1,"keys":2,"numElems":0,"s_data":5,"values":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void scan(local unsigned int s_data[(4 * 256 + 1 + (4 * 256 + 1) / 16 + (4 * 256 + 1) / 64)]) {
  unsigned int thid = get_local_id(0);

  barrier(0x01);

  s_data[hook(5, 2 * thid + 1 + (((unsigned int)(2 * thid + 1) >> min((unsigned int)((unsigned int)(4) + (2 * thid + 1)), (unsigned int)((unsigned int)(32 - (2 * 4))))) >> (2 * 4)))] += s_data[hook(5, 2 * thid + (((unsigned int)(2 * thid) >> min((unsigned int)((unsigned int)(4) + (2 * thid)), (unsigned int)((unsigned int)(32 - (2 * 4))))) >> (2 * 4)))];
  s_data[hook(5, 2 * (get_local_size(0) + thid) + 1 + (((unsigned int)(2 * (get_local_size(0) + thid) + 1) >> min((unsigned int)((unsigned int)(4) + (2 * (get_local_size(0) + thid) + 1)), (unsigned int)((unsigned int)(32 - (2 * 4))))) >> (2 * 4)))] += s_data[hook(5, 2 * (get_local_size(0) + thid) + (((unsigned int)(2 * (get_local_size(0) + thid)) >> min((unsigned int)((unsigned int)(4) + (2 * (get_local_size(0) + thid))), (unsigned int)((unsigned int)(32 - (2 * 4))))) >> (2 * 4)))];

  unsigned int stride = 2;
  for (unsigned int d = get_local_size(0); d > 0; d >>= 1) {
    barrier(0x01);

    if (thid < d) {
      unsigned int i = 2 * stride * thid;
      unsigned int ai = i + stride - 1;
      unsigned int bi = ai + stride;

      ai += (((unsigned int)(ai) >> min((unsigned int)((unsigned int)(4) + (ai)), (unsigned int)((unsigned int)(32 - (2 * 4))))) >> (2 * 4));
      bi += (((unsigned int)(bi) >> min((unsigned int)((unsigned int)(4) + (bi)), (unsigned int)((unsigned int)(32 - (2 * 4))))) >> (2 * 4));

      s_data[hook(5, bi)] += s_data[hook(5, ai)];
    }

    stride *= 2;
  }

  if (thid == 0) {
    unsigned int last = 4 * get_local_size(0) - 1;
    last += (((unsigned int)(last) >> min((unsigned int)((unsigned int)(4) + (last)), (unsigned int)((unsigned int)(32 - (2 * 4))))) >> (2 * 4));
    s_data[hook(5, 4 * get_local_size(0) + (((unsigned int)(4 * get_local_size(0)) >> min((unsigned int)((unsigned int)(4) + (4 * get_local_size(0))), (unsigned int)((unsigned int)(32 - (2 * 4))))) >> (2 * 4)))] = s_data[hook(5, last)];
    s_data[hook(5, last)] = 0;
  }

  for (unsigned int d = 1; d <= get_local_size(0); d *= 2) {
    stride >>= 1;

    barrier(0x01);

    if (thid < d) {
      unsigned int i = 2 * stride * thid;
      unsigned int ai = i + stride - 1;
      unsigned int bi = ai + stride;

      ai += (((unsigned int)(ai) >> min((unsigned int)((unsigned int)(4) + (ai)), (unsigned int)((unsigned int)(32 - (2 * 4))))) >> (2 * 4));
      bi += (((unsigned int)(bi) >> min((unsigned int)((unsigned int)(4) + (bi)), (unsigned int)((unsigned int)(32 - (2 * 4))))) >> (2 * 4));

      unsigned int t = s_data[hook(5, ai)];
      s_data[hook(5, ai)] = s_data[hook(5, bi)];
      s_data[hook(5, bi)] += t;
    }
  }
  barrier(0x01);

  unsigned int temp = s_data[hook(5, 2 * thid + (((unsigned int)(2 * thid) >> min((unsigned int)((unsigned int)(4) + (2 * thid)), (unsigned int)((unsigned int)(32 - (2 * 4))))) >> (2 * 4)))];
  s_data[hook(5, 2 * thid + (((unsigned int)(2 * thid) >> min((unsigned int)((unsigned int)(4) + (2 * thid)), (unsigned int)((unsigned int)(32 - (2 * 4))))) >> (2 * 4)))] = s_data[hook(5, 2 * thid + 1 + (((unsigned int)(2 * thid + 1) >> min((unsigned int)((unsigned int)(4) + (2 * thid + 1)), (unsigned int)((unsigned int)(32 - (2 * 4))))) >> (2 * 4)))];
  s_data[hook(5, 2 * thid + 1 + (((unsigned int)(2 * thid + 1) >> min((unsigned int)((unsigned int)(4) + (2 * thid + 1)), (unsigned int)((unsigned int)(32 - (2 * 4))))) >> (2 * 4)))] += temp;

  unsigned int temp2 = s_data[hook(5, 2 * (get_local_size(0) + thid) + (((unsigned int)(2 * (get_local_size(0) + thid)) >> min((unsigned int)((unsigned int)(4) + (2 * (get_local_size(0) + thid))), (unsigned int)((unsigned int)(32 - (2 * 4))))) >> (2 * 4)))];
  s_data[hook(5, 2 * (get_local_size(0) + thid) + (((unsigned int)(2 * (get_local_size(0) + thid)) >> min((unsigned int)((unsigned int)(4) + (2 * (get_local_size(0) + thid))), (unsigned int)((unsigned int)(32 - (2 * 4))))) >> (2 * 4)))] = s_data[hook(5, 2 * (get_local_size(0) + thid) + 1 + (((unsigned int)(2 * (get_local_size(0) + thid) + 1) >> min((unsigned int)((unsigned int)(4) + (2 * (get_local_size(0) + thid) + 1)), (unsigned int)((unsigned int)(32 - (2 * 4))))) >> (2 * 4)))];
  s_data[hook(5, 2 * (get_local_size(0) + thid) + 1 + (((unsigned int)(2 * (get_local_size(0) + thid) + 1) >> min((unsigned int)((unsigned int)(4) + (2 * (get_local_size(0) + thid) + 1)), (unsigned int)((unsigned int)(32 - (2 * 4))))) >> (2 * 4)))] += temp2;

  barrier(0x01);
}

kernel void splitSort(int numElems, int iter, global unsigned int* keys, global unsigned int* values, global unsigned int* histo) {
  local unsigned int flags[(4 * 256 + 1 + (4 * 256 + 1) / 16 + (4 * 256 + 1) / 64)];
  local unsigned int histo_s[1 << 4];

  const unsigned int tid = get_local_id(0);
  const unsigned int gid = get_group_id(0) * 4 * 256 + 4 * get_local_id(0);

  uint4 lkey = {4294967295, 4294967295, 4294967295, 4294967295};
  uint4 lvalue;
  if (gid < numElems) {
    lkey = *((global uint4*)(keys + gid));
    lvalue = *((global uint4*)(values + gid));
  }

  if (tid < (1 << 4)) {
    histo_s[hook(6, tid)] = 0;
  }
  barrier(0x01);

  atom_add(histo_s + ((lkey.x & ((1 << (4 * (iter + 1))) - 1)) >> (4 * iter)), 1);
  atom_add(histo_s + ((lkey.y & ((1 << (4 * (iter + 1))) - 1)) >> (4 * iter)), 1);
  atom_add(histo_s + ((lkey.z & ((1 << (4 * (iter + 1))) - 1)) >> (4 * iter)), 1);
  atom_add(histo_s + ((lkey.w & ((1 << (4 * (iter + 1))) - 1)) >> (4 * iter)), 1);

  uint4 index = (uint4)(4 * tid, 4 * tid + 1, 4 * tid + 2, 4 * tid + 3);

  for (int i = 4 * iter; i < 4 * (iter + 1); i++) {
    const uint4 flag = (uint4)((lkey.x >> i) & 0x1, (lkey.y >> i) & 0x1, (lkey.z >> i) & 0x1, (lkey.w >> i) & 0x1);

    flags[hook(7, index.x + (((unsigned int)(index.x) >> min((unsigned int)((unsigned int)(4) + (index.x)), (unsigned int)((unsigned int)(32 - (2 * 4))))) >> (2 * 4)))] = 1 << (16 * flag.x);
    flags[hook(7, index.y + (((unsigned int)(index.y) >> min((unsigned int)((unsigned int)(4) + (index.y)), (unsigned int)((unsigned int)(32 - (2 * 4))))) >> (2 * 4)))] = 1 << (16 * flag.y);
    flags[hook(7, index.z + (((unsigned int)(index.z) >> min((unsigned int)((unsigned int)(4) + (index.z)), (unsigned int)((unsigned int)(32 - (2 * 4))))) >> (2 * 4)))] = 1 << (16 * flag.z);
    flags[hook(7, index.w + (((unsigned int)(index.w) >> min((unsigned int)((unsigned int)(4) + (index.w)), (unsigned int)((unsigned int)(32 - (2 * 4))))) >> (2 * 4)))] = 1 << (16 * flag.w);

    scan(flags);

    index.x = (flags[hook(7, index.x + (((unsigned int)(index.x) >> min((unsigned int)((unsigned int)(4) + (index.x)), (unsigned int)((unsigned int)(32 - (2 * 4))))) >> (2 * 4)))] >> (16 * flag.x)) & 0xFFFF;
    index.y = (flags[hook(7, index.y + (((unsigned int)(index.y) >> min((unsigned int)((unsigned int)(4) + (index.y)), (unsigned int)((unsigned int)(32 - (2 * 4))))) >> (2 * 4)))] >> (16 * flag.y)) & 0xFFFF;
    index.z = (flags[hook(7, index.z + (((unsigned int)(index.z) >> min((unsigned int)((unsigned int)(4) + (index.z)), (unsigned int)((unsigned int)(32 - (2 * 4))))) >> (2 * 4)))] >> (16 * flag.z)) & 0xFFFF;
    index.w = (flags[hook(7, index.w + (((unsigned int)(index.w) >> min((unsigned int)((unsigned int)(4) + (index.w)), (unsigned int)((unsigned int)(32 - (2 * 4))))) >> (2 * 4)))] >> (16 * flag.w)) & 0xFFFF;

    unsigned short offset = flags[hook(7, 4 * get_local_size(0) + (((unsigned int)(4 * get_local_size(0)) >> min((unsigned int)((unsigned int)(4) + (4 * get_local_size(0))), (unsigned int)((unsigned int)(32 - (2 * 4))))) >> (2 * 4)))] & 0xFFFF;
    index.x += (flag.x) ? offset : 0;
    index.y += (flag.y) ? offset : 0;
    index.z += (flag.z) ? offset : 0;
    index.w += (flag.w) ? offset : 0;

    barrier(0x01);
  }

  if (gid < numElems) {
    keys[hook(2, get_group_id(0) * 4 * 256 + index.x)] = lkey.x;
    keys[hook(2, get_group_id(0) * 4 * 256 + index.y)] = lkey.y;
    keys[hook(2, get_group_id(0) * 4 * 256 + index.z)] = lkey.z;
    keys[hook(2, get_group_id(0) * 4 * 256 + index.w)] = lkey.w;

    values[hook(3, get_group_id(0) * 4 * 256 + index.x)] = lvalue.x;
    values[hook(3, get_group_id(0) * 4 * 256 + index.y)] = lvalue.y;
    values[hook(3, get_group_id(0) * 4 * 256 + index.z)] = lvalue.z;
    values[hook(3, get_group_id(0) * 4 * 256 + index.w)] = lvalue.w;
  }
  if (tid < (1 << 4)) {
    histo[hook(4, get_num_groups(0) * get_local_id(0) + get_group_id(0))] = histo_s[hook(6, tid)];
  }
}
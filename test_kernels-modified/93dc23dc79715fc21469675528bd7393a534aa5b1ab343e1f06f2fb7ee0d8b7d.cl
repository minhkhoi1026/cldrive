//{"array_s":9,"histo":6,"histo_s":8,"iter":1,"keys_i":2,"keys_o":3,"numElems":0,"s_data":7,"values_i":4,"values_o":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void scan(local unsigned int s_data[(4 * 256 + 1 + (4 * 256 + 1) / 16 + (4 * 256 + 1) / 64)]) {
  unsigned int thid = get_local_id(0);

  barrier(0x01);

  s_data[hook(7, 2 * thid + 1 + (((unsigned int)(2 * thid + 1) >> min((unsigned int)((unsigned int)(4) + (2 * thid + 1)), (unsigned int)((unsigned int)(32 - (2 * 4))))) >> (2 * 4)))] += s_data[hook(7, 2 * thid + (((unsigned int)(2 * thid) >> min((unsigned int)((unsigned int)(4) + (2 * thid)), (unsigned int)((unsigned int)(32 - (2 * 4))))) >> (2 * 4)))];
  s_data[hook(7, 2 * (get_local_size(0) + thid) + 1 + (((unsigned int)(2 * (get_local_size(0) + thid) + 1) >> min((unsigned int)((unsigned int)(4) + (2 * (get_local_size(0) + thid) + 1)), (unsigned int)((unsigned int)(32 - (2 * 4))))) >> (2 * 4)))] += s_data[hook(7, 2 * (get_local_size(0) + thid) + (((unsigned int)(2 * (get_local_size(0) + thid)) >> min((unsigned int)((unsigned int)(4) + (2 * (get_local_size(0) + thid))), (unsigned int)((unsigned int)(32 - (2 * 4))))) >> (2 * 4)))];

  unsigned int stride = 2;
  for (unsigned int d = get_local_size(0); d > 0; d >>= 1) {
    barrier(0x01);

    if (thid < d) {
      unsigned int i = 2 * stride * thid;
      unsigned int ai = i + stride - 1;
      unsigned int bi = ai + stride;

      ai += (((unsigned int)(ai) >> min((unsigned int)((unsigned int)(4) + (ai)), (unsigned int)((unsigned int)(32 - (2 * 4))))) >> (2 * 4));
      bi += (((unsigned int)(bi) >> min((unsigned int)((unsigned int)(4) + (bi)), (unsigned int)((unsigned int)(32 - (2 * 4))))) >> (2 * 4));

      s_data[hook(7, bi)] += s_data[hook(7, ai)];
    }

    stride *= 2;
  }

  if (thid == 0) {
    unsigned int last = 4 * get_local_size(0) - 1;
    last += (((unsigned int)(last) >> min((unsigned int)((unsigned int)(4) + (last)), (unsigned int)((unsigned int)(32 - (2 * 4))))) >> (2 * 4));
    s_data[hook(7, 4 * get_local_size(0) + (((unsigned int)(4 * get_local_size(0)) >> min((unsigned int)((unsigned int)(4) + (4 * get_local_size(0))), (unsigned int)((unsigned int)(32 - (2 * 4))))) >> (2 * 4)))] = s_data[hook(7, last)];
    s_data[hook(7, last)] = 0;
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

      unsigned int t = s_data[hook(7, ai)];
      s_data[hook(7, ai)] = s_data[hook(7, bi)];
      s_data[hook(7, bi)] += t;
    }
  }
  barrier(0x01);

  unsigned int temp = s_data[hook(7, 2 * thid + (((unsigned int)(2 * thid) >> min((unsigned int)((unsigned int)(4) + (2 * thid)), (unsigned int)((unsigned int)(32 - (2 * 4))))) >> (2 * 4)))];
  s_data[hook(7, 2 * thid + (((unsigned int)(2 * thid) >> min((unsigned int)((unsigned int)(4) + (2 * thid)), (unsigned int)((unsigned int)(32 - (2 * 4))))) >> (2 * 4)))] = s_data[hook(7, 2 * thid + 1 + (((unsigned int)(2 * thid + 1) >> min((unsigned int)((unsigned int)(4) + (2 * thid + 1)), (unsigned int)((unsigned int)(32 - (2 * 4))))) >> (2 * 4)))];
  s_data[hook(7, 2 * thid + 1 + (((unsigned int)(2 * thid + 1) >> min((unsigned int)((unsigned int)(4) + (2 * thid + 1)), (unsigned int)((unsigned int)(32 - (2 * 4))))) >> (2 * 4)))] += temp;

  unsigned int temp2 = s_data[hook(7, 2 * (get_local_size(0) + thid) + (((unsigned int)(2 * (get_local_size(0) + thid)) >> min((unsigned int)((unsigned int)(4) + (2 * (get_local_size(0) + thid))), (unsigned int)((unsigned int)(32 - (2 * 4))))) >> (2 * 4)))];
  s_data[hook(7, 2 * (get_local_size(0) + thid) + (((unsigned int)(2 * (get_local_size(0) + thid)) >> min((unsigned int)((unsigned int)(4) + (2 * (get_local_size(0) + thid))), (unsigned int)((unsigned int)(32 - (2 * 4))))) >> (2 * 4)))] = s_data[hook(7, 2 * (get_local_size(0) + thid) + 1 + (((unsigned int)(2 * (get_local_size(0) + thid) + 1) >> min((unsigned int)((unsigned int)(4) + (2 * (get_local_size(0) + thid) + 1)), (unsigned int)((unsigned int)(32 - (2 * 4))))) >> (2 * 4)))];
  s_data[hook(7, 2 * (get_local_size(0) + thid) + 1 + (((unsigned int)(2 * (get_local_size(0) + thid) + 1) >> min((unsigned int)((unsigned int)(4) + (2 * (get_local_size(0) + thid) + 1)), (unsigned int)((unsigned int)(32 - (2 * 4))))) >> (2 * 4)))] += temp2;

  barrier(0x01);
}

kernel void splitRearrange(int numElems, int iter, global unsigned int* keys_i, global unsigned int* keys_o, global unsigned int* values_i, global unsigned int* values_o, global unsigned int* histo) {
  local unsigned int histo_s[(1 << 4)];
  local unsigned int array_s[4 * 256];
  int index = get_group_id(0) * 4 * 256 + 4 * get_local_id(0);

  if (get_local_id(0) < (1 << 4)) {
    histo_s[hook(8, get_local_id(0))] = histo[hook(6, get_num_groups(0) * get_local_id(0) + get_group_id(0))];
  }

  uint4 mine, value;
  if (index < numElems) {
    mine = *((global uint4*)(keys_i + index));
    value = *((global uint4*)(values_i + index));
  } else {
    mine.x = 4294967295;
    mine.y = 4294967295;
    mine.z = 4294967295;
    mine.w = 4294967295;
  }

  uint4 masks = (uint4)((mine.x & ((1 << (4 * (iter + 1))) - 1)) >> (4 * iter), (mine.y & ((1 << (4 * (iter + 1))) - 1)) >> (4 * iter), (mine.z & ((1 << (4 * (iter + 1))) - 1)) >> (4 * iter), (mine.w & ((1 << (4 * (iter + 1))) - 1)) >> (4 * iter));

  vstore4(masks, get_local_id(0), (local unsigned int*)array_s);

  barrier(0x01);

  uint4 new_index = (uint4)(histo_s[hook(8, masks.x)], histo_s[hook(8, masks.y)], histo_s[hook(8, masks.z)], histo_s[hook(8, masks.w)]);

  int i = 4 * get_local_id(0) - 1;

  while (i >= 0) {
    if (array_s[hook(9, i)] == masks.x) {
      new_index.x++;
      i--;
    } else {
      break;
    }
  }

  new_index.y = (masks.y == masks.x) ? new_index.x + 1 : new_index.y;
  new_index.z = (masks.z == masks.y) ? new_index.y + 1 : new_index.z;
  new_index.w = (masks.w == masks.z) ? new_index.z + 1 : new_index.w;

  if (index < numElems) {
    keys_o[hook(3, new_index.x)] = mine.x;
    values_o[hook(5, new_index.x)] = value.x;

    keys_o[hook(3, new_index.y)] = mine.y;
    values_o[hook(5, new_index.y)] = value.y;

    keys_o[hook(3, new_index.z)] = mine.z;
    values_o[hook(5, new_index.z)] = value.z;

    keys_o[hook(3, new_index.w)] = mine.w;
    values_o[hook(5, new_index.w)] = value.w;
  }
}
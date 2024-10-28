//{"addr->hi":15,"addr->lo":14,"block->hi":7,"block->lo":8,"curr->hi":25,"curr->lo":24,"index":6,"lanes":2,"local_addr.hi":22,"local_addr.lo":21,"mem_curr->data":23,"mem_prev->data":18,"memory":0,"next_block->hi":12,"next_block->lo":10,"pass":4,"passes":1,"prev->hi":20,"prev->lo":19,"prev_block->hi":13,"prev_block->lo":11,"ref_block->data":9,"segment_blocks":3,"slice":5,"tmp->hi":17,"tmp->lo":16}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
struct block_g {
  ulong data[(1024 / 8)];
};

struct block_l {
  unsigned int lo[(1024 / 8)];
  unsigned int hi[(1024 / 8)];
};

void g(local struct block_l* block, unsigned int subblock, unsigned int hash_lane, unsigned int bw, unsigned int bh, unsigned int dx, unsigned int dy, unsigned int offset) {
  unsigned int index[4];
  for (unsigned int i = 0; i < 4; i++) {
    unsigned int bpos = (hash_lane + i * offset) % 4;
    unsigned int x = (subblock * dy + i * dx) * bw + bpos % bw;
    unsigned int y = (subblock * dx + i * dy) * bh + bpos / bw;

    index[hook(6, i)] = y * 16 + (x + (y / 2) * 4) % 16;
  }

  ulong a, b, c, d;
  a = upsample(block->hi[hook(7, index[0hook(6, 0))], block->lo[hook(8, index[0hook(6, 0))]);
  b = upsample(block->hi[hook(7, index[1hook(6, 1))], block->lo[hook(8, index[1hook(6, 1))]);
  c = upsample(block->hi[hook(7, index[2hook(6, 2))], block->lo[hook(8, index[2hook(6, 2))]);
  d = upsample(block->hi[hook(7, index[3hook(6, 3))], block->lo[hook(8, index[3hook(6, 3))]);

  a = ((a) + (b) + 2 * upsample(mul_hi((unsigned int)(a), (unsigned int)(b)), (unsigned int)(a) * (unsigned int)(b)));
  d = rotate(d ^ a, (ulong)(64 - (32)));
  c = ((c) + (d) + 2 * upsample(mul_hi((unsigned int)(c), (unsigned int)(d)), (unsigned int)(c) * (unsigned int)(d)));
  b = rotate(b ^ c, (ulong)(64 - (24)));
  a = ((a) + (b) + 2 * upsample(mul_hi((unsigned int)(a), (unsigned int)(b)), (unsigned int)(a) * (unsigned int)(b)));
  d = rotate(d ^ a, (ulong)(64 - (16)));
  c = ((c) + (d) + 2 * upsample(mul_hi((unsigned int)(c), (unsigned int)(d)), (unsigned int)(c) * (unsigned int)(d)));
  b = rotate(b ^ c, (ulong)(64 - (63)));

  block->lo[hook(8, index[0hook(6, 0))] = (unsigned int)a;
  block->lo[hook(8, index[1hook(6, 1))] = (unsigned int)b;
  block->lo[hook(8, index[2hook(6, 2))] = (unsigned int)c;
  block->lo[hook(8, index[3hook(6, 3))] = (unsigned int)d;

  block->hi[hook(7, index[0hook(6, 0))] = (unsigned int)(a >> 32);
  block->hi[hook(7, index[1hook(6, 1))] = (unsigned int)(b >> 32);
  block->hi[hook(7, index[2hook(6, 2))] = (unsigned int)(c >> 32);
  block->hi[hook(7, index[3hook(6, 3))] = (unsigned int)(d >> 32);
}

void shuffle_block(local struct block_l* block, unsigned int thread) {
  unsigned int subblock = (thread >> 2) & 0x7;
  unsigned int hash_lane = (thread >> 0) & 0x3;

  g(block, subblock, hash_lane, 4, 1, 1, 0, 0);

  barrier(0x01);

  g(block, subblock, hash_lane, 4, 1, 1, 0, 1);

  barrier(0x01);

  g(block, subblock, hash_lane, 2, 2, 0, 1, 0);

  barrier(0x01);

  g(block, subblock, hash_lane, 2, 2, 0, 1, 1);
}

void fill_block(global const struct block_g* restrict ref_block, local struct block_l* restrict prev_block, local struct block_l* restrict next_block, unsigned int thread) {
  for (unsigned int i = 0; i < ((1024 / 8) / 32); i++) {
    unsigned int pos_l = i * 32 + (thread & 0x10) + ((thread + i * 4) & 0xf);
    ulong in = ref_block->data[hook(9, i * 32 + thread)];
    next_block->lo[hook(10, pos_l)] = prev_block->lo[hook(11, pos_l)] ^= (unsigned int)in;
    next_block->hi[hook(12, pos_l)] = prev_block->hi[hook(13, pos_l)] ^= (unsigned int)(in >> 32);
  }

  barrier(0x01);

  shuffle_block(prev_block, thread);

  barrier(0x01);

  for (unsigned int i = 0; i < ((1024 / 8) / 32); i++) {
    unsigned int pos_l = i * 32 + (thread & 0x10) + ((thread + i * 4) & 0xf);
    next_block->lo[hook(10, pos_l)] ^= prev_block->lo[hook(11, pos_l)];
    next_block->hi[hook(12, pos_l)] ^= prev_block->hi[hook(13, pos_l)];
  }
}

void fill_block_xor(global const struct block_g* restrict ref_block, local struct block_l* restrict prev_block, local struct block_l* restrict next_block, unsigned int thread) {
  for (unsigned int i = 0; i < ((1024 / 8) / 32); i++) {
    unsigned int pos_l = i * 32 + (thread & 0x10) + ((thread + i * 4) & 0xf);
    ulong in = ref_block->data[hook(9, i * 32 + thread)];
    next_block->lo[hook(10, pos_l)] ^= prev_block->lo[hook(11, pos_l)] ^= (unsigned int)in;
    next_block->hi[hook(12, pos_l)] ^= prev_block->hi[hook(13, pos_l)] ^= (unsigned int)(in >> 32);
  }

  barrier(0x01);

  shuffle_block(prev_block, thread);

  barrier(0x01);

  for (unsigned int i = 0; i < ((1024 / 8) / 32); i++) {
    unsigned int pos_l = i * 32 + (thread & 0x10) + ((thread + i * 4) & 0xf);
    next_block->lo[hook(10, pos_l)] ^= prev_block->lo[hook(11, pos_l)];
    next_block->hi[hook(12, pos_l)] ^= prev_block->hi[hook(13, pos_l)];
  }
}

void next_addresses(unsigned int thread_input, local struct block_l* restrict addr, local struct block_l* restrict tmp, unsigned int thread) {
  addr->lo[hook(14, thread)] = thread_input;
  addr->hi[hook(15, thread)] = 0;
  for (unsigned int i = 1; i < ((1024 / 8) / 32); i++) {
    unsigned int pos = i * 32 + thread;
    addr->hi[hook(15, pos)] = addr->lo[hook(14, pos)] = 0;
  }

  barrier(0x01);

  shuffle_block(addr, thread);

  barrier(0x01);

  tmp->lo[hook(16, thread)] = addr->lo[hook(14, thread)] ^= thread_input;
  tmp->hi[hook(17, thread)] = addr->hi[hook(15, thread)];
  for (unsigned int i = 1; i < ((1024 / 8) / 32); i++) {
    unsigned int pos = i * 32 + thread;
    tmp->lo[hook(16, pos)] = addr->lo[hook(14, pos)];
    tmp->hi[hook(17, pos)] = addr->hi[hook(15, pos)];
  }

  barrier(0x01);

  shuffle_block(addr, thread);

  barrier(0x01);

  for (unsigned int i = 0; i < ((1024 / 8) / 32); i++) {
    unsigned int pos = i * 32 + thread;
    addr->lo[hook(14, pos)] ^= tmp->lo[hook(16, pos)];
    addr->hi[hook(15, pos)] ^= tmp->hi[hook(17, pos)];
  }

  barrier(0x01);
}

kernel void argon2_kernel_segment(global struct block_g* memory, unsigned int passes, unsigned int lanes, unsigned int segment_blocks, unsigned int pass, unsigned int slice) {
  size_t job_id = get_global_id(0);
  unsigned int lane = get_global_id(1);
  unsigned int thread = (unsigned int)get_global_id(2);

  unsigned int lane_blocks = 4 * segment_blocks;

  memory += job_id * lanes * lane_blocks;

  local struct block_l local_curr, local_prev;
  local struct block_l* curr = &local_curr;
  local struct block_l* prev = &local_prev;

  local struct block_l local_addr;

  unsigned int thread_input;
  switch (thread) {
    case 0:
      thread_input = pass;
      break;
    case 1:
      thread_input = lane;
      break;
    case 2:
      thread_input = slice;
      break;
    case 3:
      thread_input = lanes * lane_blocks;
      break;
    case 4:
      thread_input = passes;
      break;
    case 5:
      thread_input = 1;
      break;
    default:
      thread_input = 0;
      break;
  }

  if (pass == 0 && slice == 0 && segment_blocks > 2) {
    if (thread == 6) {
      ++thread_input;
    }
    next_addresses(thread_input, &local_addr, curr, thread);
  }

  global struct block_g* mem_segment = memory + lane * lane_blocks + slice * segment_blocks;
  global struct block_g *mem_prev, *mem_curr;
  unsigned int start_offset = 0;
  if (pass == 0) {
    if (slice == 0) {
      mem_prev = mem_segment + 1;
      mem_curr = mem_segment + 2;
      start_offset = 2;
    } else {
      mem_prev = mem_segment - 1;
      mem_curr = mem_segment;
    }
  } else {
    mem_prev = mem_segment + (slice == 0 ? lane_blocks : 0) - 1;
    mem_curr = mem_segment;
  }

  for (unsigned int i = 0; i < ((1024 / 8) / 32); i++) {
    unsigned int pos_l = (thread & 0x10) + ((thread + i * 4) & 0xf);
    ulong in = mem_prev->data[hook(18, i * 32 + thread)];
    prev->lo[hook(19, i * 32 + pos_l)] = (unsigned int)in;
    prev->hi[hook(20, i * 32 + pos_l)] = (unsigned int)(in >> 32);
  }

  for (unsigned int offset = start_offset; offset < segment_blocks; ++offset) {
    unsigned int pseudo_rand_lo, pseudo_rand_hi;

    unsigned int addr_index = offset % (1024 / 8);
    if (addr_index == 0) {
      if (thread == 6) {
        ++thread_input;
      }
      next_addresses(thread_input, &local_addr, curr, thread);
    }
    unsigned int addr_index_x = addr_index % 16;
    unsigned int addr_index_y = addr_index / 16;
    addr_index = addr_index_y * 16 + (addr_index_x + (addr_index_y / 2) * 4) % 16;
    pseudo_rand_lo = local_addr.lo[hook(21, addr_index)];
    pseudo_rand_hi = local_addr.hi[hook(22, addr_index)];

    unsigned int ref_lane = pseudo_rand_hi % lanes;

    unsigned int base;
    if (pass != 0) {
      base = lane_blocks - segment_blocks;
    } else {
      if (slice == 0) {
        ref_lane = lane;
      }
      base = slice * segment_blocks;
    }

    unsigned int ref_area_size = base + offset - 1;
    if (ref_lane != lane) {
      ref_area_size = min(ref_area_size, base);
    }

    unsigned int ref_index = pseudo_rand_lo;
    ref_index = mul_hi(ref_index, ref_index);
    ref_index = ref_area_size - 1 - mul_hi(ref_area_size, ref_index);

    if (pass != 0 && slice != 4 - 1) {
      ref_index += (slice + 1) * segment_blocks;
      ref_index %= lane_blocks;
    }

    global struct block_g* mem_ref = memory + ref_lane * lane_blocks + ref_index;
    if (pass != 0) {
      for (unsigned int i = 0; i < ((1024 / 8) / 32); i++) {
        unsigned int pos_l = (thread & 0x10) + ((thread + i * 4) & 0xf);
        ulong in = mem_curr->data[hook(23, i * 32 + thread)];
        curr->lo[hook(24, i * 32 + pos_l)] = (unsigned int)in;
        curr->hi[hook(25, i * 32 + pos_l)] = (unsigned int)(in >> 32);
      }

      fill_block_xor(mem_ref, prev, curr, thread);
    } else {
      fill_block(mem_ref, prev, curr, thread);
    }

    for (unsigned int i = 0; i < ((1024 / 8) / 32); i++) {
      unsigned int pos_l = (thread & 0x10) + ((thread + i * 4) & 0xf);
      ulong out = upsample(curr->hi[hook(25, i * 32 + pos_l)], curr->lo[hook(24, i * 32 + pos_l)]);
      mem_curr->data[hook(23, i * 32 + thread)] = out;
    }

    local struct block_l* tmp = curr;
    curr = prev;
    prev = tmp;

    ++mem_curr;
  }
}
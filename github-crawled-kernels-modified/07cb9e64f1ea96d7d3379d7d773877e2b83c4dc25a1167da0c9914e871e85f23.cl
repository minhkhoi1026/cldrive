//{"addr->hi":14,"addr->lo":13,"block->hi":6,"block->lo":7,"curr->hi":22,"curr->lo":21,"index":5,"lanes":3,"mem_curr->data":20,"mem_prev->data":17,"memory":0,"next_block->hi":11,"next_block->lo":9,"passes":2,"prev->hi":19,"prev->lo":18,"prev_block->hi":12,"prev_block->lo":10,"ref_block->data":8,"segment_blocks":4,"shared":1,"tmp->hi":16,"tmp->lo":15}
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

    index[hook(5, i)] = y * 16 + (x + (y / 2) * 4) % 16;
  }

  ulong a, b, c, d;
  a = upsample(block->hi[hook(6, index[0hook(5, 0))], block->lo[hook(7, index[0hook(5, 0))]);
  b = upsample(block->hi[hook(6, index[1hook(5, 1))], block->lo[hook(7, index[1hook(5, 1))]);
  c = upsample(block->hi[hook(6, index[2hook(5, 2))], block->lo[hook(7, index[2hook(5, 2))]);
  d = upsample(block->hi[hook(6, index[3hook(5, 3))], block->lo[hook(7, index[3hook(5, 3))]);

  a = ((a) + (b) + 2 * upsample(mul_hi((unsigned int)(a), (unsigned int)(b)), (unsigned int)(a) * (unsigned int)(b)));
  d = rotate(d ^ a, (ulong)(64 - (32)));
  c = ((c) + (d) + 2 * upsample(mul_hi((unsigned int)(c), (unsigned int)(d)), (unsigned int)(c) * (unsigned int)(d)));
  b = rotate(b ^ c, (ulong)(64 - (24)));
  a = ((a) + (b) + 2 * upsample(mul_hi((unsigned int)(a), (unsigned int)(b)), (unsigned int)(a) * (unsigned int)(b)));
  d = rotate(d ^ a, (ulong)(64 - (16)));
  c = ((c) + (d) + 2 * upsample(mul_hi((unsigned int)(c), (unsigned int)(d)), (unsigned int)(c) * (unsigned int)(d)));
  b = rotate(b ^ c, (ulong)(64 - (63)));

  block->lo[hook(7, index[0hook(5, 0))] = (unsigned int)a;
  block->lo[hook(7, index[1hook(5, 1))] = (unsigned int)b;
  block->lo[hook(7, index[2hook(5, 2))] = (unsigned int)c;
  block->lo[hook(7, index[3hook(5, 3))] = (unsigned int)d;

  block->hi[hook(6, index[0hook(5, 0))] = (unsigned int)(a >> 32);
  block->hi[hook(6, index[1hook(5, 1))] = (unsigned int)(b >> 32);
  block->hi[hook(6, index[2hook(5, 2))] = (unsigned int)(c >> 32);
  block->hi[hook(6, index[3hook(5, 3))] = (unsigned int)(d >> 32);
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
    ulong in = ref_block->data[hook(8, i * 32 + thread)];
    next_block->lo[hook(9, pos_l)] = prev_block->lo[hook(10, pos_l)] ^= (unsigned int)in;
    next_block->hi[hook(11, pos_l)] = prev_block->hi[hook(12, pos_l)] ^= (unsigned int)(in >> 32);
  }

  barrier(0x01);

  shuffle_block(prev_block, thread);

  barrier(0x01);

  for (unsigned int i = 0; i < ((1024 / 8) / 32); i++) {
    unsigned int pos_l = i * 32 + (thread & 0x10) + ((thread + i * 4) & 0xf);
    next_block->lo[hook(9, pos_l)] ^= prev_block->lo[hook(10, pos_l)];
    next_block->hi[hook(11, pos_l)] ^= prev_block->hi[hook(12, pos_l)];
  }
}

void fill_block_xor(global const struct block_g* restrict ref_block, local struct block_l* restrict prev_block, local struct block_l* restrict next_block, unsigned int thread) {
  for (unsigned int i = 0; i < ((1024 / 8) / 32); i++) {
    unsigned int pos_l = i * 32 + (thread & 0x10) + ((thread + i * 4) & 0xf);
    ulong in = ref_block->data[hook(8, i * 32 + thread)];
    next_block->lo[hook(9, pos_l)] ^= prev_block->lo[hook(10, pos_l)] ^= (unsigned int)in;
    next_block->hi[hook(11, pos_l)] ^= prev_block->hi[hook(12, pos_l)] ^= (unsigned int)(in >> 32);
  }

  barrier(0x01);

  shuffle_block(prev_block, thread);

  barrier(0x01);

  for (unsigned int i = 0; i < ((1024 / 8) / 32); i++) {
    unsigned int pos_l = i * 32 + (thread & 0x10) + ((thread + i * 4) & 0xf);
    next_block->lo[hook(9, pos_l)] ^= prev_block->lo[hook(10, pos_l)];
    next_block->hi[hook(11, pos_l)] ^= prev_block->hi[hook(12, pos_l)];
  }
}

void next_addresses(unsigned int thread_input, local struct block_l* restrict addr, local struct block_l* restrict tmp, unsigned int thread) {
  addr->lo[hook(13, thread)] = thread_input;
  addr->hi[hook(14, thread)] = 0;
  for (unsigned int i = 1; i < ((1024 / 8) / 32); i++) {
    unsigned int pos = i * 32 + thread;
    addr->hi[hook(14, pos)] = addr->lo[hook(13, pos)] = 0;
  }

  barrier(0x01);

  shuffle_block(addr, thread);

  barrier(0x01);

  tmp->lo[hook(15, thread)] = addr->lo[hook(13, thread)] ^= thread_input;
  tmp->hi[hook(16, thread)] = addr->hi[hook(14, thread)];
  for (unsigned int i = 1; i < ((1024 / 8) / 32); i++) {
    unsigned int pos = i * 32 + thread;
    tmp->lo[hook(15, pos)] = addr->lo[hook(13, pos)];
    tmp->hi[hook(16, pos)] = addr->hi[hook(14, pos)];
  }

  barrier(0x01);

  shuffle_block(addr, thread);

  barrier(0x01);

  for (unsigned int i = 0; i < ((1024 / 8) / 32); i++) {
    unsigned int pos = i * 32 + thread;
    addr->lo[hook(13, pos)] ^= tmp->lo[hook(15, pos)];
    addr->hi[hook(14, pos)] ^= tmp->hi[hook(16, pos)];
  }

  barrier(0x01);
}

kernel void argon2_kernel_oneshot(global struct block_g* memory, local struct block_l* shared, unsigned int passes, unsigned int lanes, unsigned int segment_blocks) {
  size_t job_id = get_global_id(0);
  unsigned int lane = get_global_id(1);
  unsigned int thread = (unsigned int)get_global_id(2);

  unsigned int lane_blocks = 4 * segment_blocks;

  memory += job_id * lanes * lane_blocks;

  shared += lane * 3;

  local struct block_l* restrict curr = &shared[hook(1, 0)];
  local struct block_l* restrict prev = &shared[hook(1, 1)];

  local struct block_l* restrict addr = &shared[hook(1, 2)];

  unsigned int thread_input;
  switch (thread) {
    case 1:
      thread_input = lane;
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

  if (segment_blocks > 2) {
    if (thread == 6) {
      ++thread_input;
    }
    next_addresses(thread_input, addr, curr, thread);
  }

  global struct block_g* mem_lane = memory + lane * lane_blocks;
  global struct block_g* mem_prev = mem_lane + 1;
  global struct block_g* mem_curr = mem_lane + 2;

  for (unsigned int i = 0; i < ((1024 / 8) / 32); i++) {
    unsigned int pos_l = (thread & 0x10) + ((thread + i * 4) & 0xf);
    ulong in = mem_prev->data[hook(17, i * 32 + thread)];
    prev->lo[hook(18, i * 32 + pos_l)] = (unsigned int)in;
    prev->hi[hook(19, i * 32 + pos_l)] = (unsigned int)(in >> 32);
  }
  unsigned int skip = 2;
  for (unsigned int pass = 0; pass < passes; ++pass) {
    for (unsigned int slice = 0; slice < 4; ++slice) {
      for (unsigned int offset = 0; offset < segment_blocks; ++offset) {
        if (skip > 0) {
          --skip;
          continue;
        }

        unsigned int pseudo_rand_lo, pseudo_rand_hi;

        unsigned int addr_index = offset % (1024 / 8);
        if (addr_index == 0) {
          if (thread == 6) {
            ++thread_input;
          }
          next_addresses(thread_input, addr, curr, thread);
        }
        unsigned int addr_index_x = addr_index % 16;
        unsigned int addr_index_y = addr_index / 16;
        addr_index = addr_index_y * 16 + (addr_index_x + (addr_index_y / 2) * 4) % 16;
        pseudo_rand_lo = addr->lo[hook(13, addr_index)];
        pseudo_rand_hi = addr->hi[hook(14, addr_index)];

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
            ulong in = mem_curr->data[hook(20, i * 32 + thread)];
            curr->lo[hook(21, i * 32 + pos_l)] = (unsigned int)in;
            curr->hi[hook(22, i * 32 + pos_l)] = (unsigned int)(in >> 32);
          }

          fill_block_xor(mem_ref, prev, curr, thread);
        } else {
          fill_block(mem_ref, prev, curr, thread);
        }

        for (unsigned int i = 0; i < ((1024 / 8) / 32); i++) {
          unsigned int pos_l = (thread & 0x10) + ((thread + i * 4) & 0xf);
          ulong out = upsample(curr->hi[hook(22, i * 32 + pos_l)], curr->lo[hook(21, i * 32 + pos_l)]);
          mem_curr->data[hook(20, i * 32 + thread)] = out;
        }

        local struct block_l* tmp = curr;
        curr = prev;
        prev = tmp;

        ++mem_curr;
      }

      barrier(0x02);

      if (thread == 2) {
        ++thread_input;
      }
      if (thread == 6) {
        thread_input = 0;
      }
    }

    if (thread == 0) {
      ++thread_input;
    }
    if (thread == 2) {
      thread_input = 0;
    }

    mem_curr = mem_lane;
  }
}
//{"<recovery-expr>()":5,"<recovery-expr>(plains_buf)":8,"bitmap":6,"buf":0,"d1":3,"d2":4,"digest":7,"gid_max":2,"sw":18,"value":1,"w":9,"w0":10,"w1":11,"w2":12,"w3":13,"w4":14,"w5":15,"w6":16,"w7":17}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline int hash_comp(const unsigned int d1[4], global unsigned int* d2) {
  if (d1[hook(3, 3)] > d2[hook(4, 3)])
    return (1);
  if (d1[hook(3, 3)] < d2[hook(4, 3)])
    return (-1);
  if (d1[hook(3, 2)] > d2[hook(4, 2)])
    return (1);
  if (d1[hook(3, 2)] < d2[hook(4, 2)])
    return (-1);
  if (d1[hook(3, 1)] > d2[hook(4, 1)])
    return (1);
  if (d1[hook(3, 1)] < d2[hook(4, 1)])
    return (-1);
  if (d1[hook(3, 0)] > d2[hook(4, 0)])
    return (1);
  if (d1[hook(3, 0)] < d2[hook(4, 0)])
    return (-1);

  return (0);
}

inline int find_hash(const unsigned int digest[4], const unsigned int digests_cnt, global digest_t* digests_buf) {
  for (unsigned int l = 0, r = digests_cnt; r; r >>= 1) {
    const unsigned int m = r >> 1;

    const unsigned int c = l + m;

    const int cmp = hash_comp(digest, digests_buf[hook(5, c)].digest_buf);

    if (cmp > 0) {
      l += m + 1;

      r--;
    }

    if (cmp == 0)
      return (c);
  }

  return (-1);
}

inline unsigned int check_bitmap(global unsigned int* bitmap, const unsigned int bitmap_mask, const unsigned int bitmap_shift, const unsigned int digest) {
  return (bitmap[hook(6, (digest >> bitmap_shift) & bitmap_mask)] & (1 << (digest & 0x1f)));
}

inline unsigned int check(const unsigned int digest[2], global unsigned int* bitmap_s1_a, global unsigned int* bitmap_s1_b, global unsigned int* bitmap_s1_c, global unsigned int* bitmap_s1_d, global unsigned int* bitmap_s2_a, global unsigned int* bitmap_s2_b, global unsigned int* bitmap_s2_c, global unsigned int* bitmap_s2_d, const unsigned int bitmap_mask, const unsigned int bitmap_shift1, const unsigned int bitmap_shift2) {
  if (check_bitmap(bitmap_s1_a, bitmap_mask, bitmap_shift1, digest[hook(7, 0)]) == 0)
    return (0);
  if (check_bitmap(bitmap_s1_b, bitmap_mask, bitmap_shift1, digest[hook(7, 1)]) == 0)
    return (0);
  if (check_bitmap(bitmap_s1_c, bitmap_mask, bitmap_shift1, digest[hook(7, 2)]) == 0)
    return (0);
  if (check_bitmap(bitmap_s1_d, bitmap_mask, bitmap_shift1, digest[hook(7, 3)]) == 0)
    return (0);

  if (check_bitmap(bitmap_s2_a, bitmap_mask, bitmap_shift2, digest[hook(7, 0)]) == 0)
    return (0);
  if (check_bitmap(bitmap_s2_b, bitmap_mask, bitmap_shift2, digest[hook(7, 1)]) == 0)
    return (0);
  if (check_bitmap(bitmap_s2_c, bitmap_mask, bitmap_shift2, digest[hook(7, 2)]) == 0)
    return (0);
  if (check_bitmap(bitmap_s2_d, bitmap_mask, bitmap_shift2, digest[hook(7, 3)]) == 0)
    return (0);

  return (1);
}

inline void mark_hash(global plain_t* plains_buf, global unsigned int* d_result, const int salt_pos, const int digest_pos, const int hash_pos, const unsigned int gid, const unsigned int il_pos) {
  const unsigned int idx = atomic_inc(d_result);

  plains_buf[hook(8, idx)].salt_pos = salt_pos;
  plains_buf[hook(8, idx)].digest_pos = digest_pos;
  plains_buf[hook(8, idx)].hash_pos = hash_pos;
  plains_buf[hook(8, idx)].gidvid = gid;
  plains_buf[hook(8, idx)].il_pos = il_pos;
}

inline void truncate_block(unsigned int w[4], const unsigned int len) {
  switch (len) {
    case 0:
      w[hook(9, 0)] &= 0;
      w[hook(9, 1)] &= 0;
      w[hook(9, 2)] &= 0;
      w[hook(9, 3)] &= 0;
      break;
    case 1:
      w[hook(9, 0)] &= 0x000000FF;
      w[hook(9, 1)] &= 0;
      w[hook(9, 2)] &= 0;
      w[hook(9, 3)] &= 0;
      break;
    case 2:
      w[hook(9, 0)] &= 0x0000FFFF;
      w[hook(9, 1)] &= 0;
      w[hook(9, 2)] &= 0;
      w[hook(9, 3)] &= 0;
      break;
    case 3:
      w[hook(9, 0)] &= 0x00FFFFFF;
      w[hook(9, 1)] &= 0;
      w[hook(9, 2)] &= 0;
      w[hook(9, 3)] &= 0;
      break;
    case 4:
      w[hook(9, 1)] &= 0;
      w[hook(9, 2)] &= 0;
      w[hook(9, 3)] &= 0;
      break;
    case 5:
      w[hook(9, 1)] &= 0x000000FF;
      w[hook(9, 2)] &= 0;
      w[hook(9, 3)] &= 0;
      break;
    case 6:
      w[hook(9, 1)] &= 0x0000FFFF;
      w[hook(9, 2)] &= 0;
      w[hook(9, 3)] &= 0;
      break;
    case 7:
      w[hook(9, 1)] &= 0x00FFFFFF;
      w[hook(9, 2)] &= 0;
      w[hook(9, 3)] &= 0;
      break;
    case 8:
      w[hook(9, 2)] &= 0;
      w[hook(9, 3)] &= 0;
      break;
    case 9:
      w[hook(9, 2)] &= 0x000000FF;
      w[hook(9, 3)] &= 0;
      break;
    case 10:
      w[hook(9, 2)] &= 0x0000FFFF;
      w[hook(9, 3)] &= 0;
      break;
    case 11:
      w[hook(9, 2)] &= 0x00FFFFFF;
      w[hook(9, 3)] &= 0;
      break;
    case 12:
      w[hook(9, 3)] &= 0;
      break;
    case 13:
      w[hook(9, 3)] &= 0x000000FF;
      break;
    case 14:
      w[hook(9, 3)] &= 0x0000FFFF;
      break;
    case 15:
      w[hook(9, 3)] &= 0x00FFFFFF;
      break;
  }
}

inline void make_unicode(const unsigned int in[4], unsigned int out1[4], unsigned int out2[4]) {
}

inline void undo_unicode(const unsigned int in1[4], const unsigned int in2[4], unsigned int out[4]) {
}

inline void append_0x01_1x4(unsigned int w0[4], const unsigned int offset) {
  switch (offset) {
    case 0:
      w0[hook(10, 0)] = 0x01;
      break;

    case 1:
      w0[hook(10, 0)] = w0[hook(10, 0)] | 0x0100;
      break;

    case 2:
      w0[hook(10, 0)] = w0[hook(10, 0)] | 0x010000;
      break;

    case 3:
      w0[hook(10, 0)] = w0[hook(10, 0)] | 0x01000000;
      break;

    case 4:
      w0[hook(10, 1)] = 0x01;
      break;

    case 5:
      w0[hook(10, 1)] = w0[hook(10, 1)] | 0x0100;
      break;

    case 6:
      w0[hook(10, 1)] = w0[hook(10, 1)] | 0x010000;
      break;

    case 7:
      w0[hook(10, 1)] = w0[hook(10, 1)] | 0x01000000;
      break;

    case 8:
      w0[hook(10, 2)] = 0x01;
      break;

    case 9:
      w0[hook(10, 2)] = w0[hook(10, 2)] | 0x0100;
      break;

    case 10:
      w0[hook(10, 2)] = w0[hook(10, 2)] | 0x010000;
      break;

    case 11:
      w0[hook(10, 2)] = w0[hook(10, 2)] | 0x01000000;
      break;

    case 12:
      w0[hook(10, 3)] = 0x01;
      break;

    case 13:
      w0[hook(10, 3)] = w0[hook(10, 3)] | 0x0100;
      break;

    case 14:
      w0[hook(10, 3)] = w0[hook(10, 3)] | 0x010000;
      break;

    case 15:
      w0[hook(10, 3)] = w0[hook(10, 3)] | 0x01000000;
      break;
  }
}

inline void append_0x01_2x4(unsigned int w0[4], unsigned int w1[4], const unsigned int offset) {
  switch (offset) {
    case 0:
      w0[hook(10, 0)] = 0x01;
      break;

    case 1:
      w0[hook(10, 0)] = w0[hook(10, 0)] | 0x0100;
      break;

    case 2:
      w0[hook(10, 0)] = w0[hook(10, 0)] | 0x010000;
      break;

    case 3:
      w0[hook(10, 0)] = w0[hook(10, 0)] | 0x01000000;
      break;

    case 4:
      w0[hook(10, 1)] = 0x01;
      break;

    case 5:
      w0[hook(10, 1)] = w0[hook(10, 1)] | 0x0100;
      break;

    case 6:
      w0[hook(10, 1)] = w0[hook(10, 1)] | 0x010000;
      break;

    case 7:
      w0[hook(10, 1)] = w0[hook(10, 1)] | 0x01000000;
      break;

    case 8:
      w0[hook(10, 2)] = 0x01;
      break;

    case 9:
      w0[hook(10, 2)] = w0[hook(10, 2)] | 0x0100;
      break;

    case 10:
      w0[hook(10, 2)] = w0[hook(10, 2)] | 0x010000;
      break;

    case 11:
      w0[hook(10, 2)] = w0[hook(10, 2)] | 0x01000000;
      break;

    case 12:
      w0[hook(10, 3)] = 0x01;
      break;

    case 13:
      w0[hook(10, 3)] = w0[hook(10, 3)] | 0x0100;
      break;

    case 14:
      w0[hook(10, 3)] = w0[hook(10, 3)] | 0x010000;
      break;

    case 15:
      w0[hook(10, 3)] = w0[hook(10, 3)] | 0x01000000;
      break;

    case 16:
      w1[hook(11, 0)] = 0x01;
      break;

    case 17:
      w1[hook(11, 0)] = w1[hook(11, 0)] | 0x0100;
      break;

    case 18:
      w1[hook(11, 0)] = w1[hook(11, 0)] | 0x010000;
      break;

    case 19:
      w1[hook(11, 0)] = w1[hook(11, 0)] | 0x01000000;
      break;

    case 20:
      w1[hook(11, 1)] = 0x01;
      break;

    case 21:
      w1[hook(11, 1)] = w1[hook(11, 1)] | 0x0100;
      break;

    case 22:
      w1[hook(11, 1)] = w1[hook(11, 1)] | 0x010000;
      break;

    case 23:
      w1[hook(11, 1)] = w1[hook(11, 1)] | 0x01000000;
      break;

    case 24:
      w1[hook(11, 2)] = 0x01;
      break;

    case 25:
      w1[hook(11, 2)] = w1[hook(11, 2)] | 0x0100;
      break;

    case 26:
      w1[hook(11, 2)] = w1[hook(11, 2)] | 0x010000;
      break;

    case 27:
      w1[hook(11, 2)] = w1[hook(11, 2)] | 0x01000000;
      break;

    case 28:
      w1[hook(11, 3)] = 0x01;
      break;

    case 29:
      w1[hook(11, 3)] = w1[hook(11, 3)] | 0x0100;
      break;

    case 30:
      w1[hook(11, 3)] = w1[hook(11, 3)] | 0x010000;
      break;

    case 31:
      w1[hook(11, 3)] = w1[hook(11, 3)] | 0x01000000;
      break;
  }
}

inline void append_0x01_3x4(unsigned int w0[4], unsigned int w1[4], unsigned int w2[4], const unsigned int offset) {
  switch (offset) {
    case 0:
      w0[hook(10, 0)] = 0x01;
      break;

    case 1:
      w0[hook(10, 0)] = w0[hook(10, 0)] | 0x0100;
      break;

    case 2:
      w0[hook(10, 0)] = w0[hook(10, 0)] | 0x010000;
      break;

    case 3:
      w0[hook(10, 0)] = w0[hook(10, 0)] | 0x01000000;
      break;

    case 4:
      w0[hook(10, 1)] = 0x01;
      break;

    case 5:
      w0[hook(10, 1)] = w0[hook(10, 1)] | 0x0100;
      break;

    case 6:
      w0[hook(10, 1)] = w0[hook(10, 1)] | 0x010000;
      break;

    case 7:
      w0[hook(10, 1)] = w0[hook(10, 1)] | 0x01000000;
      break;

    case 8:
      w0[hook(10, 2)] = 0x01;
      break;

    case 9:
      w0[hook(10, 2)] = w0[hook(10, 2)] | 0x0100;
      break;

    case 10:
      w0[hook(10, 2)] = w0[hook(10, 2)] | 0x010000;
      break;

    case 11:
      w0[hook(10, 2)] = w0[hook(10, 2)] | 0x01000000;
      break;

    case 12:
      w0[hook(10, 3)] = 0x01;
      break;

    case 13:
      w0[hook(10, 3)] = w0[hook(10, 3)] | 0x0100;
      break;

    case 14:
      w0[hook(10, 3)] = w0[hook(10, 3)] | 0x010000;
      break;

    case 15:
      w0[hook(10, 3)] = w0[hook(10, 3)] | 0x01000000;
      break;

    case 16:
      w1[hook(11, 0)] = 0x01;
      break;

    case 17:
      w1[hook(11, 0)] = w1[hook(11, 0)] | 0x0100;
      break;

    case 18:
      w1[hook(11, 0)] = w1[hook(11, 0)] | 0x010000;
      break;

    case 19:
      w1[hook(11, 0)] = w1[hook(11, 0)] | 0x01000000;
      break;

    case 20:
      w1[hook(11, 1)] = 0x01;
      break;

    case 21:
      w1[hook(11, 1)] = w1[hook(11, 1)] | 0x0100;
      break;

    case 22:
      w1[hook(11, 1)] = w1[hook(11, 1)] | 0x010000;
      break;

    case 23:
      w1[hook(11, 1)] = w1[hook(11, 1)] | 0x01000000;
      break;

    case 24:
      w1[hook(11, 2)] = 0x01;
      break;

    case 25:
      w1[hook(11, 2)] = w1[hook(11, 2)] | 0x0100;
      break;

    case 26:
      w1[hook(11, 2)] = w1[hook(11, 2)] | 0x010000;
      break;

    case 27:
      w1[hook(11, 2)] = w1[hook(11, 2)] | 0x01000000;
      break;

    case 28:
      w1[hook(11, 3)] = 0x01;
      break;

    case 29:
      w1[hook(11, 3)] = w1[hook(11, 3)] | 0x0100;
      break;

    case 30:
      w1[hook(11, 3)] = w1[hook(11, 3)] | 0x010000;
      break;

    case 31:
      w1[hook(11, 3)] = w1[hook(11, 3)] | 0x01000000;
      break;

    case 32:
      w2[hook(12, 0)] = 0x01;
      break;

    case 33:
      w2[hook(12, 0)] = w2[hook(12, 0)] | 0x0100;
      break;

    case 34:
      w2[hook(12, 0)] = w2[hook(12, 0)] | 0x010000;
      break;

    case 35:
      w2[hook(12, 0)] = w2[hook(12, 0)] | 0x01000000;
      break;

    case 36:
      w2[hook(12, 1)] = 0x01;
      break;

    case 37:
      w2[hook(12, 1)] = w2[hook(12, 1)] | 0x0100;
      break;

    case 38:
      w2[hook(12, 1)] = w2[hook(12, 1)] | 0x010000;
      break;

    case 39:
      w2[hook(12, 1)] = w2[hook(12, 1)] | 0x01000000;
      break;

    case 40:
      w2[hook(12, 2)] = 0x01;
      break;

    case 41:
      w2[hook(12, 2)] = w2[hook(12, 2)] | 0x0100;
      break;

    case 42:
      w2[hook(12, 2)] = w2[hook(12, 2)] | 0x010000;
      break;

    case 43:
      w2[hook(12, 2)] = w2[hook(12, 2)] | 0x01000000;
      break;

    case 44:
      w2[hook(12, 3)] = 0x01;
      break;

    case 45:
      w2[hook(12, 3)] = w2[hook(12, 3)] | 0x0100;
      break;

    case 46:
      w2[hook(12, 3)] = w2[hook(12, 3)] | 0x010000;
      break;

    case 47:
      w2[hook(12, 3)] = w2[hook(12, 3)] | 0x01000000;
      break;
  }
}

inline void append_0x01_4x4(unsigned int w0[4], unsigned int w1[4], unsigned int w2[4], unsigned int w3[4], const unsigned int offset) {
  switch (offset) {
    case 0:
      w0[hook(10, 0)] = 0x01;
      break;

    case 1:
      w0[hook(10, 0)] = w0[hook(10, 0)] | 0x0100;
      break;

    case 2:
      w0[hook(10, 0)] = w0[hook(10, 0)] | 0x010000;
      break;

    case 3:
      w0[hook(10, 0)] = w0[hook(10, 0)] | 0x01000000;
      break;

    case 4:
      w0[hook(10, 1)] = 0x01;
      break;

    case 5:
      w0[hook(10, 1)] = w0[hook(10, 1)] | 0x0100;
      break;

    case 6:
      w0[hook(10, 1)] = w0[hook(10, 1)] | 0x010000;
      break;

    case 7:
      w0[hook(10, 1)] = w0[hook(10, 1)] | 0x01000000;
      break;

    case 8:
      w0[hook(10, 2)] = 0x01;
      break;

    case 9:
      w0[hook(10, 2)] = w0[hook(10, 2)] | 0x0100;
      break;

    case 10:
      w0[hook(10, 2)] = w0[hook(10, 2)] | 0x010000;
      break;

    case 11:
      w0[hook(10, 2)] = w0[hook(10, 2)] | 0x01000000;
      break;

    case 12:
      w0[hook(10, 3)] = 0x01;
      break;

    case 13:
      w0[hook(10, 3)] = w0[hook(10, 3)] | 0x0100;
      break;

    case 14:
      w0[hook(10, 3)] = w0[hook(10, 3)] | 0x010000;
      break;

    case 15:
      w0[hook(10, 3)] = w0[hook(10, 3)] | 0x01000000;
      break;

    case 16:
      w1[hook(11, 0)] = 0x01;
      break;

    case 17:
      w1[hook(11, 0)] = w1[hook(11, 0)] | 0x0100;
      break;

    case 18:
      w1[hook(11, 0)] = w1[hook(11, 0)] | 0x010000;
      break;

    case 19:
      w1[hook(11, 0)] = w1[hook(11, 0)] | 0x01000000;
      break;

    case 20:
      w1[hook(11, 1)] = 0x01;
      break;

    case 21:
      w1[hook(11, 1)] = w1[hook(11, 1)] | 0x0100;
      break;

    case 22:
      w1[hook(11, 1)] = w1[hook(11, 1)] | 0x010000;
      break;

    case 23:
      w1[hook(11, 1)] = w1[hook(11, 1)] | 0x01000000;
      break;

    case 24:
      w1[hook(11, 2)] = 0x01;
      break;

    case 25:
      w1[hook(11, 2)] = w1[hook(11, 2)] | 0x0100;
      break;

    case 26:
      w1[hook(11, 2)] = w1[hook(11, 2)] | 0x010000;
      break;

    case 27:
      w1[hook(11, 2)] = w1[hook(11, 2)] | 0x01000000;
      break;

    case 28:
      w1[hook(11, 3)] = 0x01;
      break;

    case 29:
      w1[hook(11, 3)] = w1[hook(11, 3)] | 0x0100;
      break;

    case 30:
      w1[hook(11, 3)] = w1[hook(11, 3)] | 0x010000;
      break;

    case 31:
      w1[hook(11, 3)] = w1[hook(11, 3)] | 0x01000000;
      break;

    case 32:
      w2[hook(12, 0)] = 0x01;
      break;

    case 33:
      w2[hook(12, 0)] = w2[hook(12, 0)] | 0x0100;
      break;

    case 34:
      w2[hook(12, 0)] = w2[hook(12, 0)] | 0x010000;
      break;

    case 35:
      w2[hook(12, 0)] = w2[hook(12, 0)] | 0x01000000;
      break;

    case 36:
      w2[hook(12, 1)] = 0x01;
      break;

    case 37:
      w2[hook(12, 1)] = w2[hook(12, 1)] | 0x0100;
      break;

    case 38:
      w2[hook(12, 1)] = w2[hook(12, 1)] | 0x010000;
      break;

    case 39:
      w2[hook(12, 1)] = w2[hook(12, 1)] | 0x01000000;
      break;

    case 40:
      w2[hook(12, 2)] = 0x01;
      break;

    case 41:
      w2[hook(12, 2)] = w2[hook(12, 2)] | 0x0100;
      break;

    case 42:
      w2[hook(12, 2)] = w2[hook(12, 2)] | 0x010000;
      break;

    case 43:
      w2[hook(12, 2)] = w2[hook(12, 2)] | 0x01000000;
      break;

    case 44:
      w2[hook(12, 3)] = 0x01;
      break;

    case 45:
      w2[hook(12, 3)] = w2[hook(12, 3)] | 0x0100;
      break;

    case 46:
      w2[hook(12, 3)] = w2[hook(12, 3)] | 0x010000;
      break;

    case 47:
      w2[hook(12, 3)] = w2[hook(12, 3)] | 0x01000000;
      break;

    case 48:
      w3[hook(13, 0)] = 0x01;
      break;

    case 49:
      w3[hook(13, 0)] = w3[hook(13, 0)] | 0x0100;
      break;

    case 50:
      w3[hook(13, 0)] = w3[hook(13, 0)] | 0x010000;
      break;

    case 51:
      w3[hook(13, 0)] = w3[hook(13, 0)] | 0x01000000;
      break;

    case 52:
      w3[hook(13, 1)] = 0x01;
      break;

    case 53:
      w3[hook(13, 1)] = w3[hook(13, 1)] | 0x0100;
      break;

    case 54:
      w3[hook(13, 1)] = w3[hook(13, 1)] | 0x010000;
      break;

    case 55:
      w3[hook(13, 1)] = w3[hook(13, 1)] | 0x01000000;
      break;

    case 56:
      w3[hook(13, 2)] = 0x01;
      break;

    case 57:
      w3[hook(13, 2)] = w3[hook(13, 2)] | 0x0100;
      break;

    case 58:
      w3[hook(13, 2)] = w3[hook(13, 2)] | 0x010000;
      break;

    case 59:
      w3[hook(13, 2)] = w3[hook(13, 2)] | 0x01000000;
      break;

    case 60:
      w3[hook(13, 3)] = 0x01;
      break;

    case 61:
      w3[hook(13, 3)] = w3[hook(13, 3)] | 0x0100;
      break;

    case 62:
      w3[hook(13, 3)] = w3[hook(13, 3)] | 0x010000;
      break;

    case 63:
      w3[hook(13, 3)] = w3[hook(13, 3)] | 0x01000000;
      break;
  }
}

inline void append_0x01_8x4(unsigned int w0[4], unsigned int w1[4], unsigned int w2[4], unsigned int w3[4], unsigned int w4[4], unsigned int w5[4], unsigned int w6[4], unsigned int w7[4], const unsigned int offset) {
  switch (offset) {
    case 0:
      w0[hook(10, 0)] = 0x01;
      break;

    case 1:
      w0[hook(10, 0)] = w0[hook(10, 0)] | 0x0100;
      break;

    case 2:
      w0[hook(10, 0)] = w0[hook(10, 0)] | 0x010000;
      break;

    case 3:
      w0[hook(10, 0)] = w0[hook(10, 0)] | 0x01000000;
      break;

    case 4:
      w0[hook(10, 1)] = 0x01;
      break;

    case 5:
      w0[hook(10, 1)] = w0[hook(10, 1)] | 0x0100;
      break;

    case 6:
      w0[hook(10, 1)] = w0[hook(10, 1)] | 0x010000;
      break;

    case 7:
      w0[hook(10, 1)] = w0[hook(10, 1)] | 0x01000000;
      break;

    case 8:
      w0[hook(10, 2)] = 0x01;
      break;

    case 9:
      w0[hook(10, 2)] = w0[hook(10, 2)] | 0x0100;
      break;

    case 10:
      w0[hook(10, 2)] = w0[hook(10, 2)] | 0x010000;
      break;

    case 11:
      w0[hook(10, 2)] = w0[hook(10, 2)] | 0x01000000;
      break;

    case 12:
      w0[hook(10, 3)] = 0x01;
      break;

    case 13:
      w0[hook(10, 3)] = w0[hook(10, 3)] | 0x0100;
      break;

    case 14:
      w0[hook(10, 3)] = w0[hook(10, 3)] | 0x010000;
      break;

    case 15:
      w0[hook(10, 3)] = w0[hook(10, 3)] | 0x01000000;
      break;

    case 16:
      w1[hook(11, 0)] = 0x01;
      break;

    case 17:
      w1[hook(11, 0)] = w1[hook(11, 0)] | 0x0100;
      break;

    case 18:
      w1[hook(11, 0)] = w1[hook(11, 0)] | 0x010000;
      break;

    case 19:
      w1[hook(11, 0)] = w1[hook(11, 0)] | 0x01000000;
      break;

    case 20:
      w1[hook(11, 1)] = 0x01;
      break;

    case 21:
      w1[hook(11, 1)] = w1[hook(11, 1)] | 0x0100;
      break;

    case 22:
      w1[hook(11, 1)] = w1[hook(11, 1)] | 0x010000;
      break;

    case 23:
      w1[hook(11, 1)] = w1[hook(11, 1)] | 0x01000000;
      break;

    case 24:
      w1[hook(11, 2)] = 0x01;
      break;

    case 25:
      w1[hook(11, 2)] = w1[hook(11, 2)] | 0x0100;
      break;

    case 26:
      w1[hook(11, 2)] = w1[hook(11, 2)] | 0x010000;
      break;

    case 27:
      w1[hook(11, 2)] = w1[hook(11, 2)] | 0x01000000;
      break;

    case 28:
      w1[hook(11, 3)] = 0x01;
      break;

    case 29:
      w1[hook(11, 3)] = w1[hook(11, 3)] | 0x0100;
      break;

    case 30:
      w1[hook(11, 3)] = w1[hook(11, 3)] | 0x010000;
      break;

    case 31:
      w1[hook(11, 3)] = w1[hook(11, 3)] | 0x01000000;
      break;

    case 32:
      w2[hook(12, 0)] = 0x01;
      break;

    case 33:
      w2[hook(12, 0)] = w2[hook(12, 0)] | 0x0100;
      break;

    case 34:
      w2[hook(12, 0)] = w2[hook(12, 0)] | 0x010000;
      break;

    case 35:
      w2[hook(12, 0)] = w2[hook(12, 0)] | 0x01000000;
      break;

    case 36:
      w2[hook(12, 1)] = 0x01;
      break;

    case 37:
      w2[hook(12, 1)] = w2[hook(12, 1)] | 0x0100;
      break;

    case 38:
      w2[hook(12, 1)] = w2[hook(12, 1)] | 0x010000;
      break;

    case 39:
      w2[hook(12, 1)] = w2[hook(12, 1)] | 0x01000000;
      break;

    case 40:
      w2[hook(12, 2)] = 0x01;
      break;

    case 41:
      w2[hook(12, 2)] = w2[hook(12, 2)] | 0x0100;
      break;

    case 42:
      w2[hook(12, 2)] = w2[hook(12, 2)] | 0x010000;
      break;

    case 43:
      w2[hook(12, 2)] = w2[hook(12, 2)] | 0x01000000;
      break;

    case 44:
      w2[hook(12, 3)] = 0x01;
      break;

    case 45:
      w2[hook(12, 3)] = w2[hook(12, 3)] | 0x0100;
      break;

    case 46:
      w2[hook(12, 3)] = w2[hook(12, 3)] | 0x010000;
      break;

    case 47:
      w2[hook(12, 3)] = w2[hook(12, 3)] | 0x01000000;
      break;

    case 48:
      w3[hook(13, 0)] = 0x01;
      break;

    case 49:
      w3[hook(13, 0)] = w3[hook(13, 0)] | 0x0100;
      break;

    case 50:
      w3[hook(13, 0)] = w3[hook(13, 0)] | 0x010000;
      break;

    case 51:
      w3[hook(13, 0)] = w3[hook(13, 0)] | 0x01000000;
      break;

    case 52:
      w3[hook(13, 1)] = 0x01;
      break;

    case 53:
      w3[hook(13, 1)] = w3[hook(13, 1)] | 0x0100;
      break;

    case 54:
      w3[hook(13, 1)] = w3[hook(13, 1)] | 0x010000;
      break;

    case 55:
      w3[hook(13, 1)] = w3[hook(13, 1)] | 0x01000000;
      break;

    case 56:
      w3[hook(13, 2)] = 0x01;
      break;

    case 57:
      w3[hook(13, 2)] = w3[hook(13, 2)] | 0x0100;
      break;

    case 58:
      w3[hook(13, 2)] = w3[hook(13, 2)] | 0x010000;
      break;

    case 59:
      w3[hook(13, 2)] = w3[hook(13, 2)] | 0x01000000;
      break;

    case 60:
      w3[hook(13, 3)] = 0x01;
      break;

    case 61:
      w3[hook(13, 3)] = w3[hook(13, 3)] | 0x0100;
      break;

    case 62:
      w3[hook(13, 3)] = w3[hook(13, 3)] | 0x010000;
      break;

    case 63:
      w3[hook(13, 3)] = w3[hook(13, 3)] | 0x01000000;
      break;

    case 64:
      w4[hook(14, 0)] = 0x01;
      break;

    case 65:
      w4[hook(14, 0)] = w4[hook(14, 0)] | 0x0100;
      break;

    case 66:
      w4[hook(14, 0)] = w4[hook(14, 0)] | 0x010000;
      break;

    case 67:
      w4[hook(14, 0)] = w4[hook(14, 0)] | 0x01000000;
      break;

    case 68:
      w4[hook(14, 1)] = 0x01;
      break;

    case 69:
      w4[hook(14, 1)] = w4[hook(14, 1)] | 0x0100;
      break;

    case 70:
      w4[hook(14, 1)] = w4[hook(14, 1)] | 0x010000;
      break;

    case 71:
      w4[hook(14, 1)] = w4[hook(14, 1)] | 0x01000000;
      break;

    case 72:
      w4[hook(14, 2)] = 0x01;
      break;

    case 73:
      w4[hook(14, 2)] = w4[hook(14, 2)] | 0x0100;
      break;

    case 74:
      w4[hook(14, 2)] = w4[hook(14, 2)] | 0x010000;
      break;

    case 75:
      w4[hook(14, 2)] = w4[hook(14, 2)] | 0x01000000;
      break;

    case 76:
      w4[hook(14, 3)] = 0x01;
      break;

    case 77:
      w4[hook(14, 3)] = w4[hook(14, 3)] | 0x0100;
      break;

    case 78:
      w4[hook(14, 3)] = w4[hook(14, 3)] | 0x010000;
      break;

    case 79:
      w4[hook(14, 3)] = w4[hook(14, 3)] | 0x01000000;
      break;

    case 80:
      w5[hook(15, 0)] = 0x01;
      break;

    case 81:
      w5[hook(15, 0)] = w5[hook(15, 0)] | 0x0100;
      break;

    case 82:
      w5[hook(15, 0)] = w5[hook(15, 0)] | 0x010000;
      break;

    case 83:
      w5[hook(15, 0)] = w5[hook(15, 0)] | 0x01000000;
      break;

    case 84:
      w5[hook(15, 1)] = 0x01;
      break;

    case 85:
      w5[hook(15, 1)] = w5[hook(15, 1)] | 0x0100;
      break;

    case 86:
      w5[hook(15, 1)] = w5[hook(15, 1)] | 0x010000;
      break;

    case 87:
      w5[hook(15, 1)] = w5[hook(15, 1)] | 0x01000000;
      break;

    case 88:
      w5[hook(15, 2)] = 0x01;
      break;

    case 89:
      w5[hook(15, 2)] = w5[hook(15, 2)] | 0x0100;
      break;

    case 90:
      w5[hook(15, 2)] = w5[hook(15, 2)] | 0x010000;
      break;

    case 91:
      w5[hook(15, 2)] = w5[hook(15, 2)] | 0x01000000;
      break;

    case 92:
      w5[hook(15, 3)] = 0x01;
      break;

    case 93:
      w5[hook(15, 3)] = w5[hook(15, 3)] | 0x0100;
      break;

    case 94:
      w5[hook(15, 3)] = w5[hook(15, 3)] | 0x010000;
      break;

    case 95:
      w5[hook(15, 3)] = w5[hook(15, 3)] | 0x01000000;
      break;

    case 96:
      w6[hook(16, 0)] = 0x01;
      break;

    case 97:
      w6[hook(16, 0)] = w6[hook(16, 0)] | 0x0100;
      break;

    case 98:
      w6[hook(16, 0)] = w6[hook(16, 0)] | 0x010000;
      break;

    case 99:
      w6[hook(16, 0)] = w6[hook(16, 0)] | 0x01000000;
      break;

    case 100:
      w6[hook(16, 1)] = 0x01;
      break;

    case 101:
      w6[hook(16, 1)] = w6[hook(16, 1)] | 0x0100;
      break;

    case 102:
      w6[hook(16, 1)] = w6[hook(16, 1)] | 0x010000;
      break;

    case 103:
      w6[hook(16, 1)] = w6[hook(16, 1)] | 0x01000000;
      break;

    case 104:
      w6[hook(16, 2)] = 0x01;
      break;

    case 105:
      w6[hook(16, 2)] = w6[hook(16, 2)] | 0x0100;
      break;

    case 106:
      w6[hook(16, 2)] = w6[hook(16, 2)] | 0x010000;
      break;

    case 107:
      w6[hook(16, 2)] = w6[hook(16, 2)] | 0x01000000;
      break;

    case 108:
      w6[hook(16, 3)] = 0x01;
      break;

    case 109:
      w6[hook(16, 3)] = w6[hook(16, 3)] | 0x0100;
      break;

    case 110:
      w6[hook(16, 3)] = w6[hook(16, 3)] | 0x010000;
      break;

    case 111:
      w6[hook(16, 3)] = w6[hook(16, 3)] | 0x01000000;
      break;

    case 112:
      w7[hook(17, 0)] = 0x01;
      break;

    case 113:
      w7[hook(17, 0)] = w7[hook(17, 0)] | 0x0100;
      break;

    case 114:
      w7[hook(17, 0)] = w7[hook(17, 0)] | 0x010000;
      break;

    case 115:
      w7[hook(17, 0)] = w7[hook(17, 0)] | 0x01000000;
      break;

    case 116:
      w7[hook(17, 1)] = 0x01;
      break;

    case 117:
      w7[hook(17, 1)] = w7[hook(17, 1)] | 0x0100;
      break;

    case 118:
      w7[hook(17, 1)] = w7[hook(17, 1)] | 0x010000;
      break;

    case 119:
      w7[hook(17, 1)] = w7[hook(17, 1)] | 0x01000000;
      break;

    case 120:
      w7[hook(17, 2)] = 0x01;
      break;

    case 121:
      w7[hook(17, 2)] = w7[hook(17, 2)] | 0x0100;
      break;

    case 122:
      w7[hook(17, 2)] = w7[hook(17, 2)] | 0x010000;
      break;

    case 123:
      w7[hook(17, 2)] = w7[hook(17, 2)] | 0x01000000;
      break;

    case 124:
      w7[hook(17, 3)] = 0x01;
      break;

    case 125:
      w7[hook(17, 3)] = w7[hook(17, 3)] | 0x0100;
      break;

    case 126:
      w7[hook(17, 3)] = w7[hook(17, 3)] | 0x010000;
      break;

    case 127:
      w7[hook(17, 3)] = w7[hook(17, 3)] | 0x01000000;
      break;
  }
}

inline void append_0x02_1x4(unsigned int w0[4], const unsigned int offset) {
  switch (offset) {
    case 0:
      w0[hook(10, 0)] = 0x02;
      break;

    case 1:
      w0[hook(10, 0)] = w0[hook(10, 0)] | 0x0200;
      break;

    case 2:
      w0[hook(10, 0)] = w0[hook(10, 0)] | 0x020000;
      break;

    case 3:
      w0[hook(10, 0)] = w0[hook(10, 0)] | 0x02000000;
      break;

    case 4:
      w0[hook(10, 1)] = 0x02;
      break;

    case 5:
      w0[hook(10, 1)] = w0[hook(10, 1)] | 0x0200;
      break;

    case 6:
      w0[hook(10, 1)] = w0[hook(10, 1)] | 0x020000;
      break;

    case 7:
      w0[hook(10, 1)] = w0[hook(10, 1)] | 0x02000000;
      break;

    case 8:
      w0[hook(10, 2)] = 0x02;
      break;

    case 9:
      w0[hook(10, 2)] = w0[hook(10, 2)] | 0x0200;
      break;

    case 10:
      w0[hook(10, 2)] = w0[hook(10, 2)] | 0x020000;
      break;

    case 11:
      w0[hook(10, 2)] = w0[hook(10, 2)] | 0x02000000;
      break;

    case 12:
      w0[hook(10, 3)] = 0x02;
      break;

    case 13:
      w0[hook(10, 3)] = w0[hook(10, 3)] | 0x0200;
      break;

    case 14:
      w0[hook(10, 3)] = w0[hook(10, 3)] | 0x020000;
      break;

    case 15:
      w0[hook(10, 3)] = w0[hook(10, 3)] | 0x02000000;
      break;
  }
}

inline void append_0x02_2x4(unsigned int w0[4], unsigned int w1[4], const unsigned int offset) {
  switch (offset) {
    case 0:
      w0[hook(10, 0)] = 0x02;
      break;

    case 1:
      w0[hook(10, 0)] = w0[hook(10, 0)] | 0x0200;
      break;

    case 2:
      w0[hook(10, 0)] = w0[hook(10, 0)] | 0x020000;
      break;

    case 3:
      w0[hook(10, 0)] = w0[hook(10, 0)] | 0x02000000;
      break;

    case 4:
      w0[hook(10, 1)] = 0x02;
      break;

    case 5:
      w0[hook(10, 1)] = w0[hook(10, 1)] | 0x0200;
      break;

    case 6:
      w0[hook(10, 1)] = w0[hook(10, 1)] | 0x020000;
      break;

    case 7:
      w0[hook(10, 1)] = w0[hook(10, 1)] | 0x02000000;
      break;

    case 8:
      w0[hook(10, 2)] = 0x02;
      break;

    case 9:
      w0[hook(10, 2)] = w0[hook(10, 2)] | 0x0200;
      break;

    case 10:
      w0[hook(10, 2)] = w0[hook(10, 2)] | 0x020000;
      break;

    case 11:
      w0[hook(10, 2)] = w0[hook(10, 2)] | 0x02000000;
      break;

    case 12:
      w0[hook(10, 3)] = 0x02;
      break;

    case 13:
      w0[hook(10, 3)] = w0[hook(10, 3)] | 0x0200;
      break;

    case 14:
      w0[hook(10, 3)] = w0[hook(10, 3)] | 0x020000;
      break;

    case 15:
      w0[hook(10, 3)] = w0[hook(10, 3)] | 0x02000000;
      break;

    case 16:
      w1[hook(11, 0)] = 0x02;
      break;

    case 17:
      w1[hook(11, 0)] = w1[hook(11, 0)] | 0x0200;
      break;

    case 18:
      w1[hook(11, 0)] = w1[hook(11, 0)] | 0x020000;
      break;

    case 19:
      w1[hook(11, 0)] = w1[hook(11, 0)] | 0x02000000;
      break;

    case 20:
      w1[hook(11, 1)] = 0x02;
      break;

    case 21:
      w1[hook(11, 1)] = w1[hook(11, 1)] | 0x0200;
      break;

    case 22:
      w1[hook(11, 1)] = w1[hook(11, 1)] | 0x020000;
      break;

    case 23:
      w1[hook(11, 1)] = w1[hook(11, 1)] | 0x02000000;
      break;

    case 24:
      w1[hook(11, 2)] = 0x02;
      break;

    case 25:
      w1[hook(11, 2)] = w1[hook(11, 2)] | 0x0200;
      break;

    case 26:
      w1[hook(11, 2)] = w1[hook(11, 2)] | 0x020000;
      break;

    case 27:
      w1[hook(11, 2)] = w1[hook(11, 2)] | 0x02000000;
      break;

    case 28:
      w1[hook(11, 3)] = 0x02;
      break;

    case 29:
      w1[hook(11, 3)] = w1[hook(11, 3)] | 0x0200;
      break;

    case 30:
      w1[hook(11, 3)] = w1[hook(11, 3)] | 0x020000;
      break;

    case 31:
      w1[hook(11, 3)] = w1[hook(11, 3)] | 0x02000000;
      break;
  }
}

inline void append_0x02_3x4(unsigned int w0[4], unsigned int w1[4], unsigned int w2[4], const unsigned int offset) {
  switch (offset) {
    case 0:
      w0[hook(10, 0)] = 0x02;
      break;

    case 1:
      w0[hook(10, 0)] = w0[hook(10, 0)] | 0x0200;
      break;

    case 2:
      w0[hook(10, 0)] = w0[hook(10, 0)] | 0x020000;
      break;

    case 3:
      w0[hook(10, 0)] = w0[hook(10, 0)] | 0x02000000;
      break;

    case 4:
      w0[hook(10, 1)] = 0x02;
      break;

    case 5:
      w0[hook(10, 1)] = w0[hook(10, 1)] | 0x0200;
      break;

    case 6:
      w0[hook(10, 1)] = w0[hook(10, 1)] | 0x020000;
      break;

    case 7:
      w0[hook(10, 1)] = w0[hook(10, 1)] | 0x02000000;
      break;

    case 8:
      w0[hook(10, 2)] = 0x02;
      break;

    case 9:
      w0[hook(10, 2)] = w0[hook(10, 2)] | 0x0200;
      break;

    case 10:
      w0[hook(10, 2)] = w0[hook(10, 2)] | 0x020000;
      break;

    case 11:
      w0[hook(10, 2)] = w0[hook(10, 2)] | 0x02000000;
      break;

    case 12:
      w0[hook(10, 3)] = 0x02;
      break;

    case 13:
      w0[hook(10, 3)] = w0[hook(10, 3)] | 0x0200;
      break;

    case 14:
      w0[hook(10, 3)] = w0[hook(10, 3)] | 0x020000;
      break;

    case 15:
      w0[hook(10, 3)] = w0[hook(10, 3)] | 0x02000000;
      break;

    case 16:
      w1[hook(11, 0)] = 0x02;
      break;

    case 17:
      w1[hook(11, 0)] = w1[hook(11, 0)] | 0x0200;
      break;

    case 18:
      w1[hook(11, 0)] = w1[hook(11, 0)] | 0x020000;
      break;

    case 19:
      w1[hook(11, 0)] = w1[hook(11, 0)] | 0x02000000;
      break;

    case 20:
      w1[hook(11, 1)] = 0x02;
      break;

    case 21:
      w1[hook(11, 1)] = w1[hook(11, 1)] | 0x0200;
      break;

    case 22:
      w1[hook(11, 1)] = w1[hook(11, 1)] | 0x020000;
      break;

    case 23:
      w1[hook(11, 1)] = w1[hook(11, 1)] | 0x02000000;
      break;

    case 24:
      w1[hook(11, 2)] = 0x02;
      break;

    case 25:
      w1[hook(11, 2)] = w1[hook(11, 2)] | 0x0200;
      break;

    case 26:
      w1[hook(11, 2)] = w1[hook(11, 2)] | 0x020000;
      break;

    case 27:
      w1[hook(11, 2)] = w1[hook(11, 2)] | 0x02000000;
      break;

    case 28:
      w1[hook(11, 3)] = 0x02;
      break;

    case 29:
      w1[hook(11, 3)] = w1[hook(11, 3)] | 0x0200;
      break;

    case 30:
      w1[hook(11, 3)] = w1[hook(11, 3)] | 0x020000;
      break;

    case 31:
      w1[hook(11, 3)] = w1[hook(11, 3)] | 0x02000000;
      break;

    case 32:
      w2[hook(12, 0)] = 0x02;
      break;

    case 33:
      w2[hook(12, 0)] = w2[hook(12, 0)] | 0x0200;
      break;

    case 34:
      w2[hook(12, 0)] = w2[hook(12, 0)] | 0x020000;
      break;

    case 35:
      w2[hook(12, 0)] = w2[hook(12, 0)] | 0x02000000;
      break;

    case 36:
      w2[hook(12, 1)] = 0x02;
      break;

    case 37:
      w2[hook(12, 1)] = w2[hook(12, 1)] | 0x0200;
      break;

    case 38:
      w2[hook(12, 1)] = w2[hook(12, 1)] | 0x020000;
      break;

    case 39:
      w2[hook(12, 1)] = w2[hook(12, 1)] | 0x02000000;
      break;

    case 40:
      w2[hook(12, 2)] = 0x02;
      break;

    case 41:
      w2[hook(12, 2)] = w2[hook(12, 2)] | 0x0200;
      break;

    case 42:
      w2[hook(12, 2)] = w2[hook(12, 2)] | 0x020000;
      break;

    case 43:
      w2[hook(12, 2)] = w2[hook(12, 2)] | 0x02000000;
      break;

    case 44:
      w2[hook(12, 3)] = 0x02;
      break;

    case 45:
      w2[hook(12, 3)] = w2[hook(12, 3)] | 0x0200;
      break;

    case 46:
      w2[hook(12, 3)] = w2[hook(12, 3)] | 0x020000;
      break;

    case 47:
      w2[hook(12, 3)] = w2[hook(12, 3)] | 0x02000000;
      break;
  }
}

inline void append_0x02_4x4(unsigned int w0[4], unsigned int w1[4], unsigned int w2[4], unsigned int w3[4], const unsigned int offset) {
  switch (offset) {
    case 0:
      w0[hook(10, 0)] = 0x02;
      break;

    case 1:
      w0[hook(10, 0)] = w0[hook(10, 0)] | 0x0200;
      break;

    case 2:
      w0[hook(10, 0)] = w0[hook(10, 0)] | 0x020000;
      break;

    case 3:
      w0[hook(10, 0)] = w0[hook(10, 0)] | 0x02000000;
      break;

    case 4:
      w0[hook(10, 1)] = 0x02;
      break;

    case 5:
      w0[hook(10, 1)] = w0[hook(10, 1)] | 0x0200;
      break;

    case 6:
      w0[hook(10, 1)] = w0[hook(10, 1)] | 0x020000;
      break;

    case 7:
      w0[hook(10, 1)] = w0[hook(10, 1)] | 0x02000000;
      break;

    case 8:
      w0[hook(10, 2)] = 0x02;
      break;

    case 9:
      w0[hook(10, 2)] = w0[hook(10, 2)] | 0x0200;
      break;

    case 10:
      w0[hook(10, 2)] = w0[hook(10, 2)] | 0x020000;
      break;

    case 11:
      w0[hook(10, 2)] = w0[hook(10, 2)] | 0x02000000;
      break;

    case 12:
      w0[hook(10, 3)] = 0x02;
      break;

    case 13:
      w0[hook(10, 3)] = w0[hook(10, 3)] | 0x0200;
      break;

    case 14:
      w0[hook(10, 3)] = w0[hook(10, 3)] | 0x020000;
      break;

    case 15:
      w0[hook(10, 3)] = w0[hook(10, 3)] | 0x02000000;
      break;

    case 16:
      w1[hook(11, 0)] = 0x02;
      break;

    case 17:
      w1[hook(11, 0)] = w1[hook(11, 0)] | 0x0200;
      break;

    case 18:
      w1[hook(11, 0)] = w1[hook(11, 0)] | 0x020000;
      break;

    case 19:
      w1[hook(11, 0)] = w1[hook(11, 0)] | 0x02000000;
      break;

    case 20:
      w1[hook(11, 1)] = 0x02;
      break;

    case 21:
      w1[hook(11, 1)] = w1[hook(11, 1)] | 0x0200;
      break;

    case 22:
      w1[hook(11, 1)] = w1[hook(11, 1)] | 0x020000;
      break;

    case 23:
      w1[hook(11, 1)] = w1[hook(11, 1)] | 0x02000000;
      break;

    case 24:
      w1[hook(11, 2)] = 0x02;
      break;

    case 25:
      w1[hook(11, 2)] = w1[hook(11, 2)] | 0x0200;
      break;

    case 26:
      w1[hook(11, 2)] = w1[hook(11, 2)] | 0x020000;
      break;

    case 27:
      w1[hook(11, 2)] = w1[hook(11, 2)] | 0x02000000;
      break;

    case 28:
      w1[hook(11, 3)] = 0x02;
      break;

    case 29:
      w1[hook(11, 3)] = w1[hook(11, 3)] | 0x0200;
      break;

    case 30:
      w1[hook(11, 3)] = w1[hook(11, 3)] | 0x020000;
      break;

    case 31:
      w1[hook(11, 3)] = w1[hook(11, 3)] | 0x02000000;
      break;

    case 32:
      w2[hook(12, 0)] = 0x02;
      break;

    case 33:
      w2[hook(12, 0)] = w2[hook(12, 0)] | 0x0200;
      break;

    case 34:
      w2[hook(12, 0)] = w2[hook(12, 0)] | 0x020000;
      break;

    case 35:
      w2[hook(12, 0)] = w2[hook(12, 0)] | 0x02000000;
      break;

    case 36:
      w2[hook(12, 1)] = 0x02;
      break;

    case 37:
      w2[hook(12, 1)] = w2[hook(12, 1)] | 0x0200;
      break;

    case 38:
      w2[hook(12, 1)] = w2[hook(12, 1)] | 0x020000;
      break;

    case 39:
      w2[hook(12, 1)] = w2[hook(12, 1)] | 0x02000000;
      break;

    case 40:
      w2[hook(12, 2)] = 0x02;
      break;

    case 41:
      w2[hook(12, 2)] = w2[hook(12, 2)] | 0x0200;
      break;

    case 42:
      w2[hook(12, 2)] = w2[hook(12, 2)] | 0x020000;
      break;

    case 43:
      w2[hook(12, 2)] = w2[hook(12, 2)] | 0x02000000;
      break;

    case 44:
      w2[hook(12, 3)] = 0x02;
      break;

    case 45:
      w2[hook(12, 3)] = w2[hook(12, 3)] | 0x0200;
      break;

    case 46:
      w2[hook(12, 3)] = w2[hook(12, 3)] | 0x020000;
      break;

    case 47:
      w2[hook(12, 3)] = w2[hook(12, 3)] | 0x02000000;
      break;

    case 48:
      w3[hook(13, 0)] = 0x02;
      break;

    case 49:
      w3[hook(13, 0)] = w3[hook(13, 0)] | 0x0200;
      break;

    case 50:
      w3[hook(13, 0)] = w3[hook(13, 0)] | 0x020000;
      break;

    case 51:
      w3[hook(13, 0)] = w3[hook(13, 0)] | 0x02000000;
      break;

    case 52:
      w3[hook(13, 1)] = 0x02;
      break;

    case 53:
      w3[hook(13, 1)] = w3[hook(13, 1)] | 0x0200;
      break;

    case 54:
      w3[hook(13, 1)] = w3[hook(13, 1)] | 0x020000;
      break;

    case 55:
      w3[hook(13, 1)] = w3[hook(13, 1)] | 0x02000000;
      break;

    case 56:
      w3[hook(13, 2)] = 0x02;
      break;

    case 57:
      w3[hook(13, 2)] = w3[hook(13, 2)] | 0x0200;
      break;

    case 58:
      w3[hook(13, 2)] = w3[hook(13, 2)] | 0x020000;
      break;

    case 59:
      w3[hook(13, 2)] = w3[hook(13, 2)] | 0x02000000;
      break;

    case 60:
      w3[hook(13, 3)] = 0x02;
      break;

    case 61:
      w3[hook(13, 3)] = w3[hook(13, 3)] | 0x0200;
      break;

    case 62:
      w3[hook(13, 3)] = w3[hook(13, 3)] | 0x020000;
      break;

    case 63:
      w3[hook(13, 3)] = w3[hook(13, 3)] | 0x02000000;
      break;
  }
}

inline void append_0x02_8x4(unsigned int w0[4], unsigned int w1[4], unsigned int w2[4], unsigned int w3[4], unsigned int w4[4], unsigned int w5[4], unsigned int w6[4], unsigned int w7[4], const unsigned int offset) {
  switch (offset) {
    case 0:
      w0[hook(10, 0)] = 0x02;
      break;

    case 1:
      w0[hook(10, 0)] = w0[hook(10, 0)] | 0x0200;
      break;

    case 2:
      w0[hook(10, 0)] = w0[hook(10, 0)] | 0x020000;
      break;

    case 3:
      w0[hook(10, 0)] = w0[hook(10, 0)] | 0x02000000;
      break;

    case 4:
      w0[hook(10, 1)] = 0x02;
      break;

    case 5:
      w0[hook(10, 1)] = w0[hook(10, 1)] | 0x0200;
      break;

    case 6:
      w0[hook(10, 1)] = w0[hook(10, 1)] | 0x020000;
      break;

    case 7:
      w0[hook(10, 1)] = w0[hook(10, 1)] | 0x02000000;
      break;

    case 8:
      w0[hook(10, 2)] = 0x02;
      break;

    case 9:
      w0[hook(10, 2)] = w0[hook(10, 2)] | 0x0200;
      break;

    case 10:
      w0[hook(10, 2)] = w0[hook(10, 2)] | 0x020000;
      break;

    case 11:
      w0[hook(10, 2)] = w0[hook(10, 2)] | 0x02000000;
      break;

    case 12:
      w0[hook(10, 3)] = 0x02;
      break;

    case 13:
      w0[hook(10, 3)] = w0[hook(10, 3)] | 0x0200;
      break;

    case 14:
      w0[hook(10, 3)] = w0[hook(10, 3)] | 0x020000;
      break;

    case 15:
      w0[hook(10, 3)] = w0[hook(10, 3)] | 0x02000000;
      break;

    case 16:
      w1[hook(11, 0)] = 0x02;
      break;

    case 17:
      w1[hook(11, 0)] = w1[hook(11, 0)] | 0x0200;
      break;

    case 18:
      w1[hook(11, 0)] = w1[hook(11, 0)] | 0x020000;
      break;

    case 19:
      w1[hook(11, 0)] = w1[hook(11, 0)] | 0x02000000;
      break;

    case 20:
      w1[hook(11, 1)] = 0x02;
      break;

    case 21:
      w1[hook(11, 1)] = w1[hook(11, 1)] | 0x0200;
      break;

    case 22:
      w1[hook(11, 1)] = w1[hook(11, 1)] | 0x020000;
      break;

    case 23:
      w1[hook(11, 1)] = w1[hook(11, 1)] | 0x02000000;
      break;

    case 24:
      w1[hook(11, 2)] = 0x02;
      break;

    case 25:
      w1[hook(11, 2)] = w1[hook(11, 2)] | 0x0200;
      break;

    case 26:
      w1[hook(11, 2)] = w1[hook(11, 2)] | 0x020000;
      break;

    case 27:
      w1[hook(11, 2)] = w1[hook(11, 2)] | 0x02000000;
      break;

    case 28:
      w1[hook(11, 3)] = 0x02;
      break;

    case 29:
      w1[hook(11, 3)] = w1[hook(11, 3)] | 0x0200;
      break;

    case 30:
      w1[hook(11, 3)] = w1[hook(11, 3)] | 0x020000;
      break;

    case 31:
      w1[hook(11, 3)] = w1[hook(11, 3)] | 0x02000000;
      break;

    case 32:
      w2[hook(12, 0)] = 0x02;
      break;

    case 33:
      w2[hook(12, 0)] = w2[hook(12, 0)] | 0x0200;
      break;

    case 34:
      w2[hook(12, 0)] = w2[hook(12, 0)] | 0x020000;
      break;

    case 35:
      w2[hook(12, 0)] = w2[hook(12, 0)] | 0x02000000;
      break;

    case 36:
      w2[hook(12, 1)] = 0x02;
      break;

    case 37:
      w2[hook(12, 1)] = w2[hook(12, 1)] | 0x0200;
      break;

    case 38:
      w2[hook(12, 1)] = w2[hook(12, 1)] | 0x020000;
      break;

    case 39:
      w2[hook(12, 1)] = w2[hook(12, 1)] | 0x02000000;
      break;

    case 40:
      w2[hook(12, 2)] = 0x02;
      break;

    case 41:
      w2[hook(12, 2)] = w2[hook(12, 2)] | 0x0200;
      break;

    case 42:
      w2[hook(12, 2)] = w2[hook(12, 2)] | 0x020000;
      break;

    case 43:
      w2[hook(12, 2)] = w2[hook(12, 2)] | 0x02000000;
      break;

    case 44:
      w2[hook(12, 3)] = 0x02;
      break;

    case 45:
      w2[hook(12, 3)] = w2[hook(12, 3)] | 0x0200;
      break;

    case 46:
      w2[hook(12, 3)] = w2[hook(12, 3)] | 0x020000;
      break;

    case 47:
      w2[hook(12, 3)] = w2[hook(12, 3)] | 0x02000000;
      break;

    case 48:
      w3[hook(13, 0)] = 0x02;
      break;

    case 49:
      w3[hook(13, 0)] = w3[hook(13, 0)] | 0x0200;
      break;

    case 50:
      w3[hook(13, 0)] = w3[hook(13, 0)] | 0x020000;
      break;

    case 51:
      w3[hook(13, 0)] = w3[hook(13, 0)] | 0x02000000;
      break;

    case 52:
      w3[hook(13, 1)] = 0x02;
      break;

    case 53:
      w3[hook(13, 1)] = w3[hook(13, 1)] | 0x0200;
      break;

    case 54:
      w3[hook(13, 1)] = w3[hook(13, 1)] | 0x020000;
      break;

    case 55:
      w3[hook(13, 1)] = w3[hook(13, 1)] | 0x02000000;
      break;

    case 56:
      w3[hook(13, 2)] = 0x02;
      break;

    case 57:
      w3[hook(13, 2)] = w3[hook(13, 2)] | 0x0200;
      break;

    case 58:
      w3[hook(13, 2)] = w3[hook(13, 2)] | 0x020000;
      break;

    case 59:
      w3[hook(13, 2)] = w3[hook(13, 2)] | 0x02000000;
      break;

    case 60:
      w3[hook(13, 3)] = 0x02;
      break;

    case 61:
      w3[hook(13, 3)] = w3[hook(13, 3)] | 0x0200;
      break;

    case 62:
      w3[hook(13, 3)] = w3[hook(13, 3)] | 0x020000;
      break;

    case 63:
      w3[hook(13, 3)] = w3[hook(13, 3)] | 0x02000000;
      break;

    case 64:
      w4[hook(14, 0)] = 0x02;
      break;

    case 65:
      w4[hook(14, 0)] = w4[hook(14, 0)] | 0x0200;
      break;

    case 66:
      w4[hook(14, 0)] = w4[hook(14, 0)] | 0x020000;
      break;

    case 67:
      w4[hook(14, 0)] = w4[hook(14, 0)] | 0x02000000;
      break;

    case 68:
      w4[hook(14, 1)] = 0x02;
      break;

    case 69:
      w4[hook(14, 1)] = w4[hook(14, 1)] | 0x0200;
      break;

    case 70:
      w4[hook(14, 1)] = w4[hook(14, 1)] | 0x020000;
      break;

    case 71:
      w4[hook(14, 1)] = w4[hook(14, 1)] | 0x02000000;
      break;

    case 72:
      w4[hook(14, 2)] = 0x02;
      break;

    case 73:
      w4[hook(14, 2)] = w4[hook(14, 2)] | 0x0200;
      break;

    case 74:
      w4[hook(14, 2)] = w4[hook(14, 2)] | 0x020000;
      break;

    case 75:
      w4[hook(14, 2)] = w4[hook(14, 2)] | 0x02000000;
      break;

    case 76:
      w4[hook(14, 3)] = 0x02;
      break;

    case 77:
      w4[hook(14, 3)] = w4[hook(14, 3)] | 0x0200;
      break;

    case 78:
      w4[hook(14, 3)] = w4[hook(14, 3)] | 0x020000;
      break;

    case 79:
      w4[hook(14, 3)] = w4[hook(14, 3)] | 0x02000000;
      break;

    case 80:
      w5[hook(15, 0)] = 0x02;
      break;

    case 81:
      w5[hook(15, 0)] = w5[hook(15, 0)] | 0x0200;
      break;

    case 82:
      w5[hook(15, 0)] = w5[hook(15, 0)] | 0x020000;
      break;

    case 83:
      w5[hook(15, 0)] = w5[hook(15, 0)] | 0x02000000;
      break;

    case 84:
      w5[hook(15, 1)] = 0x02;
      break;

    case 85:
      w5[hook(15, 1)] = w5[hook(15, 1)] | 0x0200;
      break;

    case 86:
      w5[hook(15, 1)] = w5[hook(15, 1)] | 0x020000;
      break;

    case 87:
      w5[hook(15, 1)] = w5[hook(15, 1)] | 0x02000000;
      break;

    case 88:
      w5[hook(15, 2)] = 0x02;
      break;

    case 89:
      w5[hook(15, 2)] = w5[hook(15, 2)] | 0x0200;
      break;

    case 90:
      w5[hook(15, 2)] = w5[hook(15, 2)] | 0x020000;
      break;

    case 91:
      w5[hook(15, 2)] = w5[hook(15, 2)] | 0x02000000;
      break;

    case 92:
      w5[hook(15, 3)] = 0x02;
      break;

    case 93:
      w5[hook(15, 3)] = w5[hook(15, 3)] | 0x0200;
      break;

    case 94:
      w5[hook(15, 3)] = w5[hook(15, 3)] | 0x020000;
      break;

    case 95:
      w5[hook(15, 3)] = w5[hook(15, 3)] | 0x02000000;
      break;

    case 96:
      w6[hook(16, 0)] = 0x02;
      break;

    case 97:
      w6[hook(16, 0)] = w6[hook(16, 0)] | 0x0200;
      break;

    case 98:
      w6[hook(16, 0)] = w6[hook(16, 0)] | 0x020000;
      break;

    case 99:
      w6[hook(16, 0)] = w6[hook(16, 0)] | 0x02000000;
      break;

    case 100:
      w6[hook(16, 1)] = 0x02;
      break;

    case 101:
      w6[hook(16, 1)] = w6[hook(16, 1)] | 0x0200;
      break;

    case 102:
      w6[hook(16, 1)] = w6[hook(16, 1)] | 0x020000;
      break;

    case 103:
      w6[hook(16, 1)] = w6[hook(16, 1)] | 0x02000000;
      break;

    case 104:
      w6[hook(16, 2)] = 0x02;
      break;

    case 105:
      w6[hook(16, 2)] = w6[hook(16, 2)] | 0x0200;
      break;

    case 106:
      w6[hook(16, 2)] = w6[hook(16, 2)] | 0x020000;
      break;

    case 107:
      w6[hook(16, 2)] = w6[hook(16, 2)] | 0x02000000;
      break;

    case 108:
      w6[hook(16, 3)] = 0x02;
      break;

    case 109:
      w6[hook(16, 3)] = w6[hook(16, 3)] | 0x0200;
      break;

    case 110:
      w6[hook(16, 3)] = w6[hook(16, 3)] | 0x020000;
      break;

    case 111:
      w6[hook(16, 3)] = w6[hook(16, 3)] | 0x02000000;
      break;

    case 112:
      w7[hook(17, 0)] = 0x02;
      break;

    case 113:
      w7[hook(17, 0)] = w7[hook(17, 0)] | 0x0200;
      break;

    case 114:
      w7[hook(17, 0)] = w7[hook(17, 0)] | 0x020000;
      break;

    case 115:
      w7[hook(17, 0)] = w7[hook(17, 0)] | 0x02000000;
      break;

    case 116:
      w7[hook(17, 1)] = 0x02;
      break;

    case 117:
      w7[hook(17, 1)] = w7[hook(17, 1)] | 0x0200;
      break;

    case 118:
      w7[hook(17, 1)] = w7[hook(17, 1)] | 0x020000;
      break;

    case 119:
      w7[hook(17, 1)] = w7[hook(17, 1)] | 0x02000000;
      break;

    case 120:
      w7[hook(17, 2)] = 0x02;
      break;

    case 121:
      w7[hook(17, 2)] = w7[hook(17, 2)] | 0x0200;
      break;

    case 122:
      w7[hook(17, 2)] = w7[hook(17, 2)] | 0x020000;
      break;

    case 123:
      w7[hook(17, 2)] = w7[hook(17, 2)] | 0x02000000;
      break;

    case 124:
      w7[hook(17, 3)] = 0x02;
      break;

    case 125:
      w7[hook(17, 3)] = w7[hook(17, 3)] | 0x0200;
      break;

    case 126:
      w7[hook(17, 3)] = w7[hook(17, 3)] | 0x020000;
      break;

    case 127:
      w7[hook(17, 3)] = w7[hook(17, 3)] | 0x02000000;
      break;
  }
}

inline void append_0x80_1x4(unsigned int w0[4], const unsigned int offset) {
  switch (offset) {
    case 0:
      w0[hook(10, 0)] = 0x80;
      break;

    case 1:
      w0[hook(10, 0)] = w0[hook(10, 0)] | 0x8000;
      break;

    case 2:
      w0[hook(10, 0)] = w0[hook(10, 0)] | 0x800000;
      break;

    case 3:
      w0[hook(10, 0)] = w0[hook(10, 0)] | 0x80000000;
      break;

    case 4:
      w0[hook(10, 1)] = 0x80;
      break;

    case 5:
      w0[hook(10, 1)] = w0[hook(10, 1)] | 0x8000;
      break;

    case 6:
      w0[hook(10, 1)] = w0[hook(10, 1)] | 0x800000;
      break;

    case 7:
      w0[hook(10, 1)] = w0[hook(10, 1)] | 0x80000000;
      break;

    case 8:
      w0[hook(10, 2)] = 0x80;
      break;

    case 9:
      w0[hook(10, 2)] = w0[hook(10, 2)] | 0x8000;
      break;

    case 10:
      w0[hook(10, 2)] = w0[hook(10, 2)] | 0x800000;
      break;

    case 11:
      w0[hook(10, 2)] = w0[hook(10, 2)] | 0x80000000;
      break;

    case 12:
      w0[hook(10, 3)] = 0x80;
      break;

    case 13:
      w0[hook(10, 3)] = w0[hook(10, 3)] | 0x8000;
      break;

    case 14:
      w0[hook(10, 3)] = w0[hook(10, 3)] | 0x800000;
      break;

    case 15:
      w0[hook(10, 3)] = w0[hook(10, 3)] | 0x80000000;
      break;
  }
}

inline void append_0x80_2x4(unsigned int w0[4], unsigned int w1[4], const unsigned int offset) {
  switch (offset) {
    case 0:
      w0[hook(10, 0)] = 0x80;
      break;

    case 1:
      w0[hook(10, 0)] = w0[hook(10, 0)] | 0x8000;
      break;

    case 2:
      w0[hook(10, 0)] = w0[hook(10, 0)] | 0x800000;
      break;

    case 3:
      w0[hook(10, 0)] = w0[hook(10, 0)] | 0x80000000;
      break;

    case 4:
      w0[hook(10, 1)] = 0x80;
      break;

    case 5:
      w0[hook(10, 1)] = w0[hook(10, 1)] | 0x8000;
      break;

    case 6:
      w0[hook(10, 1)] = w0[hook(10, 1)] | 0x800000;
      break;

    case 7:
      w0[hook(10, 1)] = w0[hook(10, 1)] | 0x80000000;
      break;

    case 8:
      w0[hook(10, 2)] = 0x80;
      break;

    case 9:
      w0[hook(10, 2)] = w0[hook(10, 2)] | 0x8000;
      break;

    case 10:
      w0[hook(10, 2)] = w0[hook(10, 2)] | 0x800000;
      break;

    case 11:
      w0[hook(10, 2)] = w0[hook(10, 2)] | 0x80000000;
      break;

    case 12:
      w0[hook(10, 3)] = 0x80;
      break;

    case 13:
      w0[hook(10, 3)] = w0[hook(10, 3)] | 0x8000;
      break;

    case 14:
      w0[hook(10, 3)] = w0[hook(10, 3)] | 0x800000;
      break;

    case 15:
      w0[hook(10, 3)] = w0[hook(10, 3)] | 0x80000000;
      break;

    case 16:
      w1[hook(11, 0)] = 0x80;
      break;

    case 17:
      w1[hook(11, 0)] = w1[hook(11, 0)] | 0x8000;
      break;

    case 18:
      w1[hook(11, 0)] = w1[hook(11, 0)] | 0x800000;
      break;

    case 19:
      w1[hook(11, 0)] = w1[hook(11, 0)] | 0x80000000;
      break;

    case 20:
      w1[hook(11, 1)] = 0x80;
      break;

    case 21:
      w1[hook(11, 1)] = w1[hook(11, 1)] | 0x8000;
      break;

    case 22:
      w1[hook(11, 1)] = w1[hook(11, 1)] | 0x800000;
      break;

    case 23:
      w1[hook(11, 1)] = w1[hook(11, 1)] | 0x80000000;
      break;

    case 24:
      w1[hook(11, 2)] = 0x80;
      break;

    case 25:
      w1[hook(11, 2)] = w1[hook(11, 2)] | 0x8000;
      break;

    case 26:
      w1[hook(11, 2)] = w1[hook(11, 2)] | 0x800000;
      break;

    case 27:
      w1[hook(11, 2)] = w1[hook(11, 2)] | 0x80000000;
      break;

    case 28:
      w1[hook(11, 3)] = 0x80;
      break;

    case 29:
      w1[hook(11, 3)] = w1[hook(11, 3)] | 0x8000;
      break;

    case 30:
      w1[hook(11, 3)] = w1[hook(11, 3)] | 0x800000;
      break;

    case 31:
      w1[hook(11, 3)] = w1[hook(11, 3)] | 0x80000000;
      break;
  }
}

inline void append_0x80_3x4(unsigned int w0[4], unsigned int w1[4], unsigned int w2[4], const unsigned int offset) {
  switch (offset) {
    case 0:
      w0[hook(10, 0)] = 0x80;
      break;

    case 1:
      w0[hook(10, 0)] = w0[hook(10, 0)] | 0x8000;
      break;

    case 2:
      w0[hook(10, 0)] = w0[hook(10, 0)] | 0x800000;
      break;

    case 3:
      w0[hook(10, 0)] = w0[hook(10, 0)] | 0x80000000;
      break;

    case 4:
      w0[hook(10, 1)] = 0x80;
      break;

    case 5:
      w0[hook(10, 1)] = w0[hook(10, 1)] | 0x8000;
      break;

    case 6:
      w0[hook(10, 1)] = w0[hook(10, 1)] | 0x800000;
      break;

    case 7:
      w0[hook(10, 1)] = w0[hook(10, 1)] | 0x80000000;
      break;

    case 8:
      w0[hook(10, 2)] = 0x80;
      break;

    case 9:
      w0[hook(10, 2)] = w0[hook(10, 2)] | 0x8000;
      break;

    case 10:
      w0[hook(10, 2)] = w0[hook(10, 2)] | 0x800000;
      break;

    case 11:
      w0[hook(10, 2)] = w0[hook(10, 2)] | 0x80000000;
      break;

    case 12:
      w0[hook(10, 3)] = 0x80;
      break;

    case 13:
      w0[hook(10, 3)] = w0[hook(10, 3)] | 0x8000;
      break;

    case 14:
      w0[hook(10, 3)] = w0[hook(10, 3)] | 0x800000;
      break;

    case 15:
      w0[hook(10, 3)] = w0[hook(10, 3)] | 0x80000000;
      break;

    case 16:
      w1[hook(11, 0)] = 0x80;
      break;

    case 17:
      w1[hook(11, 0)] = w1[hook(11, 0)] | 0x8000;
      break;

    case 18:
      w1[hook(11, 0)] = w1[hook(11, 0)] | 0x800000;
      break;

    case 19:
      w1[hook(11, 0)] = w1[hook(11, 0)] | 0x80000000;
      break;

    case 20:
      w1[hook(11, 1)] = 0x80;
      break;

    case 21:
      w1[hook(11, 1)] = w1[hook(11, 1)] | 0x8000;
      break;

    case 22:
      w1[hook(11, 1)] = w1[hook(11, 1)] | 0x800000;
      break;

    case 23:
      w1[hook(11, 1)] = w1[hook(11, 1)] | 0x80000000;
      break;

    case 24:
      w1[hook(11, 2)] = 0x80;
      break;

    case 25:
      w1[hook(11, 2)] = w1[hook(11, 2)] | 0x8000;
      break;

    case 26:
      w1[hook(11, 2)] = w1[hook(11, 2)] | 0x800000;
      break;

    case 27:
      w1[hook(11, 2)] = w1[hook(11, 2)] | 0x80000000;
      break;

    case 28:
      w1[hook(11, 3)] = 0x80;
      break;

    case 29:
      w1[hook(11, 3)] = w1[hook(11, 3)] | 0x8000;
      break;

    case 30:
      w1[hook(11, 3)] = w1[hook(11, 3)] | 0x800000;
      break;

    case 31:
      w1[hook(11, 3)] = w1[hook(11, 3)] | 0x80000000;
      break;

    case 32:
      w2[hook(12, 0)] = 0x80;
      break;

    case 33:
      w2[hook(12, 0)] = w2[hook(12, 0)] | 0x8000;
      break;

    case 34:
      w2[hook(12, 0)] = w2[hook(12, 0)] | 0x800000;
      break;

    case 35:
      w2[hook(12, 0)] = w2[hook(12, 0)] | 0x80000000;
      break;

    case 36:
      w2[hook(12, 1)] = 0x80;
      break;

    case 37:
      w2[hook(12, 1)] = w2[hook(12, 1)] | 0x8000;
      break;

    case 38:
      w2[hook(12, 1)] = w2[hook(12, 1)] | 0x800000;
      break;

    case 39:
      w2[hook(12, 1)] = w2[hook(12, 1)] | 0x80000000;
      break;

    case 40:
      w2[hook(12, 2)] = 0x80;
      break;

    case 41:
      w2[hook(12, 2)] = w2[hook(12, 2)] | 0x8000;
      break;

    case 42:
      w2[hook(12, 2)] = w2[hook(12, 2)] | 0x800000;
      break;

    case 43:
      w2[hook(12, 2)] = w2[hook(12, 2)] | 0x80000000;
      break;

    case 44:
      w2[hook(12, 3)] = 0x80;
      break;

    case 45:
      w2[hook(12, 3)] = w2[hook(12, 3)] | 0x8000;
      break;

    case 46:
      w2[hook(12, 3)] = w2[hook(12, 3)] | 0x800000;
      break;

    case 47:
      w2[hook(12, 3)] = w2[hook(12, 3)] | 0x80000000;
      break;
  }
}

inline void append_0x80_4x4(unsigned int w0[4], unsigned int w1[4], unsigned int w2[4], unsigned int w3[4], const unsigned int offset) {
  switch (offset) {
    case 0:
      w0[hook(10, 0)] = 0x80;
      break;

    case 1:
      w0[hook(10, 0)] = w0[hook(10, 0)] | 0x8000;
      break;

    case 2:
      w0[hook(10, 0)] = w0[hook(10, 0)] | 0x800000;
      break;

    case 3:
      w0[hook(10, 0)] = w0[hook(10, 0)] | 0x80000000;
      break;

    case 4:
      w0[hook(10, 1)] = 0x80;
      break;

    case 5:
      w0[hook(10, 1)] = w0[hook(10, 1)] | 0x8000;
      break;

    case 6:
      w0[hook(10, 1)] = w0[hook(10, 1)] | 0x800000;
      break;

    case 7:
      w0[hook(10, 1)] = w0[hook(10, 1)] | 0x80000000;
      break;

    case 8:
      w0[hook(10, 2)] = 0x80;
      break;

    case 9:
      w0[hook(10, 2)] = w0[hook(10, 2)] | 0x8000;
      break;

    case 10:
      w0[hook(10, 2)] = w0[hook(10, 2)] | 0x800000;
      break;

    case 11:
      w0[hook(10, 2)] = w0[hook(10, 2)] | 0x80000000;
      break;

    case 12:
      w0[hook(10, 3)] = 0x80;
      break;

    case 13:
      w0[hook(10, 3)] = w0[hook(10, 3)] | 0x8000;
      break;

    case 14:
      w0[hook(10, 3)] = w0[hook(10, 3)] | 0x800000;
      break;

    case 15:
      w0[hook(10, 3)] = w0[hook(10, 3)] | 0x80000000;
      break;

    case 16:
      w1[hook(11, 0)] = 0x80;
      break;

    case 17:
      w1[hook(11, 0)] = w1[hook(11, 0)] | 0x8000;
      break;

    case 18:
      w1[hook(11, 0)] = w1[hook(11, 0)] | 0x800000;
      break;

    case 19:
      w1[hook(11, 0)] = w1[hook(11, 0)] | 0x80000000;
      break;

    case 20:
      w1[hook(11, 1)] = 0x80;
      break;

    case 21:
      w1[hook(11, 1)] = w1[hook(11, 1)] | 0x8000;
      break;

    case 22:
      w1[hook(11, 1)] = w1[hook(11, 1)] | 0x800000;
      break;

    case 23:
      w1[hook(11, 1)] = w1[hook(11, 1)] | 0x80000000;
      break;

    case 24:
      w1[hook(11, 2)] = 0x80;
      break;

    case 25:
      w1[hook(11, 2)] = w1[hook(11, 2)] | 0x8000;
      break;

    case 26:
      w1[hook(11, 2)] = w1[hook(11, 2)] | 0x800000;
      break;

    case 27:
      w1[hook(11, 2)] = w1[hook(11, 2)] | 0x80000000;
      break;

    case 28:
      w1[hook(11, 3)] = 0x80;
      break;

    case 29:
      w1[hook(11, 3)] = w1[hook(11, 3)] | 0x8000;
      break;

    case 30:
      w1[hook(11, 3)] = w1[hook(11, 3)] | 0x800000;
      break;

    case 31:
      w1[hook(11, 3)] = w1[hook(11, 3)] | 0x80000000;
      break;

    case 32:
      w2[hook(12, 0)] = 0x80;
      break;

    case 33:
      w2[hook(12, 0)] = w2[hook(12, 0)] | 0x8000;
      break;

    case 34:
      w2[hook(12, 0)] = w2[hook(12, 0)] | 0x800000;
      break;

    case 35:
      w2[hook(12, 0)] = w2[hook(12, 0)] | 0x80000000;
      break;

    case 36:
      w2[hook(12, 1)] = 0x80;
      break;

    case 37:
      w2[hook(12, 1)] = w2[hook(12, 1)] | 0x8000;
      break;

    case 38:
      w2[hook(12, 1)] = w2[hook(12, 1)] | 0x800000;
      break;

    case 39:
      w2[hook(12, 1)] = w2[hook(12, 1)] | 0x80000000;
      break;

    case 40:
      w2[hook(12, 2)] = 0x80;
      break;

    case 41:
      w2[hook(12, 2)] = w2[hook(12, 2)] | 0x8000;
      break;

    case 42:
      w2[hook(12, 2)] = w2[hook(12, 2)] | 0x800000;
      break;

    case 43:
      w2[hook(12, 2)] = w2[hook(12, 2)] | 0x80000000;
      break;

    case 44:
      w2[hook(12, 3)] = 0x80;
      break;

    case 45:
      w2[hook(12, 3)] = w2[hook(12, 3)] | 0x8000;
      break;

    case 46:
      w2[hook(12, 3)] = w2[hook(12, 3)] | 0x800000;
      break;

    case 47:
      w2[hook(12, 3)] = w2[hook(12, 3)] | 0x80000000;
      break;

    case 48:
      w3[hook(13, 0)] = 0x80;
      break;

    case 49:
      w3[hook(13, 0)] = w3[hook(13, 0)] | 0x8000;
      break;

    case 50:
      w3[hook(13, 0)] = w3[hook(13, 0)] | 0x800000;
      break;

    case 51:
      w3[hook(13, 0)] = w3[hook(13, 0)] | 0x80000000;
      break;

    case 52:
      w3[hook(13, 1)] = 0x80;
      break;

    case 53:
      w3[hook(13, 1)] = w3[hook(13, 1)] | 0x8000;
      break;

    case 54:
      w3[hook(13, 1)] = w3[hook(13, 1)] | 0x800000;
      break;

    case 55:
      w3[hook(13, 1)] = w3[hook(13, 1)] | 0x80000000;
      break;

    case 56:
      w3[hook(13, 2)] = 0x80;
      break;

    case 57:
      w3[hook(13, 2)] = w3[hook(13, 2)] | 0x8000;
      break;

    case 58:
      w3[hook(13, 2)] = w3[hook(13, 2)] | 0x800000;
      break;

    case 59:
      w3[hook(13, 2)] = w3[hook(13, 2)] | 0x80000000;
      break;

    case 60:
      w3[hook(13, 3)] = 0x80;
      break;

    case 61:
      w3[hook(13, 3)] = w3[hook(13, 3)] | 0x8000;
      break;

    case 62:
      w3[hook(13, 3)] = w3[hook(13, 3)] | 0x800000;
      break;

    case 63:
      w3[hook(13, 3)] = w3[hook(13, 3)] | 0x80000000;
      break;
  }
}

inline void append_0x80_8x4(unsigned int w0[4], unsigned int w1[4], unsigned int w2[4], unsigned int w3[4], unsigned int w4[4], unsigned int w5[4], unsigned int w6[4], unsigned int w7[4], const unsigned int offset) {
  switch (offset) {
    case 0:
      w0[hook(10, 0)] = 0x80;
      break;

    case 1:
      w0[hook(10, 0)] = w0[hook(10, 0)] | 0x8000;
      break;

    case 2:
      w0[hook(10, 0)] = w0[hook(10, 0)] | 0x800000;
      break;

    case 3:
      w0[hook(10, 0)] = w0[hook(10, 0)] | 0x80000000;
      break;

    case 4:
      w0[hook(10, 1)] = 0x80;
      break;

    case 5:
      w0[hook(10, 1)] = w0[hook(10, 1)] | 0x8000;
      break;

    case 6:
      w0[hook(10, 1)] = w0[hook(10, 1)] | 0x800000;
      break;

    case 7:
      w0[hook(10, 1)] = w0[hook(10, 1)] | 0x80000000;
      break;

    case 8:
      w0[hook(10, 2)] = 0x80;
      break;

    case 9:
      w0[hook(10, 2)] = w0[hook(10, 2)] | 0x8000;
      break;

    case 10:
      w0[hook(10, 2)] = w0[hook(10, 2)] | 0x800000;
      break;

    case 11:
      w0[hook(10, 2)] = w0[hook(10, 2)] | 0x80000000;
      break;

    case 12:
      w0[hook(10, 3)] = 0x80;
      break;

    case 13:
      w0[hook(10, 3)] = w0[hook(10, 3)] | 0x8000;
      break;

    case 14:
      w0[hook(10, 3)] = w0[hook(10, 3)] | 0x800000;
      break;

    case 15:
      w0[hook(10, 3)] = w0[hook(10, 3)] | 0x80000000;
      break;

    case 16:
      w1[hook(11, 0)] = 0x80;
      break;

    case 17:
      w1[hook(11, 0)] = w1[hook(11, 0)] | 0x8000;
      break;

    case 18:
      w1[hook(11, 0)] = w1[hook(11, 0)] | 0x800000;
      break;

    case 19:
      w1[hook(11, 0)] = w1[hook(11, 0)] | 0x80000000;
      break;

    case 20:
      w1[hook(11, 1)] = 0x80;
      break;

    case 21:
      w1[hook(11, 1)] = w1[hook(11, 1)] | 0x8000;
      break;

    case 22:
      w1[hook(11, 1)] = w1[hook(11, 1)] | 0x800000;
      break;

    case 23:
      w1[hook(11, 1)] = w1[hook(11, 1)] | 0x80000000;
      break;

    case 24:
      w1[hook(11, 2)] = 0x80;
      break;

    case 25:
      w1[hook(11, 2)] = w1[hook(11, 2)] | 0x8000;
      break;

    case 26:
      w1[hook(11, 2)] = w1[hook(11, 2)] | 0x800000;
      break;

    case 27:
      w1[hook(11, 2)] = w1[hook(11, 2)] | 0x80000000;
      break;

    case 28:
      w1[hook(11, 3)] = 0x80;
      break;

    case 29:
      w1[hook(11, 3)] = w1[hook(11, 3)] | 0x8000;
      break;

    case 30:
      w1[hook(11, 3)] = w1[hook(11, 3)] | 0x800000;
      break;

    case 31:
      w1[hook(11, 3)] = w1[hook(11, 3)] | 0x80000000;
      break;

    case 32:
      w2[hook(12, 0)] = 0x80;
      break;

    case 33:
      w2[hook(12, 0)] = w2[hook(12, 0)] | 0x8000;
      break;

    case 34:
      w2[hook(12, 0)] = w2[hook(12, 0)] | 0x800000;
      break;

    case 35:
      w2[hook(12, 0)] = w2[hook(12, 0)] | 0x80000000;
      break;

    case 36:
      w2[hook(12, 1)] = 0x80;
      break;

    case 37:
      w2[hook(12, 1)] = w2[hook(12, 1)] | 0x8000;
      break;

    case 38:
      w2[hook(12, 1)] = w2[hook(12, 1)] | 0x800000;
      break;

    case 39:
      w2[hook(12, 1)] = w2[hook(12, 1)] | 0x80000000;
      break;

    case 40:
      w2[hook(12, 2)] = 0x80;
      break;

    case 41:
      w2[hook(12, 2)] = w2[hook(12, 2)] | 0x8000;
      break;

    case 42:
      w2[hook(12, 2)] = w2[hook(12, 2)] | 0x800000;
      break;

    case 43:
      w2[hook(12, 2)] = w2[hook(12, 2)] | 0x80000000;
      break;

    case 44:
      w2[hook(12, 3)] = 0x80;
      break;

    case 45:
      w2[hook(12, 3)] = w2[hook(12, 3)] | 0x8000;
      break;

    case 46:
      w2[hook(12, 3)] = w2[hook(12, 3)] | 0x800000;
      break;

    case 47:
      w2[hook(12, 3)] = w2[hook(12, 3)] | 0x80000000;
      break;

    case 48:
      w3[hook(13, 0)] = 0x80;
      break;

    case 49:
      w3[hook(13, 0)] = w3[hook(13, 0)] | 0x8000;
      break;

    case 50:
      w3[hook(13, 0)] = w3[hook(13, 0)] | 0x800000;
      break;

    case 51:
      w3[hook(13, 0)] = w3[hook(13, 0)] | 0x80000000;
      break;

    case 52:
      w3[hook(13, 1)] = 0x80;
      break;

    case 53:
      w3[hook(13, 1)] = w3[hook(13, 1)] | 0x8000;
      break;

    case 54:
      w3[hook(13, 1)] = w3[hook(13, 1)] | 0x800000;
      break;

    case 55:
      w3[hook(13, 1)] = w3[hook(13, 1)] | 0x80000000;
      break;

    case 56:
      w3[hook(13, 2)] = 0x80;
      break;

    case 57:
      w3[hook(13, 2)] = w3[hook(13, 2)] | 0x8000;
      break;

    case 58:
      w3[hook(13, 2)] = w3[hook(13, 2)] | 0x800000;
      break;

    case 59:
      w3[hook(13, 2)] = w3[hook(13, 2)] | 0x80000000;
      break;

    case 60:
      w3[hook(13, 3)] = 0x80;
      break;

    case 61:
      w3[hook(13, 3)] = w3[hook(13, 3)] | 0x8000;
      break;

    case 62:
      w3[hook(13, 3)] = w3[hook(13, 3)] | 0x800000;
      break;

    case 63:
      w3[hook(13, 3)] = w3[hook(13, 3)] | 0x80000000;
      break;

    case 64:
      w4[hook(14, 0)] = 0x80;
      break;

    case 65:
      w4[hook(14, 0)] = w4[hook(14, 0)] | 0x8000;
      break;

    case 66:
      w4[hook(14, 0)] = w4[hook(14, 0)] | 0x800000;
      break;

    case 67:
      w4[hook(14, 0)] = w4[hook(14, 0)] | 0x80000000;
      break;

    case 68:
      w4[hook(14, 1)] = 0x80;
      break;

    case 69:
      w4[hook(14, 1)] = w4[hook(14, 1)] | 0x8000;
      break;

    case 70:
      w4[hook(14, 1)] = w4[hook(14, 1)] | 0x800000;
      break;

    case 71:
      w4[hook(14, 1)] = w4[hook(14, 1)] | 0x80000000;
      break;

    case 72:
      w4[hook(14, 2)] = 0x80;
      break;

    case 73:
      w4[hook(14, 2)] = w4[hook(14, 2)] | 0x8000;
      break;

    case 74:
      w4[hook(14, 2)] = w4[hook(14, 2)] | 0x800000;
      break;

    case 75:
      w4[hook(14, 2)] = w4[hook(14, 2)] | 0x80000000;
      break;

    case 76:
      w4[hook(14, 3)] = 0x80;
      break;

    case 77:
      w4[hook(14, 3)] = w4[hook(14, 3)] | 0x8000;
      break;

    case 78:
      w4[hook(14, 3)] = w4[hook(14, 3)] | 0x800000;
      break;

    case 79:
      w4[hook(14, 3)] = w4[hook(14, 3)] | 0x80000000;
      break;

    case 80:
      w5[hook(15, 0)] = 0x80;
      break;

    case 81:
      w5[hook(15, 0)] = w5[hook(15, 0)] | 0x8000;
      break;

    case 82:
      w5[hook(15, 0)] = w5[hook(15, 0)] | 0x800000;
      break;

    case 83:
      w5[hook(15, 0)] = w5[hook(15, 0)] | 0x80000000;
      break;

    case 84:
      w5[hook(15, 1)] = 0x80;
      break;

    case 85:
      w5[hook(15, 1)] = w5[hook(15, 1)] | 0x8000;
      break;

    case 86:
      w5[hook(15, 1)] = w5[hook(15, 1)] | 0x800000;
      break;

    case 87:
      w5[hook(15, 1)] = w5[hook(15, 1)] | 0x80000000;
      break;

    case 88:
      w5[hook(15, 2)] = 0x80;
      break;

    case 89:
      w5[hook(15, 2)] = w5[hook(15, 2)] | 0x8000;
      break;

    case 90:
      w5[hook(15, 2)] = w5[hook(15, 2)] | 0x800000;
      break;

    case 91:
      w5[hook(15, 2)] = w5[hook(15, 2)] | 0x80000000;
      break;

    case 92:
      w5[hook(15, 3)] = 0x80;
      break;

    case 93:
      w5[hook(15, 3)] = w5[hook(15, 3)] | 0x8000;
      break;

    case 94:
      w5[hook(15, 3)] = w5[hook(15, 3)] | 0x800000;
      break;

    case 95:
      w5[hook(15, 3)] = w5[hook(15, 3)] | 0x80000000;
      break;

    case 96:
      w6[hook(16, 0)] = 0x80;
      break;

    case 97:
      w6[hook(16, 0)] = w6[hook(16, 0)] | 0x8000;
      break;

    case 98:
      w6[hook(16, 0)] = w6[hook(16, 0)] | 0x800000;
      break;

    case 99:
      w6[hook(16, 0)] = w6[hook(16, 0)] | 0x80000000;
      break;

    case 100:
      w6[hook(16, 1)] = 0x80;
      break;

    case 101:
      w6[hook(16, 1)] = w6[hook(16, 1)] | 0x8000;
      break;

    case 102:
      w6[hook(16, 1)] = w6[hook(16, 1)] | 0x800000;
      break;

    case 103:
      w6[hook(16, 1)] = w6[hook(16, 1)] | 0x80000000;
      break;

    case 104:
      w6[hook(16, 2)] = 0x80;
      break;

    case 105:
      w6[hook(16, 2)] = w6[hook(16, 2)] | 0x8000;
      break;

    case 106:
      w6[hook(16, 2)] = w6[hook(16, 2)] | 0x800000;
      break;

    case 107:
      w6[hook(16, 2)] = w6[hook(16, 2)] | 0x80000000;
      break;

    case 108:
      w6[hook(16, 3)] = 0x80;
      break;

    case 109:
      w6[hook(16, 3)] = w6[hook(16, 3)] | 0x8000;
      break;

    case 110:
      w6[hook(16, 3)] = w6[hook(16, 3)] | 0x800000;
      break;

    case 111:
      w6[hook(16, 3)] = w6[hook(16, 3)] | 0x80000000;
      break;

    case 112:
      w7[hook(17, 0)] = 0x80;
      break;

    case 113:
      w7[hook(17, 0)] = w7[hook(17, 0)] | 0x8000;
      break;

    case 114:
      w7[hook(17, 0)] = w7[hook(17, 0)] | 0x800000;
      break;

    case 115:
      w7[hook(17, 0)] = w7[hook(17, 0)] | 0x80000000;
      break;

    case 116:
      w7[hook(17, 1)] = 0x80;
      break;

    case 117:
      w7[hook(17, 1)] = w7[hook(17, 1)] | 0x8000;
      break;

    case 118:
      w7[hook(17, 1)] = w7[hook(17, 1)] | 0x800000;
      break;

    case 119:
      w7[hook(17, 1)] = w7[hook(17, 1)] | 0x80000000;
      break;

    case 120:
      w7[hook(17, 2)] = 0x80;
      break;

    case 121:
      w7[hook(17, 2)] = w7[hook(17, 2)] | 0x8000;
      break;

    case 122:
      w7[hook(17, 2)] = w7[hook(17, 2)] | 0x800000;
      break;

    case 123:
      w7[hook(17, 2)] = w7[hook(17, 2)] | 0x80000000;
      break;

    case 124:
      w7[hook(17, 3)] = 0x80;
      break;

    case 125:
      w7[hook(17, 3)] = w7[hook(17, 3)] | 0x8000;
      break;

    case 126:
      w7[hook(17, 3)] = w7[hook(17, 3)] | 0x800000;
      break;

    case 127:
      w7[hook(17, 3)] = w7[hook(17, 3)] | 0x80000000;
      break;
  }
}

inline void append_0x80_1x16(unsigned int w[16], const unsigned int offset) {
  switch (offset) {
    case 0:
      w[hook(9, 0)] = 0x80;
      break;

    case 1:
      w[hook(9, 0)] = w[hook(9, 0)] | 0x8000;
      break;

    case 2:
      w[hook(9, 0)] = w[hook(9, 0)] | 0x800000;
      break;

    case 3:
      w[hook(9, 0)] = w[hook(9, 0)] | 0x80000000;
      break;

    case 4:
      w[hook(9, 1)] = 0x80;
      break;

    case 5:
      w[hook(9, 1)] = w[hook(9, 1)] | 0x8000;
      break;

    case 6:
      w[hook(9, 1)] = w[hook(9, 1)] | 0x800000;
      break;

    case 7:
      w[hook(9, 1)] = w[hook(9, 1)] | 0x80000000;
      break;

    case 8:
      w[hook(9, 2)] = 0x80;
      break;

    case 9:
      w[hook(9, 2)] = w[hook(9, 2)] | 0x8000;
      break;

    case 10:
      w[hook(9, 2)] = w[hook(9, 2)] | 0x800000;
      break;

    case 11:
      w[hook(9, 2)] = w[hook(9, 2)] | 0x80000000;
      break;

    case 12:
      w[hook(9, 3)] = 0x80;
      break;

    case 13:
      w[hook(9, 3)] = w[hook(9, 3)] | 0x8000;
      break;

    case 14:
      w[hook(9, 3)] = w[hook(9, 3)] | 0x800000;
      break;

    case 15:
      w[hook(9, 3)] = w[hook(9, 3)] | 0x80000000;
      break;

    case 16:
      w[hook(9, 4)] = 0x80;
      break;

    case 17:
      w[hook(9, 4)] = w[hook(9, 4)] | 0x8000;
      break;

    case 18:
      w[hook(9, 4)] = w[hook(9, 4)] | 0x800000;
      break;

    case 19:
      w[hook(9, 4)] = w[hook(9, 4)] | 0x80000000;
      break;

    case 20:
      w[hook(9, 5)] = 0x80;
      break;

    case 21:
      w[hook(9, 5)] = w[hook(9, 5)] | 0x8000;
      break;

    case 22:
      w[hook(9, 5)] = w[hook(9, 5)] | 0x800000;
      break;

    case 23:
      w[hook(9, 5)] = w[hook(9, 5)] | 0x80000000;
      break;

    case 24:
      w[hook(9, 6)] = 0x80;
      break;

    case 25:
      w[hook(9, 6)] = w[hook(9, 6)] | 0x8000;
      break;

    case 26:
      w[hook(9, 6)] = w[hook(9, 6)] | 0x800000;
      break;

    case 27:
      w[hook(9, 6)] = w[hook(9, 6)] | 0x80000000;
      break;

    case 28:
      w[hook(9, 7)] = 0x80;
      break;

    case 29:
      w[hook(9, 7)] = w[hook(9, 7)] | 0x8000;
      break;

    case 30:
      w[hook(9, 7)] = w[hook(9, 7)] | 0x800000;
      break;

    case 31:
      w[hook(9, 7)] = w[hook(9, 7)] | 0x80000000;
      break;

    case 32:
      w[hook(9, 8)] = 0x80;
      break;

    case 33:
      w[hook(9, 8)] = w[hook(9, 8)] | 0x8000;
      break;

    case 34:
      w[hook(9, 8)] = w[hook(9, 8)] | 0x800000;
      break;

    case 35:
      w[hook(9, 8)] = w[hook(9, 8)] | 0x80000000;
      break;

    case 36:
      w[hook(9, 9)] = 0x80;
      break;

    case 37:
      w[hook(9, 9)] = w[hook(9, 9)] | 0x8000;
      break;

    case 38:
      w[hook(9, 9)] = w[hook(9, 9)] | 0x800000;
      break;

    case 39:
      w[hook(9, 9)] = w[hook(9, 9)] | 0x80000000;
      break;

    case 40:
      w[hook(9, 10)] = 0x80;
      break;

    case 41:
      w[hook(9, 10)] = w[hook(9, 10)] | 0x8000;
      break;

    case 42:
      w[hook(9, 10)] = w[hook(9, 10)] | 0x800000;
      break;

    case 43:
      w[hook(9, 10)] = w[hook(9, 10)] | 0x80000000;
      break;

    case 44:
      w[hook(9, 11)] = 0x80;
      break;

    case 45:
      w[hook(9, 11)] = w[hook(9, 11)] | 0x8000;
      break;

    case 46:
      w[hook(9, 11)] = w[hook(9, 11)] | 0x800000;
      break;

    case 47:
      w[hook(9, 11)] = w[hook(9, 11)] | 0x80000000;
      break;

    case 48:
      w[hook(9, 12)] = 0x80;
      break;

    case 49:
      w[hook(9, 12)] = w[hook(9, 12)] | 0x8000;
      break;

    case 50:
      w[hook(9, 12)] = w[hook(9, 12)] | 0x800000;
      break;

    case 51:
      w[hook(9, 12)] = w[hook(9, 12)] | 0x80000000;
      break;

    case 52:
      w[hook(9, 13)] = 0x80;
      break;

    case 53:
      w[hook(9, 13)] = w[hook(9, 13)] | 0x8000;
      break;

    case 54:
      w[hook(9, 13)] = w[hook(9, 13)] | 0x800000;
      break;

    case 55:
      w[hook(9, 13)] = w[hook(9, 13)] | 0x80000000;
      break;

    case 56:
      w[hook(9, 14)] = 0x80;
      break;

    case 57:
      w[hook(9, 14)] = w[hook(9, 14)] | 0x8000;
      break;

    case 58:
      w[hook(9, 14)] = w[hook(9, 14)] | 0x800000;
      break;

    case 59:
      w[hook(9, 14)] = w[hook(9, 14)] | 0x80000000;
      break;

    case 60:
      w[hook(9, 15)] = 0x80;
      break;

    case 61:
      w[hook(9, 15)] = w[hook(9, 15)] | 0x8000;
      break;

    case 62:
      w[hook(9, 15)] = w[hook(9, 15)] | 0x800000;
      break;

    case 63:
      w[hook(9, 15)] = w[hook(9, 15)] | 0x80000000;
      break;
  }
}

inline void switch_buffer_by_offset_le(unsigned int w0[4], unsigned int w1[4], unsigned int w2[4], unsigned int w3[4], const unsigned int offset) {
}

inline void switch_buffer_by_offset_be(unsigned int w0[4], unsigned int w1[4], unsigned int w2[4], unsigned int w3[4], const unsigned int offset) {
}

inline void overwrite_at_le(unsigned int sw[16], const unsigned int w0, const unsigned int salt_len) {
  switch (salt_len) {
    case 0:
      sw[hook(18, 0)] = w0;
      break;
    case 1:
      sw[hook(18, 0)] = (sw[hook(18, 0)] & 0x000000ff) | (w0 << 8);
      sw[hook(18, 1)] = (sw[hook(18, 1)] & 0xffffff00) | (w0 >> 24);
      break;
    case 2:
      sw[hook(18, 0)] = (sw[hook(18, 0)] & 0x0000ffff) | (w0 << 16);
      sw[hook(18, 1)] = (sw[hook(18, 1)] & 0xffff0000) | (w0 >> 16);
      break;
    case 3:
      sw[hook(18, 0)] = (sw[hook(18, 0)] & 0x00ffffff) | (w0 << 24);
      sw[hook(18, 1)] = (sw[hook(18, 1)] & 0xff000000) | (w0 >> 8);
      break;
    case 4:
      sw[hook(18, 1)] = w0;
      break;
    case 5:
      sw[hook(18, 1)] = (sw[hook(18, 1)] & 0x000000ff) | (w0 << 8);
      sw[hook(18, 2)] = (sw[hook(18, 2)] & 0xffffff00) | (w0 >> 24);
      break;
    case 6:
      sw[hook(18, 1)] = (sw[hook(18, 1)] & 0x0000ffff) | (w0 << 16);
      sw[hook(18, 2)] = (sw[hook(18, 2)] & 0xffff0000) | (w0 >> 16);
      break;
    case 7:
      sw[hook(18, 1)] = (sw[hook(18, 1)] & 0x00ffffff) | (w0 << 24);
      sw[hook(18, 2)] = (sw[hook(18, 2)] & 0xff000000) | (w0 >> 8);
      break;
    case 8:
      sw[hook(18, 2)] = w0;
      break;
    case 9:
      sw[hook(18, 2)] = (sw[hook(18, 2)] & 0x000000ff) | (w0 << 8);
      sw[hook(18, 3)] = (sw[hook(18, 3)] & 0xffffff00) | (w0 >> 24);
      break;
    case 10:
      sw[hook(18, 2)] = (sw[hook(18, 2)] & 0x0000ffff) | (w0 << 16);
      sw[hook(18, 3)] = (sw[hook(18, 3)] & 0xffff0000) | (w0 >> 16);
      break;
    case 11:
      sw[hook(18, 2)] = (sw[hook(18, 2)] & 0x00ffffff) | (w0 << 24);
      sw[hook(18, 3)] = (sw[hook(18, 3)] & 0xff000000) | (w0 >> 8);
      break;
    case 12:
      sw[hook(18, 3)] = w0;
      break;
    case 13:
      sw[hook(18, 3)] = (sw[hook(18, 3)] & 0x000000ff) | (w0 << 8);
      sw[hook(18, 4)] = (sw[hook(18, 4)] & 0xffffff00) | (w0 >> 24);
      break;
    case 14:
      sw[hook(18, 3)] = (sw[hook(18, 3)] & 0x0000ffff) | (w0 << 16);
      sw[hook(18, 4)] = (sw[hook(18, 4)] & 0xffff0000) | (w0 >> 16);
      break;
    case 15:
      sw[hook(18, 3)] = (sw[hook(18, 3)] & 0x00ffffff) | (w0 << 24);
      sw[hook(18, 4)] = (sw[hook(18, 4)] & 0xff000000) | (w0 >> 8);
      break;
    case 16:
      sw[hook(18, 4)] = w0;
      break;
    case 17:
      sw[hook(18, 4)] = (sw[hook(18, 4)] & 0x000000ff) | (w0 << 8);
      sw[hook(18, 5)] = (sw[hook(18, 5)] & 0xffffff00) | (w0 >> 24);
      break;
    case 18:
      sw[hook(18, 4)] = (sw[hook(18, 4)] & 0x0000ffff) | (w0 << 16);
      sw[hook(18, 5)] = (sw[hook(18, 5)] & 0xffff0000) | (w0 >> 16);
      break;
    case 19:
      sw[hook(18, 4)] = (sw[hook(18, 4)] & 0x00ffffff) | (w0 << 24);
      sw[hook(18, 5)] = (sw[hook(18, 5)] & 0xff000000) | (w0 >> 8);
      break;
    case 20:
      sw[hook(18, 5)] = w0;
      break;
    case 21:
      sw[hook(18, 5)] = (sw[hook(18, 5)] & 0x000000ff) | (w0 << 8);
      sw[hook(18, 6)] = (sw[hook(18, 6)] & 0xffffff00) | (w0 >> 24);
      break;
    case 22:
      sw[hook(18, 5)] = (sw[hook(18, 5)] & 0x0000ffff) | (w0 << 16);
      sw[hook(18, 6)] = (sw[hook(18, 6)] & 0xffff0000) | (w0 >> 16);
      break;
    case 23:
      sw[hook(18, 5)] = (sw[hook(18, 5)] & 0x00ffffff) | (w0 << 24);
      sw[hook(18, 6)] = (sw[hook(18, 6)] & 0xff000000) | (w0 >> 8);
      break;
    case 24:
      sw[hook(18, 6)] = w0;
      break;
    case 25:
      sw[hook(18, 6)] = (sw[hook(18, 6)] & 0x000000ff) | (w0 << 8);
      sw[hook(18, 7)] = (sw[hook(18, 7)] & 0xffffff00) | (w0 >> 24);
      break;
    case 26:
      sw[hook(18, 6)] = (sw[hook(18, 6)] & 0x0000ffff) | (w0 << 16);
      sw[hook(18, 7)] = (sw[hook(18, 7)] & 0xffff0000) | (w0 >> 16);
      break;
    case 27:
      sw[hook(18, 6)] = (sw[hook(18, 6)] & 0x00ffffff) | (w0 << 24);
      sw[hook(18, 7)] = (sw[hook(18, 7)] & 0xff000000) | (w0 >> 8);
      break;
    case 28:
      sw[hook(18, 7)] = w0;
      break;
    case 29:
      sw[hook(18, 7)] = (sw[hook(18, 7)] & 0x000000ff) | (w0 << 8);
      sw[hook(18, 8)] = (sw[hook(18, 8)] & 0xffffff00) | (w0 >> 24);
      break;
    case 30:
      sw[hook(18, 7)] = (sw[hook(18, 7)] & 0x0000ffff) | (w0 << 16);
      sw[hook(18, 8)] = (sw[hook(18, 8)] & 0xffff0000) | (w0 >> 16);
      break;
    case 31:
      sw[hook(18, 7)] = (sw[hook(18, 7)] & 0x00ffffff) | (w0 << 24);
      sw[hook(18, 8)] = (sw[hook(18, 8)] & 0xff000000) | (w0 >> 8);
      break;
  }
}

inline void overwrite_at_be(unsigned int sw[16], const unsigned int w0, const unsigned int salt_len) {
  switch (salt_len) {
    case 0:
      sw[hook(18, 0)] = w0;
      break;
    case 1:
      sw[hook(18, 0)] = (sw[hook(18, 0)] & 0xff000000) | (w0 >> 8);
      sw[hook(18, 1)] = (sw[hook(18, 1)] & 0x00ffffff) | (w0 << 24);
      break;
    case 2:
      sw[hook(18, 0)] = (sw[hook(18, 0)] & 0xffff0000) | (w0 >> 16);
      sw[hook(18, 1)] = (sw[hook(18, 1)] & 0x0000ffff) | (w0 << 16);
      break;
    case 3:
      sw[hook(18, 0)] = (sw[hook(18, 0)] & 0xffffff00) | (w0 >> 24);
      sw[hook(18, 1)] = (sw[hook(18, 1)] & 0x000000ff) | (w0 << 8);
      break;
    case 4:
      sw[hook(18, 1)] = w0;
      break;
    case 5:
      sw[hook(18, 1)] = (sw[hook(18, 1)] & 0xff000000) | (w0 >> 8);
      sw[hook(18, 2)] = (sw[hook(18, 2)] & 0x00ffffff) | (w0 << 24);
      break;
    case 6:
      sw[hook(18, 1)] = (sw[hook(18, 1)] & 0xffff0000) | (w0 >> 16);
      sw[hook(18, 2)] = (sw[hook(18, 2)] & 0x0000ffff) | (w0 << 16);
      break;
    case 7:
      sw[hook(18, 1)] = (sw[hook(18, 1)] & 0xffffff00) | (w0 >> 24);
      sw[hook(18, 2)] = (sw[hook(18, 2)] & 0x000000ff) | (w0 << 8);
      break;
    case 8:
      sw[hook(18, 2)] = w0;
      break;
    case 9:
      sw[hook(18, 2)] = (sw[hook(18, 2)] & 0xff000000) | (w0 >> 8);
      sw[hook(18, 3)] = (sw[hook(18, 3)] & 0x00ffffff) | (w0 << 24);
      break;
    case 10:
      sw[hook(18, 2)] = (sw[hook(18, 2)] & 0xffff0000) | (w0 >> 16);
      sw[hook(18, 3)] = (sw[hook(18, 3)] & 0x0000ffff) | (w0 << 16);
      break;
    case 11:
      sw[hook(18, 2)] = (sw[hook(18, 2)] & 0xffffff00) | (w0 >> 24);
      sw[hook(18, 3)] = (sw[hook(18, 3)] & 0x000000ff) | (w0 << 8);
      break;
    case 12:
      sw[hook(18, 3)] = w0;
      break;
    case 13:
      sw[hook(18, 3)] = (sw[hook(18, 3)] & 0xff000000) | (w0 >> 8);
      sw[hook(18, 4)] = (sw[hook(18, 4)] & 0x00ffffff) | (w0 << 24);
      break;
    case 14:
      sw[hook(18, 3)] = (sw[hook(18, 3)] & 0xffff0000) | (w0 >> 16);
      sw[hook(18, 4)] = (sw[hook(18, 4)] & 0x0000ffff) | (w0 << 16);
      break;
    case 15:
      sw[hook(18, 3)] = (sw[hook(18, 3)] & 0xffffff00) | (w0 >> 24);
      sw[hook(18, 4)] = (sw[hook(18, 4)] & 0x000000ff) | (w0 << 8);
      break;
    case 16:
      sw[hook(18, 4)] = w0;
      break;
    case 17:
      sw[hook(18, 4)] = (sw[hook(18, 4)] & 0xff000000) | (w0 >> 8);
      sw[hook(18, 5)] = (sw[hook(18, 5)] & 0x00ffffff) | (w0 << 24);
      break;
    case 18:
      sw[hook(18, 4)] = (sw[hook(18, 4)] & 0xffff0000) | (w0 >> 16);
      sw[hook(18, 5)] = (sw[hook(18, 5)] & 0x0000ffff) | (w0 << 16);
      break;
    case 19:
      sw[hook(18, 4)] = (sw[hook(18, 4)] & 0xffffff00) | (w0 >> 24);
      sw[hook(18, 5)] = (sw[hook(18, 5)] & 0x000000ff) | (w0 << 8);
      break;
    case 20:
      sw[hook(18, 5)] = w0;
      break;
    case 21:
      sw[hook(18, 5)] = (sw[hook(18, 5)] & 0xff000000) | (w0 >> 8);
      sw[hook(18, 6)] = (sw[hook(18, 6)] & 0x00ffffff) | (w0 << 24);
      break;
    case 22:
      sw[hook(18, 5)] = (sw[hook(18, 5)] & 0xffff0000) | (w0 >> 16);
      sw[hook(18, 6)] = (sw[hook(18, 6)] & 0x0000ffff) | (w0 << 16);
      break;
    case 23:
      sw[hook(18, 5)] = (sw[hook(18, 5)] & 0xffffff00) | (w0 >> 24);
      sw[hook(18, 6)] = (sw[hook(18, 6)] & 0x000000ff) | (w0 << 8);
      break;
    case 24:
      sw[hook(18, 6)] = w0;
      break;
    case 25:
      sw[hook(18, 6)] = (sw[hook(18, 6)] & 0xff000000) | (w0 >> 8);
      sw[hook(18, 7)] = (sw[hook(18, 7)] & 0x00ffffff) | (w0 << 24);
      break;
    case 26:
      sw[hook(18, 6)] = (sw[hook(18, 6)] & 0xffff0000) | (w0 >> 16);
      sw[hook(18, 7)] = (sw[hook(18, 7)] & 0x0000ffff) | (w0 << 16);
      break;
    case 27:
      sw[hook(18, 6)] = (sw[hook(18, 6)] & 0xffffff00) | (w0 >> 24);
      sw[hook(18, 7)] = (sw[hook(18, 7)] & 0x000000ff) | (w0 << 8);
      break;
    case 28:
      sw[hook(18, 7)] = w0;
      break;
    case 29:
      sw[hook(18, 7)] = (sw[hook(18, 7)] & 0xff000000) | (w0 >> 8);
      sw[hook(18, 8)] = (sw[hook(18, 8)] & 0x00ffffff) | (w0 << 24);
      break;
    case 30:
      sw[hook(18, 7)] = (sw[hook(18, 7)] & 0xffff0000) | (w0 >> 16);
      sw[hook(18, 8)] = (sw[hook(18, 8)] & 0x0000ffff) | (w0 << 16);
      break;
    case 31:
      sw[hook(18, 7)] = (sw[hook(18, 7)] & 0xffffff00) | (w0 >> 24);
      sw[hook(18, 8)] = (sw[hook(18, 8)] & 0x000000ff) | (w0 << 8);
      break;
  }
}

inline void overwrite_at_le_4x4(unsigned int w0[4], unsigned int w1[4], unsigned int w2[4], unsigned int w3[4], const unsigned int wx, const unsigned int salt_len) {
  switch (salt_len) {
    case 0:
      w0[hook(10, 0)] = wx;
      break;
    case 1:
      w0[hook(10, 0)] = (w0[hook(10, 0)] & 0x000000ff) | (wx << 8);
      w0[hook(10, 1)] = (w0[hook(10, 1)] & 0xffffff00) | (wx >> 24);
      break;
    case 2:
      w0[hook(10, 0)] = (w0[hook(10, 0)] & 0x0000ffff) | (wx << 16);
      w0[hook(10, 1)] = (w0[hook(10, 1)] & 0xffff0000) | (wx >> 16);
      break;
    case 3:
      w0[hook(10, 0)] = (w0[hook(10, 0)] & 0x00ffffff) | (wx << 24);
      w0[hook(10, 1)] = (w0[hook(10, 1)] & 0xff000000) | (wx >> 8);
      break;
    case 4:
      w0[hook(10, 1)] = wx;
      break;
    case 5:
      w0[hook(10, 1)] = (w0[hook(10, 1)] & 0x000000ff) | (wx << 8);
      w0[hook(10, 2)] = (w0[hook(10, 2)] & 0xffffff00) | (wx >> 24);
      break;
    case 6:
      w0[hook(10, 1)] = (w0[hook(10, 1)] & 0x0000ffff) | (wx << 16);
      w0[hook(10, 2)] = (w0[hook(10, 2)] & 0xffff0000) | (wx >> 16);
      break;
    case 7:
      w0[hook(10, 1)] = (w0[hook(10, 1)] & 0x00ffffff) | (wx << 24);
      w0[hook(10, 2)] = (w0[hook(10, 2)] & 0xff000000) | (wx >> 8);
      break;
    case 8:
      w0[hook(10, 2)] = wx;
      break;
    case 9:
      w0[hook(10, 2)] = (w0[hook(10, 2)] & 0x000000ff) | (wx << 8);
      w0[hook(10, 3)] = (w0[hook(10, 3)] & 0xffffff00) | (wx >> 24);
      break;
    case 10:
      w0[hook(10, 2)] = (w0[hook(10, 2)] & 0x0000ffff) | (wx << 16);
      w0[hook(10, 3)] = (w0[hook(10, 3)] & 0xffff0000) | (wx >> 16);
      break;
    case 11:
      w0[hook(10, 2)] = (w0[hook(10, 2)] & 0x00ffffff) | (wx << 24);
      w0[hook(10, 3)] = (w0[hook(10, 3)] & 0xff000000) | (wx >> 8);
      break;
    case 12:
      w0[hook(10, 3)] = wx;
      break;
    case 13:
      w0[hook(10, 3)] = (w0[hook(10, 3)] & 0x000000ff) | (wx << 8);
      w1[hook(11, 0)] = (w1[hook(11, 0)] & 0xffffff00) | (wx >> 24);
      break;
    case 14:
      w0[hook(10, 3)] = (w0[hook(10, 3)] & 0x0000ffff) | (wx << 16);
      w1[hook(11, 0)] = (w1[hook(11, 0)] & 0xffff0000) | (wx >> 16);
      break;
    case 15:
      w0[hook(10, 3)] = (w0[hook(10, 3)] & 0x00ffffff) | (wx << 24);
      w1[hook(11, 0)] = (w1[hook(11, 0)] & 0xff000000) | (wx >> 8);
      break;
    case 16:
      w1[hook(11, 0)] = wx;
      break;
    case 17:
      w1[hook(11, 0)] = (w1[hook(11, 0)] & 0x000000ff) | (wx << 8);
      w1[hook(11, 1)] = (w1[hook(11, 1)] & 0xffffff00) | (wx >> 24);
      break;
    case 18:
      w1[hook(11, 0)] = (w1[hook(11, 0)] & 0x0000ffff) | (wx << 16);
      w1[hook(11, 1)] = (w1[hook(11, 1)] & 0xffff0000) | (wx >> 16);
      break;
    case 19:
      w1[hook(11, 0)] = (w1[hook(11, 0)] & 0x00ffffff) | (wx << 24);
      w1[hook(11, 1)] = (w1[hook(11, 1)] & 0xff000000) | (wx >> 8);
      break;
    case 20:
      w1[hook(11, 1)] = wx;
      break;
    case 21:
      w1[hook(11, 1)] = (w1[hook(11, 1)] & 0x000000ff) | (wx << 8);
      w1[hook(11, 2)] = (w1[hook(11, 2)] & 0xffffff00) | (wx >> 24);
      break;
    case 22:
      w1[hook(11, 1)] = (w1[hook(11, 1)] & 0x0000ffff) | (wx << 16);
      w1[hook(11, 2)] = (w1[hook(11, 2)] & 0xffff0000) | (wx >> 16);
      break;
    case 23:
      w1[hook(11, 1)] = (w1[hook(11, 1)] & 0x00ffffff) | (wx << 24);
      w1[hook(11, 2)] = (w1[hook(11, 2)] & 0xff000000) | (wx >> 8);
      break;
    case 24:
      w1[hook(11, 2)] = wx;
      break;
    case 25:
      w1[hook(11, 2)] = (w1[hook(11, 2)] & 0x000000ff) | (wx << 8);
      w1[hook(11, 3)] = (w1[hook(11, 3)] & 0xffffff00) | (wx >> 24);
      break;
    case 26:
      w1[hook(11, 2)] = (w1[hook(11, 2)] & 0x0000ffff) | (wx << 16);
      w1[hook(11, 3)] = (w1[hook(11, 3)] & 0xffff0000) | (wx >> 16);
      break;
    case 27:
      w1[hook(11, 2)] = (w1[hook(11, 2)] & 0x00ffffff) | (wx << 24);
      w1[hook(11, 3)] = (w1[hook(11, 3)] & 0xff000000) | (wx >> 8);
      break;
    case 28:
      w1[hook(11, 3)] = wx;
      break;
    case 29:
      w1[hook(11, 3)] = (w1[hook(11, 3)] & 0x000000ff) | (wx << 8);
      w2[hook(12, 0)] = (w2[hook(12, 0)] & 0xffffff00) | (wx >> 24);
      break;
    case 30:
      w1[hook(11, 3)] = (w1[hook(11, 3)] & 0x0000ffff) | (wx << 16);
      w2[hook(12, 0)] = (w2[hook(12, 0)] & 0xffff0000) | (wx >> 16);
      break;
    case 31:
      w1[hook(11, 3)] = (w1[hook(11, 3)] & 0x00ffffff) | (wx << 24);
      w2[hook(12, 0)] = (w2[hook(12, 0)] & 0xff000000) | (wx >> 8);
      break;
    case 32:
      w2[hook(12, 0)] = wx;
      break;
    case 33:
      w2[hook(12, 0)] = (w2[hook(12, 0)] & 0x000000ff) | (wx << 8);
      w2[hook(12, 1)] = (w2[hook(12, 1)] & 0xffffff00) | (wx >> 24);
      break;
    case 34:
      w2[hook(12, 0)] = (w2[hook(12, 0)] & 0x0000ffff) | (wx << 16);
      w2[hook(12, 1)] = (w2[hook(12, 1)] & 0xffff0000) | (wx >> 16);
      break;
    case 35:
      w2[hook(12, 0)] = (w2[hook(12, 0)] & 0x00ffffff) | (wx << 24);
      w2[hook(12, 1)] = (w2[hook(12, 1)] & 0xff000000) | (wx >> 8);
      break;
    case 36:
      w2[hook(12, 1)] = wx;
      break;
    case 37:
      w2[hook(12, 1)] = (w2[hook(12, 1)] & 0x000000ff) | (wx << 8);
      w2[hook(12, 2)] = (w2[hook(12, 2)] & 0xffffff00) | (wx >> 24);
      break;
    case 38:
      w2[hook(12, 1)] = (w2[hook(12, 1)] & 0x0000ffff) | (wx << 16);
      w2[hook(12, 2)] = (w2[hook(12, 2)] & 0xffff0000) | (wx >> 16);
      break;
    case 39:
      w2[hook(12, 1)] = (w2[hook(12, 1)] & 0x00ffffff) | (wx << 24);
      w2[hook(12, 2)] = (w2[hook(12, 2)] & 0xff000000) | (wx >> 8);
      break;
    case 40:
      w2[hook(12, 2)] = wx;
      break;
    case 41:
      w2[hook(12, 2)] = (w2[hook(12, 2)] & 0x000000ff) | (wx << 8);
      w2[hook(12, 3)] = (w2[hook(12, 3)] & 0xffffff00) | (wx >> 24);
      break;
    case 42:
      w2[hook(12, 2)] = (w2[hook(12, 2)] & 0x0000ffff) | (wx << 16);
      w2[hook(12, 3)] = (w2[hook(12, 3)] & 0xffff0000) | (wx >> 16);
      break;
    case 43:
      w2[hook(12, 2)] = (w2[hook(12, 2)] & 0x00ffffff) | (wx << 24);
      w2[hook(12, 3)] = (w2[hook(12, 3)] & 0xff000000) | (wx >> 8);
      break;
    case 44:
      w2[hook(12, 3)] = wx;
      break;
    case 45:
      w2[hook(12, 3)] = (w2[hook(12, 3)] & 0x000000ff) | (wx << 8);
      w3[hook(13, 0)] = (w3[hook(13, 0)] & 0xffffff00) | (wx >> 24);
      break;
    case 46:
      w2[hook(12, 3)] = (w2[hook(12, 3)] & 0x0000ffff) | (wx << 16);
      w3[hook(13, 0)] = (w3[hook(13, 0)] & 0xffff0000) | (wx >> 16);
      break;
    case 47:
      w2[hook(12, 3)] = (w2[hook(12, 3)] & 0x00ffffff) | (wx << 24);
      w3[hook(13, 0)] = (w3[hook(13, 0)] & 0xff000000) | (wx >> 8);
      break;
    case 48:
      w3[hook(13, 0)] = wx;
      break;
    case 49:
      w3[hook(13, 0)] = (w3[hook(13, 0)] & 0x000000ff) | (wx << 8);
      w3[hook(13, 1)] = (w3[hook(13, 1)] & 0xffffff00) | (wx >> 24);
      break;
    case 50:
      w3[hook(13, 0)] = (w3[hook(13, 0)] & 0x0000ffff) | (wx << 16);
      w3[hook(13, 1)] = (w3[hook(13, 1)] & 0xffff0000) | (wx >> 16);
      break;
    case 51:
      w3[hook(13, 0)] = (w3[hook(13, 0)] & 0x00ffffff) | (wx << 24);
      w3[hook(13, 1)] = (w3[hook(13, 1)] & 0xff000000) | (wx >> 8);
      break;
    case 52:
      w3[hook(13, 1)] = wx;
      break;
    case 53:
      w3[hook(13, 1)] = (w3[hook(13, 1)] & 0x000000ff) | (wx << 8);
      w3[hook(13, 2)] = (w3[hook(13, 2)] & 0xffffff00) | (wx >> 24);
      break;
    case 54:
      w3[hook(13, 1)] = (w3[hook(13, 1)] & 0x0000ffff) | (wx << 16);
      w3[hook(13, 2)] = (w3[hook(13, 2)] & 0xffff0000) | (wx >> 16);
      break;
    case 55:
      w3[hook(13, 1)] = (w3[hook(13, 1)] & 0x00ffffff) | (wx << 24);
      w3[hook(13, 2)] = (w3[hook(13, 2)] & 0xff000000) | (wx >> 8);
      break;
    case 56:
      w3[hook(13, 2)] = wx;
      break;
    case 57:
      w3[hook(13, 2)] = (w3[hook(13, 2)] & 0x000000ff) | (wx << 8);
      w3[hook(13, 3)] = (w3[hook(13, 3)] & 0xffffff00) | (wx >> 24);
      break;
    case 58:
      w3[hook(13, 2)] = (w3[hook(13, 2)] & 0x0000ffff) | (wx << 16);
      w3[hook(13, 3)] = (w3[hook(13, 3)] & 0xffff0000) | (wx >> 16);
      break;
    case 59:
      w3[hook(13, 2)] = (w3[hook(13, 2)] & 0x00ffffff) | (wx << 24);
      w3[hook(13, 3)] = (w3[hook(13, 3)] & 0xff000000) | (wx >> 8);
      break;
    case 60:
      w3[hook(13, 3)] = wx;
      break;
    case 61:
      w3[hook(13, 3)] = (w3[hook(13, 3)] & 0x000000ff) | (wx << 8);

      break;
    case 62:
      w3[hook(13, 3)] = (w3[hook(13, 3)] & 0x0000ffff) | (wx << 16);

      break;
    case 63:
      w3[hook(13, 3)] = (w3[hook(13, 3)] & 0x00ffffff) | (wx << 24);

      break;
  }
}

inline void overwrite_at_be_4x4(unsigned int w0[4], unsigned int w1[4], unsigned int w2[4], unsigned int w3[4], const unsigned int wx, const unsigned int salt_len) {
  switch (salt_len) {
    case 0:
      w0[hook(10, 0)] = wx;
      break;
    case 1:
      w0[hook(10, 0)] = (w0[hook(10, 0)] & 0xff000000) | (wx >> 8);
      w0[hook(10, 1)] = (w0[hook(10, 1)] & 0x00ffffff) | (wx << 24);
      break;
    case 2:
      w0[hook(10, 0)] = (w0[hook(10, 0)] & 0xffff0000) | (wx >> 16);
      w0[hook(10, 1)] = (w0[hook(10, 1)] & 0x0000ffff) | (wx << 16);
      break;
    case 3:
      w0[hook(10, 0)] = (w0[hook(10, 0)] & 0xffffff00) | (wx >> 24);
      w0[hook(10, 1)] = (w0[hook(10, 1)] & 0x000000ff) | (wx << 8);
      break;
    case 4:
      w0[hook(10, 1)] = wx;
      break;
    case 5:
      w0[hook(10, 1)] = (w0[hook(10, 1)] & 0xff000000) | (wx >> 8);
      w0[hook(10, 2)] = (w0[hook(10, 2)] & 0x00ffffff) | (wx << 24);
      break;
    case 6:
      w0[hook(10, 1)] = (w0[hook(10, 1)] & 0xffff0000) | (wx >> 16);
      w0[hook(10, 2)] = (w0[hook(10, 2)] & 0x0000ffff) | (wx << 16);
      break;
    case 7:
      w0[hook(10, 1)] = (w0[hook(10, 1)] & 0xffffff00) | (wx >> 24);
      w0[hook(10, 2)] = (w0[hook(10, 2)] & 0x000000ff) | (wx << 8);
      break;
    case 8:
      w0[hook(10, 2)] = wx;
      break;
    case 9:
      w0[hook(10, 2)] = (w0[hook(10, 2)] & 0xff000000) | (wx >> 8);
      w0[hook(10, 3)] = (w0[hook(10, 3)] & 0x00ffffff) | (wx << 24);
      break;
    case 10:
      w0[hook(10, 2)] = (w0[hook(10, 2)] & 0xffff0000) | (wx >> 16);
      w0[hook(10, 3)] = (w0[hook(10, 3)] & 0x0000ffff) | (wx << 16);
      break;
    case 11:
      w0[hook(10, 2)] = (w0[hook(10, 2)] & 0xffffff00) | (wx >> 24);
      w0[hook(10, 3)] = (w0[hook(10, 3)] & 0x000000ff) | (wx << 8);
      break;
    case 12:
      w0[hook(10, 3)] = wx;
      break;
    case 13:
      w0[hook(10, 3)] = (w0[hook(10, 3)] & 0xff000000) | (wx >> 8);
      w1[hook(11, 0)] = (w1[hook(11, 0)] & 0x00ffffff) | (wx << 24);
      break;
    case 14:
      w0[hook(10, 3)] = (w0[hook(10, 3)] & 0xffff0000) | (wx >> 16);
      w1[hook(11, 0)] = (w1[hook(11, 0)] & 0x0000ffff) | (wx << 16);
      break;
    case 15:
      w0[hook(10, 3)] = (w0[hook(10, 3)] & 0xffffff00) | (wx >> 24);
      w1[hook(11, 0)] = (w1[hook(11, 0)] & 0x000000ff) | (wx << 8);
      break;
    case 16:
      w1[hook(11, 0)] = wx;
      break;
    case 17:
      w1[hook(11, 0)] = (w1[hook(11, 0)] & 0xff000000) | (wx >> 8);
      w1[hook(11, 1)] = (w1[hook(11, 1)] & 0x00ffffff) | (wx << 24);
      break;
    case 18:
      w1[hook(11, 0)] = (w1[hook(11, 0)] & 0xffff0000) | (wx >> 16);
      w1[hook(11, 1)] = (w1[hook(11, 1)] & 0x0000ffff) | (wx << 16);
      break;
    case 19:
      w1[hook(11, 0)] = (w1[hook(11, 0)] & 0xffffff00) | (wx >> 24);
      w1[hook(11, 1)] = (w1[hook(11, 1)] & 0x000000ff) | (wx << 8);
      break;
    case 20:
      w1[hook(11, 1)] = wx;
      break;
    case 21:
      w1[hook(11, 1)] = (w1[hook(11, 1)] & 0xff000000) | (wx >> 8);
      w1[hook(11, 2)] = (w1[hook(11, 2)] & 0x00ffffff) | (wx << 24);
      break;
    case 22:
      w1[hook(11, 1)] = (w1[hook(11, 1)] & 0xffff0000) | (wx >> 16);
      w1[hook(11, 2)] = (w1[hook(11, 2)] & 0x0000ffff) | (wx << 16);
      break;
    case 23:
      w1[hook(11, 1)] = (w1[hook(11, 1)] & 0xffffff00) | (wx >> 24);
      w1[hook(11, 2)] = (w1[hook(11, 2)] & 0x000000ff) | (wx << 8);
      break;
    case 24:
      w1[hook(11, 2)] = wx;
      break;
    case 25:
      w1[hook(11, 2)] = (w1[hook(11, 2)] & 0xff000000) | (wx >> 8);
      w1[hook(11, 3)] = (w1[hook(11, 3)] & 0x00ffffff) | (wx << 24);
      break;
    case 26:
      w1[hook(11, 2)] = (w1[hook(11, 2)] & 0xffff0000) | (wx >> 16);
      w1[hook(11, 3)] = (w1[hook(11, 3)] & 0x0000ffff) | (wx << 16);
      break;
    case 27:
      w1[hook(11, 2)] = (w1[hook(11, 2)] & 0xffffff00) | (wx >> 24);
      w1[hook(11, 3)] = (w1[hook(11, 3)] & 0x000000ff) | (wx << 8);
      break;
    case 28:
      w1[hook(11, 3)] = wx;
      break;
    case 29:
      w1[hook(11, 3)] = (w1[hook(11, 3)] & 0xff000000) | (wx >> 8);
      w2[hook(12, 0)] = (w2[hook(12, 0)] & 0x00ffffff) | (wx << 24);
      break;
    case 30:
      w1[hook(11, 3)] = (w1[hook(11, 3)] & 0xffff0000) | (wx >> 16);
      w2[hook(12, 0)] = (w2[hook(12, 0)] & 0x0000ffff) | (wx << 16);
      break;
    case 31:
      w1[hook(11, 3)] = (w1[hook(11, 3)] & 0xffffff00) | (wx >> 24);
      w2[hook(12, 0)] = (w2[hook(12, 0)] & 0x000000ff) | (wx << 8);
      break;
    case 32:
      w2[hook(12, 0)] = wx;
      break;
    case 33:
      w2[hook(12, 0)] = (w2[hook(12, 0)] & 0xff000000) | (wx >> 8);
      w2[hook(12, 1)] = (w2[hook(12, 1)] & 0x00ffffff) | (wx << 24);
      break;
    case 34:
      w2[hook(12, 0)] = (w2[hook(12, 0)] & 0xffff0000) | (wx >> 16);
      w2[hook(12, 1)] = (w2[hook(12, 1)] & 0x0000ffff) | (wx << 16);
      break;
    case 35:
      w2[hook(12, 0)] = (w2[hook(12, 0)] & 0xffffff00) | (wx >> 24);
      w2[hook(12, 1)] = (w2[hook(12, 1)] & 0x000000ff) | (wx << 8);
      break;
    case 36:
      w2[hook(12, 1)] = wx;
      break;
    case 37:
      w2[hook(12, 1)] = (w2[hook(12, 1)] & 0xff000000) | (wx >> 8);
      w2[hook(12, 2)] = (w2[hook(12, 2)] & 0x00ffffff) | (wx << 24);
      break;
    case 38:
      w2[hook(12, 1)] = (w2[hook(12, 1)] & 0xffff0000) | (wx >> 16);
      w2[hook(12, 2)] = (w2[hook(12, 2)] & 0x0000ffff) | (wx << 16);
      break;
    case 39:
      w2[hook(12, 1)] = (w2[hook(12, 1)] & 0xffffff00) | (wx >> 24);
      w2[hook(12, 2)] = (w2[hook(12, 2)] & 0x000000ff) | (wx << 8);
      break;
    case 40:
      w2[hook(12, 2)] = wx;
      break;
    case 41:
      w2[hook(12, 2)] = (w2[hook(12, 2)] & 0xff000000) | (wx >> 8);
      w2[hook(12, 3)] = (w2[hook(12, 3)] & 0x00ffffff) | (wx << 24);
      break;
    case 42:
      w2[hook(12, 2)] = (w2[hook(12, 2)] & 0xffff0000) | (wx >> 16);
      w2[hook(12, 3)] = (w2[hook(12, 3)] & 0x0000ffff) | (wx << 16);
      break;
    case 43:
      w2[hook(12, 2)] = (w2[hook(12, 2)] & 0xffffff00) | (wx >> 24);
      w2[hook(12, 3)] = (w2[hook(12, 3)] & 0x000000ff) | (wx << 8);
      break;
    case 44:
      w2[hook(12, 3)] = wx;
      break;
    case 45:
      w2[hook(12, 3)] = (w2[hook(12, 3)] & 0xff000000) | (wx >> 8);
      w3[hook(13, 0)] = (w3[hook(13, 0)] & 0x00ffffff) | (wx << 24);
      break;
    case 46:
      w2[hook(12, 3)] = (w2[hook(12, 3)] & 0xffff0000) | (wx >> 16);
      w3[hook(13, 0)] = (w3[hook(13, 0)] & 0x0000ffff) | (wx << 16);
      break;
    case 47:
      w2[hook(12, 3)] = (w2[hook(12, 3)] & 0xffffff00) | (wx >> 24);
      w3[hook(13, 0)] = (w3[hook(13, 0)] & 0x000000ff) | (wx << 8);
      break;
    case 48:
      w3[hook(13, 0)] = wx;
      break;
    case 49:
      w3[hook(13, 0)] = (w3[hook(13, 0)] & 0xff000000) | (wx >> 8);
      w3[hook(13, 1)] = (w3[hook(13, 1)] & 0x00ffffff) | (wx << 24);
      break;
    case 50:
      w3[hook(13, 0)] = (w3[hook(13, 0)] & 0xffff0000) | (wx >> 16);
      w3[hook(13, 1)] = (w3[hook(13, 1)] & 0x0000ffff) | (wx << 16);
      break;
    case 51:
      w3[hook(13, 0)] = (w3[hook(13, 0)] & 0xffffff00) | (wx >> 24);
      w3[hook(13, 1)] = (w3[hook(13, 1)] & 0x000000ff) | (wx << 8);
      break;
    case 52:
      w3[hook(13, 1)] = wx;
      break;
    case 53:
      w3[hook(13, 1)] = (w3[hook(13, 1)] & 0xff000000) | (wx >> 8);
      w3[hook(13, 2)] = (w3[hook(13, 2)] & 0x00ffffff) | (wx << 24);
      break;
    case 54:
      w3[hook(13, 1)] = (w3[hook(13, 1)] & 0xffff0000) | (wx >> 16);
      w3[hook(13, 2)] = (w3[hook(13, 2)] & 0x0000ffff) | (wx << 16);
      break;
    case 55:
      w3[hook(13, 1)] = (w3[hook(13, 1)] & 0xffffff00) | (wx >> 24);
      w3[hook(13, 2)] = (w3[hook(13, 2)] & 0x000000ff) | (wx << 8);
      break;
    case 56:
      w3[hook(13, 2)] = wx;
      break;
    case 57:
      w3[hook(13, 2)] = (w3[hook(13, 2)] & 0xff000000) | (wx >> 8);
      w3[hook(13, 3)] = (w3[hook(13, 3)] & 0x00ffffff) | (wx << 24);
      break;
    case 58:
      w3[hook(13, 2)] = (w3[hook(13, 2)] & 0xffff0000) | (wx >> 16);
      w3[hook(13, 3)] = (w3[hook(13, 3)] & 0x0000ffff) | (wx << 16);
      break;
    case 59:
      w3[hook(13, 2)] = (w3[hook(13, 2)] & 0xffffff00) | (wx >> 24);
      w3[hook(13, 3)] = (w3[hook(13, 3)] & 0x000000ff) | (wx << 8);
      break;
    case 60:
      w3[hook(13, 3)] = wx;
      break;
    case 61:
      w3[hook(13, 3)] = (w3[hook(13, 3)] & 0xff000000) | (wx >> 8);

      break;
    case 62:
      w3[hook(13, 3)] = (w3[hook(13, 3)] & 0xffff0000) | (wx >> 16);

      break;
    case 63:
      w3[hook(13, 3)] = (w3[hook(13, 3)] & 0xffffff00) | (wx >> 24);

      break;
  }
}

inline void append_0x01_1x4_S(unsigned int w0[4], const unsigned int offset) {
  switch (offset) {
    case 0:
      w0[hook(10, 0)] = 0x01;
      break;

    case 1:
      w0[hook(10, 0)] = w0[hook(10, 0)] | 0x0100;
      break;

    case 2:
      w0[hook(10, 0)] = w0[hook(10, 0)] | 0x010000;
      break;

    case 3:
      w0[hook(10, 0)] = w0[hook(10, 0)] | 0x01000000;
      break;

    case 4:
      w0[hook(10, 1)] = 0x01;
      break;

    case 5:
      w0[hook(10, 1)] = w0[hook(10, 1)] | 0x0100;
      break;

    case 6:
      w0[hook(10, 1)] = w0[hook(10, 1)] | 0x010000;
      break;

    case 7:
      w0[hook(10, 1)] = w0[hook(10, 1)] | 0x01000000;
      break;

    case 8:
      w0[hook(10, 2)] = 0x01;
      break;

    case 9:
      w0[hook(10, 2)] = w0[hook(10, 2)] | 0x0100;
      break;

    case 10:
      w0[hook(10, 2)] = w0[hook(10, 2)] | 0x010000;
      break;

    case 11:
      w0[hook(10, 2)] = w0[hook(10, 2)] | 0x01000000;
      break;

    case 12:
      w0[hook(10, 3)] = 0x01;
      break;

    case 13:
      w0[hook(10, 3)] = w0[hook(10, 3)] | 0x0100;
      break;

    case 14:
      w0[hook(10, 3)] = w0[hook(10, 3)] | 0x010000;
      break;

    case 15:
      w0[hook(10, 3)] = w0[hook(10, 3)] | 0x01000000;
      break;
  }
}

inline void append_0x01_2x4_S(unsigned int w0[4], unsigned int w1[4], const unsigned int offset) {
  switch (offset) {
    case 0:
      w0[hook(10, 0)] = 0x01;
      break;

    case 1:
      w0[hook(10, 0)] = w0[hook(10, 0)] | 0x0100;
      break;

    case 2:
      w0[hook(10, 0)] = w0[hook(10, 0)] | 0x010000;
      break;

    case 3:
      w0[hook(10, 0)] = w0[hook(10, 0)] | 0x01000000;
      break;

    case 4:
      w0[hook(10, 1)] = 0x01;
      break;

    case 5:
      w0[hook(10, 1)] = w0[hook(10, 1)] | 0x0100;
      break;

    case 6:
      w0[hook(10, 1)] = w0[hook(10, 1)] | 0x010000;
      break;

    case 7:
      w0[hook(10, 1)] = w0[hook(10, 1)] | 0x01000000;
      break;

    case 8:
      w0[hook(10, 2)] = 0x01;
      break;

    case 9:
      w0[hook(10, 2)] = w0[hook(10, 2)] | 0x0100;
      break;

    case 10:
      w0[hook(10, 2)] = w0[hook(10, 2)] | 0x010000;
      break;

    case 11:
      w0[hook(10, 2)] = w0[hook(10, 2)] | 0x01000000;
      break;

    case 12:
      w0[hook(10, 3)] = 0x01;
      break;

    case 13:
      w0[hook(10, 3)] = w0[hook(10, 3)] | 0x0100;
      break;

    case 14:
      w0[hook(10, 3)] = w0[hook(10, 3)] | 0x010000;
      break;

    case 15:
      w0[hook(10, 3)] = w0[hook(10, 3)] | 0x01000000;
      break;

    case 16:
      w1[hook(11, 0)] = 0x01;
      break;

    case 17:
      w1[hook(11, 0)] = w1[hook(11, 0)] | 0x0100;
      break;

    case 18:
      w1[hook(11, 0)] = w1[hook(11, 0)] | 0x010000;
      break;

    case 19:
      w1[hook(11, 0)] = w1[hook(11, 0)] | 0x01000000;
      break;

    case 20:
      w1[hook(11, 1)] = 0x01;
      break;

    case 21:
      w1[hook(11, 1)] = w1[hook(11, 1)] | 0x0100;
      break;

    case 22:
      w1[hook(11, 1)] = w1[hook(11, 1)] | 0x010000;
      break;

    case 23:
      w1[hook(11, 1)] = w1[hook(11, 1)] | 0x01000000;
      break;

    case 24:
      w1[hook(11, 2)] = 0x01;
      break;

    case 25:
      w1[hook(11, 2)] = w1[hook(11, 2)] | 0x0100;
      break;

    case 26:
      w1[hook(11, 2)] = w1[hook(11, 2)] | 0x010000;
      break;

    case 27:
      w1[hook(11, 2)] = w1[hook(11, 2)] | 0x01000000;
      break;

    case 28:
      w1[hook(11, 3)] = 0x01;
      break;

    case 29:
      w1[hook(11, 3)] = w1[hook(11, 3)] | 0x0100;
      break;

    case 30:
      w1[hook(11, 3)] = w1[hook(11, 3)] | 0x010000;
      break;

    case 31:
      w1[hook(11, 3)] = w1[hook(11, 3)] | 0x01000000;
      break;
  }
}

inline void append_0x01_3x4_S(unsigned int w0[4], unsigned int w1[4], unsigned int w2[4], const unsigned int offset) {
  switch (offset) {
    case 0:
      w0[hook(10, 0)] = 0x01;
      break;

    case 1:
      w0[hook(10, 0)] = w0[hook(10, 0)] | 0x0100;
      break;

    case 2:
      w0[hook(10, 0)] = w0[hook(10, 0)] | 0x010000;
      break;

    case 3:
      w0[hook(10, 0)] = w0[hook(10, 0)] | 0x01000000;
      break;

    case 4:
      w0[hook(10, 1)] = 0x01;
      break;

    case 5:
      w0[hook(10, 1)] = w0[hook(10, 1)] | 0x0100;
      break;

    case 6:
      w0[hook(10, 1)] = w0[hook(10, 1)] | 0x010000;
      break;

    case 7:
      w0[hook(10, 1)] = w0[hook(10, 1)] | 0x01000000;
      break;

    case 8:
      w0[hook(10, 2)] = 0x01;
      break;

    case 9:
      w0[hook(10, 2)] = w0[hook(10, 2)] | 0x0100;
      break;

    case 10:
      w0[hook(10, 2)] = w0[hook(10, 2)] | 0x010000;
      break;

    case 11:
      w0[hook(10, 2)] = w0[hook(10, 2)] | 0x01000000;
      break;

    case 12:
      w0[hook(10, 3)] = 0x01;
      break;

    case 13:
      w0[hook(10, 3)] = w0[hook(10, 3)] | 0x0100;
      break;

    case 14:
      w0[hook(10, 3)] = w0[hook(10, 3)] | 0x010000;
      break;

    case 15:
      w0[hook(10, 3)] = w0[hook(10, 3)] | 0x01000000;
      break;

    case 16:
      w1[hook(11, 0)] = 0x01;
      break;

    case 17:
      w1[hook(11, 0)] = w1[hook(11, 0)] | 0x0100;
      break;

    case 18:
      w1[hook(11, 0)] = w1[hook(11, 0)] | 0x010000;
      break;

    case 19:
      w1[hook(11, 0)] = w1[hook(11, 0)] | 0x01000000;
      break;

    case 20:
      w1[hook(11, 1)] = 0x01;
      break;

    case 21:
      w1[hook(11, 1)] = w1[hook(11, 1)] | 0x0100;
      break;

    case 22:
      w1[hook(11, 1)] = w1[hook(11, 1)] | 0x010000;
      break;

    case 23:
      w1[hook(11, 1)] = w1[hook(11, 1)] | 0x01000000;
      break;

    case 24:
      w1[hook(11, 2)] = 0x01;
      break;

    case 25:
      w1[hook(11, 2)] = w1[hook(11, 2)] | 0x0100;
      break;

    case 26:
      w1[hook(11, 2)] = w1[hook(11, 2)] | 0x010000;
      break;

    case 27:
      w1[hook(11, 2)] = w1[hook(11, 2)] | 0x01000000;
      break;

    case 28:
      w1[hook(11, 3)] = 0x01;
      break;

    case 29:
      w1[hook(11, 3)] = w1[hook(11, 3)] | 0x0100;
      break;

    case 30:
      w1[hook(11, 3)] = w1[hook(11, 3)] | 0x010000;
      break;

    case 31:
      w1[hook(11, 3)] = w1[hook(11, 3)] | 0x01000000;
      break;

    case 32:
      w2[hook(12, 0)] = 0x01;
      break;

    case 33:
      w2[hook(12, 0)] = w2[hook(12, 0)] | 0x0100;
      break;

    case 34:
      w2[hook(12, 0)] = w2[hook(12, 0)] | 0x010000;
      break;

    case 35:
      w2[hook(12, 0)] = w2[hook(12, 0)] | 0x01000000;
      break;

    case 36:
      w2[hook(12, 1)] = 0x01;
      break;

    case 37:
      w2[hook(12, 1)] = w2[hook(12, 1)] | 0x0100;
      break;

    case 38:
      w2[hook(12, 1)] = w2[hook(12, 1)] | 0x010000;
      break;

    case 39:
      w2[hook(12, 1)] = w2[hook(12, 1)] | 0x01000000;
      break;

    case 40:
      w2[hook(12, 2)] = 0x01;
      break;

    case 41:
      w2[hook(12, 2)] = w2[hook(12, 2)] | 0x0100;
      break;

    case 42:
      w2[hook(12, 2)] = w2[hook(12, 2)] | 0x010000;
      break;

    case 43:
      w2[hook(12, 2)] = w2[hook(12, 2)] | 0x01000000;
      break;

    case 44:
      w2[hook(12, 3)] = 0x01;
      break;

    case 45:
      w2[hook(12, 3)] = w2[hook(12, 3)] | 0x0100;
      break;

    case 46:
      w2[hook(12, 3)] = w2[hook(12, 3)] | 0x010000;
      break;

    case 47:
      w2[hook(12, 3)] = w2[hook(12, 3)] | 0x01000000;
      break;
  }
}

inline void append_0x01_4x4_S(unsigned int w0[4], unsigned int w1[4], unsigned int w2[4], unsigned int w3[4], const unsigned int offset) {
  switch (offset) {
    case 0:
      w0[hook(10, 0)] = 0x01;
      break;

    case 1:
      w0[hook(10, 0)] = w0[hook(10, 0)] | 0x0100;
      break;

    case 2:
      w0[hook(10, 0)] = w0[hook(10, 0)] | 0x010000;
      break;

    case 3:
      w0[hook(10, 0)] = w0[hook(10, 0)] | 0x01000000;
      break;

    case 4:
      w0[hook(10, 1)] = 0x01;
      break;

    case 5:
      w0[hook(10, 1)] = w0[hook(10, 1)] | 0x0100;
      break;

    case 6:
      w0[hook(10, 1)] = w0[hook(10, 1)] | 0x010000;
      break;

    case 7:
      w0[hook(10, 1)] = w0[hook(10, 1)] | 0x01000000;
      break;

    case 8:
      w0[hook(10, 2)] = 0x01;
      break;

    case 9:
      w0[hook(10, 2)] = w0[hook(10, 2)] | 0x0100;
      break;

    case 10:
      w0[hook(10, 2)] = w0[hook(10, 2)] | 0x010000;
      break;

    case 11:
      w0[hook(10, 2)] = w0[hook(10, 2)] | 0x01000000;
      break;

    case 12:
      w0[hook(10, 3)] = 0x01;
      break;

    case 13:
      w0[hook(10, 3)] = w0[hook(10, 3)] | 0x0100;
      break;

    case 14:
      w0[hook(10, 3)] = w0[hook(10, 3)] | 0x010000;
      break;

    case 15:
      w0[hook(10, 3)] = w0[hook(10, 3)] | 0x01000000;
      break;

    case 16:
      w1[hook(11, 0)] = 0x01;
      break;

    case 17:
      w1[hook(11, 0)] = w1[hook(11, 0)] | 0x0100;
      break;

    case 18:
      w1[hook(11, 0)] = w1[hook(11, 0)] | 0x010000;
      break;

    case 19:
      w1[hook(11, 0)] = w1[hook(11, 0)] | 0x01000000;
      break;

    case 20:
      w1[hook(11, 1)] = 0x01;
      break;

    case 21:
      w1[hook(11, 1)] = w1[hook(11, 1)] | 0x0100;
      break;

    case 22:
      w1[hook(11, 1)] = w1[hook(11, 1)] | 0x010000;
      break;

    case 23:
      w1[hook(11, 1)] = w1[hook(11, 1)] | 0x01000000;
      break;

    case 24:
      w1[hook(11, 2)] = 0x01;
      break;

    case 25:
      w1[hook(11, 2)] = w1[hook(11, 2)] | 0x0100;
      break;

    case 26:
      w1[hook(11, 2)] = w1[hook(11, 2)] | 0x010000;
      break;

    case 27:
      w1[hook(11, 2)] = w1[hook(11, 2)] | 0x01000000;
      break;

    case 28:
      w1[hook(11, 3)] = 0x01;
      break;

    case 29:
      w1[hook(11, 3)] = w1[hook(11, 3)] | 0x0100;
      break;

    case 30:
      w1[hook(11, 3)] = w1[hook(11, 3)] | 0x010000;
      break;

    case 31:
      w1[hook(11, 3)] = w1[hook(11, 3)] | 0x01000000;
      break;

    case 32:
      w2[hook(12, 0)] = 0x01;
      break;

    case 33:
      w2[hook(12, 0)] = w2[hook(12, 0)] | 0x0100;
      break;

    case 34:
      w2[hook(12, 0)] = w2[hook(12, 0)] | 0x010000;
      break;

    case 35:
      w2[hook(12, 0)] = w2[hook(12, 0)] | 0x01000000;
      break;

    case 36:
      w2[hook(12, 1)] = 0x01;
      break;

    case 37:
      w2[hook(12, 1)] = w2[hook(12, 1)] | 0x0100;
      break;

    case 38:
      w2[hook(12, 1)] = w2[hook(12, 1)] | 0x010000;
      break;

    case 39:
      w2[hook(12, 1)] = w2[hook(12, 1)] | 0x01000000;
      break;

    case 40:
      w2[hook(12, 2)] = 0x01;
      break;

    case 41:
      w2[hook(12, 2)] = w2[hook(12, 2)] | 0x0100;
      break;

    case 42:
      w2[hook(12, 2)] = w2[hook(12, 2)] | 0x010000;
      break;

    case 43:
      w2[hook(12, 2)] = w2[hook(12, 2)] | 0x01000000;
      break;

    case 44:
      w2[hook(12, 3)] = 0x01;
      break;

    case 45:
      w2[hook(12, 3)] = w2[hook(12, 3)] | 0x0100;
      break;

    case 46:
      w2[hook(12, 3)] = w2[hook(12, 3)] | 0x010000;
      break;

    case 47:
      w2[hook(12, 3)] = w2[hook(12, 3)] | 0x01000000;
      break;

    case 48:
      w3[hook(13, 0)] = 0x01;
      break;

    case 49:
      w3[hook(13, 0)] = w3[hook(13, 0)] | 0x0100;
      break;

    case 50:
      w3[hook(13, 0)] = w3[hook(13, 0)] | 0x010000;
      break;

    case 51:
      w3[hook(13, 0)] = w3[hook(13, 0)] | 0x01000000;
      break;

    case 52:
      w3[hook(13, 1)] = 0x01;
      break;

    case 53:
      w3[hook(13, 1)] = w3[hook(13, 1)] | 0x0100;
      break;

    case 54:
      w3[hook(13, 1)] = w3[hook(13, 1)] | 0x010000;
      break;

    case 55:
      w3[hook(13, 1)] = w3[hook(13, 1)] | 0x01000000;
      break;

    case 56:
      w3[hook(13, 2)] = 0x01;
      break;

    case 57:
      w3[hook(13, 2)] = w3[hook(13, 2)] | 0x0100;
      break;

    case 58:
      w3[hook(13, 2)] = w3[hook(13, 2)] | 0x010000;
      break;

    case 59:
      w3[hook(13, 2)] = w3[hook(13, 2)] | 0x01000000;
      break;

    case 60:
      w3[hook(13, 3)] = 0x01;
      break;

    case 61:
      w3[hook(13, 3)] = w3[hook(13, 3)] | 0x0100;
      break;

    case 62:
      w3[hook(13, 3)] = w3[hook(13, 3)] | 0x010000;
      break;

    case 63:
      w3[hook(13, 3)] = w3[hook(13, 3)] | 0x01000000;
      break;
  }
}

inline void append_0x02_2x4_S(unsigned int w0[4], unsigned int w1[4], const unsigned int offset) {
  switch (offset) {
    case 0:
      w0[hook(10, 0)] = 0x02;
      break;

    case 1:
      w0[hook(10, 0)] = w0[hook(10, 0)] | 0x0200;
      break;

    case 2:
      w0[hook(10, 0)] = w0[hook(10, 0)] | 0x020000;
      break;

    case 3:
      w0[hook(10, 0)] = w0[hook(10, 0)] | 0x02000000;
      break;

    case 4:
      w0[hook(10, 1)] = 0x02;
      break;

    case 5:
      w0[hook(10, 1)] = w0[hook(10, 1)] | 0x0200;
      break;

    case 6:
      w0[hook(10, 1)] = w0[hook(10, 1)] | 0x020000;
      break;

    case 7:
      w0[hook(10, 1)] = w0[hook(10, 1)] | 0x02000000;
      break;

    case 8:
      w0[hook(10, 2)] = 0x02;
      break;

    case 9:
      w0[hook(10, 2)] = w0[hook(10, 2)] | 0x0200;
      break;

    case 10:
      w0[hook(10, 2)] = w0[hook(10, 2)] | 0x020000;
      break;

    case 11:
      w0[hook(10, 2)] = w0[hook(10, 2)] | 0x02000000;
      break;

    case 12:
      w0[hook(10, 3)] = 0x02;
      break;

    case 13:
      w0[hook(10, 3)] = w0[hook(10, 3)] | 0x0200;
      break;

    case 14:
      w0[hook(10, 3)] = w0[hook(10, 3)] | 0x020000;
      break;

    case 15:
      w0[hook(10, 3)] = w0[hook(10, 3)] | 0x02000000;
      break;

    case 16:
      w1[hook(11, 0)] = 0x02;
      break;

    case 17:
      w1[hook(11, 0)] = w1[hook(11, 0)] | 0x0200;
      break;

    case 18:
      w1[hook(11, 0)] = w1[hook(11, 0)] | 0x020000;
      break;

    case 19:
      w1[hook(11, 0)] = w1[hook(11, 0)] | 0x02000000;
      break;

    case 20:
      w1[hook(11, 1)] = 0x02;
      break;

    case 21:
      w1[hook(11, 1)] = w1[hook(11, 1)] | 0x0200;
      break;

    case 22:
      w1[hook(11, 1)] = w1[hook(11, 1)] | 0x020000;
      break;

    case 23:
      w1[hook(11, 1)] = w1[hook(11, 1)] | 0x02000000;
      break;

    case 24:
      w1[hook(11, 2)] = 0x02;
      break;

    case 25:
      w1[hook(11, 2)] = w1[hook(11, 2)] | 0x0200;
      break;

    case 26:
      w1[hook(11, 2)] = w1[hook(11, 2)] | 0x020000;
      break;

    case 27:
      w1[hook(11, 2)] = w1[hook(11, 2)] | 0x02000000;
      break;

    case 28:
      w1[hook(11, 3)] = 0x02;
      break;

    case 29:
      w1[hook(11, 3)] = w1[hook(11, 3)] | 0x0200;
      break;

    case 30:
      w1[hook(11, 3)] = w1[hook(11, 3)] | 0x020000;
      break;

    case 31:
      w1[hook(11, 3)] = w1[hook(11, 3)] | 0x02000000;
      break;
  }
}

inline void append_0x02_3x4_S(unsigned int w0[4], unsigned int w1[4], unsigned int w2[4], const unsigned int offset) {
  switch (offset) {
    case 0:
      w0[hook(10, 0)] = 0x02;
      break;

    case 1:
      w0[hook(10, 0)] = w0[hook(10, 0)] | 0x0200;
      break;

    case 2:
      w0[hook(10, 0)] = w0[hook(10, 0)] | 0x020000;
      break;

    case 3:
      w0[hook(10, 0)] = w0[hook(10, 0)] | 0x02000000;
      break;

    case 4:
      w0[hook(10, 1)] = 0x02;
      break;

    case 5:
      w0[hook(10, 1)] = w0[hook(10, 1)] | 0x0200;
      break;

    case 6:
      w0[hook(10, 1)] = w0[hook(10, 1)] | 0x020000;
      break;

    case 7:
      w0[hook(10, 1)] = w0[hook(10, 1)] | 0x02000000;
      break;

    case 8:
      w0[hook(10, 2)] = 0x02;
      break;

    case 9:
      w0[hook(10, 2)] = w0[hook(10, 2)] | 0x0200;
      break;

    case 10:
      w0[hook(10, 2)] = w0[hook(10, 2)] | 0x020000;
      break;

    case 11:
      w0[hook(10, 2)] = w0[hook(10, 2)] | 0x02000000;
      break;

    case 12:
      w0[hook(10, 3)] = 0x02;
      break;

    case 13:
      w0[hook(10, 3)] = w0[hook(10, 3)] | 0x0200;
      break;

    case 14:
      w0[hook(10, 3)] = w0[hook(10, 3)] | 0x020000;
      break;

    case 15:
      w0[hook(10, 3)] = w0[hook(10, 3)] | 0x02000000;
      break;

    case 16:
      w1[hook(11, 0)] = 0x02;
      break;

    case 17:
      w1[hook(11, 0)] = w1[hook(11, 0)] | 0x0200;
      break;

    case 18:
      w1[hook(11, 0)] = w1[hook(11, 0)] | 0x020000;
      break;

    case 19:
      w1[hook(11, 0)] = w1[hook(11, 0)] | 0x02000000;
      break;

    case 20:
      w1[hook(11, 1)] = 0x02;
      break;

    case 21:
      w1[hook(11, 1)] = w1[hook(11, 1)] | 0x0200;
      break;

    case 22:
      w1[hook(11, 1)] = w1[hook(11, 1)] | 0x020000;
      break;

    case 23:
      w1[hook(11, 1)] = w1[hook(11, 1)] | 0x02000000;
      break;

    case 24:
      w1[hook(11, 2)] = 0x02;
      break;

    case 25:
      w1[hook(11, 2)] = w1[hook(11, 2)] | 0x0200;
      break;

    case 26:
      w1[hook(11, 2)] = w1[hook(11, 2)] | 0x020000;
      break;

    case 27:
      w1[hook(11, 2)] = w1[hook(11, 2)] | 0x02000000;
      break;

    case 28:
      w1[hook(11, 3)] = 0x02;
      break;

    case 29:
      w1[hook(11, 3)] = w1[hook(11, 3)] | 0x0200;
      break;

    case 30:
      w1[hook(11, 3)] = w1[hook(11, 3)] | 0x020000;
      break;

    case 31:
      w1[hook(11, 3)] = w1[hook(11, 3)] | 0x02000000;
      break;

    case 32:
      w2[hook(12, 0)] = 0x02;
      break;

    case 33:
      w2[hook(12, 0)] = w2[hook(12, 0)] | 0x0200;
      break;

    case 34:
      w2[hook(12, 0)] = w2[hook(12, 0)] | 0x020000;
      break;

    case 35:
      w2[hook(12, 0)] = w2[hook(12, 0)] | 0x02000000;
      break;

    case 36:
      w2[hook(12, 1)] = 0x02;
      break;

    case 37:
      w2[hook(12, 1)] = w2[hook(12, 1)] | 0x0200;
      break;

    case 38:
      w2[hook(12, 1)] = w2[hook(12, 1)] | 0x020000;
      break;

    case 39:
      w2[hook(12, 1)] = w2[hook(12, 1)] | 0x02000000;
      break;

    case 40:
      w2[hook(12, 2)] = 0x02;
      break;

    case 41:
      w2[hook(12, 2)] = w2[hook(12, 2)] | 0x0200;
      break;

    case 42:
      w2[hook(12, 2)] = w2[hook(12, 2)] | 0x020000;
      break;

    case 43:
      w2[hook(12, 2)] = w2[hook(12, 2)] | 0x02000000;
      break;

    case 44:
      w2[hook(12, 3)] = 0x02;
      break;

    case 45:
      w2[hook(12, 3)] = w2[hook(12, 3)] | 0x0200;
      break;

    case 46:
      w2[hook(12, 3)] = w2[hook(12, 3)] | 0x020000;
      break;

    case 47:
      w2[hook(12, 3)] = w2[hook(12, 3)] | 0x02000000;
      break;
  }
}

inline void append_0x80_1x4_S(unsigned int w0[4], const unsigned int offset) {
  switch (offset) {
    case 0:
      w0[hook(10, 0)] = 0x80;
      break;

    case 1:
      w0[hook(10, 0)] = w0[hook(10, 0)] | 0x8000;
      break;

    case 2:
      w0[hook(10, 0)] = w0[hook(10, 0)] | 0x800000;
      break;

    case 3:
      w0[hook(10, 0)] = w0[hook(10, 0)] | 0x80000000;
      break;

    case 4:
      w0[hook(10, 1)] = 0x80;
      break;

    case 5:
      w0[hook(10, 1)] = w0[hook(10, 1)] | 0x8000;
      break;

    case 6:
      w0[hook(10, 1)] = w0[hook(10, 1)] | 0x800000;
      break;

    case 7:
      w0[hook(10, 1)] = w0[hook(10, 1)] | 0x80000000;
      break;

    case 8:
      w0[hook(10, 2)] = 0x80;
      break;

    case 9:
      w0[hook(10, 2)] = w0[hook(10, 2)] | 0x8000;
      break;

    case 10:
      w0[hook(10, 2)] = w0[hook(10, 2)] | 0x800000;
      break;

    case 11:
      w0[hook(10, 2)] = w0[hook(10, 2)] | 0x80000000;
      break;

    case 12:
      w0[hook(10, 3)] = 0x80;
      break;

    case 13:
      w0[hook(10, 3)] = w0[hook(10, 3)] | 0x8000;
      break;

    case 14:
      w0[hook(10, 3)] = w0[hook(10, 3)] | 0x800000;
      break;

    case 15:
      w0[hook(10, 3)] = w0[hook(10, 3)] | 0x80000000;
      break;
  }
}

inline void append_0x80_2x4_S(unsigned int w0[4], unsigned int w1[4], const unsigned int offset) {
  switch (offset) {
    case 0:
      w0[hook(10, 0)] = 0x80;
      break;

    case 1:
      w0[hook(10, 0)] = w0[hook(10, 0)] | 0x8000;
      break;

    case 2:
      w0[hook(10, 0)] = w0[hook(10, 0)] | 0x800000;
      break;

    case 3:
      w0[hook(10, 0)] = w0[hook(10, 0)] | 0x80000000;
      break;

    case 4:
      w0[hook(10, 1)] = 0x80;
      break;

    case 5:
      w0[hook(10, 1)] = w0[hook(10, 1)] | 0x8000;
      break;

    case 6:
      w0[hook(10, 1)] = w0[hook(10, 1)] | 0x800000;
      break;

    case 7:
      w0[hook(10, 1)] = w0[hook(10, 1)] | 0x80000000;
      break;

    case 8:
      w0[hook(10, 2)] = 0x80;
      break;

    case 9:
      w0[hook(10, 2)] = w0[hook(10, 2)] | 0x8000;
      break;

    case 10:
      w0[hook(10, 2)] = w0[hook(10, 2)] | 0x800000;
      break;

    case 11:
      w0[hook(10, 2)] = w0[hook(10, 2)] | 0x80000000;
      break;

    case 12:
      w0[hook(10, 3)] = 0x80;
      break;

    case 13:
      w0[hook(10, 3)] = w0[hook(10, 3)] | 0x8000;
      break;

    case 14:
      w0[hook(10, 3)] = w0[hook(10, 3)] | 0x800000;
      break;

    case 15:
      w0[hook(10, 3)] = w0[hook(10, 3)] | 0x80000000;
      break;

    case 16:
      w1[hook(11, 0)] = 0x80;
      break;

    case 17:
      w1[hook(11, 0)] = w1[hook(11, 0)] | 0x8000;
      break;

    case 18:
      w1[hook(11, 0)] = w1[hook(11, 0)] | 0x800000;
      break;

    case 19:
      w1[hook(11, 0)] = w1[hook(11, 0)] | 0x80000000;
      break;

    case 20:
      w1[hook(11, 1)] = 0x80;
      break;

    case 21:
      w1[hook(11, 1)] = w1[hook(11, 1)] | 0x8000;
      break;

    case 22:
      w1[hook(11, 1)] = w1[hook(11, 1)] | 0x800000;
      break;

    case 23:
      w1[hook(11, 1)] = w1[hook(11, 1)] | 0x80000000;
      break;

    case 24:
      w1[hook(11, 2)] = 0x80;
      break;

    case 25:
      w1[hook(11, 2)] = w1[hook(11, 2)] | 0x8000;
      break;

    case 26:
      w1[hook(11, 2)] = w1[hook(11, 2)] | 0x800000;
      break;

    case 27:
      w1[hook(11, 2)] = w1[hook(11, 2)] | 0x80000000;
      break;

    case 28:
      w1[hook(11, 3)] = 0x80;
      break;

    case 29:
      w1[hook(11, 3)] = w1[hook(11, 3)] | 0x8000;
      break;

    case 30:
      w1[hook(11, 3)] = w1[hook(11, 3)] | 0x800000;
      break;

    case 31:
      w1[hook(11, 3)] = w1[hook(11, 3)] | 0x80000000;
      break;
  }
}

inline void append_0x80_3x4_S(unsigned int w0[4], unsigned int w1[4], unsigned int w2[4], const unsigned int offset) {
  switch (offset) {
    case 0:
      w0[hook(10, 0)] = 0x80;
      break;

    case 1:
      w0[hook(10, 0)] = w0[hook(10, 0)] | 0x8000;
      break;

    case 2:
      w0[hook(10, 0)] = w0[hook(10, 0)] | 0x800000;
      break;

    case 3:
      w0[hook(10, 0)] = w0[hook(10, 0)] | 0x80000000;
      break;

    case 4:
      w0[hook(10, 1)] = 0x80;
      break;

    case 5:
      w0[hook(10, 1)] = w0[hook(10, 1)] | 0x8000;
      break;

    case 6:
      w0[hook(10, 1)] = w0[hook(10, 1)] | 0x800000;
      break;

    case 7:
      w0[hook(10, 1)] = w0[hook(10, 1)] | 0x80000000;
      break;

    case 8:
      w0[hook(10, 2)] = 0x80;
      break;

    case 9:
      w0[hook(10, 2)] = w0[hook(10, 2)] | 0x8000;
      break;

    case 10:
      w0[hook(10, 2)] = w0[hook(10, 2)] | 0x800000;
      break;

    case 11:
      w0[hook(10, 2)] = w0[hook(10, 2)] | 0x80000000;
      break;

    case 12:
      w0[hook(10, 3)] = 0x80;
      break;

    case 13:
      w0[hook(10, 3)] = w0[hook(10, 3)] | 0x8000;
      break;

    case 14:
      w0[hook(10, 3)] = w0[hook(10, 3)] | 0x800000;
      break;

    case 15:
      w0[hook(10, 3)] = w0[hook(10, 3)] | 0x80000000;
      break;

    case 16:
      w1[hook(11, 0)] = 0x80;
      break;

    case 17:
      w1[hook(11, 0)] = w1[hook(11, 0)] | 0x8000;
      break;

    case 18:
      w1[hook(11, 0)] = w1[hook(11, 0)] | 0x800000;
      break;

    case 19:
      w1[hook(11, 0)] = w1[hook(11, 0)] | 0x80000000;
      break;

    case 20:
      w1[hook(11, 1)] = 0x80;
      break;

    case 21:
      w1[hook(11, 1)] = w1[hook(11, 1)] | 0x8000;
      break;

    case 22:
      w1[hook(11, 1)] = w1[hook(11, 1)] | 0x800000;
      break;

    case 23:
      w1[hook(11, 1)] = w1[hook(11, 1)] | 0x80000000;
      break;

    case 24:
      w1[hook(11, 2)] = 0x80;
      break;

    case 25:
      w1[hook(11, 2)] = w1[hook(11, 2)] | 0x8000;
      break;

    case 26:
      w1[hook(11, 2)] = w1[hook(11, 2)] | 0x800000;
      break;

    case 27:
      w1[hook(11, 2)] = w1[hook(11, 2)] | 0x80000000;
      break;

    case 28:
      w1[hook(11, 3)] = 0x80;
      break;

    case 29:
      w1[hook(11, 3)] = w1[hook(11, 3)] | 0x8000;
      break;

    case 30:
      w1[hook(11, 3)] = w1[hook(11, 3)] | 0x800000;
      break;

    case 31:
      w1[hook(11, 3)] = w1[hook(11, 3)] | 0x80000000;
      break;

    case 32:
      w2[hook(12, 0)] = 0x80;
      break;

    case 33:
      w2[hook(12, 0)] = w2[hook(12, 0)] | 0x8000;
      break;

    case 34:
      w2[hook(12, 0)] = w2[hook(12, 0)] | 0x800000;
      break;

    case 35:
      w2[hook(12, 0)] = w2[hook(12, 0)] | 0x80000000;
      break;

    case 36:
      w2[hook(12, 1)] = 0x80;
      break;

    case 37:
      w2[hook(12, 1)] = w2[hook(12, 1)] | 0x8000;
      break;

    case 38:
      w2[hook(12, 1)] = w2[hook(12, 1)] | 0x800000;
      break;

    case 39:
      w2[hook(12, 1)] = w2[hook(12, 1)] | 0x80000000;
      break;

    case 40:
      w2[hook(12, 2)] = 0x80;
      break;

    case 41:
      w2[hook(12, 2)] = w2[hook(12, 2)] | 0x8000;
      break;

    case 42:
      w2[hook(12, 2)] = w2[hook(12, 2)] | 0x800000;
      break;

    case 43:
      w2[hook(12, 2)] = w2[hook(12, 2)] | 0x80000000;
      break;

    case 44:
      w2[hook(12, 3)] = 0x80;
      break;

    case 45:
      w2[hook(12, 3)] = w2[hook(12, 3)] | 0x8000;
      break;

    case 46:
      w2[hook(12, 3)] = w2[hook(12, 3)] | 0x800000;
      break;

    case 47:
      w2[hook(12, 3)] = w2[hook(12, 3)] | 0x80000000;
      break;
  }
}

inline void append_0x80_4x4_S(unsigned int w0[4], unsigned int w1[4], unsigned int w2[4], unsigned int w3[4], const unsigned int offset) {
  switch (offset) {
    case 0:
      w0[hook(10, 0)] = 0x80;
      break;

    case 1:
      w0[hook(10, 0)] = w0[hook(10, 0)] | 0x8000;
      break;

    case 2:
      w0[hook(10, 0)] = w0[hook(10, 0)] | 0x800000;
      break;

    case 3:
      w0[hook(10, 0)] = w0[hook(10, 0)] | 0x80000000;
      break;

    case 4:
      w0[hook(10, 1)] = 0x80;
      break;

    case 5:
      w0[hook(10, 1)] = w0[hook(10, 1)] | 0x8000;
      break;

    case 6:
      w0[hook(10, 1)] = w0[hook(10, 1)] | 0x800000;
      break;

    case 7:
      w0[hook(10, 1)] = w0[hook(10, 1)] | 0x80000000;
      break;

    case 8:
      w0[hook(10, 2)] = 0x80;
      break;

    case 9:
      w0[hook(10, 2)] = w0[hook(10, 2)] | 0x8000;
      break;

    case 10:
      w0[hook(10, 2)] = w0[hook(10, 2)] | 0x800000;
      break;

    case 11:
      w0[hook(10, 2)] = w0[hook(10, 2)] | 0x80000000;
      break;

    case 12:
      w0[hook(10, 3)] = 0x80;
      break;

    case 13:
      w0[hook(10, 3)] = w0[hook(10, 3)] | 0x8000;
      break;

    case 14:
      w0[hook(10, 3)] = w0[hook(10, 3)] | 0x800000;
      break;

    case 15:
      w0[hook(10, 3)] = w0[hook(10, 3)] | 0x80000000;
      break;

    case 16:
      w1[hook(11, 0)] = 0x80;
      break;

    case 17:
      w1[hook(11, 0)] = w1[hook(11, 0)] | 0x8000;
      break;

    case 18:
      w1[hook(11, 0)] = w1[hook(11, 0)] | 0x800000;
      break;

    case 19:
      w1[hook(11, 0)] = w1[hook(11, 0)] | 0x80000000;
      break;

    case 20:
      w1[hook(11, 1)] = 0x80;
      break;

    case 21:
      w1[hook(11, 1)] = w1[hook(11, 1)] | 0x8000;
      break;

    case 22:
      w1[hook(11, 1)] = w1[hook(11, 1)] | 0x800000;
      break;

    case 23:
      w1[hook(11, 1)] = w1[hook(11, 1)] | 0x80000000;
      break;

    case 24:
      w1[hook(11, 2)] = 0x80;
      break;

    case 25:
      w1[hook(11, 2)] = w1[hook(11, 2)] | 0x8000;
      break;

    case 26:
      w1[hook(11, 2)] = w1[hook(11, 2)] | 0x800000;
      break;

    case 27:
      w1[hook(11, 2)] = w1[hook(11, 2)] | 0x80000000;
      break;

    case 28:
      w1[hook(11, 3)] = 0x80;
      break;

    case 29:
      w1[hook(11, 3)] = w1[hook(11, 3)] | 0x8000;
      break;

    case 30:
      w1[hook(11, 3)] = w1[hook(11, 3)] | 0x800000;
      break;

    case 31:
      w1[hook(11, 3)] = w1[hook(11, 3)] | 0x80000000;
      break;

    case 32:
      w2[hook(12, 0)] = 0x80;
      break;

    case 33:
      w2[hook(12, 0)] = w2[hook(12, 0)] | 0x8000;
      break;

    case 34:
      w2[hook(12, 0)] = w2[hook(12, 0)] | 0x800000;
      break;

    case 35:
      w2[hook(12, 0)] = w2[hook(12, 0)] | 0x80000000;
      break;

    case 36:
      w2[hook(12, 1)] = 0x80;
      break;

    case 37:
      w2[hook(12, 1)] = w2[hook(12, 1)] | 0x8000;
      break;

    case 38:
      w2[hook(12, 1)] = w2[hook(12, 1)] | 0x800000;
      break;

    case 39:
      w2[hook(12, 1)] = w2[hook(12, 1)] | 0x80000000;
      break;

    case 40:
      w2[hook(12, 2)] = 0x80;
      break;

    case 41:
      w2[hook(12, 2)] = w2[hook(12, 2)] | 0x8000;
      break;

    case 42:
      w2[hook(12, 2)] = w2[hook(12, 2)] | 0x800000;
      break;

    case 43:
      w2[hook(12, 2)] = w2[hook(12, 2)] | 0x80000000;
      break;

    case 44:
      w2[hook(12, 3)] = 0x80;
      break;

    case 45:
      w2[hook(12, 3)] = w2[hook(12, 3)] | 0x8000;
      break;

    case 46:
      w2[hook(12, 3)] = w2[hook(12, 3)] | 0x800000;
      break;

    case 47:
      w2[hook(12, 3)] = w2[hook(12, 3)] | 0x80000000;
      break;

    case 48:
      w3[hook(13, 0)] = 0x80;
      break;

    case 49:
      w3[hook(13, 0)] = w3[hook(13, 0)] | 0x8000;
      break;

    case 50:
      w3[hook(13, 0)] = w3[hook(13, 0)] | 0x800000;
      break;

    case 51:
      w3[hook(13, 0)] = w3[hook(13, 0)] | 0x80000000;
      break;

    case 52:
      w3[hook(13, 1)] = 0x80;
      break;

    case 53:
      w3[hook(13, 1)] = w3[hook(13, 1)] | 0x8000;
      break;

    case 54:
      w3[hook(13, 1)] = w3[hook(13, 1)] | 0x800000;
      break;

    case 55:
      w3[hook(13, 1)] = w3[hook(13, 1)] | 0x80000000;
      break;

    case 56:
      w3[hook(13, 2)] = 0x80;
      break;

    case 57:
      w3[hook(13, 2)] = w3[hook(13, 2)] | 0x8000;
      break;

    case 58:
      w3[hook(13, 2)] = w3[hook(13, 2)] | 0x800000;
      break;

    case 59:
      w3[hook(13, 2)] = w3[hook(13, 2)] | 0x80000000;
      break;

    case 60:
      w3[hook(13, 3)] = 0x80;
      break;

    case 61:
      w3[hook(13, 3)] = w3[hook(13, 3)] | 0x8000;
      break;

    case 62:
      w3[hook(13, 3)] = w3[hook(13, 3)] | 0x800000;
      break;

    case 63:
      w3[hook(13, 3)] = w3[hook(13, 3)] | 0x80000000;
      break;
  }
}

inline void truncate_block_S(unsigned int w[4], const unsigned int len) {
  switch (len) {
    case 0:
      w[hook(9, 0)] &= 0;
      w[hook(9, 1)] &= 0;
      w[hook(9, 2)] &= 0;
      w[hook(9, 3)] &= 0;
      break;
    case 1:
      w[hook(9, 0)] &= 0x000000FF;
      w[hook(9, 1)] &= 0;
      w[hook(9, 2)] &= 0;
      w[hook(9, 3)] &= 0;
      break;
    case 2:
      w[hook(9, 0)] &= 0x0000FFFF;
      w[hook(9, 1)] &= 0;
      w[hook(9, 2)] &= 0;
      w[hook(9, 3)] &= 0;
      break;
    case 3:
      w[hook(9, 0)] &= 0x00FFFFFF;
      w[hook(9, 1)] &= 0;
      w[hook(9, 2)] &= 0;
      w[hook(9, 3)] &= 0;
      break;
    case 4:
      w[hook(9, 1)] &= 0;
      w[hook(9, 2)] &= 0;
      w[hook(9, 3)] &= 0;
      break;
    case 5:
      w[hook(9, 1)] &= 0x000000FF;
      w[hook(9, 2)] &= 0;
      w[hook(9, 3)] &= 0;
      break;
    case 6:
      w[hook(9, 1)] &= 0x0000FFFF;
      w[hook(9, 2)] &= 0;
      w[hook(9, 3)] &= 0;
      break;
    case 7:
      w[hook(9, 1)] &= 0x00FFFFFF;
      w[hook(9, 2)] &= 0;
      w[hook(9, 3)] &= 0;
      break;
    case 8:
      w[hook(9, 2)] &= 0;
      w[hook(9, 3)] &= 0;
      break;
    case 9:
      w[hook(9, 2)] &= 0x000000FF;
      w[hook(9, 3)] &= 0;
      break;
    case 10:
      w[hook(9, 2)] &= 0x0000FFFF;
      w[hook(9, 3)] &= 0;
      break;
    case 11:
      w[hook(9, 2)] &= 0x00FFFFFF;
      w[hook(9, 3)] &= 0;
      break;
    case 12:
      w[hook(9, 3)] &= 0;
      break;
    case 13:
      w[hook(9, 3)] &= 0x000000FF;
      break;
    case 14:
      w[hook(9, 3)] &= 0x0000FFFF;
      break;
    case 15:
      w[hook(9, 3)] &= 0x00FFFFFF;
      break;
  }
}

inline void make_unicode_S(const unsigned int in[4], unsigned int out1[4], unsigned int out2[4]) {
}

inline void undo_unicode_S(const unsigned int in1[4], const unsigned int in2[4], unsigned int out[4]) {
}

inline void switch_buffer_by_offset_le_S(unsigned int w0[4], unsigned int w1[4], unsigned int w2[4], unsigned int w3[4], const unsigned int offset) {
}

inline void switch_buffer_by_offset_be_S(unsigned int w0[4], unsigned int w1[4], unsigned int w2[4], unsigned int w3[4], const unsigned int offset) {
}
inline void switch_buffer_by_offset_le_VV(unsigned int w0[4], unsigned int w1[4], unsigned int w2[4], unsigned int w3[4], const unsigned int offset) {
  switch_buffer_by_offset_le_S(w0, w1, w2, w3, offset);
}

inline void append_0x01_2x4_VV(unsigned int w0[4], unsigned int w1[4], const unsigned int offset) {
  append_0x01_2x4_S(w0, w1, offset);
}

inline void append_0x80_2x4_VV(unsigned int w0[4], unsigned int w1[4], const unsigned int offset) {
  append_0x80_2x4_S(w0, w1, offset);
}

inline void append_0x80_4x4_VV(unsigned int w0[4], unsigned int w1[4], unsigned int w2[4], unsigned int w3[4], const unsigned int offset) {
  append_0x80_4x4_S(w0, w1, w2, w3, offset);
}

kernel void gpu_memset(global uint4* buf, const unsigned int value, const unsigned int gid_max) {
  const unsigned int gid = get_global_id(0);

  if (gid >= gid_max)
    return;

  buf[hook(0, gid)] = (uint4)(value);
}
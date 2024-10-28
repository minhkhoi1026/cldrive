//{"Debug":7,"HashTable":8,"block_size":4,"blocksPerLaunch":5,"dvs":12,"end_pts":6,"in":0,"in_size":1,"iter":9,"out":2,"out_size":3,"test":10,"vals":11}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void lzo1x_1_15_compress(global const unsigned char* in, unsigned int in_size, global unsigned char* out, unsigned int out_size, unsigned int block_size, int blocksPerLaunch, global unsigned int* end_pts, global unsigned int* Debug, global unsigned short* HashTable, int iter) {
  unsigned short wrkgrp = get_group_id(0);
  unsigned int gbl_wrkgrp = wrkgrp + iter * blocksPerLaunch;
  unsigned int startidx_inp = gbl_wrkgrp * block_size;
  unsigned short blks = in_size % block_size == 0 ? in_size / block_size : in_size / block_size + 1;
  unsigned int startidx_out = gbl_wrkgrp * (out_size / blks);

  short NUM_THREADS = get_local_size(0);
  short pl = 128 / NUM_THREADS;

  unsigned short lcid = get_local_id(0);
  unsigned short data_sz = block_size > in_size - startidx_inp ? in_size - startidx_inp : block_size;
  unsigned int Hashidx = gbl_wrkgrp * 8192;
  HashTable += Hashidx;
  unsigned short loops = 8192 / NUM_THREADS;
  unsigned short rem = 8192 % NUM_THREADS;
  unsigned short i;
  for (i = 0; i < loops; i++) {
    HashTable[hook(8, lcid + i * NUM_THREADS)] = 0;
  }
  if (lcid < rem) {
    HashTable[hook(8, loops * NUM_THREADS + lcid)] = 0;
  }
  unsigned short D_bits = 0;
  unsigned short Hashtable_entries = 8192;
  while (Hashtable_entries != 0) {
    D_bits++;
    Hashtable_entries /= 2;
  }
  D_bits--;
  unsigned int endidx_inp = startidx_inp + data_sz;
  unsigned int stopidx_inp = startidx_inp + data_sz - 20;
  unsigned int lastMatch_inp = startidx_inp;
  unsigned int curridx_inp = startidx_inp;
  unsigned int curridx_out = startidx_out;
  unsigned int m_pos;
  unsigned short m_len, m_off;
  unsigned int dv;
  unsigned short dindex;
  curridx_inp += 4;

  unsigned short t = 0;
  unsigned short flag = 1;
  local char test[8];
  if (lcid < 8) {
    test[hook(10, lcid)] = 0;
  }
  local unsigned char vals[128 + 3];
  local unsigned int dvs[128];
  unsigned int cacheidx;
  loops = pl;
  if (data_sz >= 128 + 3) {
    cacheidx = startidx_inp + 5;
    for (i = 0; i < loops; i++) {
      vals[hook(11, NUM_THREADS * i + lcid)] = in[hook(0, startidx_inp + NUM_THREADS * i + lcid + 5)];
    }
    if (lcid < 3) {
      vals[hook(11, NUM_THREADS * loops + lcid)] = in[hook(0, startidx_inp + NUM_THREADS * i + lcid + 5)];
    }
    barrier(0x01);
    for (i = 0; i < loops; i++) {
      unsigned int cacheval = loops * lcid + i;
      dvs[hook(12, cacheval)] = ((unsigned int)vals[hook(11, cacheval)] | ((unsigned int)vals[hook(11, cacheval + 1)] << 8) | ((unsigned int)vals[hook(11, cacheval + 2)] << 16) | ((unsigned int)vals[hook(11, cacheval + 3)] << 24));
    }

    for (i = 0; i < loops; i++) {
      unsigned int cacheval = ((loops - i) * NUM_THREADS - 1) - lcid;
      if (lcid > NUM_THREADS / 2)
        HashTable[hook(8, ((1 << D_bits) - 1) & (((unsigned int)(405029533 * dvs[chook(12, cacheval))) >> (32 - D_bits)))] = (unsigned short)(cacheidx + cacheval - startidx_inp);
    }

    barrier(0x01);
  }
  char lookaheadflag = 0;
  char stopcache = 0;
  for (;;) {
    if (flag)
      curridx_inp += 1 + ((curridx_inp - lastMatch_inp) >> 6);
    else
      flag = 1;
    if (curridx_inp >= stopidx_inp)
      break;
    if (!stopcache && lookaheadflag) {
      unsigned short len = stopidx_inp - curridx_inp > 128 + 3 ? 128 + 3 : 0;
      if (len) {
        cacheidx = curridx_inp;
        loops = pl;
        for (i = 0; i < loops; i++)
          vals[hook(11, NUM_THREADS * i + lcid)] = in[hook(0, curridx_inp + NUM_THREADS * i + lcid)];
        if (lcid < 3)
          vals[hook(11, loops * NUM_THREADS + lcid)] = in[hook(0, curridx_inp + loops * NUM_THREADS + lcid)];
        barrier(0x01);
        for (i = 0; i < loops; i++) {
          unsigned int cacheval = loops * lcid + i;
          dvs[hook(12, cacheval)] = ((unsigned int)vals[hook(11, cacheval)] | ((unsigned int)vals[hook(11, cacheval + 1)] << 8) | ((unsigned int)vals[hook(11, cacheval + 2)] << 16) | ((unsigned int)vals[hook(11, cacheval + 3)] << 24));
        }

        for (i = 0; i < loops; i++) {
          unsigned int cacheval = ((loops - i) * NUM_THREADS - 1) - lcid;
          if (lcid > NUM_THREADS / 2)
            HashTable[hook(8, ((1 << D_bits) - 1) & (((unsigned int)(405029533 * dvs[chook(12, cacheval))) >> (32 - D_bits)))] = (unsigned short)(cacheidx + cacheval - startidx_inp);
        }

        lookaheadflag = 0;
      } else
        stopcache = 1;
      barrier(0x01);
    }
    short offset = curridx_inp - cacheidx;
    if (!stopcache && offset < 128) {
      dv = dvs[hook(12, offset)];
    } else {
      dv = ((unsigned int)in[hook(0, curridx_inp)] | ((unsigned int)in[hook(0, curridx_inp + 1)] << 8) | ((unsigned int)in[hook(0, curridx_inp + 2)] << 16) | ((unsigned int)in[hook(0, curridx_inp + 3)] << 24));
      lookaheadflag = 1;
    }
    dindex = ((1 << D_bits) - 1) & (((unsigned int)(0x1824429d * dv)) >> (32 - D_bits));
    m_pos = startidx_inp + HashTable[hook(8, dindex)];
    barrier(0x01);
    if (m_pos == curridx_inp)
      continue;
    if (lcid == 0)
      HashTable[hook(8, dindex)] = (unsigned short)(curridx_inp - startidx_inp);
    unsigned int match_val;
    match_val = ((unsigned int)in[hook(0, m_pos)] | ((unsigned int)in[hook(0, m_pos + 1)] << 8) | ((unsigned int)in[hook(0, m_pos + 2)] << 16) | ((unsigned int)in[hook(0, m_pos + 3)] << 24));
    if (dv != match_val)
      continue;

    if (m_pos > curridx_inp) {
      unsigned int temp = m_pos;
      m_pos = curridx_inp;
      curridx_inp = temp;
    }
    t = (unsigned short)(curridx_inp - lastMatch_inp);
    if (t) {
      if (t <= 3) {
        if (lcid == 0)
          out[hook(2, curridx_out - 2)] = (unsigned char)(out[hook(2, curridx_out - 2)] | t);
        do {
          if (lcid == 0)
            out[hook(2, curridx_out)] = in[hook(0, lastMatch_inp)];
          curridx_out++;
          lastMatch_inp++;
        } while (--t > 0);
      } else {
        if (t <= 18) {
          if (lcid == 0)
            out[hook(2, curridx_out)] = (unsigned char)(t - 3);
          curridx_out++;
        } else {
          unsigned short tt = t - 18;
          if (lcid == 0)
            out[hook(2, curridx_out)] = 0;
          curridx_out++;
          while (tt > 255) {
            tt -= 255;
            if (lcid == 0)
              out[hook(2, curridx_out)] = 0;
            curridx_out++;
          }
          if (lcid == 0)
            out[hook(2, curridx_out)] = (unsigned char)tt;
          curridx_out++;
        }
        unsigned short loops = t / NUM_THREADS;
        unsigned short rem = t % NUM_THREADS;
        unsigned short i;
        for (i = 0; i < loops; i++) {
          out[hook(2, curridx_out + NUM_THREADS * i + lcid)] = in[hook(0, lastMatch_inp + NUM_THREADS * i + lcid)];
        }
        curridx_out += loops * NUM_THREADS;
        lastMatch_inp += loops * NUM_THREADS;
        if (lcid < rem) {
          out[hook(2, curridx_out + lcid)] = in[hook(0, lastMatch_inp + lcid)];
        }
        curridx_out += rem;
        lastMatch_inp += rem;
      }
    }
    m_len = 4;
    while (1) {
      if (lcid < 8) {
        test[hook(10, lcid)] = (in[hook(0, m_pos + m_len + lcid)] == in[hook(0, curridx_inp + m_len + lcid)]);
      }
      barrier(0x01);
      char lenidx;
      for (lenidx = 0; lenidx < 8; lenidx++) {
        if (!test[hook(10, lenidx)])
          break;
        m_len += 1;
      }
      if (lenidx < 8)
        break;
      if (curridx_inp + m_len >= stopidx_inp)
        break;
    }

    m_off = curridx_inp - m_pos;
    curridx_inp += m_len;
    lastMatch_inp = curridx_inp;
    if (m_len <= 8 && m_off <= 0x800) {
      m_off -= 1;
      if (lcid == 0) {
        out[hook(2, curridx_out)] = (unsigned char)(((m_len - 1) << 5) | ((m_off & 7) << 2));
        out[hook(2, curridx_out + 1)] = (unsigned char)(m_off >> 3);
      }
      curridx_out += 2;
    } else if (m_off <= 0x4000) {
      m_off -= 1;
      if (m_len <= 33) {
        if (lcid == 0)
          out[hook(2, curridx_out)] = (unsigned char)(32 | (m_len - 2));
        curridx_out++;
      } else {
        m_len -= 33;
        if (lcid == 0)
          out[hook(2, curridx_out)] = (unsigned char)(32 | 0);
        curridx_out++;
        while (m_len > 255) {
          m_len -= 255;
          if (lcid == 0)
            out[hook(2, curridx_out)] = 0;
          curridx_out++;
        }
        if (lcid == 0)
          out[hook(2, curridx_out)] = (unsigned char)(m_len);
        curridx_out++;
      }
      if (lcid == 0) {
        out[hook(2, curridx_out)] = (unsigned char)(m_off << 2);
        out[hook(2, curridx_out + 1)] = (unsigned char)(m_off >> 6);
      }
      curridx_out += 2;
    } else {
      m_off -= 0x4000;
      if (m_len <= 9) {
        if (lcid == 0)
          out[hook(2, curridx_out)] = (unsigned char)(16 | ((m_off >> 11) & 8) | (m_len - 2));
        curridx_out++;
      } else {
        m_len -= 9;
        if (lcid == 0)
          out[hook(2, curridx_out)] = (unsigned char)(16 | ((m_off >> 11) & 8));
        curridx_out++;
        while (m_len > 255) {
          m_len -= 255;
          if (lcid == 0)
            out[hook(2, curridx_out)] = 0;
          curridx_out++;
        }
        if (lcid == 0)
          out[hook(2, curridx_out)] = (unsigned char)(m_len);
        curridx_out++;
      }
      if (lcid == 0) {
        out[hook(2, curridx_out)] = (unsigned char)(m_off << 2);
        out[hook(2, curridx_out + 1)] = (unsigned char)(m_off >> 6);
      }
      curridx_out += 2;
    }
    flag = 0;
  }

  t = (unsigned short)(endidx_inp - lastMatch_inp);
  if (t > 0) {
    if (t <= 3) {
      if (lcid == 0)
        out[hook(2, curridx_out - 2)] = (unsigned char)(out[hook(2, curridx_out - 2)] | t);
    } else if (t <= 18) {
      if (lcid == 0)
        out[hook(2, curridx_out)] = (unsigned char)(t - 3);
      curridx_out++;
    } else {
      unsigned short tt = t - 18;
      if (lcid == 0)
        out[hook(2, curridx_out)] = 0;
      curridx_out++;
      while (tt > 255) {
        tt -= 255;
        if (lcid == 0)
          out[hook(2, curridx_out)] = 0;
        curridx_out++;
      }
      if (lcid == 0)
        out[hook(2, curridx_out)] = (unsigned char)tt;
      curridx_out++;
    }
    unsigned short loops = t / NUM_THREADS;
    unsigned short rem = t % NUM_THREADS;
    unsigned short i;
    for (i = 0; i < loops; i++) {
      out[hook(2, curridx_out + lcid + i * NUM_THREADS)] = in[hook(0, lastMatch_inp + lcid + i * NUM_THREADS)];
    }
    curridx_out += loops * NUM_THREADS;
    lastMatch_inp += loops * NUM_THREADS;
    if (lcid < rem) {
      out[hook(2, curridx_out + lcid)] = in[hook(0, lastMatch_inp + lcid)];
    }
    curridx_out += rem;
    lastMatch_inp += rem;
  }

  if (lcid == 0) {
    out[hook(2, curridx_out++)] = 16 | 1;
    out[hook(2, curridx_out++)] = 0;
    out[hook(2, curridx_out++)] = 0;
    end_pts[hook(6, gbl_wrkgrp)] = (curridx_out - startidx_out);
  }
}
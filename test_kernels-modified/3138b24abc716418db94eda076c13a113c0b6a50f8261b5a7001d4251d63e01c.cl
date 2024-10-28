//{"Histogram":0,"Image":0,"n4VectorsPerThread":2,"nSubHists":1,"p":4,"subhists":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel __attribute__((reqd_work_group_size(256, 1, 1))) void histogramKernel(global uint4* Image, global unsigned int* Histogram, unsigned int n4VectorsPerThread) {
  local unsigned int subhists[16 * 256];

  unsigned int tid = get_global_id(0);
  unsigned int ltid = get_local_id(0);
  unsigned int Stride = get_global_size(0);

  unsigned int i, idx;
  uint4 temp, temp2;
  const unsigned int shft = (unsigned int)8;
  const unsigned int msk = (unsigned int)(256 - 1);
  unsigned int offset = (unsigned int)ltid % (unsigned int)(16);

  unsigned int lmem_items = 16 * 256;
  unsigned int lmem_items_per_thread;
  unsigned int lmem_max_threads;

  lmem_max_threads = ((1) < (get_local_size(0) / lmem_items)) ? (1) : (get_local_size(0) / lmem_items);

  lmem_max_threads = ((1) > (lmem_max_threads / lmem_items)) ? (1) : (lmem_max_threads / lmem_items);

  lmem_max_threads = lmem_items / lmem_max_threads;

  lmem_max_threads = ((get_local_size(0)) < (lmem_max_threads)) ? (get_local_size(0)) : (lmem_max_threads);

  lmem_items_per_thread = lmem_items / lmem_max_threads;

  local uint4* p = (local uint4*)subhists;

  if (ltid < lmem_max_threads) {
    for (i = 0, idx = ltid; i < lmem_items_per_thread / 4; i++, idx += lmem_max_threads) {
      p[hook(4, idx)] = 0;
    }
  }

  barrier(0x01);

  for (i = 0, idx = tid; i < n4VectorsPerThread; i++, idx += Stride) {
    temp = Image[hook(0, idx)];
    temp2 = (temp & msk) * (uint4)16 + offset;

    (void)atom_inc(subhists + temp2.x);
    (void)atom_inc(subhists + temp2.y);
    (void)atom_inc(subhists + temp2.z);
    (void)atom_inc(subhists + temp2.w);

    temp = temp >> shft;
    temp2 = (temp & msk) * (uint4)16 + offset;

    (void)atom_inc(subhists + temp2.x);
    (void)atom_inc(subhists + temp2.y);
    (void)atom_inc(subhists + temp2.z);
    (void)atom_inc(subhists + temp2.w);

    temp = temp >> shft;
    temp2 = (temp & msk) * (uint4)16 + offset;

    (void)atom_inc(subhists + temp2.x);
    (void)atom_inc(subhists + temp2.y);
    (void)atom_inc(subhists + temp2.z);
    (void)atom_inc(subhists + temp2.w);

    temp = temp >> shft;
    temp2 = (temp & msk) * (uint4)16 + offset;

    (void)atom_inc(subhists + temp2.x);
    (void)atom_inc(subhists + temp2.y);
    (void)atom_inc(subhists + temp2.z);
    (void)atom_inc(subhists + temp2.w);
  }

  barrier(0x01);

  if (ltid < 256) {
    unsigned int bin = 0;

    for (i = 0; i < 16; i++) {
      bin += subhists[hook(5, (ltid * 16) + i)];
    }

    Histogram[hook(0, (get_group_id(0) * 256) + ltid)] = bin;
  }
}

kernel void reduceKernel(global unsigned int* Histogram, unsigned int nSubHists) {
  unsigned int tid = get_global_id(0);
  unsigned int bin = 0;

  for (int i = 0; i < nSubHists; i++)
    bin += Histogram[hook(0, (i * 256) + tid)];

  Histogram[hook(0, tid)] = bin;
}
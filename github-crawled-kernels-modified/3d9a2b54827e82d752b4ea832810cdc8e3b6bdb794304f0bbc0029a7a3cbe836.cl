//{"iv":1,"lhist":2,"pipe":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
enum RV_TYPE { RV_UNIFORM, RV_GAUSSIAN };

int rng_div(int dv, int dr) {
  int k = 0;

  while (dv > dr) {
    k++;
    dv -= dr;
  }

  return k;
}

void rng_init(int seed, local int* iv) {
  int j;
  int k;
  int t;

  seed ^= 0x2F24EA81;

  iv[hook(1, 0)] = seed;

  for (j = 1; j < ((256) * ((16))); j++) {
    k = rng_div(seed, (127773));

    seed = (16807) * (seed - k * (127773)) - (2836) * k;

    if (seed < 0)
      seed += (2147483647);

    iv[hook(1, j)] = seed;
  }
}

int rng_pm(int prn, local int* iv) {
  int j;
  int k;
  int nrn;

  j = prn / (1 + ((2147483647) - 1) / (16));
  nrn = iv[hook(1, j)];

  k = rng_div(prn, (127773));

  prn = (16807) * (prn - k * (127773)) - (2836) * k;

  if (prn < 0)
    prn += (2147483647);

  iv[hook(1, j)] = prn;

  return nrn;
}

float2 box_muller(float2 uniform) {
  float r = sqrt(-2 * log(uniform.x));
  float theta = 2 * 3.14159265359 * uniform.y;
  return (float2)(r * sin(theta), r * cos(theta));
}
kernel void pipe_consumer(read_only pipe float2 rng_pipe, global int* hist, float hist_min, float hist_max) {
  int bindex;
  int found, freq;
  int lap, laps;

  float2 rn;
  float bin_width;
  float rmin, rmax;

  local int lhist[256];

  int lid = get_local_id(0);
  int gid = get_global_id(0);
  int grid = get_group_id(0);
  int szgr = get_local_size(0);
  int szgl = get_global_size(0);

  laps = (256) / szgr;

  if (grid == 0) {
    for (lap = 0; lap < laps; ++lap) {
      bindex = lid + lap * szgr;
      hist[hook(2, bindex)] = 0;
    }
  }

  work_group_barrier(0x02);

  reserve_id_t rid = work_group_reserve_read_pipe(rng_pipe, szgr);

  if (is_valid_reserve_id(rid)) {
    read_pipe(rng_pipe, rid, lid, &rn);
    work_group_commit_read_pipe(rng_pipe, rid);
  }

  bin_width = (hist_max - hist_min) / (float)(256);

  rmin = hist_min;
  rmax = rmin + bin_width;
  found = 0;

  for (bindex = 0; bindex < 256; bindex++) {
    if ((rn.x >= rmin) && (rn.x < rmax)) {
      found += 1;
    }

    if ((rn.y >= rmin) && (rn.y < rmax)) {
      found += 1;
    }

    work_group_barrier(0x01);

    freq = work_group_reduce_add(found);
    if (lid == 0) {
      lhist[hook(2, bindex)] = freq;
    }

    work_group_barrier(0x01);

    rmin = rmax;
    rmax = rmin + bin_width;
    found = 0;
  }

  work_group_barrier(0x01);

  for (lap = 0; lap < laps; ++lap) {
    bindex = lid + lap * szgr;
    atomic_add((volatile global int*)(hist + bindex), lhist[bindex]);
  }

  work_group_barrier(0x02);
}
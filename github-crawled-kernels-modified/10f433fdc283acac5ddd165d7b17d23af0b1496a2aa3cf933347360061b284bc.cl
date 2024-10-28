//{"iv":1,"pipe":0}
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
kernel void pipe_producer(write_only pipe float2 rng_pipe, int pkt_per_thread, int seed, int rng_type) {
  float2 ufrn;
  float2 gfrn;
  int2 irn;
  int iter;
  int lflag;

  local int iv[((256) * ((16)))];

  int lid = get_local_id(0);
  int szgr = get_local_size(0);

  if (lid == 0) {
    rng_init(seed, iv);
  }
  work_group_barrier(0x01 | 0x02);

  iter = 0;
  irn.x = (lid + 1) * (lid + 1);
  irn.y = (lid + 1) * (lid + 1);

  while (iter < pkt_per_thread) {
    reserve_id_t rid = work_group_reserve_write_pipe(rng_pipe, szgr);

    if (is_valid_reserve_id(rid)) {
      irn.x = rng_pm(irn.y, (iv + lid * (16)));
      work_group_barrier(0x01);

      irn.y = rng_pm(irn.x, (iv + lid * (16)));
      work_group_barrier(0x01);

      ufrn.x = (float)(irn.x) * (1.0f / (float)(2147483647));
      if (ufrn.x > (1.0f - 1.2e-7))
        ufrn.x = (1.0f - 1.2e-7);

      ufrn.y = (float)(irn.y) * (1.0f / (float)(2147483647));
      if (ufrn.y > (1.0f - 1.2e-7))
        ufrn.y = (1.0f - 1.2e-7);

      if (rng_type == RV_GAUSSIAN) {
        gfrn = box_muller(ufrn);
      } else {
        gfrn = ufrn;
      }

      write_pipe(rng_pipe, rid, lid, &gfrn);
      work_group_commit_write_pipe(rng_pipe, rid);
    }

    work_group_barrier(0x02);

    iter += 1;
  }
}
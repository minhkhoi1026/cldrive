//{"c2":4,"erffactor":9,"n":3,"o":0,"prefactor":8,"q":2,"qlocal":12,"s":1,"slocal":11,"vlocal":10,"w":5,"xsize":6,"ysize":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void gauss2(global double* o, global int* s, global int* q, int n, int c2, global int* w, int xsize, int ysize, double prefactor, double erffactor) {
  int qi = q[hook(2, get_group_id(0))];
  int si = w[hook(5, get_group_id(0))];

  int zi = (si) / (xsize * ysize);
  int yi = (si) / (xsize) - (zi * ysize);
  int xi = (si) % (xsize);

  local int slocal[1024];
  local int qlocal[1024];
  local double vlocal[1024];

  vlocal[hook(10, get_local_id(0))] = 0;
  barrier(0x01);

  int num_loads = n / (get_local_size(0)) + 1;

  for (int load_number = 0; load_number < num_loads; load_number++) {
    int load_id = get_local_size(0) * load_number + get_local_id(0);
    if (load_id < n) {
      slocal[hook(11, get_local_id(0))] = s[hook(1, load_id)];
      qlocal[hook(12, get_local_id(0))] = q[hook(2, load_id)];
    } else {
      slocal[hook(11, get_local_id(0))] = -1;
      qlocal[hook(12, get_local_id(0))] = -1;
    }
    barrier(0x01);

    int sj = slocal[hook(11, get_local_id(0))];
    if (sj >= 0) {
      int zj = (sj) / (xsize * ysize);
      int yj = (sj) / (xsize) - (zj * ysize);
      int xj = (sj) % (xsize);
      double r = (xi - xj) * (xi - xj) + (yi - yj) * (yi - yj) + (zi - zj) * (zi - zj);

      if (r > 0 && r < c2) {
        r = sqrt(r);
        vlocal[hook(10, get_local_id(0))] = vlocal[hook(10, get_local_id(0))] + qlocal[hook(12, get_local_id(0))] * erf(erffactor * r) / r;
      }
    }
    barrier(0x01);
  }

  barrier(0x01);
  if (get_local_id(0) == 0) {
    double v = 0;
    for (int l = 0; l < get_local_size(0); l++) {
      v = v + vlocal[hook(10, l)];
    }

    o[hook(0, get_group_id(0))] = prefactor * v;
  }
}
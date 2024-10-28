//{"c2":4,"erffactor":6,"n":3,"o":0,"prefactor":5,"q":2,"qlocal":9,"s":1,"slocal":8,"vlocal":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void gauss1(global double* o, global int* s, global int* q, int n, int c2, double prefactor, double erffactor) {
  int j = get_local_id(0) + get_local_id(1) * get_local_size(0) + get_local_id(2) * get_local_size(0) * get_local_size(1);

  int k = get_group_id(0) + get_group_id(1) * get_num_groups(0) + get_group_id(2) * get_num_groups(0) * get_num_groups(1);

  local int slocal[64];
  local int qlocal[64];
  local double vlocal[64];

  vlocal[hook(7, j)] = 0;
  barrier(0x01);

  int local_volume = get_local_size(0) * get_local_size(1) * get_local_size(2);
  int num_loads = n / (local_volume) + 1;

  for (int load_number = 0; load_number < num_loads; load_number++) {
    int load_id = local_volume * load_number + j;
    if (load_id < n) {
      slocal[hook(8, j)] = s[hook(1, load_id)];
      qlocal[hook(9, j)] = q[hook(2, load_id)];
    } else {
      slocal[hook(8, j)] = -1;
      qlocal[hook(9, j)] = -1;
    }
    barrier(0x01);

    int s = slocal[hook(8, j)];
    if (s >= 0) {
      int z = (s) / (get_num_groups(0) * get_num_groups(1));
      int y = (s) / (get_num_groups(0)) - (z * get_num_groups(1));
      int x = (s) % (get_num_groups(0));

      double r = (get_group_id(0) - x) * (get_group_id(0) - x) + (get_group_id(1) - y) * (get_group_id(1) - y) + (get_group_id(2) - z) * (get_group_id(2) - z);

      if (r > 0 && r < c2) {
        r = sqrt(r);
        vlocal[hook(7, j)] = vlocal[hook(7, j)] + qlocal[hook(9, j)] * erf(erffactor * r) / r;
      }
    }
    barrier(0x01);
  }
  barrier(0x01);

  if (j == 0) {
    double v = 0;
    for (int l = 0; l < local_volume; l++) {
      v = v + vlocal[hook(7, l)];
    }
    o[hook(0, k)] = prefactor * v;
  }
}
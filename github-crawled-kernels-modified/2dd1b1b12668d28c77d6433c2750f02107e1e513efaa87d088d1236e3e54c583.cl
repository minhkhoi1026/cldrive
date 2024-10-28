//{"dist_grid":1,"dna_size":2,"individuals":3,"lo_grid":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void construct_individuals(global const double* lo_grid, global const double* dist_grid, global const long* dna_size, global double* individuals) {
  long i_id = get_global_id(0);

  long st_idx = i_id * dna_size[hook(2, 0)];
  double two_pi = 2 * 3.14159265358979323846f;

  individuals[hook(3, st_idx + 0)] = lo_grid[hook(0, 0)] + (individuals[hook(3, st_idx + 0)] * dist_grid[hook(1, 0)]);
  individuals[hook(3, st_idx + 1)] = lo_grid[hook(0, 1)] + (individuals[hook(3, st_idx + 1)] * dist_grid[hook(1, 1)]);
  individuals[hook(3, st_idx + 2)] = lo_grid[hook(0, 2)] + (individuals[hook(3, st_idx + 2)] * dist_grid[hook(1, 2)]);

  double x0 = individuals[hook(3, st_idx + 3)];

  double t1 = individuals[hook(3, st_idx + 4)] * two_pi;

  double t2 = individuals[hook(3, st_idx + 5)] * two_pi;
  double r1 = sqrt(1.0 - x0);
  double r2 = sqrt(x0);
  individuals[hook(3, st_idx + 4)] = sin(t1) * r1;
  individuals[hook(3, st_idx + 5)] = cos(t1) * r1;
  individuals[hook(3, st_idx + 6)] = sin(t2) * r2;
  individuals[hook(3, st_idx + 3)] = cos(t2) * r2;

  for (long tor_idx = 7; tor_idx < dna_size[hook(2, 0)]; tor_idx++) {
    individuals[hook(3, st_idx + tor_idx)] = (individuals[hook(3, st_idx + tor_idx)] - 0.5) * two_pi;
  }

  if (0 == 1) {
    if (i_id == 0 || i_id == 20 || i_id == 149) {
      individuals[hook(3, i_id * 19 + 0)] = 2.056477;
      individuals[hook(3, i_id * 19 + 1)] = 5.846611;
      individuals[hook(3, i_id * 19 + 2)] = -7.245407;
      individuals[hook(3, i_id * 19 + 3)] = 0.532211;
      individuals[hook(3, i_id * 19 + 4)] = 0.379383;
      individuals[hook(3, i_id * 19 + 5)] = 0.612442;
      individuals[hook(3, i_id * 19 + 6)] = 0.444674;
      individuals[hook(3, i_id * 19 + 7)] = radians(-122.13);
      individuals[hook(3, i_id * 19 + 8)] = radians(-179.41);
      individuals[hook(3, i_id * 19 + 9)] = radians(-141.59);
      individuals[hook(3, i_id * 19 + 10)] = radians(177.29);
      individuals[hook(3, i_id * 19 + 11)] = radians(-179.46);
      individuals[hook(3, i_id * 19 + 12)] = radians(-9.31);
      individuals[hook(3, i_id * 19 + 13)] = radians(132.37);
      individuals[hook(3, i_id * 19 + 14)] = radians(-89.19);
      individuals[hook(3, i_id * 19 + 15)] = radians(78.43);
      individuals[hook(3, i_id * 19 + 16)] = radians(22.22);
      individuals[hook(3, i_id * 19 + 17)] = radians(71.37);
      individuals[hook(3, i_id * 19 + 18)] = radians(59.52);
    }
  }
}
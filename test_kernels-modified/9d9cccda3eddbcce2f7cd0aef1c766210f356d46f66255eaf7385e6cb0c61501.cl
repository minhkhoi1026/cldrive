//{"amps_g":3,"datalength":4,"freqs_g":2,"mags_g":1,"times_g":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void periodogram(global const double* times_g, global const double* mags_g, global const double* freqs_g, global double* amps_g, const int datalength) {
  int gid = get_global_id(0);
  double this_frequency = freqs_g[hook(2, gid)];
  double realpart = 0.0;
  double imagpart = 0.0;
  double pi = 3.141592653589793;

  for (int i = 0; i < datalength; i++) {
    realpart = realpart + mags_g[hook(1, i)] * cos(2.0 * pi * this_frequency * times_g[hook(0, i)]);
    imagpart = imagpart + mags_g[hook(1, i)] * sin(2.0 * pi * this_frequency * times_g[hook(0, i)]);
  }
  amps_g[hook(3, gid)] = 2.0 * sqrt(pow(realpart, 2) + pow(imagpart, 2)) / datalength;
}
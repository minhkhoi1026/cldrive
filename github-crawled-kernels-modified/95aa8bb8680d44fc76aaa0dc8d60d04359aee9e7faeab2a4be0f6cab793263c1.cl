//{"Diffusivity":1,"N":0,"Q":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void SRAD_Diffusivity_32f(global float* N, global float* Diffusivity, float Q) {
  int k = get_global_id(0);
  int j = get_global_id(1);
  int i = get_global_id(2);

  int linear_coords = i + get_global_size(2) * j + get_global_size(2) * get_global_size(1) * k;

  int tempminus_x = 0;
  int tempplus_x = 0;
  int tempminus_y = 0;
  int tempplus_y = 0;
  int tempminus_z = 0;
  int tempplus_z = 0;

  if (i - 1 < 0) {
    tempminus_x = i;
  } else {
    tempminus_x = i - 1;
  }

  if (i + 1 >= get_global_size(2)) {
    tempplus_x = i;
  } else {
    tempplus_x = i + 1;
  }

  if (j - 1 < 0) {
    tempminus_y = j;
  } else {
    tempminus_y = j - 1;
  }

  if (j + 1 >= get_global_size(1)) {
    tempplus_y = j;
  } else {
    tempplus_y = j + 1;
  }

  if (k - 1 < 0) {
    tempminus_z = k;
  } else {
    tempminus_z = k - 1;
  }

  if (k + 1 >= get_global_size(0)) {
    tempplus_z = k;
  } else {
    tempplus_z = k + 1;
  }

  int linear_coord_minus_one_x = tempminus_x + get_global_size(2) * j + get_global_size(2) * get_global_size(1) * k;
  int linear_coord_plus_one_x = tempplus_x + get_global_size(2) * j + get_global_size(2) * get_global_size(1) * k;
  int linear_coord_minus_one_y = i + get_global_size(2) * (tempminus_y) + get_global_size(2) * get_global_size(1) * k;
  int linear_coord_plus_one_y = i + get_global_size(2) * (tempplus_y) + get_global_size(2) * get_global_size(1) * k;
  int linear_coord_minus_one_z = i + get_global_size(2) * j + get_global_size(2) * get_global_size(1) * (tempminus_z);
  int linear_coord_plus_one_z = i + get_global_size(2) * j + get_global_size(2) * get_global_size(1) * (tempplus_z);

  float n = N[hook(0, linear_coords)];

  float n_xminus1 = N[hook(0, linear_coord_minus_one_x)];

  if (n_xminus1 <= 0) {
    n_xminus1 = 1;
  }

  float n_xplus1 = N[hook(0, linear_coord_plus_one_x)];

  if (n_xplus1 <= 0) {
    n_xplus1 = 1;
  }

  float n_yminus1 = N[hook(0, linear_coord_minus_one_y)];

  if (n_yminus1 <= 0) {
    n_yminus1 = 1;
  }

  float n_yplus1 = N[hook(0, linear_coord_plus_one_y)];

  if (n_yplus1 <= 0) {
    n_yplus1 = 1;
  }

  float n_zminus1 = N[hook(0, linear_coord_minus_one_z)];

  if (n_zminus1 <= 0) {
    n_zminus1 = 1;
  }

  float n_zplus1 = N[hook(0, linear_coord_plus_one_z)];

  if (n_zplus1 <= 0) {
    n_zplus1 = 1;
  }

  float Laplacian = n_xminus1 + n_xplus1 + n_yminus1 + n_yplus1 + n_zminus1 + n_zplus1 - 4 * n;

  float GradientMag = pow((n_xplus1 - n_xminus1) / 2, 2) + pow((n_yplus1 - n_yminus1) / 2, 2) + pow((n_zplus1 - n_zminus1) / 2, 2);

  GradientMag = .5 * GradientMag;

  float numerator = GradientMag - (1 / 16) * pow(Laplacian, 2);
  float denominator = pow((n + .25 * Laplacian), 2);
  float q = sqrt(numerator / denominator);

  if (q < 0) {
    q = 0;
  }

  numerator = pow(q, 2) - pow(Q, 2);
  denominator = pow(Q, 2) * (1 + pow(Q, 2));
  float diffusivity = 1 - numerator / denominator;
  diffusivity = 1 / diffusivity;

  Diffusivity[hook(1, linear_coords)] = diffusivity;
}
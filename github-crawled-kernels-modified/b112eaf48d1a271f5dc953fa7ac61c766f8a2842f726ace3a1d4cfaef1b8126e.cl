//{"Input":0,"Processed":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Laplacian_64f(global double* Input, global double* Processed) {
  int k = get_global_id(0);
  int j = get_global_id(1);
  int i = get_global_id(2);

  double xminus1 = 0;
  double xplus1 = 0;
  double yminus1 = 0;
  double yplus1 = 0;
  double zminus1 = 0;
  double zplus1 = 0;

  int linear_coords = i + get_global_size(2) * j + get_global_size(2) * get_global_size(1) * k;

  if (get_global_id(2) > 0 && get_global_id(2) < get_global_size(2) - 1 && get_global_id(1) > 0 && get_global_id(1) < get_global_size(1) - 1 && get_global_id(0) > 0 && get_global_id(0) < get_global_size(0) - 1) {
    int linear_coord_minus_one_x = i - 1 + get_global_size(2) * j + get_global_size(2) * get_global_size(1) * k;
    int linear_coord_plus_one_x = i + 1 + get_global_size(2) * j + get_global_size(2) * get_global_size(1) * k;
    xminus1 = Input[hook(0, linear_coord_minus_one_x)];
    xplus1 = Input[hook(0, linear_coord_plus_one_x)];

    int linear_coord_minus_one_y = i + get_global_size(2) * (j - 1) + get_global_size(2) * get_global_size(1) * k;
    int linear_coord_plus_one_y = i + get_global_size(2) * (j + 1) + get_global_size(2) * get_global_size(1) * k;
    yminus1 = Input[hook(0, linear_coord_minus_one_y)];
    yplus1 = Input[hook(0, linear_coord_plus_one_y)];

    int linear_coord_minus_one_z = i + get_global_size(2) * j + get_global_size(2) * get_global_size(1) * (k - 1);
    int linear_coord_plus_one_z = i + get_global_size(2) * j + get_global_size(2) * get_global_size(1) * (k + 1);
    zminus1 = Input[hook(0, linear_coord_minus_one_z)];
    zplus1 = Input[hook(0, linear_coord_plus_one_z)];
  }

  double temp = xminus1 + xplus1 + yminus1 + yplus1 + zminus1 + zplus1 - 4 * Input[hook(0, linear_coords)];

  Processed[hook(1, linear_coords)] = temp;
}
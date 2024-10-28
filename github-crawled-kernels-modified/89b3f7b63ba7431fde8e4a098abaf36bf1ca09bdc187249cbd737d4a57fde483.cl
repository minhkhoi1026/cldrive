//{"Raw":0,"X":1,"Y":2,"Z":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Gradient_32f(global float* Raw, global float* X, global float* Y, global float* Z) {
  int k = get_global_id(0);
  int j = get_global_id(1);
  int i = get_global_id(2);

  int linear_coords = i + get_global_size(2) * j + get_global_size(2) * get_global_size(1) * k;
  float Processed_Value = 0;

  if (get_global_id(2) > 0 && get_global_id(2) < get_global_size(2) - 1 && get_global_id(1) > 0 && get_global_id(1) < get_global_size(1) - 1 && get_global_id(0) > 0 && get_global_id(0) < get_global_size(0) - 1) {
    int linear_coord_minus_one_x = i - 1 + get_global_size(2) * j + get_global_size(2) * get_global_size(1) * k;
    int linear_coord_plus_one_x = i + 1 + get_global_size(2) * j + get_global_size(2) * get_global_size(1) * k;
    Processed_Value = -Raw[hook(0, linear_coord_minus_one_x)] + Raw[hook(0, linear_coord_plus_one_x)];
    X[hook(1, linear_coords)] = Processed_Value;

    int linear_coord_minus_one_y = i + get_global_size(2) * (j - 1) + get_global_size(2) * get_global_size(1) * k;
    int linear_coord_plus_one_y = i + get_global_size(2) * (j + 1) + get_global_size(2) * get_global_size(1) * k;
    Processed_Value = -Raw[hook(0, linear_coord_minus_one_y)] + Raw[hook(0, linear_coord_plus_one_y)];
    Y[hook(2, linear_coords)] = Processed_Value;

    int linear_coord_minus_one_z = i + get_global_size(2) * j + get_global_size(2) * get_global_size(1) * (k - 1);
    int linear_coord_plus_one_z = i + get_global_size(2) * j + get_global_size(2) * get_global_size(1) * (k + 1);
    Processed_Value = -Raw[hook(0, linear_coord_minus_one_z)] + Raw[hook(0, linear_coord_plus_one_z)];
    Z[hook(3, linear_coords)] = Processed_Value;
  } else {
    X[hook(1, linear_coords)] = 0;
    Y[hook(2, linear_coords)] = 0;
    Z[hook(3, linear_coords)] = 0;
  }
}
//{"arr":0,"maximum":2,"minimum":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void limit_array(global float* arr, const float minimum, const float maximum) {
  int l = get_global_id(0);
  const float element = arr[hook(0, l)];
  if (arr[hook(0, l)] <= minimum)
    arr[hook(0, l)] = 0;
  else if (arr[hook(0, l)] >= maximum)
    arr[hook(0, l)] = 1.0;
  else
    arr[hook(0, l)] = (arr[hook(0, l)] - minimum) / (maximum - minimum);
}
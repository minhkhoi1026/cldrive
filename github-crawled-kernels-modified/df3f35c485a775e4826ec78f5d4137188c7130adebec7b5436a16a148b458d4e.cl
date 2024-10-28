//{"count":0,"input":1,"results":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void meanAndStandardDeviation(int count, global float* input, global float* results) {
  double sum, mean;
  sum = mean = 0.0;
  int i;
  for (i = 0; i < count; i++) {
    sum += input[hook(1, i)];
  }
  results[hook(2, 0)] = mean = sum / count;
  sum = 0.0;
  for (i = 0; i < count; i++) {
    sum += (input[hook(1, i)] - mean) * (input[hook(1, i)] - mean);
  }
  results[hook(2, 1)] = native_sqrt((float)(sum / (count - 1)));
}
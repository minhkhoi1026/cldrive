//{"A":0,"C":1,"H":3,"W":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void simple_add(global int* A, global int* C, int W, int H) {
  const int k = get_global_id(0);

  if (k >= 0 && k < W * H) {
    const int i = k / H;
    const int j = k % H;

    int sum = 0;

    const int left = (i + W - 1) % W;
    const int right = (i + 1) % W;
    const int down = (j + 1) % H;
    const int up = (j + H - 1) % H;

    sum += A[hook(0, right * H + j)];

    sum += A[hook(0, left * H + j)];

    sum += A[hook(0, i * H + up)];

    sum += A[hook(0, i * H + down)];

    sum += A[hook(0, right * H + up)];

    sum += A[hook(0, right * H + down)];

    sum += A[hook(0, left * H + up)];

    sum += A[hook(0, left * H + down)];

    int value = A[hook(0, k)];

    C[hook(1, k)] = (value == 1 && (sum == 2 || sum == 3)) || (value == 0 && (sum == 3 || sum == 6));
  }
}
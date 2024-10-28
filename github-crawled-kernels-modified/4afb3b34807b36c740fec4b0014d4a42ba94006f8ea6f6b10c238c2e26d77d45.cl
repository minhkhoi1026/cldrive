//{"decimalPlaces":1,"from":0,"piDigits":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
int modularPow(int base, int exponent, int modulus) {
  int c = 1;
  for (int e = 0; e < exponent; ++e) {
    c = (c * base) % modulus;
  }
  return c;
}

float4 functionP(const int n) {
  float4 sums = {0.0f, 0.0f, 0.0f, 0.0f};
  const int4 COEFS = {1, 4, 5, 6};
  const float4 MULTIPLIERS = {+4.0f, -2.0f, -1.0f, -1.0f};
  const int4 EIGHTS = {8, 8, 8, 8};

  for (int k = 0; k <= n; ++k) {
    int4 partials = EIGHTS * (int4)k + COEFS;

    sums += ((float4){(float)(modularPow(16, n - k, partials.s0)), (float)(modularPow(16, n - k, partials.s1)), (float)(modularPow(16, n - k, partials.s2)), (float)(modularPow(16, n - k, partials.s3))} / convert_float4(partials));

    sums -= convert_float4(convert_int4(sums));
  }

  for (int k = n + 1; k < n + 100; ++k) {
    int4 partials = EIGHTS * (int4)k + COEFS;
    float temp = pown(16.0f, n - k);

    sums += (float4){temp / (float)partials.s0, temp / (float)partials.s1, temp / (float)partials.s2, temp / (float)partials.s3};

    sums -= convert_float4(convert_int4(sums));
  }

  return sums * MULTIPLIERS;
}

kernel void pi(const int from, const int decimalPlaces, global float* piDigits) {
  const float4 ONES = {1, 1, 1, 1};

  const int local_id = get_local_id(0) + get_group_id(0) * get_local_size(0);
  const int local_size = get_local_size(0);

  for (int i = local_id; i < decimalPlaces; i += local_size) {
    const int decimalPlace = from + i - 1;
    float4 sums = functionP(decimalPlace);
    float s = sums.s0 + sums.s1 + sums.s2 + sums.s3;
    piDigits[hook(2, i)] = s - (int)s + 1.0f;
  }
  barrier(0x02);
}
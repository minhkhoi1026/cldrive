//{"bound":2,"count":1,"output":0,"tab":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
struct Bucket {
  unsigned int key;
  unsigned int val;
};
typedef struct Bucket Bucket;

kernel __attribute__((vec_type_hint(uint8))) void gather(global Bucket* tab, const unsigned int count, const ulong bound, global Bucket* output) {
  unsigned int div = count / 32;
  unsigned int min = count - 1;
  uint8 change = (uint8)(div, div, div, div, div, div, div, div);
  uint8 ccount = (uint8)(min, min, min, min, min, min, min, min);

  uint8 mask = (uint8)(1, 2, 3, 4, 5, 6, 7, 8) * (uint8)(3, 3, 3, 3, 3, 3, 3, 3) * change;

  ulong pos = 0;
  uint8 sum = 0;
  uint8 vec_key = (uint8)(0, 0, 0, 0, 0, 0, 0, 0);
  uint8 vec_val = (uint8)(0, 0, 0, 0, 0, 0, 0, 0);

  while (pos < bound) {
    vec_key.s0 = tab[hook(0, mask.s0)].key;
    vec_key.s1 = tab[hook(0, mask.s1)].key;
    vec_key.s2 = tab[hook(0, mask.s2)].key;
    vec_key.s3 = tab[hook(0, mask.s3)].key;
    vec_key.s4 = tab[hook(0, mask.s4)].key;
    vec_key.s5 = tab[hook(0, mask.s5)].key;
    vec_key.s6 = tab[hook(0, mask.s6)].key;
    vec_key.s7 = tab[hook(0, mask.s7)].key;

    vec_val.s0 = tab[hook(0, mask.s0)].val;
    vec_val.s1 = tab[hook(0, mask.s1)].val;
    vec_val.s2 = tab[hook(0, mask.s2)].val;
    vec_val.s3 = tab[hook(0, mask.s3)].val;
    vec_val.s4 = tab[hook(0, mask.s4)].val;
    vec_val.s5 = tab[hook(0, mask.s5)].val;
    vec_val.s6 = tab[hook(0, mask.s6)].val;
    vec_val.s7 = tab[hook(0, mask.s7)].val;

    sum += vec_val + vec_key;

    mask += change;
    mask = mask & ccount;

    pos += 8;
  }

  output[hook(0, 0)].key = sum.s0;
  output[hook(0, 1)].key = sum.s1;
  output[hook(0, 2)].key = sum.s2;
  output[hook(0, 3)].key = sum.s3;
  output[hook(0, 4)].key = sum.s4;
  output[hook(0, 5)].key = sum.s5;
  output[hook(0, 6)].key = sum.s6;
  output[hook(0, 7)].key = sum.s7;
}

kernel __attribute__((vec_type_hint(uint8))) kernel void scatter(global Bucket* output, const unsigned int count, const ulong bound) {
  unsigned int div = count / 32;
  unsigned int min = count - 1;
  uint8 change = (uint8)(div, div, div, div, div, div, div, div);
  uint8 ccount = (uint8)(min, min, min, min, min, min, min, min);

  uint8 mask = (uint8)(1, 2, 3, 4, 5, 6, 7, 8) * (uint8)(3, 3, 3, 3, 3, 3, 3, 3) * change;

  ulong pos = 0;
  const uint8 vec_key = (uint8)(0, 1, 2, 3, 4, 5, 6, 7);
  const uint8 vec_val = (uint8)(0, 1, 2, 3, 4, 5, 6, 7);

  while (pos < bound) {
    output[hook(0, mask.s0)].key = vec_key.s0;
    output[hook(0, mask.s1)].key = vec_key.s1;
    output[hook(0, mask.s2)].key = vec_key.s2;
    output[hook(0, mask.s3)].key = vec_key.s3;
    output[hook(0, mask.s4)].key = vec_key.s4;
    output[hook(0, mask.s5)].key = vec_key.s5;
    output[hook(0, mask.s6)].key = vec_key.s6;
    output[hook(0, mask.s7)].key = vec_key.s7;

    output[hook(0, mask.s0)].val = vec_val.s0;
    output[hook(0, mask.s1)].val = vec_val.s1;
    output[hook(0, mask.s2)].val = vec_val.s2;
    output[hook(0, mask.s3)].val = vec_val.s3;
    output[hook(0, mask.s4)].val = vec_val.s4;
    output[hook(0, mask.s5)].val = vec_val.s5;
    output[hook(0, mask.s6)].val = vec_val.s6;
    output[hook(0, mask.s7)].val = vec_val.s7;

    mask += change;
    mask = mask & ccount;

    pos += 8;
  }
}
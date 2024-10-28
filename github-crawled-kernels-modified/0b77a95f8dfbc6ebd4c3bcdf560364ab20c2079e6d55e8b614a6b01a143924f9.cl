//{"nquarts":3,"v1":1,"v2":2,"vsum":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void vecsum4(global int4* restrict vsum, global const int4* restrict v1, global const int4* restrict v2, int nquarts) {
  const int i = get_global_id(0);

  if (i >= nquarts)
    return;

  vsum[hook(0, i)] = v1[hook(1, i)] + v2[hook(2, i)];
}
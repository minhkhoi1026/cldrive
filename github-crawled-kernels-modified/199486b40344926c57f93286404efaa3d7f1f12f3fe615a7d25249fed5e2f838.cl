//{"global_float_data":4,"global_int_data":0,"global_uint_data":2,"local_float_data":5,"local_int_data":1,"local_uint_data":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void atomics(volatile global int* global_int_data, volatile local int* local_int_data, volatile global unsigned int* global_uint_data, volatile local unsigned int* local_uint_data, volatile global float* global_float_data, volatile local float* local_float_data) {
  int val_int = 1;
  int val_uint = 2;
  unsigned int cmp = 1;
  float val_float = 3;

  val_int = atomic_add(global_int_data, val_int);

  val_int = atomic_sub(global_int_data, val_int);

  val_int = atomic_xchg(global_int_data, val_int);

  val_int = atomic_inc(global_int_data);

  val_int = atomic_dec(global_int_data);

  val_int = atomic_cmpxchg(global_int_data, cmp, val_int);

  val_int = atomic_min(global_int_data, val_int);

  val_int = atomic_max(global_int_data, val_int);

  val_int = atomic_and(global_int_data, val_int);

  val_int = atomic_or(global_int_data, val_int);

  val_int = atomic_xor(global_int_data, val_int);

  val_uint = atomic_add(global_uint_data, val_uint);

  val_uint = atomic_sub(global_uint_data, val_uint);

  val_uint = atomic_xchg(global_uint_data, val_uint);

  val_uint = atomic_inc(global_uint_data);

  val_uint = atomic_dec(global_uint_data);

  val_uint = atomic_cmpxchg(global_uint_data, cmp, val_uint);

  val_uint = atomic_min(global_uint_data, val_uint);

  val_uint = atomic_max(global_uint_data, val_uint);

  val_uint = atomic_and(global_uint_data, val_uint);

  val_uint = atomic_or(global_uint_data, val_uint);

  val_uint = atomic_xor(global_uint_data, val_uint);

  val_int = atomic_add(local_int_data, val_int);

  val_int = atomic_sub(local_int_data, val_int);

  val_int = atomic_xchg(local_int_data, val_int);

  val_int = atomic_inc(local_int_data);

  val_int = atomic_dec(local_int_data);

  val_int = atomic_cmpxchg(local_int_data, cmp, val_int);

  val_int = atomic_min(local_int_data, val_int);

  val_int = atomic_max(local_int_data, val_int);

  val_int = atomic_and(local_int_data, val_int);

  val_int = atomic_or(local_int_data, val_int);

  val_int = atomic_xor(local_int_data, val_int);

  val_uint = atomic_add(local_uint_data, val_uint);

  val_uint = atomic_sub(local_uint_data, val_uint);

  val_uint = atomic_xchg(local_uint_data, val_uint);

  val_uint = atomic_inc(local_uint_data);

  val_uint = atomic_dec(local_uint_data);

  val_uint = atomic_cmpxchg(local_uint_data, cmp, val_uint);

  val_uint = atomic_min(local_uint_data, val_uint);

  val_uint = atomic_max(local_uint_data, val_uint);

  val_uint = atomic_and(local_uint_data, val_uint);

  val_uint = atomic_or(local_uint_data, val_uint);

  val_uint = atomic_xor(local_uint_data, val_uint);

  val_float = atomic_xchg(global_float_data, val_float);

  val_float = atomic_xchg(local_float_data, val_float);
}
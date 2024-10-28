//{"crypt_key":2,"i1":5,"i_saved_key":0,"lotus_magic_table":4,"m1":6,"m32":7,"magic_table":1,"o1":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline void lotus_transform_password(private unsigned int* i1, private unsigned int* o1, local unsigned int* lotus_magic_table) {
  unsigned int p1;
  int i;

  p1 = 0x00;
  for (i = 0; i < 4; i++) {
    p1 = o1[hook(3, i)] = lotus_magic_table[hook(4, ((i1hook(5, i)i] & 255) ^ p1) & 255)];
    p1 = lotus_magic_table[hook(4, (hook(5, i)(i1[i] & 65280) >> 8) ^ p1) & 255)];
    o1[hook(3, i)] |= p1 << 8;
    p1 = lotus_magic_table[hook(4, (((ihook(5, i)[i] & 16711680) >> 16) ^ p1) & 255)];
    o1[hook(3, i)] |= p1 << 16;
    p1 = lotus_magic_table[hook(4, (((i1[ihook(5, i) & 4278190080U) >> 24) ^ p1) & 255)];
    o1[hook(3, i)] |= p1 << 24;
  }
}

inline void lotus_mix(private unsigned int* m1, local unsigned int* lotus_magic_table) {
  int i, j, k;
  unsigned int p1;

  p1 = 0;

  for (i = 18; i > 0; i--) {
    k = 0;
    for (j = 48; j > 0;) {
      p1 = (m1[hook(6, k)] & 0xff) ^ lotus_magic_table[hook(4, ((j-- + p1) & 255) & 255)];
      m1[hook(6, k)] = (m1[hook(6, k)] & 0xffffff00) | p1;
      p1 = ((m1[hook(6, k)] & 0x0000ff00) >> 8) ^ lotus_magic_table[hook(4, ((j-- + p1) & 255) & 255)];
      m1[hook(6, k)] = (m1[hook(6, k)] & 0xffff00ff) | (p1 << 8);
      p1 = ((m1[hook(6, k)] & 0x00ff0000) >> 16) ^ lotus_magic_table[hook(4, ((j-- + p1) & 255) & 255)];
      m1[hook(6, k)] = (m1[hook(6, k)] & 0xff00ffff) | (p1 << 16);
      p1 = ((m1[hook(6, k)] & 0xff000000) >> 24) ^ lotus_magic_table[hook(4, ((j-- + p1) & 255) & 255)];
      m1[hook(6, k)] = (m1[hook(6, k)] & 0x00ffffff) | (p1 << 24);
      k++;
    }
  }
}

kernel void lotus5(global unsigned int* i_saved_key, global unsigned int* magic_table, global unsigned int* crypt_key) {
  unsigned int index = get_global_id(0);
  unsigned int m32[16];
  int password_length;

  local unsigned int lotus_magic_table[256];

  {
    size_t local_work_dim = get_local_size(0);
    unsigned int lid = get_local_id(0);
    size_t offset;

    for (offset = lid; offset < 256; offset += local_work_dim)
      lotus_magic_table[hook(4, offset)] = magic_table[hook(1, offset)];
  }

  m32[hook(7, 0)] = m32[hook(7, 1)] = m32[hook(7, 2)] = m32[hook(7, 3)] = 0;
  m32[hook(7, 4)] = m32[hook(7, 5)] = m32[hook(7, 6)] = m32[hook(7, 7)] = 0;

  password_length = i_saved_key[hook(0, index * ((16 >> 2) + 1) + ((16 >> 2) + 1) - 1)] >> 24;

  {
    int i, j;

    j = password_length % 4;
    i = password_length / 4;

    for (; j < 4; j++)
      m32[hook(7, 4 + i)] |= (16 - password_length) << (j * 8);

    for (j = i + 1; j < 4; j++)
      m32[hook(7, 4 + j)] = (16 - password_length) | (16 - password_length) << 8 | (16 - password_length) << 16 | (16 - password_length) << 24;
  }

  m32[hook(7, 8)] = m32[hook(7, 4)] ^= i_saved_key[hook(0, index * ((16 >> 2) + 1))];
  m32[hook(7, 9)] = m32[hook(7, 5)] ^= i_saved_key[hook(0, index * ((16 >> 2) + 1) + 1)];
  m32[hook(7, 10)] = m32[hook(7, 6)] ^= i_saved_key[hook(0, index * ((16 >> 2) + 1) + 2)];
  m32[hook(7, 11)] = m32[hook(7, 7)] ^= i_saved_key[hook(0, index * ((16 >> 2) + 1) + 3)];

  lotus_transform_password(m32 + 4, m32 + 12, lotus_magic_table);

  lotus_mix(m32, lotus_magic_table);

  m32[hook(7, 4)] = m32[hook(7, 12)];
  m32[hook(7, 5)] = m32[hook(7, 13)];
  m32[hook(7, 6)] = m32[hook(7, 14)];
  m32[hook(7, 7)] = m32[hook(7, 15)];

  m32[hook(7, 8)] = m32[hook(7, 0)] ^ m32[hook(7, 4)];
  m32[hook(7, 9)] = m32[hook(7, 1)] ^ m32[hook(7, 5)];
  m32[hook(7, 10)] = m32[hook(7, 2)] ^ m32[hook(7, 6)];
  m32[hook(7, 11)] = m32[hook(7, 3)] ^ m32[hook(7, 7)];

  lotus_mix(m32, lotus_magic_table);

  crypt_key[hook(2, index * (16 >> 2))] = m32[hook(7, 0)];
  crypt_key[hook(2, index * (16 >> 2) + 1)] = m32[hook(7, 1)];
  crypt_key[hook(2, index * (16 >> 2) + 2)] = m32[hook(7, 2)];
  crypt_key[hook(2, index * (16 >> 2) + 3)] = m32[hook(7, 3)];
}
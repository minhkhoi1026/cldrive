//{"d_iv":2,"data":0,"out":3,"p":1,"s":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void BFdecKernel_cbc(global unsigned long* data, global unsigned int* p, global unsigned long* d_iv, global unsigned long* out) {
 private
  unsigned int l, r;
 private
  unsigned long block = data[hook(0, get_global_id(0))];

  l = ((block >> 24L) & 0x000000ff) | ((block >> 8L) & 0x0000ff00) | ((block << 8L) & 0x00ff0000) | ((block << 24L) & 0xff000000), r = ((block >> 56L) & 0x000000ff) | ((block >> 40L) & 0x0000ff00) | ((block >> 24L) & 0x00ff0000) | ((block >> 8L) & 0xff000000);

  global unsigned int* s = p + 18;

  l ^= p[hook(1, 17)];
  (r ^= p[hook(1, 16)], r ^= (((s[hook(4, ((unsigned int)(l >> 24) & 255))] + s[hook(4, 256 + ((unsigned int)(l >> 16) & 255))]) ^ s[hook(4, 512 + ((unsigned int)(l >> 8) & 255))]) + s[hook(4, 768 + ((unsigned int)(l) & 255))]));
  (l ^= p[hook(1, 15)], l ^= (((s[hook(4, ((unsigned int)(r >> 24) & 255))] + s[hook(4, 256 + ((unsigned int)(r >> 16) & 255))]) ^ s[hook(4, 512 + ((unsigned int)(r >> 8) & 255))]) + s[hook(4, 768 + ((unsigned int)(r) & 255))]));
  (r ^= p[hook(1, 14)], r ^= (((s[hook(4, ((unsigned int)(l >> 24) & 255))] + s[hook(4, 256 + ((unsigned int)(l >> 16) & 255))]) ^ s[hook(4, 512 + ((unsigned int)(l >> 8) & 255))]) + s[hook(4, 768 + ((unsigned int)(l) & 255))]));
  (l ^= p[hook(1, 13)], l ^= (((s[hook(4, ((unsigned int)(r >> 24) & 255))] + s[hook(4, 256 + ((unsigned int)(r >> 16) & 255))]) ^ s[hook(4, 512 + ((unsigned int)(r >> 8) & 255))]) + s[hook(4, 768 + ((unsigned int)(r) & 255))]));
  (r ^= p[hook(1, 12)], r ^= (((s[hook(4, ((unsigned int)(l >> 24) & 255))] + s[hook(4, 256 + ((unsigned int)(l >> 16) & 255))]) ^ s[hook(4, 512 + ((unsigned int)(l >> 8) & 255))]) + s[hook(4, 768 + ((unsigned int)(l) & 255))]));
  (l ^= p[hook(1, 11)], l ^= (((s[hook(4, ((unsigned int)(r >> 24) & 255))] + s[hook(4, 256 + ((unsigned int)(r >> 16) & 255))]) ^ s[hook(4, 512 + ((unsigned int)(r >> 8) & 255))]) + s[hook(4, 768 + ((unsigned int)(r) & 255))]));
  (r ^= p[hook(1, 10)], r ^= (((s[hook(4, ((unsigned int)(l >> 24) & 255))] + s[hook(4, 256 + ((unsigned int)(l >> 16) & 255))]) ^ s[hook(4, 512 + ((unsigned int)(l >> 8) & 255))]) + s[hook(4, 768 + ((unsigned int)(l) & 255))]));
  (l ^= p[hook(1, 9)], l ^= (((s[hook(4, ((unsigned int)(r >> 24) & 255))] + s[hook(4, 256 + ((unsigned int)(r >> 16) & 255))]) ^ s[hook(4, 512 + ((unsigned int)(r >> 8) & 255))]) + s[hook(4, 768 + ((unsigned int)(r) & 255))]));
  (r ^= p[hook(1, 8)], r ^= (((s[hook(4, ((unsigned int)(l >> 24) & 255))] + s[hook(4, 256 + ((unsigned int)(l >> 16) & 255))]) ^ s[hook(4, 512 + ((unsigned int)(l >> 8) & 255))]) + s[hook(4, 768 + ((unsigned int)(l) & 255))]));
  (l ^= p[hook(1, 7)], l ^= (((s[hook(4, ((unsigned int)(r >> 24) & 255))] + s[hook(4, 256 + ((unsigned int)(r >> 16) & 255))]) ^ s[hook(4, 512 + ((unsigned int)(r >> 8) & 255))]) + s[hook(4, 768 + ((unsigned int)(r) & 255))]));
  (r ^= p[hook(1, 6)], r ^= (((s[hook(4, ((unsigned int)(l >> 24) & 255))] + s[hook(4, 256 + ((unsigned int)(l >> 16) & 255))]) ^ s[hook(4, 512 + ((unsigned int)(l >> 8) & 255))]) + s[hook(4, 768 + ((unsigned int)(l) & 255))]));
  (l ^= p[hook(1, 5)], l ^= (((s[hook(4, ((unsigned int)(r >> 24) & 255))] + s[hook(4, 256 + ((unsigned int)(r >> 16) & 255))]) ^ s[hook(4, 512 + ((unsigned int)(r >> 8) & 255))]) + s[hook(4, 768 + ((unsigned int)(r) & 255))]));
  (r ^= p[hook(1, 4)], r ^= (((s[hook(4, ((unsigned int)(l >> 24) & 255))] + s[hook(4, 256 + ((unsigned int)(l >> 16) & 255))]) ^ s[hook(4, 512 + ((unsigned int)(l >> 8) & 255))]) + s[hook(4, 768 + ((unsigned int)(l) & 255))]));
  (l ^= p[hook(1, 3)], l ^= (((s[hook(4, ((unsigned int)(r >> 24) & 255))] + s[hook(4, 256 + ((unsigned int)(r >> 16) & 255))]) ^ s[hook(4, 512 + ((unsigned int)(r >> 8) & 255))]) + s[hook(4, 768 + ((unsigned int)(r) & 255))]));
  (r ^= p[hook(1, 2)], r ^= (((s[hook(4, ((unsigned int)(l >> 24) & 255))] + s[hook(4, 256 + ((unsigned int)(l >> 16) & 255))]) ^ s[hook(4, 512 + ((unsigned int)(l >> 8) & 255))]) + s[hook(4, 768 + ((unsigned int)(l) & 255))]));
  (l ^= p[hook(1, 1)], l ^= (((s[hook(4, ((unsigned int)(r >> 24) & 255))] + s[hook(4, 256 + ((unsigned int)(r >> 16) & 255))]) ^ s[hook(4, 512 + ((unsigned int)(r >> 8) & 255))]) + s[hook(4, 768 + ((unsigned int)(r) & 255))]));
  r ^= p[hook(1, 0)];

  block = ((unsigned long)r) << 32 | l;
  (block = block << 56 | ((block & 0x000000000000FF00) << 40) | ((block & 0x0000000000FF0000) << 24) | ((block & 0x00000000FF000000) << 8) | ((block & 0x000000FF00000000) >> 8) | ((block & 0x0000FF0000000000) >> 24) | ((block & 0x00FF000000000000) >> 40) | block >> 56);

  if (get_global_id(0) == 0)
    block ^= *d_iv;
  else
    block ^= data[hook(0, get_global_id(0) - 1)];

  out[hook(3, get_global_id(0))] = block;
}
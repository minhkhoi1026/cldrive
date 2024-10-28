//{"_key":0,"_plaintext":1,"ciphertext":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
typedef unsigned int uint32_t;
kernel void serpent_encrypt(global unsigned char* _key, global unsigned char* _plaintext, global unsigned char* ciphertext) {
  ciphertext[hook(2, 0)] = _plaintext[hook(1, 0)];
  ciphertext[hook(2, 1)] = _plaintext[hook(1, 1)];
  ciphertext[hook(2, 2)] = _plaintext[hook(1, 2)];
  ciphertext[hook(2, 3)] = _plaintext[hook(1, 3)];
  ciphertext[hook(2, 4)] = _plaintext[hook(1, 4)];
  ciphertext[hook(2, 5)] = _plaintext[hook(1, 5)];
  ciphertext[hook(2, 6)] = _plaintext[hook(1, 6)];
  ciphertext[hook(2, 7)] = _plaintext[hook(1, 7)];
  ciphertext[hook(2, 8)] = _plaintext[hook(1, 8)];
  ciphertext[hook(2, 9)] = _plaintext[hook(1, 9)];
  ciphertext[hook(2, 10)] = _plaintext[hook(1, 10)];
  ciphertext[hook(2, 11)] = _plaintext[hook(1, 11)];
  ciphertext[hook(2, 12)] = _plaintext[hook(1, 12)];
  ciphertext[hook(2, 13)] = _plaintext[hook(1, 13)];
  ciphertext[hook(2, 14)] = _plaintext[hook(1, 14)];
  ciphertext[hook(2, 15)] = _plaintext[hook(1, 15)];
}
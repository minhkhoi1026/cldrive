//{"ciphertext":2,"key":1,"plaintext":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void decrypt(global int* plaintext, global int* key, global int* ciphertext) {
  unsigned int i = get_global_id(0);
  if (plaintext[hook(0, i)] > 31) {
    ciphertext[hook(2, i)] = plaintext[hook(0, i)] - key[hook(1, i)] + 32;
    if (ciphertext[hook(2, i)] < 32) {
      ciphertext[hook(2, i)] += 95;
    }
  } else {
    ciphertext[hook(2, i)] = plaintext[hook(0, i)];
  }
}
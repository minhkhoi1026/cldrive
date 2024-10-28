//{"B":8,"V":12,"W":5,"X":11,"fixedW":6,"input":0,"lookup":10,"output":1,"pad0":3,"pad1":4,"padcache":2,"tmp":7,"w":9}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
uint4 EndianSwap4(uint4 n) {
  return rotate(n & 0x00FF00FF, 24U) | rotate(n & 0xFF00FF00, 8U);
}
void SHA256(uint4* restrict state0, uint4* restrict state1, const uint4 block0, const uint4 block1, const uint4 block2, const uint4 block3) {
  uint4 S0 = *state0;
  uint4 S1 = *state1;
  uint4 W[4];

  W[hook(5, 0)].x = block0.x;
  S1.w += (rotate(S1.x, 26U) ^ rotate(S1.x, 21U) ^ rotate(S1.x, 7U)) + bitselect(S1.z, S1.y, S1.x) + W[hook(5, 0)].x + 0x428a2f98U;
  S0.w += S1.w;
  S1.w += (rotate(S0.x, 30U) ^ rotate(S0.x, 19U) ^ rotate(S0.x, 10U)) + bitselect(S0.z, S0.y, (S0.x ^ S0.z));
  ;
  W[hook(5, 0)].y = block0.y;
  S1.z += (rotate(S0.w, 26U) ^ rotate(S0.w, 21U) ^ rotate(S0.w, 7U)) + bitselect(S1.y, S1.x, S0.w) + W[hook(5, 0)].y + 0x71374491U;
  S0.z += S1.z;
  S1.z += (rotate(S1.w, 30U) ^ rotate(S1.w, 19U) ^ rotate(S1.w, 10U)) + bitselect(S0.y, S0.x, (S1.w ^ S0.y));
  ;
  W[hook(5, 0)].z = block0.z;
  S1.y += (rotate(S0.z, 26U) ^ rotate(S0.z, 21U) ^ rotate(S0.z, 7U)) + bitselect(S1.x, S0.w, S0.z) + W[hook(5, 0)].z + 0xb5c0fbcfU;
  S0.y += S1.y;
  S1.y += (rotate(S1.z, 30U) ^ rotate(S1.z, 19U) ^ rotate(S1.z, 10U)) + bitselect(S0.x, S1.w, (S1.z ^ S0.x));
  ;
  W[hook(5, 0)].w = block0.w;
  S1.x += (rotate(S0.y, 26U) ^ rotate(S0.y, 21U) ^ rotate(S0.y, 7U)) + bitselect(S0.w, S0.z, S0.y) + W[hook(5, 0)].w + 0xe9b5dba5U;
  S0.x += S1.x;
  S1.x += (rotate(S1.y, 30U) ^ rotate(S1.y, 19U) ^ rotate(S1.y, 10U)) + bitselect(S1.w, S1.z, (S1.y ^ S1.w));
  ;

  W[hook(5, 1)].x = block1.x;
  S0.w += (rotate(S0.x, 26U) ^ rotate(S0.x, 21U) ^ rotate(S0.x, 7U)) + bitselect(S0.z, S0.y, S0.x) + W[hook(5, 1)].x + 0x3956c25bU;
  S1.w += S0.w;
  S0.w += (rotate(S1.x, 30U) ^ rotate(S1.x, 19U) ^ rotate(S1.x, 10U)) + bitselect(S1.z, S1.y, (S1.x ^ S1.z));
  ;
  W[hook(5, 1)].y = block1.y;
  S0.z += (rotate(S1.w, 26U) ^ rotate(S1.w, 21U) ^ rotate(S1.w, 7U)) + bitselect(S0.y, S0.x, S1.w) + W[hook(5, 1)].y + 0x59f111f1U;
  S1.z += S0.z;
  S0.z += (rotate(S0.w, 30U) ^ rotate(S0.w, 19U) ^ rotate(S0.w, 10U)) + bitselect(S1.y, S1.x, (S0.w ^ S1.y));
  ;
  W[hook(5, 1)].z = block1.z;
  S0.y += (rotate(S1.z, 26U) ^ rotate(S1.z, 21U) ^ rotate(S1.z, 7U)) + bitselect(S0.x, S1.w, S1.z) + W[hook(5, 1)].z + 0x923f82a4U;
  S1.y += S0.y;
  S0.y += (rotate(S0.z, 30U) ^ rotate(S0.z, 19U) ^ rotate(S0.z, 10U)) + bitselect(S1.x, S0.w, (S0.z ^ S1.x));
  ;
  W[hook(5, 1)].w = block1.w;
  S0.x += (rotate(S1.y, 26U) ^ rotate(S1.y, 21U) ^ rotate(S1.y, 7U)) + bitselect(S1.w, S1.z, S1.y) + W[hook(5, 1)].w + 0xab1c5ed5U;
  S1.x += S0.x;
  S0.x += (rotate(S0.y, 30U) ^ rotate(S0.y, 19U) ^ rotate(S0.y, 10U)) + bitselect(S0.w, S0.z, (S0.y ^ S0.w));
  ;

  W[hook(5, 2)].x = block2.x;
  S1.w += (rotate(S1.x, 26U) ^ rotate(S1.x, 21U) ^ rotate(S1.x, 7U)) + bitselect(S1.z, S1.y, S1.x) + W[hook(5, 2)].x + 0xd807aa98U;
  S0.w += S1.w;
  S1.w += (rotate(S0.x, 30U) ^ rotate(S0.x, 19U) ^ rotate(S0.x, 10U)) + bitselect(S0.z, S0.y, (S0.x ^ S0.z));
  ;
  W[hook(5, 2)].y = block2.y;
  S1.z += (rotate(S0.w, 26U) ^ rotate(S0.w, 21U) ^ rotate(S0.w, 7U)) + bitselect(S1.y, S1.x, S0.w) + W[hook(5, 2)].y + 0x12835b01U;
  S0.z += S1.z;
  S1.z += (rotate(S1.w, 30U) ^ rotate(S1.w, 19U) ^ rotate(S1.w, 10U)) + bitselect(S0.y, S0.x, (S1.w ^ S0.y));
  ;
  W[hook(5, 2)].z = block2.z;
  S1.y += (rotate(S0.z, 26U) ^ rotate(S0.z, 21U) ^ rotate(S0.z, 7U)) + bitselect(S1.x, S0.w, S0.z) + W[hook(5, 2)].z + 0x243185beU;
  S0.y += S1.y;
  S1.y += (rotate(S1.z, 30U) ^ rotate(S1.z, 19U) ^ rotate(S1.z, 10U)) + bitselect(S0.x, S1.w, (S1.z ^ S0.x));
  ;
  W[hook(5, 2)].w = block2.w;
  S1.x += (rotate(S0.y, 26U) ^ rotate(S0.y, 21U) ^ rotate(S0.y, 7U)) + bitselect(S0.w, S0.z, S0.y) + W[hook(5, 2)].w + 0x550c7dc3U;
  S0.x += S1.x;
  S1.x += (rotate(S1.y, 30U) ^ rotate(S1.y, 19U) ^ rotate(S1.y, 10U)) + bitselect(S1.w, S1.z, (S1.y ^ S1.w));
  ;

  W[hook(5, 3)].x = block3.x;
  S0.w += (rotate(S0.x, 26U) ^ rotate(S0.x, 21U) ^ rotate(S0.x, 7U)) + bitselect(S0.z, S0.y, S0.x) + W[hook(5, 3)].x + 0x72be5d74U;
  S1.w += S0.w;
  S0.w += (rotate(S1.x, 30U) ^ rotate(S1.x, 19U) ^ rotate(S1.x, 10U)) + bitselect(S1.z, S1.y, (S1.x ^ S1.z));
  ;
  W[hook(5, 3)].y = block3.y;
  S0.z += (rotate(S1.w, 26U) ^ rotate(S1.w, 21U) ^ rotate(S1.w, 7U)) + bitselect(S0.y, S0.x, S1.w) + W[hook(5, 3)].y + 0x80deb1feU;
  S1.z += S0.z;
  S0.z += (rotate(S0.w, 30U) ^ rotate(S0.w, 19U) ^ rotate(S0.w, 10U)) + bitselect(S1.y, S1.x, (S0.w ^ S1.y));
  ;
  W[hook(5, 3)].z = block3.z;
  S0.y += (rotate(S1.z, 26U) ^ rotate(S1.z, 21U) ^ rotate(S1.z, 7U)) + bitselect(S0.x, S1.w, S1.z) + W[hook(5, 3)].z + 0x9bdc06a7U;
  S1.y += S0.y;
  S0.y += (rotate(S0.z, 30U) ^ rotate(S0.z, 19U) ^ rotate(S0.z, 10U)) + bitselect(S1.x, S0.w, (S0.z ^ S1.x));
  ;
  W[hook(5, 3)].w = block3.w;
  S0.x += (rotate(S1.y, 26U) ^ rotate(S1.y, 21U) ^ rotate(S1.y, 7U)) + bitselect(S1.w, S1.z, S1.y) + W[hook(5, 3)].w + 0xc19bf174U;
  S1.x += S0.x;
  S0.x += (rotate(S0.y, 30U) ^ rotate(S0.y, 19U) ^ rotate(S0.y, 10U)) + bitselect(S0.w, S0.z, (S0.y ^ S0.w));
  ;

  W[hook(5, 0)].x += (rotate(W[hook(5, 3)].z, 15U) ^ rotate(W[hook(5, 3)].z, 13U) ^ (W[hook(5, 3)].z >> 10U)) + W[hook(5, 2)].y + (rotate(W[hook(5, 0)].y, 25U) ^ rotate(W[hook(5, 0)].y, 14U) ^ (W[hook(5, 0)].y >> 3U));
  S1.w += (rotate(S1.x, 26U) ^ rotate(S1.x, 21U) ^ rotate(S1.x, 7U)) + bitselect(S1.z, S1.y, S1.x) + W[hook(5, 0)].x + 0xe49b69c1U;
  S0.w += S1.w;
  S1.w += (rotate(S0.x, 30U) ^ rotate(S0.x, 19U) ^ rotate(S0.x, 10U)) + bitselect(S0.z, S0.y, (S0.x ^ S0.z));
  ;

  W[hook(5, 0)].y += (rotate(W[hook(5, 3)].w, 15U) ^ rotate(W[hook(5, 3)].w, 13U) ^ (W[hook(5, 3)].w >> 10U)) + W[hook(5, 2)].z + (rotate(W[hook(5, 0)].z, 25U) ^ rotate(W[hook(5, 0)].z, 14U) ^ (W[hook(5, 0)].z >> 3U));
  S1.z += (rotate(S0.w, 26U) ^ rotate(S0.w, 21U) ^ rotate(S0.w, 7U)) + bitselect(S1.y, S1.x, S0.w) + W[hook(5, 0)].y + 0xefbe4786U;
  S0.z += S1.z;
  S1.z += (rotate(S1.w, 30U) ^ rotate(S1.w, 19U) ^ rotate(S1.w, 10U)) + bitselect(S0.y, S0.x, (S1.w ^ S0.y));
  ;

  W[hook(5, 0)].z += (rotate(W[hook(5, 0)].x, 15U) ^ rotate(W[hook(5, 0)].x, 13U) ^ (W[hook(5, 0)].x >> 10U)) + W[hook(5, 2)].w + (rotate(W[hook(5, 0)].w, 25U) ^ rotate(W[hook(5, 0)].w, 14U) ^ (W[hook(5, 0)].w >> 3U));
  S1.y += (rotate(S0.z, 26U) ^ rotate(S0.z, 21U) ^ rotate(S0.z, 7U)) + bitselect(S1.x, S0.w, S0.z) + W[hook(5, 0)].z + 0x0fc19dc6U;
  S0.y += S1.y;
  S1.y += (rotate(S1.z, 30U) ^ rotate(S1.z, 19U) ^ rotate(S1.z, 10U)) + bitselect(S0.x, S1.w, (S1.z ^ S0.x));
  ;

  W[hook(5, 0)].w += (rotate(W[hook(5, 0)].y, 15U) ^ rotate(W[hook(5, 0)].y, 13U) ^ (W[hook(5, 0)].y >> 10U)) + W[hook(5, 3)].x + (rotate(W[hook(5, 1)].x, 25U) ^ rotate(W[hook(5, 1)].x, 14U) ^ (W[hook(5, 1)].x >> 3U));
  S1.x += (rotate(S0.y, 26U) ^ rotate(S0.y, 21U) ^ rotate(S0.y, 7U)) + bitselect(S0.w, S0.z, S0.y) + W[hook(5, 0)].w + 0x240ca1ccU;
  S0.x += S1.x;
  S1.x += (rotate(S1.y, 30U) ^ rotate(S1.y, 19U) ^ rotate(S1.y, 10U)) + bitselect(S1.w, S1.z, (S1.y ^ S1.w));
  ;

  W[hook(5, 1)].x += (rotate(W[hook(5, 0)].z, 15U) ^ rotate(W[hook(5, 0)].z, 13U) ^ (W[hook(5, 0)].z >> 10U)) + W[hook(5, 3)].y + (rotate(W[hook(5, 1)].y, 25U) ^ rotate(W[hook(5, 1)].y, 14U) ^ (W[hook(5, 1)].y >> 3U));
  S0.w += (rotate(S0.x, 26U) ^ rotate(S0.x, 21U) ^ rotate(S0.x, 7U)) + bitselect(S0.z, S0.y, S0.x) + W[hook(5, 1)].x + 0x2de92c6fU;
  S1.w += S0.w;
  S0.w += (rotate(S1.x, 30U) ^ rotate(S1.x, 19U) ^ rotate(S1.x, 10U)) + bitselect(S1.z, S1.y, (S1.x ^ S1.z));
  ;

  W[hook(5, 1)].y += (rotate(W[hook(5, 0)].w, 15U) ^ rotate(W[hook(5, 0)].w, 13U) ^ (W[hook(5, 0)].w >> 10U)) + W[hook(5, 3)].z + (rotate(W[hook(5, 1)].z, 25U) ^ rotate(W[hook(5, 1)].z, 14U) ^ (W[hook(5, 1)].z >> 3U));
  S0.z += (rotate(S1.w, 26U) ^ rotate(S1.w, 21U) ^ rotate(S1.w, 7U)) + bitselect(S0.y, S0.x, S1.w) + W[hook(5, 1)].y + 0x4a7484aaU;
  S1.z += S0.z;
  S0.z += (rotate(S0.w, 30U) ^ rotate(S0.w, 19U) ^ rotate(S0.w, 10U)) + bitselect(S1.y, S1.x, (S0.w ^ S1.y));
  ;

  W[hook(5, 1)].z += (rotate(W[hook(5, 1)].x, 15U) ^ rotate(W[hook(5, 1)].x, 13U) ^ (W[hook(5, 1)].x >> 10U)) + W[hook(5, 3)].w + (rotate(W[hook(5, 1)].w, 25U) ^ rotate(W[hook(5, 1)].w, 14U) ^ (W[hook(5, 1)].w >> 3U));
  S0.y += (rotate(S1.z, 26U) ^ rotate(S1.z, 21U) ^ rotate(S1.z, 7U)) + bitselect(S0.x, S1.w, S1.z) + W[hook(5, 1)].z + 0x5cb0a9dcU;
  S1.y += S0.y;
  S0.y += (rotate(S0.z, 30U) ^ rotate(S0.z, 19U) ^ rotate(S0.z, 10U)) + bitselect(S1.x, S0.w, (S0.z ^ S1.x));
  ;

  W[hook(5, 1)].w += (rotate(W[hook(5, 1)].y, 15U) ^ rotate(W[hook(5, 1)].y, 13U) ^ (W[hook(5, 1)].y >> 10U)) + W[hook(5, 0)].x + (rotate(W[hook(5, 2)].x, 25U) ^ rotate(W[hook(5, 2)].x, 14U) ^ (W[hook(5, 2)].x >> 3U));
  S0.x += (rotate(S1.y, 26U) ^ rotate(S1.y, 21U) ^ rotate(S1.y, 7U)) + bitselect(S1.w, S1.z, S1.y) + W[hook(5, 1)].w + 0x76f988daU;
  S1.x += S0.x;
  S0.x += (rotate(S0.y, 30U) ^ rotate(S0.y, 19U) ^ rotate(S0.y, 10U)) + bitselect(S0.w, S0.z, (S0.y ^ S0.w));
  ;

  W[hook(5, 2)].x += (rotate(W[hook(5, 1)].z, 15U) ^ rotate(W[hook(5, 1)].z, 13U) ^ (W[hook(5, 1)].z >> 10U)) + W[hook(5, 0)].y + (rotate(W[hook(5, 2)].y, 25U) ^ rotate(W[hook(5, 2)].y, 14U) ^ (W[hook(5, 2)].y >> 3U));
  S1.w += (rotate(S1.x, 26U) ^ rotate(S1.x, 21U) ^ rotate(S1.x, 7U)) + bitselect(S1.z, S1.y, S1.x) + W[hook(5, 2)].x + 0x983e5152U;
  S0.w += S1.w;
  S1.w += (rotate(S0.x, 30U) ^ rotate(S0.x, 19U) ^ rotate(S0.x, 10U)) + bitselect(S0.z, S0.y, (S0.x ^ S0.z));
  ;

  W[hook(5, 2)].y += (rotate(W[hook(5, 1)].w, 15U) ^ rotate(W[hook(5, 1)].w, 13U) ^ (W[hook(5, 1)].w >> 10U)) + W[hook(5, 0)].z + (rotate(W[hook(5, 2)].z, 25U) ^ rotate(W[hook(5, 2)].z, 14U) ^ (W[hook(5, 2)].z >> 3U));
  S1.z += (rotate(S0.w, 26U) ^ rotate(S0.w, 21U) ^ rotate(S0.w, 7U)) + bitselect(S1.y, S1.x, S0.w) + W[hook(5, 2)].y + 0xa831c66dU;
  S0.z += S1.z;
  S1.z += (rotate(S1.w, 30U) ^ rotate(S1.w, 19U) ^ rotate(S1.w, 10U)) + bitselect(S0.y, S0.x, (S1.w ^ S0.y));
  ;

  W[hook(5, 2)].z += (rotate(W[hook(5, 2)].x, 15U) ^ rotate(W[hook(5, 2)].x, 13U) ^ (W[hook(5, 2)].x >> 10U)) + W[hook(5, 0)].w + (rotate(W[hook(5, 2)].w, 25U) ^ rotate(W[hook(5, 2)].w, 14U) ^ (W[hook(5, 2)].w >> 3U));
  S1.y += (rotate(S0.z, 26U) ^ rotate(S0.z, 21U) ^ rotate(S0.z, 7U)) + bitselect(S1.x, S0.w, S0.z) + W[hook(5, 2)].z + 0xb00327c8U;
  S0.y += S1.y;
  S1.y += (rotate(S1.z, 30U) ^ rotate(S1.z, 19U) ^ rotate(S1.z, 10U)) + bitselect(S0.x, S1.w, (S1.z ^ S0.x));
  ;

  W[hook(5, 2)].w += (rotate(W[hook(5, 2)].y, 15U) ^ rotate(W[hook(5, 2)].y, 13U) ^ (W[hook(5, 2)].y >> 10U)) + W[hook(5, 1)].x + (rotate(W[hook(5, 3)].x, 25U) ^ rotate(W[hook(5, 3)].x, 14U) ^ (W[hook(5, 3)].x >> 3U));
  S1.x += (rotate(S0.y, 26U) ^ rotate(S0.y, 21U) ^ rotate(S0.y, 7U)) + bitselect(S0.w, S0.z, S0.y) + W[hook(5, 2)].w + 0xbf597fc7U;
  S0.x += S1.x;
  S1.x += (rotate(S1.y, 30U) ^ rotate(S1.y, 19U) ^ rotate(S1.y, 10U)) + bitselect(S1.w, S1.z, (S1.y ^ S1.w));
  ;

  W[hook(5, 3)].x += (rotate(W[hook(5, 2)].z, 15U) ^ rotate(W[hook(5, 2)].z, 13U) ^ (W[hook(5, 2)].z >> 10U)) + W[hook(5, 1)].y + (rotate(W[hook(5, 3)].y, 25U) ^ rotate(W[hook(5, 3)].y, 14U) ^ (W[hook(5, 3)].y >> 3U));
  S0.w += (rotate(S0.x, 26U) ^ rotate(S0.x, 21U) ^ rotate(S0.x, 7U)) + bitselect(S0.z, S0.y, S0.x) + W[hook(5, 3)].x + 0xc6e00bf3U;
  S1.w += S0.w;
  S0.w += (rotate(S1.x, 30U) ^ rotate(S1.x, 19U) ^ rotate(S1.x, 10U)) + bitselect(S1.z, S1.y, (S1.x ^ S1.z));
  ;

  W[hook(5, 3)].y += (rotate(W[hook(5, 2)].w, 15U) ^ rotate(W[hook(5, 2)].w, 13U) ^ (W[hook(5, 2)].w >> 10U)) + W[hook(5, 1)].z + (rotate(W[hook(5, 3)].z, 25U) ^ rotate(W[hook(5, 3)].z, 14U) ^ (W[hook(5, 3)].z >> 3U));
  S0.z += (rotate(S1.w, 26U) ^ rotate(S1.w, 21U) ^ rotate(S1.w, 7U)) + bitselect(S0.y, S0.x, S1.w) + W[hook(5, 3)].y + 0xd5a79147U;
  S1.z += S0.z;
  S0.z += (rotate(S0.w, 30U) ^ rotate(S0.w, 19U) ^ rotate(S0.w, 10U)) + bitselect(S1.y, S1.x, (S0.w ^ S1.y));
  ;

  W[hook(5, 3)].z += (rotate(W[hook(5, 3)].x, 15U) ^ rotate(W[hook(5, 3)].x, 13U) ^ (W[hook(5, 3)].x >> 10U)) + W[hook(5, 1)].w + (rotate(W[hook(5, 3)].w, 25U) ^ rotate(W[hook(5, 3)].w, 14U) ^ (W[hook(5, 3)].w >> 3U));
  S0.y += (rotate(S1.z, 26U) ^ rotate(S1.z, 21U) ^ rotate(S1.z, 7U)) + bitselect(S0.x, S1.w, S1.z) + W[hook(5, 3)].z + 0x06ca6351U;
  S1.y += S0.y;
  S0.y += (rotate(S0.z, 30U) ^ rotate(S0.z, 19U) ^ rotate(S0.z, 10U)) + bitselect(S1.x, S0.w, (S0.z ^ S1.x));
  ;

  W[hook(5, 3)].w += (rotate(W[hook(5, 3)].y, 15U) ^ rotate(W[hook(5, 3)].y, 13U) ^ (W[hook(5, 3)].y >> 10U)) + W[hook(5, 2)].x + (rotate(W[hook(5, 0)].x, 25U) ^ rotate(W[hook(5, 0)].x, 14U) ^ (W[hook(5, 0)].x >> 3U));
  S0.x += (rotate(S1.y, 26U) ^ rotate(S1.y, 21U) ^ rotate(S1.y, 7U)) + bitselect(S1.w, S1.z, S1.y) + W[hook(5, 3)].w + 0x14292967U;
  S1.x += S0.x;
  S0.x += (rotate(S0.y, 30U) ^ rotate(S0.y, 19U) ^ rotate(S0.y, 10U)) + bitselect(S0.w, S0.z, (S0.y ^ S0.w));
  ;

  W[hook(5, 0)].x += (rotate(W[hook(5, 3)].z, 15U) ^ rotate(W[hook(5, 3)].z, 13U) ^ (W[hook(5, 3)].z >> 10U)) + W[hook(5, 2)].y + (rotate(W[hook(5, 0)].y, 25U) ^ rotate(W[hook(5, 0)].y, 14U) ^ (W[hook(5, 0)].y >> 3U));
  S1.w += (rotate(S1.x, 26U) ^ rotate(S1.x, 21U) ^ rotate(S1.x, 7U)) + bitselect(S1.z, S1.y, S1.x) + W[hook(5, 0)].x + 0x27b70a85U;
  S0.w += S1.w;
  S1.w += (rotate(S0.x, 30U) ^ rotate(S0.x, 19U) ^ rotate(S0.x, 10U)) + bitselect(S0.z, S0.y, (S0.x ^ S0.z));
  ;

  W[hook(5, 0)].y += (rotate(W[hook(5, 3)].w, 15U) ^ rotate(W[hook(5, 3)].w, 13U) ^ (W[hook(5, 3)].w >> 10U)) + W[hook(5, 2)].z + (rotate(W[hook(5, 0)].z, 25U) ^ rotate(W[hook(5, 0)].z, 14U) ^ (W[hook(5, 0)].z >> 3U));
  S1.z += (rotate(S0.w, 26U) ^ rotate(S0.w, 21U) ^ rotate(S0.w, 7U)) + bitselect(S1.y, S1.x, S0.w) + W[hook(5, 0)].y + 0x2e1b2138U;
  S0.z += S1.z;
  S1.z += (rotate(S1.w, 30U) ^ rotate(S1.w, 19U) ^ rotate(S1.w, 10U)) + bitselect(S0.y, S0.x, (S1.w ^ S0.y));
  ;

  W[hook(5, 0)].z += (rotate(W[hook(5, 0)].x, 15U) ^ rotate(W[hook(5, 0)].x, 13U) ^ (W[hook(5, 0)].x >> 10U)) + W[hook(5, 2)].w + (rotate(W[hook(5, 0)].w, 25U) ^ rotate(W[hook(5, 0)].w, 14U) ^ (W[hook(5, 0)].w >> 3U));
  S1.y += (rotate(S0.z, 26U) ^ rotate(S0.z, 21U) ^ rotate(S0.z, 7U)) + bitselect(S1.x, S0.w, S0.z) + W[hook(5, 0)].z + 0x4d2c6dfcU;
  S0.y += S1.y;
  S1.y += (rotate(S1.z, 30U) ^ rotate(S1.z, 19U) ^ rotate(S1.z, 10U)) + bitselect(S0.x, S1.w, (S1.z ^ S0.x));
  ;

  W[hook(5, 0)].w += (rotate(W[hook(5, 0)].y, 15U) ^ rotate(W[hook(5, 0)].y, 13U) ^ (W[hook(5, 0)].y >> 10U)) + W[hook(5, 3)].x + (rotate(W[hook(5, 1)].x, 25U) ^ rotate(W[hook(5, 1)].x, 14U) ^ (W[hook(5, 1)].x >> 3U));
  S1.x += (rotate(S0.y, 26U) ^ rotate(S0.y, 21U) ^ rotate(S0.y, 7U)) + bitselect(S0.w, S0.z, S0.y) + W[hook(5, 0)].w + 0x53380d13U;
  S0.x += S1.x;
  S1.x += (rotate(S1.y, 30U) ^ rotate(S1.y, 19U) ^ rotate(S1.y, 10U)) + bitselect(S1.w, S1.z, (S1.y ^ S1.w));
  ;

  W[hook(5, 1)].x += (rotate(W[hook(5, 0)].z, 15U) ^ rotate(W[hook(5, 0)].z, 13U) ^ (W[hook(5, 0)].z >> 10U)) + W[hook(5, 3)].y + (rotate(W[hook(5, 1)].y, 25U) ^ rotate(W[hook(5, 1)].y, 14U) ^ (W[hook(5, 1)].y >> 3U));
  S0.w += (rotate(S0.x, 26U) ^ rotate(S0.x, 21U) ^ rotate(S0.x, 7U)) + bitselect(S0.z, S0.y, S0.x) + W[hook(5, 1)].x + 0x650a7354U;
  S1.w += S0.w;
  S0.w += (rotate(S1.x, 30U) ^ rotate(S1.x, 19U) ^ rotate(S1.x, 10U)) + bitselect(S1.z, S1.y, (S1.x ^ S1.z));
  ;

  W[hook(5, 1)].y += (rotate(W[hook(5, 0)].w, 15U) ^ rotate(W[hook(5, 0)].w, 13U) ^ (W[hook(5, 0)].w >> 10U)) + W[hook(5, 3)].z + (rotate(W[hook(5, 1)].z, 25U) ^ rotate(W[hook(5, 1)].z, 14U) ^ (W[hook(5, 1)].z >> 3U));
  S0.z += (rotate(S1.w, 26U) ^ rotate(S1.w, 21U) ^ rotate(S1.w, 7U)) + bitselect(S0.y, S0.x, S1.w) + W[hook(5, 1)].y + 0x766a0abbU;
  S1.z += S0.z;
  S0.z += (rotate(S0.w, 30U) ^ rotate(S0.w, 19U) ^ rotate(S0.w, 10U)) + bitselect(S1.y, S1.x, (S0.w ^ S1.y));
  ;

  W[hook(5, 1)].z += (rotate(W[hook(5, 1)].x, 15U) ^ rotate(W[hook(5, 1)].x, 13U) ^ (W[hook(5, 1)].x >> 10U)) + W[hook(5, 3)].w + (rotate(W[hook(5, 1)].w, 25U) ^ rotate(W[hook(5, 1)].w, 14U) ^ (W[hook(5, 1)].w >> 3U));
  S0.y += (rotate(S1.z, 26U) ^ rotate(S1.z, 21U) ^ rotate(S1.z, 7U)) + bitselect(S0.x, S1.w, S1.z) + W[hook(5, 1)].z + 0x81c2c92eU;
  S1.y += S0.y;
  S0.y += (rotate(S0.z, 30U) ^ rotate(S0.z, 19U) ^ rotate(S0.z, 10U)) + bitselect(S1.x, S0.w, (S0.z ^ S1.x));
  ;

  W[hook(5, 1)].w += (rotate(W[hook(5, 1)].y, 15U) ^ rotate(W[hook(5, 1)].y, 13U) ^ (W[hook(5, 1)].y >> 10U)) + W[hook(5, 0)].x + (rotate(W[hook(5, 2)].x, 25U) ^ rotate(W[hook(5, 2)].x, 14U) ^ (W[hook(5, 2)].x >> 3U));
  S0.x += (rotate(S1.y, 26U) ^ rotate(S1.y, 21U) ^ rotate(S1.y, 7U)) + bitselect(S1.w, S1.z, S1.y) + W[hook(5, 1)].w + 0x92722c85U;
  S1.x += S0.x;
  S0.x += (rotate(S0.y, 30U) ^ rotate(S0.y, 19U) ^ rotate(S0.y, 10U)) + bitselect(S0.w, S0.z, (S0.y ^ S0.w));
  ;

  W[hook(5, 2)].x += (rotate(W[hook(5, 1)].z, 15U) ^ rotate(W[hook(5, 1)].z, 13U) ^ (W[hook(5, 1)].z >> 10U)) + W[hook(5, 0)].y + (rotate(W[hook(5, 2)].y, 25U) ^ rotate(W[hook(5, 2)].y, 14U) ^ (W[hook(5, 2)].y >> 3U));
  S1.w += (rotate(S1.x, 26U) ^ rotate(S1.x, 21U) ^ rotate(S1.x, 7U)) + bitselect(S1.z, S1.y, S1.x) + W[hook(5, 2)].x + 0xa2bfe8a1U;
  S0.w += S1.w;
  S1.w += (rotate(S0.x, 30U) ^ rotate(S0.x, 19U) ^ rotate(S0.x, 10U)) + bitselect(S0.z, S0.y, (S0.x ^ S0.z));
  ;

  W[hook(5, 2)].y += (rotate(W[hook(5, 1)].w, 15U) ^ rotate(W[hook(5, 1)].w, 13U) ^ (W[hook(5, 1)].w >> 10U)) + W[hook(5, 0)].z + (rotate(W[hook(5, 2)].z, 25U) ^ rotate(W[hook(5, 2)].z, 14U) ^ (W[hook(5, 2)].z >> 3U));
  S1.z += (rotate(S0.w, 26U) ^ rotate(S0.w, 21U) ^ rotate(S0.w, 7U)) + bitselect(S1.y, S1.x, S0.w) + W[hook(5, 2)].y + 0xa81a664bU;
  S0.z += S1.z;
  S1.z += (rotate(S1.w, 30U) ^ rotate(S1.w, 19U) ^ rotate(S1.w, 10U)) + bitselect(S0.y, S0.x, (S1.w ^ S0.y));
  ;

  W[hook(5, 2)].z += (rotate(W[hook(5, 2)].x, 15U) ^ rotate(W[hook(5, 2)].x, 13U) ^ (W[hook(5, 2)].x >> 10U)) + W[hook(5, 0)].w + (rotate(W[hook(5, 2)].w, 25U) ^ rotate(W[hook(5, 2)].w, 14U) ^ (W[hook(5, 2)].w >> 3U));
  S1.y += (rotate(S0.z, 26U) ^ rotate(S0.z, 21U) ^ rotate(S0.z, 7U)) + bitselect(S1.x, S0.w, S0.z) + W[hook(5, 2)].z + 0xc24b8b70U;
  S0.y += S1.y;
  S1.y += (rotate(S1.z, 30U) ^ rotate(S1.z, 19U) ^ rotate(S1.z, 10U)) + bitselect(S0.x, S1.w, (S1.z ^ S0.x));
  ;

  W[hook(5, 2)].w += (rotate(W[hook(5, 2)].y, 15U) ^ rotate(W[hook(5, 2)].y, 13U) ^ (W[hook(5, 2)].y >> 10U)) + W[hook(5, 1)].x + (rotate(W[hook(5, 3)].x, 25U) ^ rotate(W[hook(5, 3)].x, 14U) ^ (W[hook(5, 3)].x >> 3U));
  S1.x += (rotate(S0.y, 26U) ^ rotate(S0.y, 21U) ^ rotate(S0.y, 7U)) + bitselect(S0.w, S0.z, S0.y) + W[hook(5, 2)].w + 0xc76c51a3U;
  S0.x += S1.x;
  S1.x += (rotate(S1.y, 30U) ^ rotate(S1.y, 19U) ^ rotate(S1.y, 10U)) + bitselect(S1.w, S1.z, (S1.y ^ S1.w));
  ;

  W[hook(5, 3)].x += (rotate(W[hook(5, 2)].z, 15U) ^ rotate(W[hook(5, 2)].z, 13U) ^ (W[hook(5, 2)].z >> 10U)) + W[hook(5, 1)].y + (rotate(W[hook(5, 3)].y, 25U) ^ rotate(W[hook(5, 3)].y, 14U) ^ (W[hook(5, 3)].y >> 3U));
  S0.w += (rotate(S0.x, 26U) ^ rotate(S0.x, 21U) ^ rotate(S0.x, 7U)) + bitselect(S0.z, S0.y, S0.x) + W[hook(5, 3)].x + 0xd192e819U;
  S1.w += S0.w;
  S0.w += (rotate(S1.x, 30U) ^ rotate(S1.x, 19U) ^ rotate(S1.x, 10U)) + bitselect(S1.z, S1.y, (S1.x ^ S1.z));
  ;

  W[hook(5, 3)].y += (rotate(W[hook(5, 2)].w, 15U) ^ rotate(W[hook(5, 2)].w, 13U) ^ (W[hook(5, 2)].w >> 10U)) + W[hook(5, 1)].z + (rotate(W[hook(5, 3)].z, 25U) ^ rotate(W[hook(5, 3)].z, 14U) ^ (W[hook(5, 3)].z >> 3U));
  S0.z += (rotate(S1.w, 26U) ^ rotate(S1.w, 21U) ^ rotate(S1.w, 7U)) + bitselect(S0.y, S0.x, S1.w) + W[hook(5, 3)].y + 0xd6990624U;
  S1.z += S0.z;
  S0.z += (rotate(S0.w, 30U) ^ rotate(S0.w, 19U) ^ rotate(S0.w, 10U)) + bitselect(S1.y, S1.x, (S0.w ^ S1.y));
  ;

  W[hook(5, 3)].z += (rotate(W[hook(5, 3)].x, 15U) ^ rotate(W[hook(5, 3)].x, 13U) ^ (W[hook(5, 3)].x >> 10U)) + W[hook(5, 1)].w + (rotate(W[hook(5, 3)].w, 25U) ^ rotate(W[hook(5, 3)].w, 14U) ^ (W[hook(5, 3)].w >> 3U));
  S0.y += (rotate(S1.z, 26U) ^ rotate(S1.z, 21U) ^ rotate(S1.z, 7U)) + bitselect(S0.x, S1.w, S1.z) + W[hook(5, 3)].z + 0xf40e3585U;
  S1.y += S0.y;
  S0.y += (rotate(S0.z, 30U) ^ rotate(S0.z, 19U) ^ rotate(S0.z, 10U)) + bitselect(S1.x, S0.w, (S0.z ^ S1.x));
  ;

  W[hook(5, 3)].w += (rotate(W[hook(5, 3)].y, 15U) ^ rotate(W[hook(5, 3)].y, 13U) ^ (W[hook(5, 3)].y >> 10U)) + W[hook(5, 2)].x + (rotate(W[hook(5, 0)].x, 25U) ^ rotate(W[hook(5, 0)].x, 14U) ^ (W[hook(5, 0)].x >> 3U));
  S0.x += (rotate(S1.y, 26U) ^ rotate(S1.y, 21U) ^ rotate(S1.y, 7U)) + bitselect(S1.w, S1.z, S1.y) + W[hook(5, 3)].w + 0x106aa070U;
  S1.x += S0.x;
  S0.x += (rotate(S0.y, 30U) ^ rotate(S0.y, 19U) ^ rotate(S0.y, 10U)) + bitselect(S0.w, S0.z, (S0.y ^ S0.w));
  ;

  W[hook(5, 0)].x += (rotate(W[hook(5, 3)].z, 15U) ^ rotate(W[hook(5, 3)].z, 13U) ^ (W[hook(5, 3)].z >> 10U)) + W[hook(5, 2)].y + (rotate(W[hook(5, 0)].y, 25U) ^ rotate(W[hook(5, 0)].y, 14U) ^ (W[hook(5, 0)].y >> 3U));
  S1.w += (rotate(S1.x, 26U) ^ rotate(S1.x, 21U) ^ rotate(S1.x, 7U)) + bitselect(S1.z, S1.y, S1.x) + W[hook(5, 0)].x + 0x19a4c116U;
  S0.w += S1.w;
  S1.w += (rotate(S0.x, 30U) ^ rotate(S0.x, 19U) ^ rotate(S0.x, 10U)) + bitselect(S0.z, S0.y, (S0.x ^ S0.z));
  ;

  W[hook(5, 0)].y += (rotate(W[hook(5, 3)].w, 15U) ^ rotate(W[hook(5, 3)].w, 13U) ^ (W[hook(5, 3)].w >> 10U)) + W[hook(5, 2)].z + (rotate(W[hook(5, 0)].z, 25U) ^ rotate(W[hook(5, 0)].z, 14U) ^ (W[hook(5, 0)].z >> 3U));
  S1.z += (rotate(S0.w, 26U) ^ rotate(S0.w, 21U) ^ rotate(S0.w, 7U)) + bitselect(S1.y, S1.x, S0.w) + W[hook(5, 0)].y + 0x1e376c08U;
  S0.z += S1.z;
  S1.z += (rotate(S1.w, 30U) ^ rotate(S1.w, 19U) ^ rotate(S1.w, 10U)) + bitselect(S0.y, S0.x, (S1.w ^ S0.y));
  ;

  W[hook(5, 0)].z += (rotate(W[hook(5, 0)].x, 15U) ^ rotate(W[hook(5, 0)].x, 13U) ^ (W[hook(5, 0)].x >> 10U)) + W[hook(5, 2)].w + (rotate(W[hook(5, 0)].w, 25U) ^ rotate(W[hook(5, 0)].w, 14U) ^ (W[hook(5, 0)].w >> 3U));
  S1.y += (rotate(S0.z, 26U) ^ rotate(S0.z, 21U) ^ rotate(S0.z, 7U)) + bitselect(S1.x, S0.w, S0.z) + W[hook(5, 0)].z + 0x2748774cU;
  S0.y += S1.y;
  S1.y += (rotate(S1.z, 30U) ^ rotate(S1.z, 19U) ^ rotate(S1.z, 10U)) + bitselect(S0.x, S1.w, (S1.z ^ S0.x));
  ;

  W[hook(5, 0)].w += (rotate(W[hook(5, 0)].y, 15U) ^ rotate(W[hook(5, 0)].y, 13U) ^ (W[hook(5, 0)].y >> 10U)) + W[hook(5, 3)].x + (rotate(W[hook(5, 1)].x, 25U) ^ rotate(W[hook(5, 1)].x, 14U) ^ (W[hook(5, 1)].x >> 3U));
  S1.x += (rotate(S0.y, 26U) ^ rotate(S0.y, 21U) ^ rotate(S0.y, 7U)) + bitselect(S0.w, S0.z, S0.y) + W[hook(5, 0)].w + 0x34b0bcb5U;
  S0.x += S1.x;
  S1.x += (rotate(S1.y, 30U) ^ rotate(S1.y, 19U) ^ rotate(S1.y, 10U)) + bitselect(S1.w, S1.z, (S1.y ^ S1.w));
  ;

  W[hook(5, 1)].x += (rotate(W[hook(5, 0)].z, 15U) ^ rotate(W[hook(5, 0)].z, 13U) ^ (W[hook(5, 0)].z >> 10U)) + W[hook(5, 3)].y + (rotate(W[hook(5, 1)].y, 25U) ^ rotate(W[hook(5, 1)].y, 14U) ^ (W[hook(5, 1)].y >> 3U));
  S0.w += (rotate(S0.x, 26U) ^ rotate(S0.x, 21U) ^ rotate(S0.x, 7U)) + bitselect(S0.z, S0.y, S0.x) + W[hook(5, 1)].x + 0x391c0cb3U;
  S1.w += S0.w;
  S0.w += (rotate(S1.x, 30U) ^ rotate(S1.x, 19U) ^ rotate(S1.x, 10U)) + bitselect(S1.z, S1.y, (S1.x ^ S1.z));
  ;

  W[hook(5, 1)].y += (rotate(W[hook(5, 0)].w, 15U) ^ rotate(W[hook(5, 0)].w, 13U) ^ (W[hook(5, 0)].w >> 10U)) + W[hook(5, 3)].z + (rotate(W[hook(5, 1)].z, 25U) ^ rotate(W[hook(5, 1)].z, 14U) ^ (W[hook(5, 1)].z >> 3U));
  S0.z += (rotate(S1.w, 26U) ^ rotate(S1.w, 21U) ^ rotate(S1.w, 7U)) + bitselect(S0.y, S0.x, S1.w) + W[hook(5, 1)].y + 0x4ed8aa4aU;
  S1.z += S0.z;
  S0.z += (rotate(S0.w, 30U) ^ rotate(S0.w, 19U) ^ rotate(S0.w, 10U)) + bitselect(S1.y, S1.x, (S0.w ^ S1.y));
  ;

  W[hook(5, 1)].z += (rotate(W[hook(5, 1)].x, 15U) ^ rotate(W[hook(5, 1)].x, 13U) ^ (W[hook(5, 1)].x >> 10U)) + W[hook(5, 3)].w + (rotate(W[hook(5, 1)].w, 25U) ^ rotate(W[hook(5, 1)].w, 14U) ^ (W[hook(5, 1)].w >> 3U));
  S0.y += (rotate(S1.z, 26U) ^ rotate(S1.z, 21U) ^ rotate(S1.z, 7U)) + bitselect(S0.x, S1.w, S1.z) + W[hook(5, 1)].z + 0x5b9cca4fU;
  S1.y += S0.y;
  S0.y += (rotate(S0.z, 30U) ^ rotate(S0.z, 19U) ^ rotate(S0.z, 10U)) + bitselect(S1.x, S0.w, (S0.z ^ S1.x));
  ;

  W[hook(5, 1)].w += (rotate(W[hook(5, 1)].y, 15U) ^ rotate(W[hook(5, 1)].y, 13U) ^ (W[hook(5, 1)].y >> 10U)) + W[hook(5, 0)].x + (rotate(W[hook(5, 2)].x, 25U) ^ rotate(W[hook(5, 2)].x, 14U) ^ (W[hook(5, 2)].x >> 3U));
  S0.x += (rotate(S1.y, 26U) ^ rotate(S1.y, 21U) ^ rotate(S1.y, 7U)) + bitselect(S1.w, S1.z, S1.y) + W[hook(5, 1)].w + 0x682e6ff3U;
  S1.x += S0.x;
  S0.x += (rotate(S0.y, 30U) ^ rotate(S0.y, 19U) ^ rotate(S0.y, 10U)) + bitselect(S0.w, S0.z, (S0.y ^ S0.w));
  ;

  W[hook(5, 2)].x += (rotate(W[hook(5, 1)].z, 15U) ^ rotate(W[hook(5, 1)].z, 13U) ^ (W[hook(5, 1)].z >> 10U)) + W[hook(5, 0)].y + (rotate(W[hook(5, 2)].y, 25U) ^ rotate(W[hook(5, 2)].y, 14U) ^ (W[hook(5, 2)].y >> 3U));
  S1.w += (rotate(S1.x, 26U) ^ rotate(S1.x, 21U) ^ rotate(S1.x, 7U)) + bitselect(S1.z, S1.y, S1.x) + W[hook(5, 2)].x + 0x748f82eeU;
  S0.w += S1.w;
  S1.w += (rotate(S0.x, 30U) ^ rotate(S0.x, 19U) ^ rotate(S0.x, 10U)) + bitselect(S0.z, S0.y, (S0.x ^ S0.z));
  ;

  W[hook(5, 2)].y += (rotate(W[hook(5, 1)].w, 15U) ^ rotate(W[hook(5, 1)].w, 13U) ^ (W[hook(5, 1)].w >> 10U)) + W[hook(5, 0)].z + (rotate(W[hook(5, 2)].z, 25U) ^ rotate(W[hook(5, 2)].z, 14U) ^ (W[hook(5, 2)].z >> 3U));
  S1.z += (rotate(S0.w, 26U) ^ rotate(S0.w, 21U) ^ rotate(S0.w, 7U)) + bitselect(S1.y, S1.x, S0.w) + W[hook(5, 2)].y + 0x78a5636fU;
  S0.z += S1.z;
  S1.z += (rotate(S1.w, 30U) ^ rotate(S1.w, 19U) ^ rotate(S1.w, 10U)) + bitselect(S0.y, S0.x, (S1.w ^ S0.y));
  ;

  W[hook(5, 2)].z += (rotate(W[hook(5, 2)].x, 15U) ^ rotate(W[hook(5, 2)].x, 13U) ^ (W[hook(5, 2)].x >> 10U)) + W[hook(5, 0)].w + (rotate(W[hook(5, 2)].w, 25U) ^ rotate(W[hook(5, 2)].w, 14U) ^ (W[hook(5, 2)].w >> 3U));
  S1.y += (rotate(S0.z, 26U) ^ rotate(S0.z, 21U) ^ rotate(S0.z, 7U)) + bitselect(S1.x, S0.w, S0.z) + W[hook(5, 2)].z + 0x84c87814U;
  S0.y += S1.y;
  S1.y += (rotate(S1.z, 30U) ^ rotate(S1.z, 19U) ^ rotate(S1.z, 10U)) + bitselect(S0.x, S1.w, (S1.z ^ S0.x));
  ;

  W[hook(5, 2)].w += (rotate(W[hook(5, 2)].y, 15U) ^ rotate(W[hook(5, 2)].y, 13U) ^ (W[hook(5, 2)].y >> 10U)) + W[hook(5, 1)].x + (rotate(W[hook(5, 3)].x, 25U) ^ rotate(W[hook(5, 3)].x, 14U) ^ (W[hook(5, 3)].x >> 3U));
  S1.x += (rotate(S0.y, 26U) ^ rotate(S0.y, 21U) ^ rotate(S0.y, 7U)) + bitselect(S0.w, S0.z, S0.y) + W[hook(5, 2)].w + 0x8cc70208U;
  S0.x += S1.x;
  S1.x += (rotate(S1.y, 30U) ^ rotate(S1.y, 19U) ^ rotate(S1.y, 10U)) + bitselect(S1.w, S1.z, (S1.y ^ S1.w));
  ;

  W[hook(5, 3)].x += (rotate(W[hook(5, 2)].z, 15U) ^ rotate(W[hook(5, 2)].z, 13U) ^ (W[hook(5, 2)].z >> 10U)) + W[hook(5, 1)].y + (rotate(W[hook(5, 3)].y, 25U) ^ rotate(W[hook(5, 3)].y, 14U) ^ (W[hook(5, 3)].y >> 3U));
  S0.w += (rotate(S0.x, 26U) ^ rotate(S0.x, 21U) ^ rotate(S0.x, 7U)) + bitselect(S0.z, S0.y, S0.x) + W[hook(5, 3)].x + 0x90befffaU;
  S1.w += S0.w;
  S0.w += (rotate(S1.x, 30U) ^ rotate(S1.x, 19U) ^ rotate(S1.x, 10U)) + bitselect(S1.z, S1.y, (S1.x ^ S1.z));
  ;

  W[hook(5, 3)].y += (rotate(W[hook(5, 2)].w, 15U) ^ rotate(W[hook(5, 2)].w, 13U) ^ (W[hook(5, 2)].w >> 10U)) + W[hook(5, 1)].z + (rotate(W[hook(5, 3)].z, 25U) ^ rotate(W[hook(5, 3)].z, 14U) ^ (W[hook(5, 3)].z >> 3U));
  S0.z += (rotate(S1.w, 26U) ^ rotate(S1.w, 21U) ^ rotate(S1.w, 7U)) + bitselect(S0.y, S0.x, S1.w) + W[hook(5, 3)].y + 0xa4506cebU;
  S1.z += S0.z;
  S0.z += (rotate(S0.w, 30U) ^ rotate(S0.w, 19U) ^ rotate(S0.w, 10U)) + bitselect(S1.y, S1.x, (S0.w ^ S1.y));
  ;

  W[hook(5, 3)].z += (rotate(W[hook(5, 3)].x, 15U) ^ rotate(W[hook(5, 3)].x, 13U) ^ (W[hook(5, 3)].x >> 10U)) + W[hook(5, 1)].w + (rotate(W[hook(5, 3)].w, 25U) ^ rotate(W[hook(5, 3)].w, 14U) ^ (W[hook(5, 3)].w >> 3U));
  S0.y += (rotate(S1.z, 26U) ^ rotate(S1.z, 21U) ^ rotate(S1.z, 7U)) + bitselect(S0.x, S1.w, S1.z) + W[hook(5, 3)].z + 0xbef9a3f7U;
  S1.y += S0.y;
  S0.y += (rotate(S0.z, 30U) ^ rotate(S0.z, 19U) ^ rotate(S0.z, 10U)) + bitselect(S1.x, S0.w, (S0.z ^ S1.x));
  ;

  W[hook(5, 3)].w += (rotate(W[hook(5, 3)].y, 15U) ^ rotate(W[hook(5, 3)].y, 13U) ^ (W[hook(5, 3)].y >> 10U)) + W[hook(5, 2)].x + (rotate(W[hook(5, 0)].x, 25U) ^ rotate(W[hook(5, 0)].x, 14U) ^ (W[hook(5, 0)].x >> 3U));
  S0.x += (rotate(S1.y, 26U) ^ rotate(S1.y, 21U) ^ rotate(S1.y, 7U)) + bitselect(S1.w, S1.z, S1.y) + W[hook(5, 3)].w + 0xc67178f2U;
  S1.x += S0.x;
  S0.x += (rotate(S0.y, 30U) ^ rotate(S0.y, 19U) ^ rotate(S0.y, 10U)) + bitselect(S0.w, S0.z, (S0.y ^ S0.w));
  ;
  *state0 += S0;
  *state1 += S1;
}

void SHA256_fresh(uint4* restrict state0, uint4* restrict state1, const uint4 block0, const uint4 block1, const uint4 block2, const uint4 block3) {
  uint4 W[4];

  W[hook(5, 0)].x = block0.x;
  (*state0).w = 0x98c7e2a2U + W[hook(5, 0)].x;
  (*state1).w = 0xfc08884dU + W[hook(5, 0)].x;

  W[hook(5, 0)].y = block0.y;
  (*state0).z = 0xcd2a11aeU + (rotate((*state0).w, 26U) ^ rotate((*state0).w, 21U) ^ rotate((*state0).w, 7U)) + bitselect(0x9b05688cU, 0x510e527fU, (*state0).w) + W[hook(5, 0)].y;
  (*state1).z = 0xC3910C8EU + (*state0).z + (rotate((*state1).w, 30U) ^ rotate((*state1).w, 19U) ^ rotate((*state1).w, 10U)) + bitselect(0x2a01a605U, 0xfb6feee7U, (*state1).w);

  W[hook(5, 0)].z = block0.z;
  (*state0).y = 0x0c2e12e0U + (rotate((*state0).z, 26U) ^ rotate((*state0).z, 21U) ^ rotate((*state0).z, 7U)) + bitselect(0x510e527fU, (*state0).w, (*state0).z) + W[hook(5, 0)].z;
  (*state1).y = 0x4498517BU + (*state0).y + (rotate((*state1).z, 30U) ^ rotate((*state1).z, 19U) ^ rotate((*state1).z, 10U)) + bitselect(0x6a09e667U, (*state1).w, ((*state1).z ^ 0x6a09e667U));

  W[hook(5, 0)].w = block0.w;
  (*state0).x = 0xa4ce148bU + (rotate((*state0).y, 26U) ^ rotate((*state0).y, 21U) ^ rotate((*state0).y, 7U)) + bitselect((*state0).w, (*state0).z, (*state0).y) + W[hook(5, 0)].w;
  (*state1).x = 0x95F61999U + (*state0).x + (rotate((*state1).y, 30U) ^ rotate((*state1).y, 19U) ^ rotate((*state1).y, 10U)) + bitselect((*state1).w, (*state1).z, ((*state1).y ^ (*state1).w));

  W[hook(5, 1)].x = block1.x;
  (*state0).w += (rotate((*state0).x, 26U) ^ rotate((*state0).x, 21U) ^ rotate((*state0).x, 7U)) + bitselect((*state0).z, (*state0).y, (*state0).x) + W[hook(5, 1)].x + 0x3956c25bU;
  (*state1).w += (*state0).w;
  (*state0).w += (rotate((*state1).x, 30U) ^ rotate((*state1).x, 19U) ^ rotate((*state1).x, 10U)) + bitselect((*state1).z, (*state1).y, ((*state1).x ^ (*state1).z));
  ;
  W[hook(5, 1)].y = block1.y;
  (*state0).z += (rotate((*state1).w, 26U) ^ rotate((*state1).w, 21U) ^ rotate((*state1).w, 7U)) + bitselect((*state0).y, (*state0).x, (*state1).w) + W[hook(5, 1)].y + 0x59f111f1U;
  (*state1).z += (*state0).z;
  (*state0).z += (rotate((*state0).w, 30U) ^ rotate((*state0).w, 19U) ^ rotate((*state0).w, 10U)) + bitselect((*state1).y, (*state1).x, ((*state0).w ^ (*state1).y));
  ;
  W[hook(5, 1)].z = block1.z;
  (*state0).y += (rotate((*state1).z, 26U) ^ rotate((*state1).z, 21U) ^ rotate((*state1).z, 7U)) + bitselect((*state0).x, (*state1).w, (*state1).z) + W[hook(5, 1)].z + 0x923f82a4U;
  (*state1).y += (*state0).y;
  (*state0).y += (rotate((*state0).z, 30U) ^ rotate((*state0).z, 19U) ^ rotate((*state0).z, 10U)) + bitselect((*state1).x, (*state0).w, ((*state0).z ^ (*state1).x));
  ;
  W[hook(5, 1)].w = block1.w;
  (*state0).x += (rotate((*state1).y, 26U) ^ rotate((*state1).y, 21U) ^ rotate((*state1).y, 7U)) + bitselect((*state1).w, (*state1).z, (*state1).y) + W[hook(5, 1)].w + 0xab1c5ed5U;
  (*state1).x += (*state0).x;
  (*state0).x += (rotate((*state0).y, 30U) ^ rotate((*state0).y, 19U) ^ rotate((*state0).y, 10U)) + bitselect((*state0).w, (*state0).z, ((*state0).y ^ (*state0).w));
  ;

  W[hook(5, 2)].x = block2.x;
  (*state1).w += (rotate((*state1).x, 26U) ^ rotate((*state1).x, 21U) ^ rotate((*state1).x, 7U)) + bitselect((*state1).z, (*state1).y, (*state1).x) + W[hook(5, 2)].x + 0xd807aa98U;
  (*state0).w += (*state1).w;
  (*state1).w += (rotate((*state0).x, 30U) ^ rotate((*state0).x, 19U) ^ rotate((*state0).x, 10U)) + bitselect((*state0).z, (*state0).y, ((*state0).x ^ (*state0).z));
  ;
  W[hook(5, 2)].y = block2.y;
  (*state1).z += (rotate((*state0).w, 26U) ^ rotate((*state0).w, 21U) ^ rotate((*state0).w, 7U)) + bitselect((*state1).y, (*state1).x, (*state0).w) + W[hook(5, 2)].y + 0x12835b01U;
  (*state0).z += (*state1).z;
  (*state1).z += (rotate((*state1).w, 30U) ^ rotate((*state1).w, 19U) ^ rotate((*state1).w, 10U)) + bitselect((*state0).y, (*state0).x, ((*state1).w ^ (*state0).y));
  ;
  W[hook(5, 2)].z = block2.z;
  (*state1).y += (rotate((*state0).z, 26U) ^ rotate((*state0).z, 21U) ^ rotate((*state0).z, 7U)) + bitselect((*state1).x, (*state0).w, (*state0).z) + W[hook(5, 2)].z + 0x243185beU;
  (*state0).y += (*state1).y;
  (*state1).y += (rotate((*state1).z, 30U) ^ rotate((*state1).z, 19U) ^ rotate((*state1).z, 10U)) + bitselect((*state0).x, (*state1).w, ((*state1).z ^ (*state0).x));
  ;
  W[hook(5, 2)].w = block2.w;
  (*state1).x += (rotate((*state0).y, 26U) ^ rotate((*state0).y, 21U) ^ rotate((*state0).y, 7U)) + bitselect((*state0).w, (*state0).z, (*state0).y) + W[hook(5, 2)].w + 0x550c7dc3U;
  (*state0).x += (*state1).x;
  (*state1).x += (rotate((*state1).y, 30U) ^ rotate((*state1).y, 19U) ^ rotate((*state1).y, 10U)) + bitselect((*state1).w, (*state1).z, ((*state1).y ^ (*state1).w));
  ;

  W[hook(5, 3)].x = block3.x;
  (*state0).w += (rotate((*state0).x, 26U) ^ rotate((*state0).x, 21U) ^ rotate((*state0).x, 7U)) + bitselect((*state0).z, (*state0).y, (*state0).x) + W[hook(5, 3)].x + 0x72be5d74U;
  (*state1).w += (*state0).w;
  (*state0).w += (rotate((*state1).x, 30U) ^ rotate((*state1).x, 19U) ^ rotate((*state1).x, 10U)) + bitselect((*state1).z, (*state1).y, ((*state1).x ^ (*state1).z));
  ;
  W[hook(5, 3)].y = block3.y;
  (*state0).z += (rotate((*state1).w, 26U) ^ rotate((*state1).w, 21U) ^ rotate((*state1).w, 7U)) + bitselect((*state0).y, (*state0).x, (*state1).w) + W[hook(5, 3)].y + 0x80deb1feU;
  (*state1).z += (*state0).z;
  (*state0).z += (rotate((*state0).w, 30U) ^ rotate((*state0).w, 19U) ^ rotate((*state0).w, 10U)) + bitselect((*state1).y, (*state1).x, ((*state0).w ^ (*state1).y));
  ;
  W[hook(5, 3)].z = block3.z;
  (*state0).y += (rotate((*state1).z, 26U) ^ rotate((*state1).z, 21U) ^ rotate((*state1).z, 7U)) + bitselect((*state0).x, (*state1).w, (*state1).z) + W[hook(5, 3)].z + 0x9bdc06a7U;
  (*state1).y += (*state0).y;
  (*state0).y += (rotate((*state0).z, 30U) ^ rotate((*state0).z, 19U) ^ rotate((*state0).z, 10U)) + bitselect((*state1).x, (*state0).w, ((*state0).z ^ (*state1).x));
  ;
  W[hook(5, 3)].w = block3.w;
  (*state0).x += (rotate((*state1).y, 26U) ^ rotate((*state1).y, 21U) ^ rotate((*state1).y, 7U)) + bitselect((*state1).w, (*state1).z, (*state1).y) + W[hook(5, 3)].w + 0xc19bf174U;
  (*state1).x += (*state0).x;
  (*state0).x += (rotate((*state0).y, 30U) ^ rotate((*state0).y, 19U) ^ rotate((*state0).y, 10U)) + bitselect((*state0).w, (*state0).z, ((*state0).y ^ (*state0).w));
  ;

  W[hook(5, 0)].x += (rotate(W[hook(5, 3)].z, 15U) ^ rotate(W[hook(5, 3)].z, 13U) ^ (W[hook(5, 3)].z >> 10U)) + W[hook(5, 2)].y + (rotate(W[hook(5, 0)].y, 25U) ^ rotate(W[hook(5, 0)].y, 14U) ^ (W[hook(5, 0)].y >> 3U));
  (*state1).w += (rotate((*state1).x, 26U) ^ rotate((*state1).x, 21U) ^ rotate((*state1).x, 7U)) + bitselect((*state1).z, (*state1).y, (*state1).x) + W[hook(5, 0)].x + 0xe49b69c1U;
  (*state0).w += (*state1).w;
  (*state1).w += (rotate((*state0).x, 30U) ^ rotate((*state0).x, 19U) ^ rotate((*state0).x, 10U)) + bitselect((*state0).z, (*state0).y, ((*state0).x ^ (*state0).z));
  ;

  W[hook(5, 0)].y += (rotate(W[hook(5, 3)].w, 15U) ^ rotate(W[hook(5, 3)].w, 13U) ^ (W[hook(5, 3)].w >> 10U)) + W[hook(5, 2)].z + (rotate(W[hook(5, 0)].z, 25U) ^ rotate(W[hook(5, 0)].z, 14U) ^ (W[hook(5, 0)].z >> 3U));
  (*state1).z += (rotate((*state0).w, 26U) ^ rotate((*state0).w, 21U) ^ rotate((*state0).w, 7U)) + bitselect((*state1).y, (*state1).x, (*state0).w) + W[hook(5, 0)].y + 0xefbe4786U;
  (*state0).z += (*state1).z;
  (*state1).z += (rotate((*state1).w, 30U) ^ rotate((*state1).w, 19U) ^ rotate((*state1).w, 10U)) + bitselect((*state0).y, (*state0).x, ((*state1).w ^ (*state0).y));
  ;

  W[hook(5, 0)].z += (rotate(W[hook(5, 0)].x, 15U) ^ rotate(W[hook(5, 0)].x, 13U) ^ (W[hook(5, 0)].x >> 10U)) + W[hook(5, 2)].w + (rotate(W[hook(5, 0)].w, 25U) ^ rotate(W[hook(5, 0)].w, 14U) ^ (W[hook(5, 0)].w >> 3U));
  (*state1).y += (rotate((*state0).z, 26U) ^ rotate((*state0).z, 21U) ^ rotate((*state0).z, 7U)) + bitselect((*state1).x, (*state0).w, (*state0).z) + W[hook(5, 0)].z + 0x0fc19dc6U;
  (*state0).y += (*state1).y;
  (*state1).y += (rotate((*state1).z, 30U) ^ rotate((*state1).z, 19U) ^ rotate((*state1).z, 10U)) + bitselect((*state0).x, (*state1).w, ((*state1).z ^ (*state0).x));
  ;

  W[hook(5, 0)].w += (rotate(W[hook(5, 0)].y, 15U) ^ rotate(W[hook(5, 0)].y, 13U) ^ (W[hook(5, 0)].y >> 10U)) + W[hook(5, 3)].x + (rotate(W[hook(5, 1)].x, 25U) ^ rotate(W[hook(5, 1)].x, 14U) ^ (W[hook(5, 1)].x >> 3U));
  (*state1).x += (rotate((*state0).y, 26U) ^ rotate((*state0).y, 21U) ^ rotate((*state0).y, 7U)) + bitselect((*state0).w, (*state0).z, (*state0).y) + W[hook(5, 0)].w + 0x240ca1ccU;
  (*state0).x += (*state1).x;
  (*state1).x += (rotate((*state1).y, 30U) ^ rotate((*state1).y, 19U) ^ rotate((*state1).y, 10U)) + bitselect((*state1).w, (*state1).z, ((*state1).y ^ (*state1).w));
  ;

  W[hook(5, 1)].x += (rotate(W[hook(5, 0)].z, 15U) ^ rotate(W[hook(5, 0)].z, 13U) ^ (W[hook(5, 0)].z >> 10U)) + W[hook(5, 3)].y + (rotate(W[hook(5, 1)].y, 25U) ^ rotate(W[hook(5, 1)].y, 14U) ^ (W[hook(5, 1)].y >> 3U));
  (*state0).w += (rotate((*state0).x, 26U) ^ rotate((*state0).x, 21U) ^ rotate((*state0).x, 7U)) + bitselect((*state0).z, (*state0).y, (*state0).x) + W[hook(5, 1)].x + 0x2de92c6fU;
  (*state1).w += (*state0).w;
  (*state0).w += (rotate((*state1).x, 30U) ^ rotate((*state1).x, 19U) ^ rotate((*state1).x, 10U)) + bitselect((*state1).z, (*state1).y, ((*state1).x ^ (*state1).z));
  ;

  W[hook(5, 1)].y += (rotate(W[hook(5, 0)].w, 15U) ^ rotate(W[hook(5, 0)].w, 13U) ^ (W[hook(5, 0)].w >> 10U)) + W[hook(5, 3)].z + (rotate(W[hook(5, 1)].z, 25U) ^ rotate(W[hook(5, 1)].z, 14U) ^ (W[hook(5, 1)].z >> 3U));
  (*state0).z += (rotate((*state1).w, 26U) ^ rotate((*state1).w, 21U) ^ rotate((*state1).w, 7U)) + bitselect((*state0).y, (*state0).x, (*state1).w) + W[hook(5, 1)].y + 0x4a7484aaU;
  (*state1).z += (*state0).z;
  (*state0).z += (rotate((*state0).w, 30U) ^ rotate((*state0).w, 19U) ^ rotate((*state0).w, 10U)) + bitselect((*state1).y, (*state1).x, ((*state0).w ^ (*state1).y));
  ;

  W[hook(5, 1)].z += (rotate(W[hook(5, 1)].x, 15U) ^ rotate(W[hook(5, 1)].x, 13U) ^ (W[hook(5, 1)].x >> 10U)) + W[hook(5, 3)].w + (rotate(W[hook(5, 1)].w, 25U) ^ rotate(W[hook(5, 1)].w, 14U) ^ (W[hook(5, 1)].w >> 3U));
  (*state0).y += (rotate((*state1).z, 26U) ^ rotate((*state1).z, 21U) ^ rotate((*state1).z, 7U)) + bitselect((*state0).x, (*state1).w, (*state1).z) + W[hook(5, 1)].z + 0x5cb0a9dcU;
  (*state1).y += (*state0).y;
  (*state0).y += (rotate((*state0).z, 30U) ^ rotate((*state0).z, 19U) ^ rotate((*state0).z, 10U)) + bitselect((*state1).x, (*state0).w, ((*state0).z ^ (*state1).x));
  ;

  W[hook(5, 1)].w += (rotate(W[hook(5, 1)].y, 15U) ^ rotate(W[hook(5, 1)].y, 13U) ^ (W[hook(5, 1)].y >> 10U)) + W[hook(5, 0)].x + (rotate(W[hook(5, 2)].x, 25U) ^ rotate(W[hook(5, 2)].x, 14U) ^ (W[hook(5, 2)].x >> 3U));
  (*state0).x += (rotate((*state1).y, 26U) ^ rotate((*state1).y, 21U) ^ rotate((*state1).y, 7U)) + bitselect((*state1).w, (*state1).z, (*state1).y) + W[hook(5, 1)].w + 0x76f988daU;
  (*state1).x += (*state0).x;
  (*state0).x += (rotate((*state0).y, 30U) ^ rotate((*state0).y, 19U) ^ rotate((*state0).y, 10U)) + bitselect((*state0).w, (*state0).z, ((*state0).y ^ (*state0).w));
  ;

  W[hook(5, 2)].x += (rotate(W[hook(5, 1)].z, 15U) ^ rotate(W[hook(5, 1)].z, 13U) ^ (W[hook(5, 1)].z >> 10U)) + W[hook(5, 0)].y + (rotate(W[hook(5, 2)].y, 25U) ^ rotate(W[hook(5, 2)].y, 14U) ^ (W[hook(5, 2)].y >> 3U));
  (*state1).w += (rotate((*state1).x, 26U) ^ rotate((*state1).x, 21U) ^ rotate((*state1).x, 7U)) + bitselect((*state1).z, (*state1).y, (*state1).x) + W[hook(5, 2)].x + 0x983e5152U;
  (*state0).w += (*state1).w;
  (*state1).w += (rotate((*state0).x, 30U) ^ rotate((*state0).x, 19U) ^ rotate((*state0).x, 10U)) + bitselect((*state0).z, (*state0).y, ((*state0).x ^ (*state0).z));
  ;

  W[hook(5, 2)].y += (rotate(W[hook(5, 1)].w, 15U) ^ rotate(W[hook(5, 1)].w, 13U) ^ (W[hook(5, 1)].w >> 10U)) + W[hook(5, 0)].z + (rotate(W[hook(5, 2)].z, 25U) ^ rotate(W[hook(5, 2)].z, 14U) ^ (W[hook(5, 2)].z >> 3U));
  (*state1).z += (rotate((*state0).w, 26U) ^ rotate((*state0).w, 21U) ^ rotate((*state0).w, 7U)) + bitselect((*state1).y, (*state1).x, (*state0).w) + W[hook(5, 2)].y + 0xa831c66dU;
  (*state0).z += (*state1).z;
  (*state1).z += (rotate((*state1).w, 30U) ^ rotate((*state1).w, 19U) ^ rotate((*state1).w, 10U)) + bitselect((*state0).y, (*state0).x, ((*state1).w ^ (*state0).y));
  ;

  W[hook(5, 2)].z += (rotate(W[hook(5, 2)].x, 15U) ^ rotate(W[hook(5, 2)].x, 13U) ^ (W[hook(5, 2)].x >> 10U)) + W[hook(5, 0)].w + (rotate(W[hook(5, 2)].w, 25U) ^ rotate(W[hook(5, 2)].w, 14U) ^ (W[hook(5, 2)].w >> 3U));
  (*state1).y += (rotate((*state0).z, 26U) ^ rotate((*state0).z, 21U) ^ rotate((*state0).z, 7U)) + bitselect((*state1).x, (*state0).w, (*state0).z) + W[hook(5, 2)].z + 0xb00327c8U;
  (*state0).y += (*state1).y;
  (*state1).y += (rotate((*state1).z, 30U) ^ rotate((*state1).z, 19U) ^ rotate((*state1).z, 10U)) + bitselect((*state0).x, (*state1).w, ((*state1).z ^ (*state0).x));
  ;

  W[hook(5, 2)].w += (rotate(W[hook(5, 2)].y, 15U) ^ rotate(W[hook(5, 2)].y, 13U) ^ (W[hook(5, 2)].y >> 10U)) + W[hook(5, 1)].x + (rotate(W[hook(5, 3)].x, 25U) ^ rotate(W[hook(5, 3)].x, 14U) ^ (W[hook(5, 3)].x >> 3U));
  (*state1).x += (rotate((*state0).y, 26U) ^ rotate((*state0).y, 21U) ^ rotate((*state0).y, 7U)) + bitselect((*state0).w, (*state0).z, (*state0).y) + W[hook(5, 2)].w + 0xbf597fc7U;
  (*state0).x += (*state1).x;
  (*state1).x += (rotate((*state1).y, 30U) ^ rotate((*state1).y, 19U) ^ rotate((*state1).y, 10U)) + bitselect((*state1).w, (*state1).z, ((*state1).y ^ (*state1).w));
  ;

  W[hook(5, 3)].x += (rotate(W[hook(5, 2)].z, 15U) ^ rotate(W[hook(5, 2)].z, 13U) ^ (W[hook(5, 2)].z >> 10U)) + W[hook(5, 1)].y + (rotate(W[hook(5, 3)].y, 25U) ^ rotate(W[hook(5, 3)].y, 14U) ^ (W[hook(5, 3)].y >> 3U));
  (*state0).w += (rotate((*state0).x, 26U) ^ rotate((*state0).x, 21U) ^ rotate((*state0).x, 7U)) + bitselect((*state0).z, (*state0).y, (*state0).x) + W[hook(5, 3)].x + 0xc6e00bf3U;
  (*state1).w += (*state0).w;
  (*state0).w += (rotate((*state1).x, 30U) ^ rotate((*state1).x, 19U) ^ rotate((*state1).x, 10U)) + bitselect((*state1).z, (*state1).y, ((*state1).x ^ (*state1).z));
  ;

  W[hook(5, 3)].y += (rotate(W[hook(5, 2)].w, 15U) ^ rotate(W[hook(5, 2)].w, 13U) ^ (W[hook(5, 2)].w >> 10U)) + W[hook(5, 1)].z + (rotate(W[hook(5, 3)].z, 25U) ^ rotate(W[hook(5, 3)].z, 14U) ^ (W[hook(5, 3)].z >> 3U));
  (*state0).z += (rotate((*state1).w, 26U) ^ rotate((*state1).w, 21U) ^ rotate((*state1).w, 7U)) + bitselect((*state0).y, (*state0).x, (*state1).w) + W[hook(5, 3)].y + 0xd5a79147U;
  (*state1).z += (*state0).z;
  (*state0).z += (rotate((*state0).w, 30U) ^ rotate((*state0).w, 19U) ^ rotate((*state0).w, 10U)) + bitselect((*state1).y, (*state1).x, ((*state0).w ^ (*state1).y));
  ;

  W[hook(5, 3)].z += (rotate(W[hook(5, 3)].x, 15U) ^ rotate(W[hook(5, 3)].x, 13U) ^ (W[hook(5, 3)].x >> 10U)) + W[hook(5, 1)].w + (rotate(W[hook(5, 3)].w, 25U) ^ rotate(W[hook(5, 3)].w, 14U) ^ (W[hook(5, 3)].w >> 3U));
  (*state0).y += (rotate((*state1).z, 26U) ^ rotate((*state1).z, 21U) ^ rotate((*state1).z, 7U)) + bitselect((*state0).x, (*state1).w, (*state1).z) + W[hook(5, 3)].z + 0x06ca6351U;
  (*state1).y += (*state0).y;
  (*state0).y += (rotate((*state0).z, 30U) ^ rotate((*state0).z, 19U) ^ rotate((*state0).z, 10U)) + bitselect((*state1).x, (*state0).w, ((*state0).z ^ (*state1).x));
  ;

  W[hook(5, 3)].w += (rotate(W[hook(5, 3)].y, 15U) ^ rotate(W[hook(5, 3)].y, 13U) ^ (W[hook(5, 3)].y >> 10U)) + W[hook(5, 2)].x + (rotate(W[hook(5, 0)].x, 25U) ^ rotate(W[hook(5, 0)].x, 14U) ^ (W[hook(5, 0)].x >> 3U));
  (*state0).x += (rotate((*state1).y, 26U) ^ rotate((*state1).y, 21U) ^ rotate((*state1).y, 7U)) + bitselect((*state1).w, (*state1).z, (*state1).y) + W[hook(5, 3)].w + 0x14292967U;
  (*state1).x += (*state0).x;
  (*state0).x += (rotate((*state0).y, 30U) ^ rotate((*state0).y, 19U) ^ rotate((*state0).y, 10U)) + bitselect((*state0).w, (*state0).z, ((*state0).y ^ (*state0).w));
  ;

  W[hook(5, 0)].x += (rotate(W[hook(5, 3)].z, 15U) ^ rotate(W[hook(5, 3)].z, 13U) ^ (W[hook(5, 3)].z >> 10U)) + W[hook(5, 2)].y + (rotate(W[hook(5, 0)].y, 25U) ^ rotate(W[hook(5, 0)].y, 14U) ^ (W[hook(5, 0)].y >> 3U));
  (*state1).w += (rotate((*state1).x, 26U) ^ rotate((*state1).x, 21U) ^ rotate((*state1).x, 7U)) + bitselect((*state1).z, (*state1).y, (*state1).x) + W[hook(5, 0)].x + 0x27b70a85U;
  (*state0).w += (*state1).w;
  (*state1).w += (rotate((*state0).x, 30U) ^ rotate((*state0).x, 19U) ^ rotate((*state0).x, 10U)) + bitselect((*state0).z, (*state0).y, ((*state0).x ^ (*state0).z));
  ;

  W[hook(5, 0)].y += (rotate(W[hook(5, 3)].w, 15U) ^ rotate(W[hook(5, 3)].w, 13U) ^ (W[hook(5, 3)].w >> 10U)) + W[hook(5, 2)].z + (rotate(W[hook(5, 0)].z, 25U) ^ rotate(W[hook(5, 0)].z, 14U) ^ (W[hook(5, 0)].z >> 3U));
  (*state1).z += (rotate((*state0).w, 26U) ^ rotate((*state0).w, 21U) ^ rotate((*state0).w, 7U)) + bitselect((*state1).y, (*state1).x, (*state0).w) + W[hook(5, 0)].y + 0x2e1b2138U;
  (*state0).z += (*state1).z;
  (*state1).z += (rotate((*state1).w, 30U) ^ rotate((*state1).w, 19U) ^ rotate((*state1).w, 10U)) + bitselect((*state0).y, (*state0).x, ((*state1).w ^ (*state0).y));
  ;

  W[hook(5, 0)].z += (rotate(W[hook(5, 0)].x, 15U) ^ rotate(W[hook(5, 0)].x, 13U) ^ (W[hook(5, 0)].x >> 10U)) + W[hook(5, 2)].w + (rotate(W[hook(5, 0)].w, 25U) ^ rotate(W[hook(5, 0)].w, 14U) ^ (W[hook(5, 0)].w >> 3U));
  (*state1).y += (rotate((*state0).z, 26U) ^ rotate((*state0).z, 21U) ^ rotate((*state0).z, 7U)) + bitselect((*state1).x, (*state0).w, (*state0).z) + W[hook(5, 0)].z + 0x4d2c6dfcU;
  (*state0).y += (*state1).y;
  (*state1).y += (rotate((*state1).z, 30U) ^ rotate((*state1).z, 19U) ^ rotate((*state1).z, 10U)) + bitselect((*state0).x, (*state1).w, ((*state1).z ^ (*state0).x));
  ;

  W[hook(5, 0)].w += (rotate(W[hook(5, 0)].y, 15U) ^ rotate(W[hook(5, 0)].y, 13U) ^ (W[hook(5, 0)].y >> 10U)) + W[hook(5, 3)].x + (rotate(W[hook(5, 1)].x, 25U) ^ rotate(W[hook(5, 1)].x, 14U) ^ (W[hook(5, 1)].x >> 3U));
  (*state1).x += (rotate((*state0).y, 26U) ^ rotate((*state0).y, 21U) ^ rotate((*state0).y, 7U)) + bitselect((*state0).w, (*state0).z, (*state0).y) + W[hook(5, 0)].w + 0x53380d13U;
  (*state0).x += (*state1).x;
  (*state1).x += (rotate((*state1).y, 30U) ^ rotate((*state1).y, 19U) ^ rotate((*state1).y, 10U)) + bitselect((*state1).w, (*state1).z, ((*state1).y ^ (*state1).w));
  ;

  W[hook(5, 1)].x += (rotate(W[hook(5, 0)].z, 15U) ^ rotate(W[hook(5, 0)].z, 13U) ^ (W[hook(5, 0)].z >> 10U)) + W[hook(5, 3)].y + (rotate(W[hook(5, 1)].y, 25U) ^ rotate(W[hook(5, 1)].y, 14U) ^ (W[hook(5, 1)].y >> 3U));
  (*state0).w += (rotate((*state0).x, 26U) ^ rotate((*state0).x, 21U) ^ rotate((*state0).x, 7U)) + bitselect((*state0).z, (*state0).y, (*state0).x) + W[hook(5, 1)].x + 0x650a7354U;
  (*state1).w += (*state0).w;
  (*state0).w += (rotate((*state1).x, 30U) ^ rotate((*state1).x, 19U) ^ rotate((*state1).x, 10U)) + bitselect((*state1).z, (*state1).y, ((*state1).x ^ (*state1).z));
  ;

  W[hook(5, 1)].y += (rotate(W[hook(5, 0)].w, 15U) ^ rotate(W[hook(5, 0)].w, 13U) ^ (W[hook(5, 0)].w >> 10U)) + W[hook(5, 3)].z + (rotate(W[hook(5, 1)].z, 25U) ^ rotate(W[hook(5, 1)].z, 14U) ^ (W[hook(5, 1)].z >> 3U));
  (*state0).z += (rotate((*state1).w, 26U) ^ rotate((*state1).w, 21U) ^ rotate((*state1).w, 7U)) + bitselect((*state0).y, (*state0).x, (*state1).w) + W[hook(5, 1)].y + 0x766a0abbU;
  (*state1).z += (*state0).z;
  (*state0).z += (rotate((*state0).w, 30U) ^ rotate((*state0).w, 19U) ^ rotate((*state0).w, 10U)) + bitselect((*state1).y, (*state1).x, ((*state0).w ^ (*state1).y));
  ;

  W[hook(5, 1)].z += (rotate(W[hook(5, 1)].x, 15U) ^ rotate(W[hook(5, 1)].x, 13U) ^ (W[hook(5, 1)].x >> 10U)) + W[hook(5, 3)].w + (rotate(W[hook(5, 1)].w, 25U) ^ rotate(W[hook(5, 1)].w, 14U) ^ (W[hook(5, 1)].w >> 3U));
  (*state0).y += (rotate((*state1).z, 26U) ^ rotate((*state1).z, 21U) ^ rotate((*state1).z, 7U)) + bitselect((*state0).x, (*state1).w, (*state1).z) + W[hook(5, 1)].z + 0x81c2c92eU;
  (*state1).y += (*state0).y;
  (*state0).y += (rotate((*state0).z, 30U) ^ rotate((*state0).z, 19U) ^ rotate((*state0).z, 10U)) + bitselect((*state1).x, (*state0).w, ((*state0).z ^ (*state1).x));
  ;

  W[hook(5, 1)].w += (rotate(W[hook(5, 1)].y, 15U) ^ rotate(W[hook(5, 1)].y, 13U) ^ (W[hook(5, 1)].y >> 10U)) + W[hook(5, 0)].x + (rotate(W[hook(5, 2)].x, 25U) ^ rotate(W[hook(5, 2)].x, 14U) ^ (W[hook(5, 2)].x >> 3U));
  (*state0).x += (rotate((*state1).y, 26U) ^ rotate((*state1).y, 21U) ^ rotate((*state1).y, 7U)) + bitselect((*state1).w, (*state1).z, (*state1).y) + W[hook(5, 1)].w + 0x92722c85U;
  (*state1).x += (*state0).x;
  (*state0).x += (rotate((*state0).y, 30U) ^ rotate((*state0).y, 19U) ^ rotate((*state0).y, 10U)) + bitselect((*state0).w, (*state0).z, ((*state0).y ^ (*state0).w));
  ;

  W[hook(5, 2)].x += (rotate(W[hook(5, 1)].z, 15U) ^ rotate(W[hook(5, 1)].z, 13U) ^ (W[hook(5, 1)].z >> 10U)) + W[hook(5, 0)].y + (rotate(W[hook(5, 2)].y, 25U) ^ rotate(W[hook(5, 2)].y, 14U) ^ (W[hook(5, 2)].y >> 3U));
  (*state1).w += (rotate((*state1).x, 26U) ^ rotate((*state1).x, 21U) ^ rotate((*state1).x, 7U)) + bitselect((*state1).z, (*state1).y, (*state1).x) + W[hook(5, 2)].x + 0xa2bfe8a1U;
  (*state0).w += (*state1).w;
  (*state1).w += (rotate((*state0).x, 30U) ^ rotate((*state0).x, 19U) ^ rotate((*state0).x, 10U)) + bitselect((*state0).z, (*state0).y, ((*state0).x ^ (*state0).z));
  ;

  W[hook(5, 2)].y += (rotate(W[hook(5, 1)].w, 15U) ^ rotate(W[hook(5, 1)].w, 13U) ^ (W[hook(5, 1)].w >> 10U)) + W[hook(5, 0)].z + (rotate(W[hook(5, 2)].z, 25U) ^ rotate(W[hook(5, 2)].z, 14U) ^ (W[hook(5, 2)].z >> 3U));
  (*state1).z += (rotate((*state0).w, 26U) ^ rotate((*state0).w, 21U) ^ rotate((*state0).w, 7U)) + bitselect((*state1).y, (*state1).x, (*state0).w) + W[hook(5, 2)].y + 0xa81a664bU;
  (*state0).z += (*state1).z;
  (*state1).z += (rotate((*state1).w, 30U) ^ rotate((*state1).w, 19U) ^ rotate((*state1).w, 10U)) + bitselect((*state0).y, (*state0).x, ((*state1).w ^ (*state0).y));
  ;

  W[hook(5, 2)].z += (rotate(W[hook(5, 2)].x, 15U) ^ rotate(W[hook(5, 2)].x, 13U) ^ (W[hook(5, 2)].x >> 10U)) + W[hook(5, 0)].w + (rotate(W[hook(5, 2)].w, 25U) ^ rotate(W[hook(5, 2)].w, 14U) ^ (W[hook(5, 2)].w >> 3U));
  (*state1).y += (rotate((*state0).z, 26U) ^ rotate((*state0).z, 21U) ^ rotate((*state0).z, 7U)) + bitselect((*state1).x, (*state0).w, (*state0).z) + W[hook(5, 2)].z + 0xc24b8b70U;
  (*state0).y += (*state1).y;
  (*state1).y += (rotate((*state1).z, 30U) ^ rotate((*state1).z, 19U) ^ rotate((*state1).z, 10U)) + bitselect((*state0).x, (*state1).w, ((*state1).z ^ (*state0).x));
  ;

  W[hook(5, 2)].w += (rotate(W[hook(5, 2)].y, 15U) ^ rotate(W[hook(5, 2)].y, 13U) ^ (W[hook(5, 2)].y >> 10U)) + W[hook(5, 1)].x + (rotate(W[hook(5, 3)].x, 25U) ^ rotate(W[hook(5, 3)].x, 14U) ^ (W[hook(5, 3)].x >> 3U));
  (*state1).x += (rotate((*state0).y, 26U) ^ rotate((*state0).y, 21U) ^ rotate((*state0).y, 7U)) + bitselect((*state0).w, (*state0).z, (*state0).y) + W[hook(5, 2)].w + 0xc76c51a3U;
  (*state0).x += (*state1).x;
  (*state1).x += (rotate((*state1).y, 30U) ^ rotate((*state1).y, 19U) ^ rotate((*state1).y, 10U)) + bitselect((*state1).w, (*state1).z, ((*state1).y ^ (*state1).w));
  ;

  W[hook(5, 3)].x += (rotate(W[hook(5, 2)].z, 15U) ^ rotate(W[hook(5, 2)].z, 13U) ^ (W[hook(5, 2)].z >> 10U)) + W[hook(5, 1)].y + (rotate(W[hook(5, 3)].y, 25U) ^ rotate(W[hook(5, 3)].y, 14U) ^ (W[hook(5, 3)].y >> 3U));
  (*state0).w += (rotate((*state0).x, 26U) ^ rotate((*state0).x, 21U) ^ rotate((*state0).x, 7U)) + bitselect((*state0).z, (*state0).y, (*state0).x) + W[hook(5, 3)].x + 0xd192e819U;
  (*state1).w += (*state0).w;
  (*state0).w += (rotate((*state1).x, 30U) ^ rotate((*state1).x, 19U) ^ rotate((*state1).x, 10U)) + bitselect((*state1).z, (*state1).y, ((*state1).x ^ (*state1).z));
  ;

  W[hook(5, 3)].y += (rotate(W[hook(5, 2)].w, 15U) ^ rotate(W[hook(5, 2)].w, 13U) ^ (W[hook(5, 2)].w >> 10U)) + W[hook(5, 1)].z + (rotate(W[hook(5, 3)].z, 25U) ^ rotate(W[hook(5, 3)].z, 14U) ^ (W[hook(5, 3)].z >> 3U));
  (*state0).z += (rotate((*state1).w, 26U) ^ rotate((*state1).w, 21U) ^ rotate((*state1).w, 7U)) + bitselect((*state0).y, (*state0).x, (*state1).w) + W[hook(5, 3)].y + 0xd6990624U;
  (*state1).z += (*state0).z;
  (*state0).z += (rotate((*state0).w, 30U) ^ rotate((*state0).w, 19U) ^ rotate((*state0).w, 10U)) + bitselect((*state1).y, (*state1).x, ((*state0).w ^ (*state1).y));
  ;

  W[hook(5, 3)].z += (rotate(W[hook(5, 3)].x, 15U) ^ rotate(W[hook(5, 3)].x, 13U) ^ (W[hook(5, 3)].x >> 10U)) + W[hook(5, 1)].w + (rotate(W[hook(5, 3)].w, 25U) ^ rotate(W[hook(5, 3)].w, 14U) ^ (W[hook(5, 3)].w >> 3U));
  (*state0).y += (rotate((*state1).z, 26U) ^ rotate((*state1).z, 21U) ^ rotate((*state1).z, 7U)) + bitselect((*state0).x, (*state1).w, (*state1).z) + W[hook(5, 3)].z + 0xf40e3585U;
  (*state1).y += (*state0).y;
  (*state0).y += (rotate((*state0).z, 30U) ^ rotate((*state0).z, 19U) ^ rotate((*state0).z, 10U)) + bitselect((*state1).x, (*state0).w, ((*state0).z ^ (*state1).x));
  ;

  W[hook(5, 3)].w += (rotate(W[hook(5, 3)].y, 15U) ^ rotate(W[hook(5, 3)].y, 13U) ^ (W[hook(5, 3)].y >> 10U)) + W[hook(5, 2)].x + (rotate(W[hook(5, 0)].x, 25U) ^ rotate(W[hook(5, 0)].x, 14U) ^ (W[hook(5, 0)].x >> 3U));
  (*state0).x += (rotate((*state1).y, 26U) ^ rotate((*state1).y, 21U) ^ rotate((*state1).y, 7U)) + bitselect((*state1).w, (*state1).z, (*state1).y) + W[hook(5, 3)].w + 0x106aa070U;
  (*state1).x += (*state0).x;
  (*state0).x += (rotate((*state0).y, 30U) ^ rotate((*state0).y, 19U) ^ rotate((*state0).y, 10U)) + bitselect((*state0).w, (*state0).z, ((*state0).y ^ (*state0).w));
  ;

  W[hook(5, 0)].x += (rotate(W[hook(5, 3)].z, 15U) ^ rotate(W[hook(5, 3)].z, 13U) ^ (W[hook(5, 3)].z >> 10U)) + W[hook(5, 2)].y + (rotate(W[hook(5, 0)].y, 25U) ^ rotate(W[hook(5, 0)].y, 14U) ^ (W[hook(5, 0)].y >> 3U));
  (*state1).w += (rotate((*state1).x, 26U) ^ rotate((*state1).x, 21U) ^ rotate((*state1).x, 7U)) + bitselect((*state1).z, (*state1).y, (*state1).x) + W[hook(5, 0)].x + 0x19a4c116U;
  (*state0).w += (*state1).w;
  (*state1).w += (rotate((*state0).x, 30U) ^ rotate((*state0).x, 19U) ^ rotate((*state0).x, 10U)) + bitselect((*state0).z, (*state0).y, ((*state0).x ^ (*state0).z));
  ;

  W[hook(5, 0)].y += (rotate(W[hook(5, 3)].w, 15U) ^ rotate(W[hook(5, 3)].w, 13U) ^ (W[hook(5, 3)].w >> 10U)) + W[hook(5, 2)].z + (rotate(W[hook(5, 0)].z, 25U) ^ rotate(W[hook(5, 0)].z, 14U) ^ (W[hook(5, 0)].z >> 3U));
  (*state1).z += (rotate((*state0).w, 26U) ^ rotate((*state0).w, 21U) ^ rotate((*state0).w, 7U)) + bitselect((*state1).y, (*state1).x, (*state0).w) + W[hook(5, 0)].y + 0x1e376c08U;
  (*state0).z += (*state1).z;
  (*state1).z += (rotate((*state1).w, 30U) ^ rotate((*state1).w, 19U) ^ rotate((*state1).w, 10U)) + bitselect((*state0).y, (*state0).x, ((*state1).w ^ (*state0).y));
  ;

  W[hook(5, 0)].z += (rotate(W[hook(5, 0)].x, 15U) ^ rotate(W[hook(5, 0)].x, 13U) ^ (W[hook(5, 0)].x >> 10U)) + W[hook(5, 2)].w + (rotate(W[hook(5, 0)].w, 25U) ^ rotate(W[hook(5, 0)].w, 14U) ^ (W[hook(5, 0)].w >> 3U));
  (*state1).y += (rotate((*state0).z, 26U) ^ rotate((*state0).z, 21U) ^ rotate((*state0).z, 7U)) + bitselect((*state1).x, (*state0).w, (*state0).z) + W[hook(5, 0)].z + 0x2748774cU;
  (*state0).y += (*state1).y;
  (*state1).y += (rotate((*state1).z, 30U) ^ rotate((*state1).z, 19U) ^ rotate((*state1).z, 10U)) + bitselect((*state0).x, (*state1).w, ((*state1).z ^ (*state0).x));
  ;

  W[hook(5, 0)].w += (rotate(W[hook(5, 0)].y, 15U) ^ rotate(W[hook(5, 0)].y, 13U) ^ (W[hook(5, 0)].y >> 10U)) + W[hook(5, 3)].x + (rotate(W[hook(5, 1)].x, 25U) ^ rotate(W[hook(5, 1)].x, 14U) ^ (W[hook(5, 1)].x >> 3U));
  (*state1).x += (rotate((*state0).y, 26U) ^ rotate((*state0).y, 21U) ^ rotate((*state0).y, 7U)) + bitselect((*state0).w, (*state0).z, (*state0).y) + W[hook(5, 0)].w + 0x34b0bcb5U;
  (*state0).x += (*state1).x;
  (*state1).x += (rotate((*state1).y, 30U) ^ rotate((*state1).y, 19U) ^ rotate((*state1).y, 10U)) + bitselect((*state1).w, (*state1).z, ((*state1).y ^ (*state1).w));
  ;

  W[hook(5, 1)].x += (rotate(W[hook(5, 0)].z, 15U) ^ rotate(W[hook(5, 0)].z, 13U) ^ (W[hook(5, 0)].z >> 10U)) + W[hook(5, 3)].y + (rotate(W[hook(5, 1)].y, 25U) ^ rotate(W[hook(5, 1)].y, 14U) ^ (W[hook(5, 1)].y >> 3U));
  (*state0).w += (rotate((*state0).x, 26U) ^ rotate((*state0).x, 21U) ^ rotate((*state0).x, 7U)) + bitselect((*state0).z, (*state0).y, (*state0).x) + W[hook(5, 1)].x + 0x391c0cb3U;
  (*state1).w += (*state0).w;
  (*state0).w += (rotate((*state1).x, 30U) ^ rotate((*state1).x, 19U) ^ rotate((*state1).x, 10U)) + bitselect((*state1).z, (*state1).y, ((*state1).x ^ (*state1).z));
  ;

  W[hook(5, 1)].y += (rotate(W[hook(5, 0)].w, 15U) ^ rotate(W[hook(5, 0)].w, 13U) ^ (W[hook(5, 0)].w >> 10U)) + W[hook(5, 3)].z + (rotate(W[hook(5, 1)].z, 25U) ^ rotate(W[hook(5, 1)].z, 14U) ^ (W[hook(5, 1)].z >> 3U));
  (*state0).z += (rotate((*state1).w, 26U) ^ rotate((*state1).w, 21U) ^ rotate((*state1).w, 7U)) + bitselect((*state0).y, (*state0).x, (*state1).w) + W[hook(5, 1)].y + 0x4ed8aa4aU;
  (*state1).z += (*state0).z;
  (*state0).z += (rotate((*state0).w, 30U) ^ rotate((*state0).w, 19U) ^ rotate((*state0).w, 10U)) + bitselect((*state1).y, (*state1).x, ((*state0).w ^ (*state1).y));
  ;

  W[hook(5, 1)].z += (rotate(W[hook(5, 1)].x, 15U) ^ rotate(W[hook(5, 1)].x, 13U) ^ (W[hook(5, 1)].x >> 10U)) + W[hook(5, 3)].w + (rotate(W[hook(5, 1)].w, 25U) ^ rotate(W[hook(5, 1)].w, 14U) ^ (W[hook(5, 1)].w >> 3U));
  (*state0).y += (rotate((*state1).z, 26U) ^ rotate((*state1).z, 21U) ^ rotate((*state1).z, 7U)) + bitselect((*state0).x, (*state1).w, (*state1).z) + W[hook(5, 1)].z + 0x5b9cca4fU;
  (*state1).y += (*state0).y;
  (*state0).y += (rotate((*state0).z, 30U) ^ rotate((*state0).z, 19U) ^ rotate((*state0).z, 10U)) + bitselect((*state1).x, (*state0).w, ((*state0).z ^ (*state1).x));
  ;

  W[hook(5, 1)].w += (rotate(W[hook(5, 1)].y, 15U) ^ rotate(W[hook(5, 1)].y, 13U) ^ (W[hook(5, 1)].y >> 10U)) + W[hook(5, 0)].x + (rotate(W[hook(5, 2)].x, 25U) ^ rotate(W[hook(5, 2)].x, 14U) ^ (W[hook(5, 2)].x >> 3U));
  (*state0).x += (rotate((*state1).y, 26U) ^ rotate((*state1).y, 21U) ^ rotate((*state1).y, 7U)) + bitselect((*state1).w, (*state1).z, (*state1).y) + W[hook(5, 1)].w + 0x682e6ff3U;
  (*state1).x += (*state0).x;
  (*state0).x += (rotate((*state0).y, 30U) ^ rotate((*state0).y, 19U) ^ rotate((*state0).y, 10U)) + bitselect((*state0).w, (*state0).z, ((*state0).y ^ (*state0).w));
  ;

  W[hook(5, 2)].x += (rotate(W[hook(5, 1)].z, 15U) ^ rotate(W[hook(5, 1)].z, 13U) ^ (W[hook(5, 1)].z >> 10U)) + W[hook(5, 0)].y + (rotate(W[hook(5, 2)].y, 25U) ^ rotate(W[hook(5, 2)].y, 14U) ^ (W[hook(5, 2)].y >> 3U));
  (*state1).w += (rotate((*state1).x, 26U) ^ rotate((*state1).x, 21U) ^ rotate((*state1).x, 7U)) + bitselect((*state1).z, (*state1).y, (*state1).x) + W[hook(5, 2)].x + 0x748f82eeU;
  (*state0).w += (*state1).w;
  (*state1).w += (rotate((*state0).x, 30U) ^ rotate((*state0).x, 19U) ^ rotate((*state0).x, 10U)) + bitselect((*state0).z, (*state0).y, ((*state0).x ^ (*state0).z));
  ;

  W[hook(5, 2)].y += (rotate(W[hook(5, 1)].w, 15U) ^ rotate(W[hook(5, 1)].w, 13U) ^ (W[hook(5, 1)].w >> 10U)) + W[hook(5, 0)].z + (rotate(W[hook(5, 2)].z, 25U) ^ rotate(W[hook(5, 2)].z, 14U) ^ (W[hook(5, 2)].z >> 3U));
  (*state1).z += (rotate((*state0).w, 26U) ^ rotate((*state0).w, 21U) ^ rotate((*state0).w, 7U)) + bitselect((*state1).y, (*state1).x, (*state0).w) + W[hook(5, 2)].y + 0x78a5636fU;
  (*state0).z += (*state1).z;
  (*state1).z += (rotate((*state1).w, 30U) ^ rotate((*state1).w, 19U) ^ rotate((*state1).w, 10U)) + bitselect((*state0).y, (*state0).x, ((*state1).w ^ (*state0).y));
  ;

  W[hook(5, 2)].z += (rotate(W[hook(5, 2)].x, 15U) ^ rotate(W[hook(5, 2)].x, 13U) ^ (W[hook(5, 2)].x >> 10U)) + W[hook(5, 0)].w + (rotate(W[hook(5, 2)].w, 25U) ^ rotate(W[hook(5, 2)].w, 14U) ^ (W[hook(5, 2)].w >> 3U));
  (*state1).y += (rotate((*state0).z, 26U) ^ rotate((*state0).z, 21U) ^ rotate((*state0).z, 7U)) + bitselect((*state1).x, (*state0).w, (*state0).z) + W[hook(5, 2)].z + 0x84c87814U;
  (*state0).y += (*state1).y;
  (*state1).y += (rotate((*state1).z, 30U) ^ rotate((*state1).z, 19U) ^ rotate((*state1).z, 10U)) + bitselect((*state0).x, (*state1).w, ((*state1).z ^ (*state0).x));
  ;

  W[hook(5, 2)].w += (rotate(W[hook(5, 2)].y, 15U) ^ rotate(W[hook(5, 2)].y, 13U) ^ (W[hook(5, 2)].y >> 10U)) + W[hook(5, 1)].x + (rotate(W[hook(5, 3)].x, 25U) ^ rotate(W[hook(5, 3)].x, 14U) ^ (W[hook(5, 3)].x >> 3U));
  (*state1).x += (rotate((*state0).y, 26U) ^ rotate((*state0).y, 21U) ^ rotate((*state0).y, 7U)) + bitselect((*state0).w, (*state0).z, (*state0).y) + W[hook(5, 2)].w + 0x8cc70208U;
  (*state0).x += (*state1).x;
  (*state1).x += (rotate((*state1).y, 30U) ^ rotate((*state1).y, 19U) ^ rotate((*state1).y, 10U)) + bitselect((*state1).w, (*state1).z, ((*state1).y ^ (*state1).w));
  ;

  W[hook(5, 3)].x += (rotate(W[hook(5, 2)].z, 15U) ^ rotate(W[hook(5, 2)].z, 13U) ^ (W[hook(5, 2)].z >> 10U)) + W[hook(5, 1)].y + (rotate(W[hook(5, 3)].y, 25U) ^ rotate(W[hook(5, 3)].y, 14U) ^ (W[hook(5, 3)].y >> 3U));
  (*state0).w += (rotate((*state0).x, 26U) ^ rotate((*state0).x, 21U) ^ rotate((*state0).x, 7U)) + bitselect((*state0).z, (*state0).y, (*state0).x) + W[hook(5, 3)].x + 0x90befffaU;
  (*state1).w += (*state0).w;
  (*state0).w += (rotate((*state1).x, 30U) ^ rotate((*state1).x, 19U) ^ rotate((*state1).x, 10U)) + bitselect((*state1).z, (*state1).y, ((*state1).x ^ (*state1).z));
  ;

  W[hook(5, 3)].y += (rotate(W[hook(5, 2)].w, 15U) ^ rotate(W[hook(5, 2)].w, 13U) ^ (W[hook(5, 2)].w >> 10U)) + W[hook(5, 1)].z + (rotate(W[hook(5, 3)].z, 25U) ^ rotate(W[hook(5, 3)].z, 14U) ^ (W[hook(5, 3)].z >> 3U));
  (*state0).z += (rotate((*state1).w, 26U) ^ rotate((*state1).w, 21U) ^ rotate((*state1).w, 7U)) + bitselect((*state0).y, (*state0).x, (*state1).w) + W[hook(5, 3)].y + 0xa4506cebU;
  (*state1).z += (*state0).z;
  (*state0).z += (rotate((*state0).w, 30U) ^ rotate((*state0).w, 19U) ^ rotate((*state0).w, 10U)) + bitselect((*state1).y, (*state1).x, ((*state0).w ^ (*state1).y));
  ;

  W[hook(5, 3)].z += (rotate(W[hook(5, 3)].x, 15U) ^ rotate(W[hook(5, 3)].x, 13U) ^ (W[hook(5, 3)].x >> 10U)) + W[hook(5, 1)].w + (rotate(W[hook(5, 3)].w, 25U) ^ rotate(W[hook(5, 3)].w, 14U) ^ (W[hook(5, 3)].w >> 3U));
  (*state0).y += (rotate((*state1).z, 26U) ^ rotate((*state1).z, 21U) ^ rotate((*state1).z, 7U)) + bitselect((*state0).x, (*state1).w, (*state1).z) + W[hook(5, 3)].z + 0xbef9a3f7U;
  (*state1).y += (*state0).y;
  (*state0).y += (rotate((*state0).z, 30U) ^ rotate((*state0).z, 19U) ^ rotate((*state0).z, 10U)) + bitselect((*state1).x, (*state0).w, ((*state0).z ^ (*state1).x));
  ;

  W[hook(5, 3)].w += (rotate(W[hook(5, 3)].y, 15U) ^ rotate(W[hook(5, 3)].y, 13U) ^ (W[hook(5, 3)].y >> 10U)) + W[hook(5, 2)].x + (rotate(W[hook(5, 0)].x, 25U) ^ rotate(W[hook(5, 0)].x, 14U) ^ (W[hook(5, 0)].x >> 3U));
  (*state0).x += (rotate((*state1).y, 26U) ^ rotate((*state1).y, 21U) ^ rotate((*state1).y, 7U)) + bitselect((*state1).w, (*state1).z, (*state1).y) + W[hook(5, 3)].w + 0xc67178f2U;
  (*state1).x += (*state0).x;
  (*state0).x += (rotate((*state0).y, 30U) ^ rotate((*state0).y, 19U) ^ rotate((*state0).y, 10U)) + bitselect((*state0).w, (*state0).z, ((*state0).y ^ (*state0).w));
  ;
  *state0 += (uint4)(0x6A09E667U, 0xBB67AE85U, 0x3C6EF372U, 0xA54FF53AU);
  *state1 += (uint4)(0x510E527FU, 0x9B05688CU, 0x1F83D9ABU, 0x5BE0CD19U);
}

constant unsigned int fixedW[64] = {
    0x428a2f99, 0xf1374491, 0xb5c0fbcf, 0xe9b5dba5, 0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5, 0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3, 0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf794, 0xf59b89c2, 0x73924787, 0x23c6886e, 0xa42ca65c, 0x15ed3627, 0x4d6edcbf, 0xe28217fc, 0xef02488f, 0xb707775c, 0x0468c23f, 0xe7e72b4c, 0x49e1f1a2, 0x4b99c816, 0x926d1570, 0xaa0fc072, 0xadb36e2c, 0xad87a3ea, 0xbcb1d3a3, 0x7b993186, 0x562b9420, 0xbff3ca0c, 0xda4b0c23, 0x6cd8711a, 0x8f337caa, 0xc91b1417, 0xc359dce1, 0xa83253a7, 0x3b13c12d, 0x9d3d725d, 0xd9031a84, 0xb1a03340, 0x16f58012, 0xe64fb6a2, 0xe84d923a, 0xe93a5730, 0x09837686, 0x078ff753, 0x29833341, 0xd5de0b7e, 0x6948ccf4, 0xe0a1adbe, 0x7c728e11, 0x511c78e4, 0x315b45bd, 0xfca71413, 0xea28f96a, 0x79703128, 0x4e1ef848,
};

void SHA256_fixed(uint4* restrict state0, uint4* restrict state1) {
  uint4 S0 = *state0;
  uint4 S1 = *state1;
  S1.w += (rotate(S1.x, 26U) ^ rotate(S1.x, 21U) ^ rotate(S1.x, 7U)) + bitselect(S1.z, S1.y, S1.x) + fixedW[hook(6, 0)];
  S0.w += S1.w;
  S1.w += (rotate(S0.x, 30U) ^ rotate(S0.x, 19U) ^ rotate(S0.x, 10U)) + bitselect(S0.z, S0.y, (S0.x ^ S0.z));
  ;
  S1.z += (rotate(S0.w, 26U) ^ rotate(S0.w, 21U) ^ rotate(S0.w, 7U)) + bitselect(S1.y, S1.x, S0.w) + fixedW[hook(6, 1)];
  S0.z += S1.z;
  S1.z += (rotate(S1.w, 30U) ^ rotate(S1.w, 19U) ^ rotate(S1.w, 10U)) + bitselect(S0.y, S0.x, (S1.w ^ S0.y));
  ;
  S1.y += (rotate(S0.z, 26U) ^ rotate(S0.z, 21U) ^ rotate(S0.z, 7U)) + bitselect(S1.x, S0.w, S0.z) + fixedW[hook(6, 2)];
  S0.y += S1.y;
  S1.y += (rotate(S1.z, 30U) ^ rotate(S1.z, 19U) ^ rotate(S1.z, 10U)) + bitselect(S0.x, S1.w, (S1.z ^ S0.x));
  ;
  S1.x += (rotate(S0.y, 26U) ^ rotate(S0.y, 21U) ^ rotate(S0.y, 7U)) + bitselect(S0.w, S0.z, S0.y) + fixedW[hook(6, 3)];
  S0.x += S1.x;
  S1.x += (rotate(S1.y, 30U) ^ rotate(S1.y, 19U) ^ rotate(S1.y, 10U)) + bitselect(S1.w, S1.z, (S1.y ^ S1.w));
  ;
  S0.w += (rotate(S0.x, 26U) ^ rotate(S0.x, 21U) ^ rotate(S0.x, 7U)) + bitselect(S0.z, S0.y, S0.x) + fixedW[hook(6, 4)];
  S1.w += S0.w;
  S0.w += (rotate(S1.x, 30U) ^ rotate(S1.x, 19U) ^ rotate(S1.x, 10U)) + bitselect(S1.z, S1.y, (S1.x ^ S1.z));
  ;
  S0.z += (rotate(S1.w, 26U) ^ rotate(S1.w, 21U) ^ rotate(S1.w, 7U)) + bitselect(S0.y, S0.x, S1.w) + fixedW[hook(6, 5)];
  S1.z += S0.z;
  S0.z += (rotate(S0.w, 30U) ^ rotate(S0.w, 19U) ^ rotate(S0.w, 10U)) + bitselect(S1.y, S1.x, (S0.w ^ S1.y));
  ;
  S0.y += (rotate(S1.z, 26U) ^ rotate(S1.z, 21U) ^ rotate(S1.z, 7U)) + bitselect(S0.x, S1.w, S1.z) + fixedW[hook(6, 6)];
  S1.y += S0.y;
  S0.y += (rotate(S0.z, 30U) ^ rotate(S0.z, 19U) ^ rotate(S0.z, 10U)) + bitselect(S1.x, S0.w, (S0.z ^ S1.x));
  ;
  S0.x += (rotate(S1.y, 26U) ^ rotate(S1.y, 21U) ^ rotate(S1.y, 7U)) + bitselect(S1.w, S1.z, S1.y) + fixedW[hook(6, 7)];
  S1.x += S0.x;
  S0.x += (rotate(S0.y, 30U) ^ rotate(S0.y, 19U) ^ rotate(S0.y, 10U)) + bitselect(S0.w, S0.z, (S0.y ^ S0.w));
  ;
  S1.w += (rotate(S1.x, 26U) ^ rotate(S1.x, 21U) ^ rotate(S1.x, 7U)) + bitselect(S1.z, S1.y, S1.x) + fixedW[hook(6, 8)];
  S0.w += S1.w;
  S1.w += (rotate(S0.x, 30U) ^ rotate(S0.x, 19U) ^ rotate(S0.x, 10U)) + bitselect(S0.z, S0.y, (S0.x ^ S0.z));
  ;
  S1.z += (rotate(S0.w, 26U) ^ rotate(S0.w, 21U) ^ rotate(S0.w, 7U)) + bitselect(S1.y, S1.x, S0.w) + fixedW[hook(6, 9)];
  S0.z += S1.z;
  S1.z += (rotate(S1.w, 30U) ^ rotate(S1.w, 19U) ^ rotate(S1.w, 10U)) + bitselect(S0.y, S0.x, (S1.w ^ S0.y));
  ;
  S1.y += (rotate(S0.z, 26U) ^ rotate(S0.z, 21U) ^ rotate(S0.z, 7U)) + bitselect(S1.x, S0.w, S0.z) + fixedW[hook(6, 10)];
  S0.y += S1.y;
  S1.y += (rotate(S1.z, 30U) ^ rotate(S1.z, 19U) ^ rotate(S1.z, 10U)) + bitselect(S0.x, S1.w, (S1.z ^ S0.x));
  ;
  S1.x += (rotate(S0.y, 26U) ^ rotate(S0.y, 21U) ^ rotate(S0.y, 7U)) + bitselect(S0.w, S0.z, S0.y) + fixedW[hook(6, 11)];
  S0.x += S1.x;
  S1.x += (rotate(S1.y, 30U) ^ rotate(S1.y, 19U) ^ rotate(S1.y, 10U)) + bitselect(S1.w, S1.z, (S1.y ^ S1.w));
  ;
  S0.w += (rotate(S0.x, 26U) ^ rotate(S0.x, 21U) ^ rotate(S0.x, 7U)) + bitselect(S0.z, S0.y, S0.x) + fixedW[hook(6, 12)];
  S1.w += S0.w;
  S0.w += (rotate(S1.x, 30U) ^ rotate(S1.x, 19U) ^ rotate(S1.x, 10U)) + bitselect(S1.z, S1.y, (S1.x ^ S1.z));
  ;
  S0.z += (rotate(S1.w, 26U) ^ rotate(S1.w, 21U) ^ rotate(S1.w, 7U)) + bitselect(S0.y, S0.x, S1.w) + fixedW[hook(6, 13)];
  S1.z += S0.z;
  S0.z += (rotate(S0.w, 30U) ^ rotate(S0.w, 19U) ^ rotate(S0.w, 10U)) + bitselect(S1.y, S1.x, (S0.w ^ S1.y));
  ;
  S0.y += (rotate(S1.z, 26U) ^ rotate(S1.z, 21U) ^ rotate(S1.z, 7U)) + bitselect(S0.x, S1.w, S1.z) + fixedW[hook(6, 14)];
  S1.y += S0.y;
  S0.y += (rotate(S0.z, 30U) ^ rotate(S0.z, 19U) ^ rotate(S0.z, 10U)) + bitselect(S1.x, S0.w, (S0.z ^ S1.x));
  ;
  S0.x += (rotate(S1.y, 26U) ^ rotate(S1.y, 21U) ^ rotate(S1.y, 7U)) + bitselect(S1.w, S1.z, S1.y) + fixedW[hook(6, 15)];
  S1.x += S0.x;
  S0.x += (rotate(S0.y, 30U) ^ rotate(S0.y, 19U) ^ rotate(S0.y, 10U)) + bitselect(S0.w, S0.z, (S0.y ^ S0.w));
  ;
  S1.w += (rotate(S1.x, 26U) ^ rotate(S1.x, 21U) ^ rotate(S1.x, 7U)) + bitselect(S1.z, S1.y, S1.x) + fixedW[hook(6, 16)];
  S0.w += S1.w;
  S1.w += (rotate(S0.x, 30U) ^ rotate(S0.x, 19U) ^ rotate(S0.x, 10U)) + bitselect(S0.z, S0.y, (S0.x ^ S0.z));
  ;
  S1.z += (rotate(S0.w, 26U) ^ rotate(S0.w, 21U) ^ rotate(S0.w, 7U)) + bitselect(S1.y, S1.x, S0.w) + fixedW[hook(6, 17)];
  S0.z += S1.z;
  S1.z += (rotate(S1.w, 30U) ^ rotate(S1.w, 19U) ^ rotate(S1.w, 10U)) + bitselect(S0.y, S0.x, (S1.w ^ S0.y));
  ;
  S1.y += (rotate(S0.z, 26U) ^ rotate(S0.z, 21U) ^ rotate(S0.z, 7U)) + bitselect(S1.x, S0.w, S0.z) + fixedW[hook(6, 18)];
  S0.y += S1.y;
  S1.y += (rotate(S1.z, 30U) ^ rotate(S1.z, 19U) ^ rotate(S1.z, 10U)) + bitselect(S0.x, S1.w, (S1.z ^ S0.x));
  ;
  S1.x += (rotate(S0.y, 26U) ^ rotate(S0.y, 21U) ^ rotate(S0.y, 7U)) + bitselect(S0.w, S0.z, S0.y) + fixedW[hook(6, 19)];
  S0.x += S1.x;
  S1.x += (rotate(S1.y, 30U) ^ rotate(S1.y, 19U) ^ rotate(S1.y, 10U)) + bitselect(S1.w, S1.z, (S1.y ^ S1.w));
  ;
  S0.w += (rotate(S0.x, 26U) ^ rotate(S0.x, 21U) ^ rotate(S0.x, 7U)) + bitselect(S0.z, S0.y, S0.x) + fixedW[hook(6, 20)];
  S1.w += S0.w;
  S0.w += (rotate(S1.x, 30U) ^ rotate(S1.x, 19U) ^ rotate(S1.x, 10U)) + bitselect(S1.z, S1.y, (S1.x ^ S1.z));
  ;
  S0.z += (rotate(S1.w, 26U) ^ rotate(S1.w, 21U) ^ rotate(S1.w, 7U)) + bitselect(S0.y, S0.x, S1.w) + fixedW[hook(6, 21)];
  S1.z += S0.z;
  S0.z += (rotate(S0.w, 30U) ^ rotate(S0.w, 19U) ^ rotate(S0.w, 10U)) + bitselect(S1.y, S1.x, (S0.w ^ S1.y));
  ;
  S0.y += (rotate(S1.z, 26U) ^ rotate(S1.z, 21U) ^ rotate(S1.z, 7U)) + bitselect(S0.x, S1.w, S1.z) + fixedW[hook(6, 22)];
  S1.y += S0.y;
  S0.y += (rotate(S0.z, 30U) ^ rotate(S0.z, 19U) ^ rotate(S0.z, 10U)) + bitselect(S1.x, S0.w, (S0.z ^ S1.x));
  ;
  S0.x += (rotate(S1.y, 26U) ^ rotate(S1.y, 21U) ^ rotate(S1.y, 7U)) + bitselect(S1.w, S1.z, S1.y) + fixedW[hook(6, 23)];
  S1.x += S0.x;
  S0.x += (rotate(S0.y, 30U) ^ rotate(S0.y, 19U) ^ rotate(S0.y, 10U)) + bitselect(S0.w, S0.z, (S0.y ^ S0.w));
  ;
  S1.w += (rotate(S1.x, 26U) ^ rotate(S1.x, 21U) ^ rotate(S1.x, 7U)) + bitselect(S1.z, S1.y, S1.x) + fixedW[hook(6, 24)];
  S0.w += S1.w;
  S1.w += (rotate(S0.x, 30U) ^ rotate(S0.x, 19U) ^ rotate(S0.x, 10U)) + bitselect(S0.z, S0.y, (S0.x ^ S0.z));
  ;
  S1.z += (rotate(S0.w, 26U) ^ rotate(S0.w, 21U) ^ rotate(S0.w, 7U)) + bitselect(S1.y, S1.x, S0.w) + fixedW[hook(6, 25)];
  S0.z += S1.z;
  S1.z += (rotate(S1.w, 30U) ^ rotate(S1.w, 19U) ^ rotate(S1.w, 10U)) + bitselect(S0.y, S0.x, (S1.w ^ S0.y));
  ;
  S1.y += (rotate(S0.z, 26U) ^ rotate(S0.z, 21U) ^ rotate(S0.z, 7U)) + bitselect(S1.x, S0.w, S0.z) + fixedW[hook(6, 26)];
  S0.y += S1.y;
  S1.y += (rotate(S1.z, 30U) ^ rotate(S1.z, 19U) ^ rotate(S1.z, 10U)) + bitselect(S0.x, S1.w, (S1.z ^ S0.x));
  ;
  S1.x += (rotate(S0.y, 26U) ^ rotate(S0.y, 21U) ^ rotate(S0.y, 7U)) + bitselect(S0.w, S0.z, S0.y) + fixedW[hook(6, 27)];
  S0.x += S1.x;
  S1.x += (rotate(S1.y, 30U) ^ rotate(S1.y, 19U) ^ rotate(S1.y, 10U)) + bitselect(S1.w, S1.z, (S1.y ^ S1.w));
  ;
  S0.w += (rotate(S0.x, 26U) ^ rotate(S0.x, 21U) ^ rotate(S0.x, 7U)) + bitselect(S0.z, S0.y, S0.x) + fixedW[hook(6, 28)];
  S1.w += S0.w;
  S0.w += (rotate(S1.x, 30U) ^ rotate(S1.x, 19U) ^ rotate(S1.x, 10U)) + bitselect(S1.z, S1.y, (S1.x ^ S1.z));
  ;
  S0.z += (rotate(S1.w, 26U) ^ rotate(S1.w, 21U) ^ rotate(S1.w, 7U)) + bitselect(S0.y, S0.x, S1.w) + fixedW[hook(6, 29)];
  S1.z += S0.z;
  S0.z += (rotate(S0.w, 30U) ^ rotate(S0.w, 19U) ^ rotate(S0.w, 10U)) + bitselect(S1.y, S1.x, (S0.w ^ S1.y));
  ;
  S0.y += (rotate(S1.z, 26U) ^ rotate(S1.z, 21U) ^ rotate(S1.z, 7U)) + bitselect(S0.x, S1.w, S1.z) + fixedW[hook(6, 30)];
  S1.y += S0.y;
  S0.y += (rotate(S0.z, 30U) ^ rotate(S0.z, 19U) ^ rotate(S0.z, 10U)) + bitselect(S1.x, S0.w, (S0.z ^ S1.x));
  ;
  S0.x += (rotate(S1.y, 26U) ^ rotate(S1.y, 21U) ^ rotate(S1.y, 7U)) + bitselect(S1.w, S1.z, S1.y) + fixedW[hook(6, 31)];
  S1.x += S0.x;
  S0.x += (rotate(S0.y, 30U) ^ rotate(S0.y, 19U) ^ rotate(S0.y, 10U)) + bitselect(S0.w, S0.z, (S0.y ^ S0.w));
  ;
  S1.w += (rotate(S1.x, 26U) ^ rotate(S1.x, 21U) ^ rotate(S1.x, 7U)) + bitselect(S1.z, S1.y, S1.x) + fixedW[hook(6, 32)];
  S0.w += S1.w;
  S1.w += (rotate(S0.x, 30U) ^ rotate(S0.x, 19U) ^ rotate(S0.x, 10U)) + bitselect(S0.z, S0.y, (S0.x ^ S0.z));
  ;
  S1.z += (rotate(S0.w, 26U) ^ rotate(S0.w, 21U) ^ rotate(S0.w, 7U)) + bitselect(S1.y, S1.x, S0.w) + fixedW[hook(6, 33)];
  S0.z += S1.z;
  S1.z += (rotate(S1.w, 30U) ^ rotate(S1.w, 19U) ^ rotate(S1.w, 10U)) + bitselect(S0.y, S0.x, (S1.w ^ S0.y));
  ;
  S1.y += (rotate(S0.z, 26U) ^ rotate(S0.z, 21U) ^ rotate(S0.z, 7U)) + bitselect(S1.x, S0.w, S0.z) + fixedW[hook(6, 34)];
  S0.y += S1.y;
  S1.y += (rotate(S1.z, 30U) ^ rotate(S1.z, 19U) ^ rotate(S1.z, 10U)) + bitselect(S0.x, S1.w, (S1.z ^ S0.x));
  ;
  S1.x += (rotate(S0.y, 26U) ^ rotate(S0.y, 21U) ^ rotate(S0.y, 7U)) + bitselect(S0.w, S0.z, S0.y) + fixedW[hook(6, 35)];
  S0.x += S1.x;
  S1.x += (rotate(S1.y, 30U) ^ rotate(S1.y, 19U) ^ rotate(S1.y, 10U)) + bitselect(S1.w, S1.z, (S1.y ^ S1.w));
  ;
  S0.w += (rotate(S0.x, 26U) ^ rotate(S0.x, 21U) ^ rotate(S0.x, 7U)) + bitselect(S0.z, S0.y, S0.x) + fixedW[hook(6, 36)];
  S1.w += S0.w;
  S0.w += (rotate(S1.x, 30U) ^ rotate(S1.x, 19U) ^ rotate(S1.x, 10U)) + bitselect(S1.z, S1.y, (S1.x ^ S1.z));
  ;
  S0.z += (rotate(S1.w, 26U) ^ rotate(S1.w, 21U) ^ rotate(S1.w, 7U)) + bitselect(S0.y, S0.x, S1.w) + fixedW[hook(6, 37)];
  S1.z += S0.z;
  S0.z += (rotate(S0.w, 30U) ^ rotate(S0.w, 19U) ^ rotate(S0.w, 10U)) + bitselect(S1.y, S1.x, (S0.w ^ S1.y));
  ;
  S0.y += (rotate(S1.z, 26U) ^ rotate(S1.z, 21U) ^ rotate(S1.z, 7U)) + bitselect(S0.x, S1.w, S1.z) + fixedW[hook(6, 38)];
  S1.y += S0.y;
  S0.y += (rotate(S0.z, 30U) ^ rotate(S0.z, 19U) ^ rotate(S0.z, 10U)) + bitselect(S1.x, S0.w, (S0.z ^ S1.x));
  ;
  S0.x += (rotate(S1.y, 26U) ^ rotate(S1.y, 21U) ^ rotate(S1.y, 7U)) + bitselect(S1.w, S1.z, S1.y) + fixedW[hook(6, 39)];
  S1.x += S0.x;
  S0.x += (rotate(S0.y, 30U) ^ rotate(S0.y, 19U) ^ rotate(S0.y, 10U)) + bitselect(S0.w, S0.z, (S0.y ^ S0.w));
  ;
  S1.w += (rotate(S1.x, 26U) ^ rotate(S1.x, 21U) ^ rotate(S1.x, 7U)) + bitselect(S1.z, S1.y, S1.x) + fixedW[hook(6, 40)];
  S0.w += S1.w;
  S1.w += (rotate(S0.x, 30U) ^ rotate(S0.x, 19U) ^ rotate(S0.x, 10U)) + bitselect(S0.z, S0.y, (S0.x ^ S0.z));
  ;
  S1.z += (rotate(S0.w, 26U) ^ rotate(S0.w, 21U) ^ rotate(S0.w, 7U)) + bitselect(S1.y, S1.x, S0.w) + fixedW[hook(6, 41)];
  S0.z += S1.z;
  S1.z += (rotate(S1.w, 30U) ^ rotate(S1.w, 19U) ^ rotate(S1.w, 10U)) + bitselect(S0.y, S0.x, (S1.w ^ S0.y));
  ;
  S1.y += (rotate(S0.z, 26U) ^ rotate(S0.z, 21U) ^ rotate(S0.z, 7U)) + bitselect(S1.x, S0.w, S0.z) + fixedW[hook(6, 42)];
  S0.y += S1.y;
  S1.y += (rotate(S1.z, 30U) ^ rotate(S1.z, 19U) ^ rotate(S1.z, 10U)) + bitselect(S0.x, S1.w, (S1.z ^ S0.x));
  ;
  S1.x += (rotate(S0.y, 26U) ^ rotate(S0.y, 21U) ^ rotate(S0.y, 7U)) + bitselect(S0.w, S0.z, S0.y) + fixedW[hook(6, 43)];
  S0.x += S1.x;
  S1.x += (rotate(S1.y, 30U) ^ rotate(S1.y, 19U) ^ rotate(S1.y, 10U)) + bitselect(S1.w, S1.z, (S1.y ^ S1.w));
  ;
  S0.w += (rotate(S0.x, 26U) ^ rotate(S0.x, 21U) ^ rotate(S0.x, 7U)) + bitselect(S0.z, S0.y, S0.x) + fixedW[hook(6, 44)];
  S1.w += S0.w;
  S0.w += (rotate(S1.x, 30U) ^ rotate(S1.x, 19U) ^ rotate(S1.x, 10U)) + bitselect(S1.z, S1.y, (S1.x ^ S1.z));
  ;
  S0.z += (rotate(S1.w, 26U) ^ rotate(S1.w, 21U) ^ rotate(S1.w, 7U)) + bitselect(S0.y, S0.x, S1.w) + fixedW[hook(6, 45)];
  S1.z += S0.z;
  S0.z += (rotate(S0.w, 30U) ^ rotate(S0.w, 19U) ^ rotate(S0.w, 10U)) + bitselect(S1.y, S1.x, (S0.w ^ S1.y));
  ;
  S0.y += (rotate(S1.z, 26U) ^ rotate(S1.z, 21U) ^ rotate(S1.z, 7U)) + bitselect(S0.x, S1.w, S1.z) + fixedW[hook(6, 46)];
  S1.y += S0.y;
  S0.y += (rotate(S0.z, 30U) ^ rotate(S0.z, 19U) ^ rotate(S0.z, 10U)) + bitselect(S1.x, S0.w, (S0.z ^ S1.x));
  ;
  S0.x += (rotate(S1.y, 26U) ^ rotate(S1.y, 21U) ^ rotate(S1.y, 7U)) + bitselect(S1.w, S1.z, S1.y) + fixedW[hook(6, 47)];
  S1.x += S0.x;
  S0.x += (rotate(S0.y, 30U) ^ rotate(S0.y, 19U) ^ rotate(S0.y, 10U)) + bitselect(S0.w, S0.z, (S0.y ^ S0.w));
  ;
  S1.w += (rotate(S1.x, 26U) ^ rotate(S1.x, 21U) ^ rotate(S1.x, 7U)) + bitselect(S1.z, S1.y, S1.x) + fixedW[hook(6, 48)];
  S0.w += S1.w;
  S1.w += (rotate(S0.x, 30U) ^ rotate(S0.x, 19U) ^ rotate(S0.x, 10U)) + bitselect(S0.z, S0.y, (S0.x ^ S0.z));
  ;
  S1.z += (rotate(S0.w, 26U) ^ rotate(S0.w, 21U) ^ rotate(S0.w, 7U)) + bitselect(S1.y, S1.x, S0.w) + fixedW[hook(6, 49)];
  S0.z += S1.z;
  S1.z += (rotate(S1.w, 30U) ^ rotate(S1.w, 19U) ^ rotate(S1.w, 10U)) + bitselect(S0.y, S0.x, (S1.w ^ S0.y));
  ;
  S1.y += (rotate(S0.z, 26U) ^ rotate(S0.z, 21U) ^ rotate(S0.z, 7U)) + bitselect(S1.x, S0.w, S0.z) + fixedW[hook(6, 50)];
  S0.y += S1.y;
  S1.y += (rotate(S1.z, 30U) ^ rotate(S1.z, 19U) ^ rotate(S1.z, 10U)) + bitselect(S0.x, S1.w, (S1.z ^ S0.x));
  ;
  S1.x += (rotate(S0.y, 26U) ^ rotate(S0.y, 21U) ^ rotate(S0.y, 7U)) + bitselect(S0.w, S0.z, S0.y) + fixedW[hook(6, 51)];
  S0.x += S1.x;
  S1.x += (rotate(S1.y, 30U) ^ rotate(S1.y, 19U) ^ rotate(S1.y, 10U)) + bitselect(S1.w, S1.z, (S1.y ^ S1.w));
  ;
  S0.w += (rotate(S0.x, 26U) ^ rotate(S0.x, 21U) ^ rotate(S0.x, 7U)) + bitselect(S0.z, S0.y, S0.x) + fixedW[hook(6, 52)];
  S1.w += S0.w;
  S0.w += (rotate(S1.x, 30U) ^ rotate(S1.x, 19U) ^ rotate(S1.x, 10U)) + bitselect(S1.z, S1.y, (S1.x ^ S1.z));
  ;
  S0.z += (rotate(S1.w, 26U) ^ rotate(S1.w, 21U) ^ rotate(S1.w, 7U)) + bitselect(S0.y, S0.x, S1.w) + fixedW[hook(6, 53)];
  S1.z += S0.z;
  S0.z += (rotate(S0.w, 30U) ^ rotate(S0.w, 19U) ^ rotate(S0.w, 10U)) + bitselect(S1.y, S1.x, (S0.w ^ S1.y));
  ;
  S0.y += (rotate(S1.z, 26U) ^ rotate(S1.z, 21U) ^ rotate(S1.z, 7U)) + bitselect(S0.x, S1.w, S1.z) + fixedW[hook(6, 54)];
  S1.y += S0.y;
  S0.y += (rotate(S0.z, 30U) ^ rotate(S0.z, 19U) ^ rotate(S0.z, 10U)) + bitselect(S1.x, S0.w, (S0.z ^ S1.x));
  ;
  S0.x += (rotate(S1.y, 26U) ^ rotate(S1.y, 21U) ^ rotate(S1.y, 7U)) + bitselect(S1.w, S1.z, S1.y) + fixedW[hook(6, 55)];
  S1.x += S0.x;
  S0.x += (rotate(S0.y, 30U) ^ rotate(S0.y, 19U) ^ rotate(S0.y, 10U)) + bitselect(S0.w, S0.z, (S0.y ^ S0.w));
  ;
  S1.w += (rotate(S1.x, 26U) ^ rotate(S1.x, 21U) ^ rotate(S1.x, 7U)) + bitselect(S1.z, S1.y, S1.x) + fixedW[hook(6, 56)];
  S0.w += S1.w;
  S1.w += (rotate(S0.x, 30U) ^ rotate(S0.x, 19U) ^ rotate(S0.x, 10U)) + bitselect(S0.z, S0.y, (S0.x ^ S0.z));
  ;
  S1.z += (rotate(S0.w, 26U) ^ rotate(S0.w, 21U) ^ rotate(S0.w, 7U)) + bitselect(S1.y, S1.x, S0.w) + fixedW[hook(6, 57)];
  S0.z += S1.z;
  S1.z += (rotate(S1.w, 30U) ^ rotate(S1.w, 19U) ^ rotate(S1.w, 10U)) + bitselect(S0.y, S0.x, (S1.w ^ S0.y));
  ;
  S1.y += (rotate(S0.z, 26U) ^ rotate(S0.z, 21U) ^ rotate(S0.z, 7U)) + bitselect(S1.x, S0.w, S0.z) + fixedW[hook(6, 58)];
  S0.y += S1.y;
  S1.y += (rotate(S1.z, 30U) ^ rotate(S1.z, 19U) ^ rotate(S1.z, 10U)) + bitselect(S0.x, S1.w, (S1.z ^ S0.x));
  ;
  S1.x += (rotate(S0.y, 26U) ^ rotate(S0.y, 21U) ^ rotate(S0.y, 7U)) + bitselect(S0.w, S0.z, S0.y) + fixedW[hook(6, 59)];
  S0.x += S1.x;
  S1.x += (rotate(S1.y, 30U) ^ rotate(S1.y, 19U) ^ rotate(S1.y, 10U)) + bitselect(S1.w, S1.z, (S1.y ^ S1.w));
  ;
  S0.w += (rotate(S0.x, 26U) ^ rotate(S0.x, 21U) ^ rotate(S0.x, 7U)) + bitselect(S0.z, S0.y, S0.x) + fixedW[hook(6, 60)];
  S1.w += S0.w;
  S0.w += (rotate(S1.x, 30U) ^ rotate(S1.x, 19U) ^ rotate(S1.x, 10U)) + bitselect(S1.z, S1.y, (S1.x ^ S1.z));
  ;
  S0.z += (rotate(S1.w, 26U) ^ rotate(S1.w, 21U) ^ rotate(S1.w, 7U)) + bitselect(S0.y, S0.x, S1.w) + fixedW[hook(6, 61)];
  S1.z += S0.z;
  S0.z += (rotate(S0.w, 30U) ^ rotate(S0.w, 19U) ^ rotate(S0.w, 10U)) + bitselect(S1.y, S1.x, (S0.w ^ S1.y));
  ;
  S0.y += (rotate(S1.z, 26U) ^ rotate(S1.z, 21U) ^ rotate(S1.z, 7U)) + bitselect(S0.x, S1.w, S1.z) + fixedW[hook(6, 62)];
  S1.y += S0.y;
  S0.y += (rotate(S0.z, 30U) ^ rotate(S0.z, 19U) ^ rotate(S0.z, 10U)) + bitselect(S1.x, S0.w, (S0.z ^ S1.x));
  ;
  S0.x += (rotate(S1.y, 26U) ^ rotate(S1.y, 21U) ^ rotate(S1.y, 7U)) + bitselect(S1.w, S1.z, S1.y) + fixedW[hook(6, 63)];
  S1.x += S0.x;
  S0.x += (rotate(S0.y, 30U) ^ rotate(S0.y, 19U) ^ rotate(S0.y, 10U)) + bitselect(S0.w, S0.z, (S0.y ^ S0.w));
  ;
  *state0 += S0;
  *state1 += S1;
}

void shittify(uint4 B[8]) {
  uint4 tmp[4];
  tmp[hook(7, 0)] = (uint4)(B[hook(8, 1)].x, B[hook(8, 2)].y, B[hook(8, 3)].z, B[hook(8, 0)].w);
  tmp[hook(7, 1)] = (uint4)(B[hook(8, 2)].x, B[hook(8, 3)].y, B[hook(8, 0)].z, B[hook(8, 1)].w);
  tmp[hook(7, 2)] = (uint4)(B[hook(8, 3)].x, B[hook(8, 0)].y, B[hook(8, 1)].z, B[hook(8, 2)].w);
  tmp[hook(7, 3)] = (uint4)(B[hook(8, 0)].x, B[hook(8, 1)].y, B[hook(8, 2)].z, B[hook(8, 3)].w);

  for (unsigned int i = 0; i < 4; ++i)
    B[hook(8, i)] = EndianSwap4(tmp[hook(7, i)]);

  tmp[hook(7, 0)] = (uint4)(B[hook(8, 5)].x, B[hook(8, 6)].y, B[hook(8, 7)].z, B[hook(8, 4)].w);
  tmp[hook(7, 1)] = (uint4)(B[hook(8, 6)].x, B[hook(8, 7)].y, B[hook(8, 4)].z, B[hook(8, 5)].w);
  tmp[hook(7, 2)] = (uint4)(B[hook(8, 7)].x, B[hook(8, 4)].y, B[hook(8, 5)].z, B[hook(8, 6)].w);
  tmp[hook(7, 3)] = (uint4)(B[hook(8, 4)].x, B[hook(8, 5)].y, B[hook(8, 6)].z, B[hook(8, 7)].w);

  for (unsigned int i = 0; i < 4; ++i)
    B[hook(8, i + 4)] = EndianSwap4(tmp[hook(7, i)]);
}

void unshittify(uint4 B[8]) {
  uint4 tmp[4];
  tmp[hook(7, 0)] = (uint4)(B[hook(8, 3)].x, B[hook(8, 2)].y, B[hook(8, 1)].z, B[hook(8, 0)].w);
  tmp[hook(7, 1)] = (uint4)(B[hook(8, 0)].x, B[hook(8, 3)].y, B[hook(8, 2)].z, B[hook(8, 1)].w);
  tmp[hook(7, 2)] = (uint4)(B[hook(8, 1)].x, B[hook(8, 0)].y, B[hook(8, 3)].z, B[hook(8, 2)].w);
  tmp[hook(7, 3)] = (uint4)(B[hook(8, 2)].x, B[hook(8, 1)].y, B[hook(8, 0)].z, B[hook(8, 3)].w);

  for (unsigned int i = 0; i < 4; ++i)
    B[hook(8, i)] = EndianSwap4(tmp[hook(7, i)]);

  tmp[hook(7, 0)] = (uint4)(B[hook(8, 7)].x, B[hook(8, 6)].y, B[hook(8, 5)].z, B[hook(8, 4)].w);
  tmp[hook(7, 1)] = (uint4)(B[hook(8, 4)].x, B[hook(8, 7)].y, B[hook(8, 6)].z, B[hook(8, 5)].w);
  tmp[hook(7, 2)] = (uint4)(B[hook(8, 5)].x, B[hook(8, 4)].y, B[hook(8, 7)].z, B[hook(8, 6)].w);
  tmp[hook(7, 3)] = (uint4)(B[hook(8, 6)].x, B[hook(8, 5)].y, B[hook(8, 4)].z, B[hook(8, 7)].w);

  for (unsigned int i = 0; i < 4; ++i)
    B[hook(8, i + 4)] = EndianSwap4(tmp[hook(7, i)]);
}

void salsa(uint4 B[8]) {
  uint4 w[4];

  for (unsigned int i = 0; i < 4; ++i)
    w[hook(9, i)] = (B[hook(8, i)] ^= B[hook(8, i + 4)]);

  for (unsigned int i = 0; i < 4; ++i) {
    w[hook(9, 0)] ^= rotate(w[hook(9, 3)] + w[hook(9, 2)], 7U);
    w[hook(9, 1)] ^= rotate(w[hook(9, 0)] + w[hook(9, 3)], 9U);
    w[hook(9, 2)] ^= rotate(w[hook(9, 1)] + w[hook(9, 0)], 13U);
    w[hook(9, 3)] ^= rotate(w[hook(9, 2)] + w[hook(9, 1)], 18U);
    w[hook(9, 2)] ^= rotate(w[hook(9, 3)].wxyz + w[hook(9, 0)].zwxy, 7U);
    w[hook(9, 1)] ^= rotate(w[hook(9, 2)].wxyz + w[hook(9, 3)].zwxy, 9U);
    w[hook(9, 0)] ^= rotate(w[hook(9, 1)].wxyz + w[hook(9, 2)].zwxy, 13U);
    w[hook(9, 3)] ^= rotate(w[hook(9, 0)].wxyz + w[hook(9, 1)].zwxy, 18U);
  }

  for (unsigned int i = 0; i < 4; ++i)
    w[hook(9, i)] = (B[hook(8, i + 4)] ^= (B[hook(8, i)] += w[hook(9, i)]));

  for (unsigned int i = 0; i < 4; ++i) {
    w[hook(9, 0)] ^= rotate(w[hook(9, 3)] + w[hook(9, 2)], 7U);
    w[hook(9, 1)] ^= rotate(w[hook(9, 0)] + w[hook(9, 3)], 9U);
    w[hook(9, 2)] ^= rotate(w[hook(9, 1)] + w[hook(9, 0)], 13U);
    w[hook(9, 3)] ^= rotate(w[hook(9, 2)] + w[hook(9, 1)], 18U);
    w[hook(9, 2)] ^= rotate(w[hook(9, 3)].wxyz + w[hook(9, 0)].zwxy, 7U);
    w[hook(9, 1)] ^= rotate(w[hook(9, 2)].wxyz + w[hook(9, 3)].zwxy, 9U);
    w[hook(9, 0)] ^= rotate(w[hook(9, 1)].wxyz + w[hook(9, 2)].zwxy, 13U);
    w[hook(9, 3)] ^= rotate(w[hook(9, 0)].wxyz + w[hook(9, 1)].zwxy, 18U);
  }

  for (unsigned int i = 0; i < 4; ++i)
    B[hook(8, i + 4)] += w[hook(9, i)];
}

void scrypt_core(uint4 X[8], global uint4* restrict lookup) {
  shittify(X);
  const unsigned int zSIZE = 8;
  const unsigned int ySIZE = (1024 / 16 + (1024 % 16 > 0));
  const unsigned int xSIZE = 128;
  unsigned int x = get_global_id(0) % xSIZE;

  for (unsigned int y = 0; y < 1024 / 16; ++y) {
    for (unsigned int z = 0; z < zSIZE; ++z)
      lookup[hook(10, z + x * (zSIZE) + y * (xSIZE) * (zSIZE))] = X[hook(11, z)];
    for (unsigned int i = 0; i < 16; ++i)
      salsa(X);
  }

  {
    unsigned int y = (1024 / 16);
    for (unsigned int z = 0; z < zSIZE; ++z)
      lookup[hook(10, z + x * (zSIZE) + y * (xSIZE) * (zSIZE))] = X[hook(11, z)];
    for (unsigned int i = 0; i < 1024 % 16; ++i)
      salsa(X);
  }

  for (unsigned int i = 0; i < 1024; ++i) {
    uint4 V[8];
    unsigned int j = X[hook(11, 7)].x & 0x3FF;
    unsigned int y = (j / 16);
    for (unsigned int z = 0; z < zSIZE; ++z)
      V[hook(12, z)] = lookup[hook(10, z + x * (zSIZE) + y * (xSIZE) * (zSIZE))];

    unsigned int val = j % 16;
    for (unsigned int z = 0; z < val; ++z)
      salsa(V);

    for (unsigned int z = 0; z < zSIZE; ++z)
      X[hook(11, z)] ^= V[hook(12, z)];
    salsa(X);
  }
  unshittify(X);
}

__attribute__((reqd_work_group_size(128, 1, 1))) kernel void search(global uint4* restrict input, global unsigned int* restrict output, global uint4* restrict padcache, uint4 pad0, uint4 pad1) {
  uint4 X[8];
  uint4 tstate0, tstate1, ostate0, ostate1, tmp0, tmp1;
  uint4 data = (uint4)(input[hook(0, 4)].x, input[hook(0, 4)].y, input[hook(0, 4)].z, get_global_id(0));

  SHA256(&pad0, &pad1, data, (uint4)(0x80000000U, 0, 0, 0), (uint4)(0, 0, 0, 0), (uint4)(0, 0, 0, 0x280));
  SHA256_fresh(&ostate0, &ostate1, pad0 ^ 0x5C5C5C5CU, pad1 ^ 0x5C5C5C5CU, 0x5C5C5C5CU, 0x5C5C5C5CU);
  SHA256_fresh(&tstate0, &tstate1, pad0 ^ 0x36363636U, pad1 ^ 0x36363636U, 0x36363636U, 0x36363636U);

  tmp0 = tstate0;
  tmp1 = tstate1;
  SHA256(&tstate0, &tstate1, input[hook(0, 0)], input[hook(0, 1)], input[hook(0, 2)], input[hook(0, 3)]);

  for (unsigned int i = 0; i < 4; i++) {
    pad0 = tstate0;
    pad1 = tstate1;
    X[hook(11, i * 2)] = ostate0;
    X[hook(11, i * 2 + 1)] = ostate1;

    SHA256(&pad0, &pad1, data, (uint4)(i + 1, 0x80000000U, 0, 0), (uint4)(0, 0, 0, 0), (uint4)(0, 0, 0, 0x4a0U));
    SHA256(X + i * 2, X + i * 2 + 1, pad0, pad1, (uint4)(0x80000000U, 0U, 0U, 0U), (uint4)(0U, 0U, 0U, 0x300U));
  }
  scrypt_core(X, padcache);
  SHA256(&tmp0, &tmp1, X[hook(11, 0)], X[hook(11, 1)], X[hook(11, 2)], X[hook(11, 3)]);
  SHA256(&tmp0, &tmp1, X[hook(11, 4)], X[hook(11, 5)], X[hook(11, 6)], X[hook(11, 7)]);
  SHA256_fixed(&tmp0, &tmp1);
  SHA256(&ostate0, &ostate1, tmp0, tmp1, (uint4)(0x80000000U, 0U, 0U, 0U), (uint4)(0U, 0U, 0U, 0x300U));

  if ((ostate1.w & 0xFFFF) == 0)
    output[hook(1, get_global_id(0) & 255)] = get_global_id(0);
}
//{"((__private unsigned int *)roundKeys)":20,"AES_SBox":18,"InvSBox":24,"M":14,"Rcon":19,"W":6,"block":21,"column":26,"data":31,"digest":5,"fieldEleven":29,"fieldFourteen":25,"fieldNine":27,"fieldThirteen":28,"ipad":7,"iv":2,"key":16,"opad":8,"oridata":3,"p":13,"pass":9,"pw":30,"pwstart":0,"result":4,"rkey":22,"rotWord":17,"roundKeys":15,"salt":1,"state":12,"stateipad":10,"stateopad":11,"temp":23}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
unsigned int SWAP(unsigned int val) {
  return (rotate(((val)&0x00FF00FF), 24U) | rotate(((val)&0xFF00FF00), 8U));
}
void sha1_process2(const unsigned int* W, unsigned int* digest) {
  unsigned int A = digest[hook(5, 0)];
  unsigned int B = digest[hook(5, 1)];
  unsigned int C = digest[hook(5, 2)];
  unsigned int D = digest[hook(5, 3)];
  unsigned int E = digest[hook(5, 4)];

  unsigned int w0_t = W[hook(6, 0)];
  unsigned int w1_t = W[hook(6, 1)];
  unsigned int w2_t = W[hook(6, 2)];
  unsigned int w3_t = W[hook(6, 3)];
  unsigned int w4_t = W[hook(6, 4)];
  unsigned int w5_t = W[hook(6, 5)];
  unsigned int w6_t = W[hook(6, 6)];
  unsigned int w7_t = W[hook(6, 7)];
  unsigned int w8_t = W[hook(6, 8)];
  unsigned int w9_t = W[hook(6, 9)];
  unsigned int wa_t = W[hook(6, 10)];
  unsigned int wb_t = W[hook(6, 11)];
  unsigned int wc_t = W[hook(6, 12)];
  unsigned int wd_t = W[hook(6, 13)];
  unsigned int we_t = W[hook(6, 14)];
  unsigned int wf_t = W[hook(6, 15)];

  {
    E += 0x5a827999u;
    E += w0_t;
    E += (bitselect(D, C, B));
    E += rotate((A), (5u));
    B = rotate((B), (30u));
  };
  {
    D += 0x5a827999u;
    D += w1_t;
    D += (bitselect(C, B, A));
    D += rotate((E), (5u));
    A = rotate((A), (30u));
  };
  {
    C += 0x5a827999u;
    C += w2_t;
    C += (bitselect(B, A, E));
    C += rotate((D), (5u));
    E = rotate((E), (30u));
  };
  {
    B += 0x5a827999u;
    B += w3_t;
    B += (bitselect(A, E, D));
    B += rotate((C), (5u));
    D = rotate((D), (30u));
  };
  {
    A += 0x5a827999u;
    A += w4_t;
    A += (bitselect(E, D, C));
    A += rotate((B), (5u));
    C = rotate((C), (30u));
  };
  {
    E += 0x5a827999u;
    E += w5_t;
    E += (bitselect(D, C, B));
    E += rotate((A), (5u));
    B = rotate((B), (30u));
  };
  {
    D += 0x5a827999u;
    D += w6_t;
    D += (bitselect(C, B, A));
    D += rotate((E), (5u));
    A = rotate((A), (30u));
  };
  {
    C += 0x5a827999u;
    C += w7_t;
    C += (bitselect(B, A, E));
    C += rotate((D), (5u));
    E = rotate((E), (30u));
  };
  {
    B += 0x5a827999u;
    B += w8_t;
    B += (bitselect(A, E, D));
    B += rotate((C), (5u));
    D = rotate((D), (30u));
  };
  {
    A += 0x5a827999u;
    A += w9_t;
    A += (bitselect(E, D, C));
    A += rotate((B), (5u));
    C = rotate((C), (30u));
  };
  {
    E += 0x5a827999u;
    E += wa_t;
    E += (bitselect(D, C, B));
    E += rotate((A), (5u));
    B = rotate((B), (30u));
  };
  {
    D += 0x5a827999u;
    D += wb_t;
    D += (bitselect(C, B, A));
    D += rotate((E), (5u));
    A = rotate((A), (30u));
  };
  {
    C += 0x5a827999u;
    C += wc_t;
    C += (bitselect(B, A, E));
    C += rotate((D), (5u));
    E = rotate((E), (30u));
  };
  {
    B += 0x5a827999u;
    B += wd_t;
    B += (bitselect(A, E, D));
    B += rotate((C), (5u));
    D = rotate((D), (30u));
  };
  {
    A += 0x5a827999u;
    A += we_t;
    A += (bitselect(E, D, C));
    A += rotate((B), (5u));
    C = rotate((C), (30u));
  };
  {
    E += 0x5a827999u;
    E += wf_t;
    E += (bitselect(D, C, B));
    E += rotate((A), (5u));
    B = rotate((B), (30u));
  };
  w0_t = rotate(((wd_t ^ w8_t ^ w2_t ^ w0_t)), (1u));
  {
    D += 0x5a827999u;
    D += w0_t;
    D += (bitselect(C, B, A));
    D += rotate((E), (5u));
    A = rotate((A), (30u));
  };
  w1_t = rotate(((we_t ^ w9_t ^ w3_t ^ w1_t)), (1u));
  {
    C += 0x5a827999u;
    C += w1_t;
    C += (bitselect(B, A, E));
    C += rotate((D), (5u));
    E = rotate((E), (30u));
  };
  w2_t = rotate(((wf_t ^ wa_t ^ w4_t ^ w2_t)), (1u));
  {
    B += 0x5a827999u;
    B += w2_t;
    B += (bitselect(A, E, D));
    B += rotate((C), (5u));
    D = rotate((D), (30u));
  };
  w3_t = rotate(((w0_t ^ wb_t ^ w5_t ^ w3_t)), (1u));
  {
    A += 0x5a827999u;
    A += w3_t;
    A += (bitselect(E, D, C));
    A += rotate((B), (5u));
    C = rotate((C), (30u));
  };

  w4_t = rotate(((w1_t ^ wc_t ^ w6_t ^ w4_t)), (1u));
  {
    E += 0x6ed9eba1u;
    E += w4_t;
    E += ((B) ^ (C) ^ (D));
    E += rotate((A), (5u));
    B = rotate((B), (30u));
  };
  w5_t = rotate(((w2_t ^ wd_t ^ w7_t ^ w5_t)), (1u));
  {
    D += 0x6ed9eba1u;
    D += w5_t;
    D += ((A) ^ (B) ^ (C));
    D += rotate((E), (5u));
    A = rotate((A), (30u));
  };
  w6_t = rotate(((w3_t ^ we_t ^ w8_t ^ w6_t)), (1u));
  {
    C += 0x6ed9eba1u;
    C += w6_t;
    C += ((E) ^ (A) ^ (B));
    C += rotate((D), (5u));
    E = rotate((E), (30u));
  };
  w7_t = rotate(((w4_t ^ wf_t ^ w9_t ^ w7_t)), (1u));
  {
    B += 0x6ed9eba1u;
    B += w7_t;
    B += ((D) ^ (E) ^ (A));
    B += rotate((C), (5u));
    D = rotate((D), (30u));
  };
  w8_t = rotate(((w5_t ^ w0_t ^ wa_t ^ w8_t)), (1u));
  {
    A += 0x6ed9eba1u;
    A += w8_t;
    A += ((C) ^ (D) ^ (E));
    A += rotate((B), (5u));
    C = rotate((C), (30u));
  };
  w9_t = rotate(((w6_t ^ w1_t ^ wb_t ^ w9_t)), (1u));
  {
    E += 0x6ed9eba1u;
    E += w9_t;
    E += ((B) ^ (C) ^ (D));
    E += rotate((A), (5u));
    B = rotate((B), (30u));
  };
  wa_t = rotate(((w7_t ^ w2_t ^ wc_t ^ wa_t)), (1u));
  {
    D += 0x6ed9eba1u;
    D += wa_t;
    D += ((A) ^ (B) ^ (C));
    D += rotate((E), (5u));
    A = rotate((A), (30u));
  };
  wb_t = rotate(((w8_t ^ w3_t ^ wd_t ^ wb_t)), (1u));
  {
    C += 0x6ed9eba1u;
    C += wb_t;
    C += ((E) ^ (A) ^ (B));
    C += rotate((D), (5u));
    E = rotate((E), (30u));
  };
  wc_t = rotate(((w9_t ^ w4_t ^ we_t ^ wc_t)), (1u));
  {
    B += 0x6ed9eba1u;
    B += wc_t;
    B += ((D) ^ (E) ^ (A));
    B += rotate((C), (5u));
    D = rotate((D), (30u));
  };
  wd_t = rotate(((wa_t ^ w5_t ^ wf_t ^ wd_t)), (1u));
  {
    A += 0x6ed9eba1u;
    A += wd_t;
    A += ((C) ^ (D) ^ (E));
    A += rotate((B), (5u));
    C = rotate((C), (30u));
  };
  we_t = rotate(((wb_t ^ w6_t ^ w0_t ^ we_t)), (1u));
  {
    E += 0x6ed9eba1u;
    E += we_t;
    E += ((B) ^ (C) ^ (D));
    E += rotate((A), (5u));
    B = rotate((B), (30u));
  };
  wf_t = rotate(((wc_t ^ w7_t ^ w1_t ^ wf_t)), (1u));
  {
    D += 0x6ed9eba1u;
    D += wf_t;
    D += ((A) ^ (B) ^ (C));
    D += rotate((E), (5u));
    A = rotate((A), (30u));
  };
  w0_t = rotate(((wd_t ^ w8_t ^ w2_t ^ w0_t)), (1u));
  {
    C += 0x6ed9eba1u;
    C += w0_t;
    C += ((E) ^ (A) ^ (B));
    C += rotate((D), (5u));
    E = rotate((E), (30u));
  };
  w1_t = rotate(((we_t ^ w9_t ^ w3_t ^ w1_t)), (1u));
  {
    B += 0x6ed9eba1u;
    B += w1_t;
    B += ((D) ^ (E) ^ (A));
    B += rotate((C), (5u));
    D = rotate((D), (30u));
  };
  w2_t = rotate(((wf_t ^ wa_t ^ w4_t ^ w2_t)), (1u));
  {
    A += 0x6ed9eba1u;
    A += w2_t;
    A += ((C) ^ (D) ^ (E));
    A += rotate((B), (5u));
    C = rotate((C), (30u));
  };
  w3_t = rotate(((w0_t ^ wb_t ^ w5_t ^ w3_t)), (1u));
  {
    E += 0x6ed9eba1u;
    E += w3_t;
    E += ((B) ^ (C) ^ (D));
    E += rotate((A), (5u));
    B = rotate((B), (30u));
  };
  w4_t = rotate(((w1_t ^ wc_t ^ w6_t ^ w4_t)), (1u));
  {
    D += 0x6ed9eba1u;
    D += w4_t;
    D += ((A) ^ (B) ^ (C));
    D += rotate((E), (5u));
    A = rotate((A), (30u));
  };
  w5_t = rotate(((w2_t ^ wd_t ^ w7_t ^ w5_t)), (1u));
  {
    C += 0x6ed9eba1u;
    C += w5_t;
    C += ((E) ^ (A) ^ (B));
    C += rotate((D), (5u));
    E = rotate((E), (30u));
  };
  w6_t = rotate(((w3_t ^ we_t ^ w8_t ^ w6_t)), (1u));
  {
    B += 0x6ed9eba1u;
    B += w6_t;
    B += ((D) ^ (E) ^ (A));
    B += rotate((C), (5u));
    D = rotate((D), (30u));
  };
  w7_t = rotate(((w4_t ^ wf_t ^ w9_t ^ w7_t)), (1u));
  {
    A += 0x6ed9eba1u;
    A += w7_t;
    A += ((C) ^ (D) ^ (E));
    A += rotate((B), (5u));
    C = rotate((C), (30u));
  };

  w8_t = rotate(((w5_t ^ w0_t ^ wa_t ^ w8_t)), (1u));
  {
    E += 0x8f1bbcdcu;
    E += w8_t;
    E += (bitselect(B, C, (B ^ D)));
    E += rotate((A), (5u));
    B = rotate((B), (30u));
  };
  w9_t = rotate(((w6_t ^ w1_t ^ wb_t ^ w9_t)), (1u));
  {
    D += 0x8f1bbcdcu;
    D += w9_t;
    D += (bitselect(A, B, (A ^ C)));
    D += rotate((E), (5u));
    A = rotate((A), (30u));
  };
  wa_t = rotate(((w7_t ^ w2_t ^ wc_t ^ wa_t)), (1u));
  {
    C += 0x8f1bbcdcu;
    C += wa_t;
    C += (bitselect(E, A, (E ^ B)));
    C += rotate((D), (5u));
    E = rotate((E), (30u));
  };
  wb_t = rotate(((w8_t ^ w3_t ^ wd_t ^ wb_t)), (1u));
  {
    B += 0x8f1bbcdcu;
    B += wb_t;
    B += (bitselect(D, E, (D ^ A)));
    B += rotate((C), (5u));
    D = rotate((D), (30u));
  };
  wc_t = rotate(((w9_t ^ w4_t ^ we_t ^ wc_t)), (1u));
  {
    A += 0x8f1bbcdcu;
    A += wc_t;
    A += (bitselect(C, D, (C ^ E)));
    A += rotate((B), (5u));
    C = rotate((C), (30u));
  };
  wd_t = rotate(((wa_t ^ w5_t ^ wf_t ^ wd_t)), (1u));
  {
    E += 0x8f1bbcdcu;
    E += wd_t;
    E += (bitselect(B, C, (B ^ D)));
    E += rotate((A), (5u));
    B = rotate((B), (30u));
  };
  we_t = rotate(((wb_t ^ w6_t ^ w0_t ^ we_t)), (1u));
  {
    D += 0x8f1bbcdcu;
    D += we_t;
    D += (bitselect(A, B, (A ^ C)));
    D += rotate((E), (5u));
    A = rotate((A), (30u));
  };
  wf_t = rotate(((wc_t ^ w7_t ^ w1_t ^ wf_t)), (1u));
  {
    C += 0x8f1bbcdcu;
    C += wf_t;
    C += (bitselect(E, A, (E ^ B)));
    C += rotate((D), (5u));
    E = rotate((E), (30u));
  };
  w0_t = rotate(((wd_t ^ w8_t ^ w2_t ^ w0_t)), (1u));
  {
    B += 0x8f1bbcdcu;
    B += w0_t;
    B += (bitselect(D, E, (D ^ A)));
    B += rotate((C), (5u));
    D = rotate((D), (30u));
  };
  w1_t = rotate(((we_t ^ w9_t ^ w3_t ^ w1_t)), (1u));
  {
    A += 0x8f1bbcdcu;
    A += w1_t;
    A += (bitselect(C, D, (C ^ E)));
    A += rotate((B), (5u));
    C = rotate((C), (30u));
  };
  w2_t = rotate(((wf_t ^ wa_t ^ w4_t ^ w2_t)), (1u));
  {
    E += 0x8f1bbcdcu;
    E += w2_t;
    E += (bitselect(B, C, (B ^ D)));
    E += rotate((A), (5u));
    B = rotate((B), (30u));
  };
  w3_t = rotate(((w0_t ^ wb_t ^ w5_t ^ w3_t)), (1u));
  {
    D += 0x8f1bbcdcu;
    D += w3_t;
    D += (bitselect(A, B, (A ^ C)));
    D += rotate((E), (5u));
    A = rotate((A), (30u));
  };
  w4_t = rotate(((w1_t ^ wc_t ^ w6_t ^ w4_t)), (1u));
  {
    C += 0x8f1bbcdcu;
    C += w4_t;
    C += (bitselect(E, A, (E ^ B)));
    C += rotate((D), (5u));
    E = rotate((E), (30u));
  };
  w5_t = rotate(((w2_t ^ wd_t ^ w7_t ^ w5_t)), (1u));
  {
    B += 0x8f1bbcdcu;
    B += w5_t;
    B += (bitselect(D, E, (D ^ A)));
    B += rotate((C), (5u));
    D = rotate((D), (30u));
  };
  w6_t = rotate(((w3_t ^ we_t ^ w8_t ^ w6_t)), (1u));
  {
    A += 0x8f1bbcdcu;
    A += w6_t;
    A += (bitselect(C, D, (C ^ E)));
    A += rotate((B), (5u));
    C = rotate((C), (30u));
  };
  w7_t = rotate(((w4_t ^ wf_t ^ w9_t ^ w7_t)), (1u));
  {
    E += 0x8f1bbcdcu;
    E += w7_t;
    E += (bitselect(B, C, (B ^ D)));
    E += rotate((A), (5u));
    B = rotate((B), (30u));
  };
  w8_t = rotate(((w5_t ^ w0_t ^ wa_t ^ w8_t)), (1u));
  {
    D += 0x8f1bbcdcu;
    D += w8_t;
    D += (bitselect(A, B, (A ^ C)));
    D += rotate((E), (5u));
    A = rotate((A), (30u));
  };
  w9_t = rotate(((w6_t ^ w1_t ^ wb_t ^ w9_t)), (1u));
  {
    C += 0x8f1bbcdcu;
    C += w9_t;
    C += (bitselect(E, A, (E ^ B)));
    C += rotate((D), (5u));
    E = rotate((E), (30u));
  };
  wa_t = rotate(((w7_t ^ w2_t ^ wc_t ^ wa_t)), (1u));
  {
    B += 0x8f1bbcdcu;
    B += wa_t;
    B += (bitselect(D, E, (D ^ A)));
    B += rotate((C), (5u));
    D = rotate((D), (30u));
  };
  wb_t = rotate(((w8_t ^ w3_t ^ wd_t ^ wb_t)), (1u));
  {
    A += 0x8f1bbcdcu;
    A += wb_t;
    A += (bitselect(C, D, (C ^ E)));
    A += rotate((B), (5u));
    C = rotate((C), (30u));
  };

  wc_t = rotate(((w9_t ^ w4_t ^ we_t ^ wc_t)), (1u));
  {
    E += 0xca62c1d6u;
    E += wc_t;
    E += ((B) ^ (C) ^ (D));
    E += rotate((A), (5u));
    B = rotate((B), (30u));
  };
  wd_t = rotate(((wa_t ^ w5_t ^ wf_t ^ wd_t)), (1u));
  {
    D += 0xca62c1d6u;
    D += wd_t;
    D += ((A) ^ (B) ^ (C));
    D += rotate((E), (5u));
    A = rotate((A), (30u));
  };
  we_t = rotate(((wb_t ^ w6_t ^ w0_t ^ we_t)), (1u));
  {
    C += 0xca62c1d6u;
    C += we_t;
    C += ((E) ^ (A) ^ (B));
    C += rotate((D), (5u));
    E = rotate((E), (30u));
  };
  wf_t = rotate(((wc_t ^ w7_t ^ w1_t ^ wf_t)), (1u));
  {
    B += 0xca62c1d6u;
    B += wf_t;
    B += ((D) ^ (E) ^ (A));
    B += rotate((C), (5u));
    D = rotate((D), (30u));
  };
  w0_t = rotate(((wd_t ^ w8_t ^ w2_t ^ w0_t)), (1u));
  {
    A += 0xca62c1d6u;
    A += w0_t;
    A += ((C) ^ (D) ^ (E));
    A += rotate((B), (5u));
    C = rotate((C), (30u));
  };
  w1_t = rotate(((we_t ^ w9_t ^ w3_t ^ w1_t)), (1u));
  {
    E += 0xca62c1d6u;
    E += w1_t;
    E += ((B) ^ (C) ^ (D));
    E += rotate((A), (5u));
    B = rotate((B), (30u));
  };
  w2_t = rotate(((wf_t ^ wa_t ^ w4_t ^ w2_t)), (1u));
  {
    D += 0xca62c1d6u;
    D += w2_t;
    D += ((A) ^ (B) ^ (C));
    D += rotate((E), (5u));
    A = rotate((A), (30u));
  };
  w3_t = rotate(((w0_t ^ wb_t ^ w5_t ^ w3_t)), (1u));
  {
    C += 0xca62c1d6u;
    C += w3_t;
    C += ((E) ^ (A) ^ (B));
    C += rotate((D), (5u));
    E = rotate((E), (30u));
  };
  w4_t = rotate(((w1_t ^ wc_t ^ w6_t ^ w4_t)), (1u));
  {
    B += 0xca62c1d6u;
    B += w4_t;
    B += ((D) ^ (E) ^ (A));
    B += rotate((C), (5u));
    D = rotate((D), (30u));
  };
  w5_t = rotate(((w2_t ^ wd_t ^ w7_t ^ w5_t)), (1u));
  {
    A += 0xca62c1d6u;
    A += w5_t;
    A += ((C) ^ (D) ^ (E));
    A += rotate((B), (5u));
    C = rotate((C), (30u));
  };
  w6_t = rotate(((w3_t ^ we_t ^ w8_t ^ w6_t)), (1u));
  {
    E += 0xca62c1d6u;
    E += w6_t;
    E += ((B) ^ (C) ^ (D));
    E += rotate((A), (5u));
    B = rotate((B), (30u));
  };
  w7_t = rotate(((w4_t ^ wf_t ^ w9_t ^ w7_t)), (1u));
  {
    D += 0xca62c1d6u;
    D += w7_t;
    D += ((A) ^ (B) ^ (C));
    D += rotate((E), (5u));
    A = rotate((A), (30u));
  };
  w8_t = rotate(((w5_t ^ w0_t ^ wa_t ^ w8_t)), (1u));
  {
    C += 0xca62c1d6u;
    C += w8_t;
    C += ((E) ^ (A) ^ (B));
    C += rotate((D), (5u));
    E = rotate((E), (30u));
  };
  w9_t = rotate(((w6_t ^ w1_t ^ wb_t ^ w9_t)), (1u));
  {
    B += 0xca62c1d6u;
    B += w9_t;
    B += ((D) ^ (E) ^ (A));
    B += rotate((C), (5u));
    D = rotate((D), (30u));
  };
  wa_t = rotate(((w7_t ^ w2_t ^ wc_t ^ wa_t)), (1u));
  {
    A += 0xca62c1d6u;
    A += wa_t;
    A += ((C) ^ (D) ^ (E));
    A += rotate((B), (5u));
    C = rotate((C), (30u));
  };
  wb_t = rotate(((w8_t ^ w3_t ^ wd_t ^ wb_t)), (1u));
  {
    E += 0xca62c1d6u;
    E += wb_t;
    E += ((B) ^ (C) ^ (D));
    E += rotate((A), (5u));
    B = rotate((B), (30u));
  };
  wc_t = rotate(((w9_t ^ w4_t ^ we_t ^ wc_t)), (1u));
  {
    D += 0xca62c1d6u;
    D += wc_t;
    D += ((A) ^ (B) ^ (C));
    D += rotate((E), (5u));
    A = rotate((A), (30u));
  };
  wd_t = rotate(((wa_t ^ w5_t ^ wf_t ^ wd_t)), (1u));
  {
    C += 0xca62c1d6u;
    C += wd_t;
    C += ((E) ^ (A) ^ (B));
    C += rotate((D), (5u));
    E = rotate((E), (30u));
  };
  we_t = rotate(((wb_t ^ w6_t ^ w0_t ^ we_t)), (1u));
  {
    B += 0xca62c1d6u;
    B += we_t;
    B += ((D) ^ (E) ^ (A));
    B += rotate((C), (5u));
    D = rotate((D), (30u));
  };
  wf_t = rotate(((wc_t ^ w7_t ^ w1_t ^ wf_t)), (1u));
  {
    A += 0xca62c1d6u;
    A += wf_t;
    A += ((C) ^ (D) ^ (E));
    A += rotate((B), (5u));
    C = rotate((C), (30u));
  };

  digest[hook(5, 0)] += A;
  digest[hook(5, 1)] += B;
  digest[hook(5, 2)] += C;
  digest[hook(5, 3)] += D;
  digest[hook(5, 4)] += E;
}

void pbkdf(const unsigned int* pass, int pass_len, constant const unsigned int* salt, int salt_len, unsigned int* hash) {
  int plen = pass_len / 4;
  if (pass_len - (pass_len / 4 * 4))
    plen++;

  int slen = salt_len / 4;
  if (salt_len - (salt_len / 4 * 4))
    slen++;

  unsigned int* p = hash;

  unsigned int ipad[16];
  ipad[hook(7, 0)] = 0x36363636;
  ipad[hook(7, 1)] = 0x36363636;
  ipad[hook(7, 2)] = 0x36363636;
  ipad[hook(7, 3)] = 0x36363636;
  ipad[hook(7, 4)] = 0x36363636;
  ipad[hook(7, 5)] = 0x36363636;
  ipad[hook(7, 6)] = 0x36363636;
  ipad[hook(7, 7)] = 0x36363636;
  ipad[hook(7, 8)] = 0x36363636;
  ipad[hook(7, 9)] = 0x36363636;
  ipad[hook(7, 10)] = 0x36363636;
  ipad[hook(7, 11)] = 0x36363636;
  ipad[hook(7, 12)] = 0x36363636;
  ipad[hook(7, 13)] = 0x36363636;
  ipad[hook(7, 14)] = 0x36363636;
  ipad[hook(7, 15)] = 0x36363636;

  unsigned int opad[16];
  opad[hook(8, 0)] = 0x5C5C5C5C;
  opad[hook(8, 1)] = 0x5C5C5C5C;
  opad[hook(8, 2)] = 0x5C5C5C5C;
  opad[hook(8, 3)] = 0x5C5C5C5C;
  opad[hook(8, 4)] = 0x5C5C5C5C;
  opad[hook(8, 5)] = 0x5C5C5C5C;
  opad[hook(8, 6)] = 0x5C5C5C5C;
  opad[hook(8, 7)] = 0x5C5C5C5C;
  opad[hook(8, 8)] = 0x5C5C5C5C;
  opad[hook(8, 9)] = 0x5C5C5C5C;
  opad[hook(8, 10)] = 0x5C5C5C5C;
  opad[hook(8, 11)] = 0x5C5C5C5C;
  opad[hook(8, 12)] = 0x5C5C5C5C;
  opad[hook(8, 13)] = 0x5C5C5C5C;
  opad[hook(8, 14)] = 0x5C5C5C5C;
  opad[hook(8, 15)] = 0x5C5C5C5C;

  for (int m = 0; m < plen && m < 16; m++) {
    ipad[hook(7, m)] ^= SWAP(pass[hook(9, m)]);
    opad[hook(8, m)] ^= SWAP(pass[hook(9, m)]);
  }

  unsigned int stateipad[5] = {0};
  stateipad[hook(10, 0)] = 0x67452301;
  stateipad[hook(10, 1)] = 0xefcdab89;
  stateipad[hook(10, 2)] = 0x98badcfe;
  stateipad[hook(10, 3)] = 0x10325476;
  stateipad[hook(10, 4)] = 0xc3d2e1f0;

  unsigned int W[0x10] = {0};
  W[hook(6, 0)] = ipad[hook(7, 0)];
  W[hook(6, 1)] = ipad[hook(7, 1)];
  W[hook(6, 2)] = ipad[hook(7, 2)];
  W[hook(6, 3)] = ipad[hook(7, 3)];
  W[hook(6, 4)] = ipad[hook(7, 4)];
  W[hook(6, 5)] = ipad[hook(7, 5)];
  W[hook(6, 6)] = ipad[hook(7, 6)];
  W[hook(6, 7)] = ipad[hook(7, 7)];
  W[hook(6, 8)] = ipad[hook(7, 8)];
  W[hook(6, 9)] = ipad[hook(7, 9)];
  W[hook(6, 10)] = ipad[hook(7, 10)];
  W[hook(6, 11)] = ipad[hook(7, 11)];
  W[hook(6, 12)] = ipad[hook(7, 12)];
  W[hook(6, 13)] = ipad[hook(7, 13)];
  W[hook(6, 14)] = ipad[hook(7, 14)];
  W[hook(6, 15)] = ipad[hook(7, 15)];
  sha1_process2(W, stateipad);

  unsigned int stateopad[5] = {0};
  stateopad[hook(11, 0)] = 0x67452301;
  stateopad[hook(11, 1)] = 0xefcdab89;
  stateopad[hook(11, 2)] = 0x98badcfe;
  stateopad[hook(11, 3)] = 0x10325476;
  stateopad[hook(11, 4)] = 0xc3d2e1f0;

  W[hook(6, 0)] = opad[hook(8, 0)];
  W[hook(6, 1)] = opad[hook(8, 1)];
  W[hook(6, 2)] = opad[hook(8, 2)];
  W[hook(6, 3)] = opad[hook(8, 3)];
  W[hook(6, 4)] = opad[hook(8, 4)];
  W[hook(6, 5)] = opad[hook(8, 5)];
  W[hook(6, 6)] = opad[hook(8, 6)];
  W[hook(6, 7)] = opad[hook(8, 7)];
  W[hook(6, 8)] = opad[hook(8, 8)];
  W[hook(6, 9)] = opad[hook(8, 9)];
  W[hook(6, 10)] = opad[hook(8, 10)];
  W[hook(6, 11)] = opad[hook(8, 11)];
  W[hook(6, 12)] = opad[hook(8, 12)];
  W[hook(6, 13)] = opad[hook(8, 13)];
  W[hook(6, 14)] = opad[hook(8, 14)];
  W[hook(6, 15)] = opad[hook(8, 15)];
  sha1_process2(W, stateopad);

  unsigned int counter = 1;
  unsigned int state[5] = {0};

  unsigned int tkeylen = 32;
  unsigned int cplen = 0;
  while (tkeylen > 0) {
    if (tkeylen > 20)
      cplen = 20;
    else
      cplen = tkeylen;

    state[hook(12, 0)] = stateipad[hook(10, 0)];
    state[hook(12, 1)] = stateipad[hook(10, 1)];
    state[hook(12, 2)] = stateipad[hook(10, 2)];
    state[hook(12, 3)] = stateipad[hook(10, 3)];
    state[hook(12, 4)] = stateipad[hook(10, 4)];

    W[hook(6, 0)] = 0;
    W[hook(6, 1)] = 0;
    W[hook(6, 2)] = 0;
    W[hook(6, 3)] = 0;
    W[hook(6, 4)] = 0;
    W[hook(6, 5)] = 0;
    W[hook(6, 6)] = 0;
    W[hook(6, 7)] = 0;
    W[hook(6, 8)] = 0;
    W[hook(6, 9)] = 0;
    W[hook(6, 10)] = 0;
    W[hook(6, 11)] = 0;
    W[hook(6, 12)] = 0;
    W[hook(6, 13)] = 0;
    W[hook(6, 14)] = 0;
    for (int m = 0; m < slen; m++) {
      W[hook(6, m)] = SWAP(salt[hook(1, m)]);
    }
    W[hook(6, slen)] = counter;

    unsigned int padding = 0x80 << (((salt_len + 4) - ((salt_len + 4) / 4 * 4)) * 8);
    W[hook(6, (((salt_len + 4) - ((salt_len + 4) / (16 * 4) * (16 * 4))) / 4))] |= SWAP(padding);

    W[hook(6, 15)] = (0x40 + (salt_len + 4)) * 8;

    sha1_process2(W, state);

    W[hook(6, 0)] = state[hook(12, 0)];
    W[hook(6, 1)] = state[hook(12, 1)];
    W[hook(6, 2)] = state[hook(12, 2)];
    W[hook(6, 3)] = state[hook(12, 3)];
    W[hook(6, 4)] = state[hook(12, 4)];
    W[hook(6, 5)] = 0x80000000;
    W[hook(6, 6)] = 0x0;
    W[hook(6, 7)] = 0x0;
    W[hook(6, 8)] = 0x0;
    W[hook(6, 9)] = 0;
    W[hook(6, 10)] = 0;
    W[hook(6, 11)] = 0;
    W[hook(6, 12)] = 0;
    W[hook(6, 13)] = 0;
    W[hook(6, 14)] = 0;
    W[hook(6, 15)] = 0x54 * 8;

    state[hook(12, 0)] = stateopad[hook(11, 0)];
    state[hook(12, 1)] = stateopad[hook(11, 1)];
    state[hook(12, 2)] = stateopad[hook(11, 2)];
    state[hook(12, 3)] = stateopad[hook(11, 3)];
    state[hook(12, 4)] = stateopad[hook(11, 4)];

    sha1_process2(W, state);

    p[hook(13, 0)] = W[hook(6, 0)] = state[hook(12, 0)];
    p[hook(13, 1)] = W[hook(6, 1)] = state[hook(12, 1)];
    p[hook(13, 2)] = W[hook(6, 2)] = state[hook(12, 2)];
    p[hook(13, 3)] = W[hook(6, 3)] = state[hook(12, 3)];
    p[hook(13, 4)] = W[hook(6, 4)] = state[hook(12, 4)];

    unsigned int M[0x10];

    for (int j = 1; j < 4000; j++) {
      W[hook(6, 5)] = 0x80000000;
      W[hook(6, 6)] = 0;
      W[hook(6, 7)] = 0;
      W[hook(6, 8)] = 0;
      W[hook(6, 9)] = 0;
      W[hook(6, 10)] = 0;
      W[hook(6, 11)] = 0;
      W[hook(6, 12)] = 0;
      W[hook(6, 13)] = 0;
      W[hook(6, 14)] = 0;
      W[hook(6, 15)] = 0x54 * 8;
      state[hook(12, 0)] = stateipad[hook(10, 0)];
      state[hook(12, 1)] = stateipad[hook(10, 1)];
      state[hook(12, 2)] = stateipad[hook(10, 2)];
      state[hook(12, 3)] = stateipad[hook(10, 3)];
      state[hook(12, 4)] = stateipad[hook(10, 4)];
      sha1_process2(W, state);

      M[hook(14, 0)] = state[hook(12, 0)];
      M[hook(14, 1)] = state[hook(12, 1)];
      M[hook(14, 2)] = state[hook(12, 2)];
      M[hook(14, 3)] = state[hook(12, 3)];
      M[hook(14, 4)] = state[hook(12, 4)];
      M[hook(14, 5)] = 0x80000000;
      M[hook(14, 6)] = 0;
      M[hook(14, 7)] = 0;
      M[hook(14, 8)] = 0;
      M[hook(14, 9)] = 0;
      M[hook(14, 10)] = 0;
      M[hook(14, 11)] = 0;
      M[hook(14, 12)] = 0;
      M[hook(14, 13)] = 0;
      M[hook(14, 14)] = 0;
      M[hook(14, 15)] = 0x54 * 8;

      state[hook(12, 0)] = stateopad[hook(11, 0)];
      state[hook(12, 1)] = stateopad[hook(11, 1)];
      state[hook(12, 2)] = stateopad[hook(11, 2)];
      state[hook(12, 3)] = stateopad[hook(11, 3)];
      state[hook(12, 4)] = stateopad[hook(11, 4)];

      sha1_process2(M, state);

      W[hook(6, 0)] = state[hook(12, 0)];
      W[hook(6, 1)] = state[hook(12, 1)];
      W[hook(6, 2)] = state[hook(12, 2)];
      W[hook(6, 3)] = state[hook(12, 3)];
      W[hook(6, 4)] = state[hook(12, 4)];

      p[hook(13, 0)] ^= state[hook(12, 0)];
      p[hook(13, 1)] ^= state[hook(12, 1)];
      p[hook(13, 2)] ^= state[hook(12, 2)];
      p[hook(13, 3)] ^= state[hook(12, 3)];
      p[hook(13, 4)] ^= state[hook(12, 4)];
    }

    p[hook(13, 0)] = SWAP(p[hook(13, 0)]);
    p[hook(13, 1)] = SWAP(p[hook(13, 1)]);
    p[hook(13, 2)] = SWAP(p[hook(13, 2)]);
    p[hook(13, 3)] = SWAP(p[hook(13, 3)]);
    p[hook(13, 4)] = SWAP(p[hook(13, 4)]);

    tkeylen -= cplen;
    counter++;
    p += cplen / 4;
  }
  return;
}

constant uchar AES_SBox[256] = {0x63, 0x7C, 0x77, 0x7B, 0xF2, 0x6B, 0x6F, 0xC5, 0x30, 0x01, 0x67, 0x2B, 0xFE, 0xD7, 0xAB, 0x76, 0xCA, 0x82, 0xC9, 0x7D, 0xFA, 0x59, 0x47, 0xF0, 0xAD, 0xD4, 0xA2, 0xAF, 0x9C, 0xA4, 0x72, 0xC0, 0xB7, 0xFD, 0x93, 0x26, 0x36, 0x3F, 0xF7, 0xCC, 0x34, 0xA5, 0xE5, 0xF1, 0x71, 0xD8, 0x31, 0x15, 0x04, 0xC7, 0x23, 0xC3, 0x18, 0x96, 0x05, 0x9A, 0x07, 0x12, 0x80, 0xE2, 0xEB, 0x27, 0xB2, 0x75, 0x09, 0x83, 0x2C, 0x1A, 0x1B, 0x6E, 0x5A, 0xA0, 0x52, 0x3B, 0xD6, 0xB3, 0x29, 0xE3, 0x2F, 0x84, 0x53, 0xD1, 0x00, 0xED, 0x20, 0xFC, 0xB1, 0x5B, 0x6A, 0xCB, 0xBE, 0x39, 0x4A, 0x4C, 0x58, 0xCF, 0xD0, 0xEF, 0xAA, 0xFB, 0x43, 0x4D, 0x33, 0x85, 0x45, 0xF9, 0x02, 0x7F, 0x50, 0x3C, 0x9F, 0xA8, 0x51, 0xA3, 0x40, 0x8F, 0x92, 0x9D, 0x38, 0xF5, 0xBC, 0xB6, 0xDA, 0x21, 0x10, 0xFF, 0xF3, 0xD2, 0xCD, 0x0C, 0x13, 0xEC, 0x5F, 0x97, 0x44, 0x17, 0xC4, 0xA7, 0x7E, 0x3D, 0x64, 0x5D, 0x19, 0x73, 0x60, 0x81, 0x4F, 0xDC, 0x22, 0x2A, 0x90, 0x88, 0x46, 0xEE, 0xB8, 0x14, 0xDE, 0x5E, 0x0B, 0xDB, 0xE0, 0x32, 0x3A, 0x0A, 0x49, 0x06, 0x24, 0x5C, 0xC2, 0xD3, 0xAC, 0x62, 0x91, 0x95, 0xE4, 0x79, 0xE7, 0xC8, 0x37, 0x6D, 0x8D, 0xD5, 0x4E, 0xA9, 0x6C, 0x56, 0xF4, 0xEA, 0x65, 0x7A, 0xAE, 0x08, 0xBA, 0x78, 0x25, 0x2E, 0x1C, 0xA6, 0xB4, 0xC6, 0xE8, 0xDD, 0x74, 0x1F, 0x4B, 0xBD, 0x8B, 0x8A, 0x70, 0x3E, 0xB5, 0x66, 0x48, 0x03, 0xF6, 0x0E, 0x61, 0x35, 0x57, 0xB9, 0x86, 0xC1, 0x1D, 0x9E, 0xE1, 0xF8, 0x98, 0x11, 0x69, 0xD9, 0x8E, 0x94, 0x9B, 0x1E, 0x87, 0xE9, 0xCE, 0x55, 0x28, 0xDF, 0x8C, 0xA1, 0x89, 0x0D, 0xBF, 0xE6, 0x42, 0x68, 0x41, 0x99, 0x2D, 0x0F, 0xB0, 0x54, 0xBB, 0x16};

constant uchar Rcon[256] = {0x8D, 0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80, 0x1B, 0x36, 0x6C, 0xD8, 0xAB, 0x4D, 0x9A, 0x2F, 0x5E, 0xBC, 0x63, 0xC6, 0x97, 0x35, 0x6A, 0xD4, 0xB3, 0x7D, 0xFA, 0xEF, 0xC5, 0x91, 0x39, 0x72, 0xE4, 0xD3, 0xBD, 0x61, 0xC2, 0x9F, 0x25, 0x4A, 0x94, 0x33, 0x66, 0xCC, 0x83, 0x1D, 0x3A, 0x74, 0xE8, 0xCB, 0x8D, 0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80, 0x1B, 0x36, 0x6C, 0xD8, 0xAB, 0x4D, 0x9A, 0x2F, 0x5E, 0xBC, 0x63, 0xC6, 0x97, 0x35, 0x6A, 0xD4, 0xB3, 0x7D, 0xFA, 0xEF, 0xC5, 0x91, 0x39, 0x72, 0xE4, 0xD3, 0xBD, 0x61, 0xC2, 0x9F, 0x25, 0x4A, 0x94, 0x33, 0x66, 0xCC, 0x83, 0x1D, 0x3A, 0x74, 0xE8, 0xCB, 0x8D, 0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80, 0x1B, 0x36, 0x6C, 0xD8, 0xAB, 0x4D, 0x9A, 0x2F, 0x5E, 0xBC, 0x63, 0xC6, 0x97, 0x35, 0x6A, 0xD4, 0xB3, 0x7D, 0xFA, 0xEF, 0xC5, 0x91, 0x39, 0x72, 0xE4, 0xD3, 0xBD, 0x61, 0xC2, 0x9F, 0x25, 0x4A, 0x94, 0x33, 0x66, 0xCC, 0x83, 0x1D, 0x3A, 0x74, 0xE8, 0xCB, 0x8D, 0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80, 0x1B, 0x36, 0x6C, 0xD8, 0xAB, 0x4D, 0x9A, 0x2F, 0x5E, 0xBC, 0x63, 0xC6, 0x97, 0x35, 0x6A, 0xD4, 0xB3, 0x7D, 0xFA, 0xEF, 0xC5, 0x91, 0x39, 0x72, 0xE4, 0xD3, 0xBD, 0x61, 0xC2, 0x9F, 0x25, 0x4A, 0x94, 0x33, 0x66, 0xCC, 0x83, 0x1D, 0x3A, 0x74, 0xE8, 0xCB, 0x8D, 0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80, 0x1B, 0x36, 0x6C, 0xD8, 0xAB, 0x4D, 0x9A, 0x2F, 0x5E, 0xBC, 0x63, 0xC6, 0x97, 0x35, 0x6A, 0xD4, 0xB3, 0x7D, 0xFA, 0xEF, 0xC5, 0x91, 0x39, 0x72, 0xE4, 0xD3, 0xBD, 0x61, 0xC2, 0x9F, 0x25, 0x4A, 0x94, 0x33, 0x66, 0xCC, 0x83, 0x1D, 0x3A, 0x74, 0xE8, 0xCB, 0x8D};

constant uchar InvSBox[256] = {0x52, 0x09, 0x6A, 0xD5, 0x30, 0x36, 0xA5, 0x38, 0xBF, 0x40, 0xA3, 0x9E, 0x81, 0xF3, 0xD7, 0xFB, 0x7C, 0xE3, 0x39, 0x82, 0x9B, 0x2F, 0xFF, 0x87, 0x34, 0x8E, 0x43, 0x44, 0xC4, 0xDE, 0xE9, 0xCB, 0x54, 0x7B, 0x94, 0x32, 0xA6, 0xC2, 0x23, 0x3D, 0xEE, 0x4C, 0x95, 0x0B, 0x42, 0xFA, 0xC3, 0x4E, 0x08, 0x2E, 0xA1, 0x66, 0x28, 0xD9, 0x24, 0xB2, 0x76, 0x5B, 0xA2, 0x49, 0x6D, 0x8B, 0xD1, 0x25, 0x72, 0xF8, 0xF6, 0x64, 0x86, 0x68, 0x98, 0x16, 0xD4, 0xA4, 0x5C, 0xCC, 0x5D, 0x65, 0xB6, 0x92, 0x6C, 0x70, 0x48, 0x50, 0xFD, 0xED, 0xB9, 0xDA, 0x5E, 0x15, 0x46, 0x57, 0xA7, 0x8D, 0x9D, 0x84, 0x90, 0xD8, 0xAB, 0x00, 0x8C, 0xBC, 0xD3, 0x0A, 0xF7, 0xE4, 0x58, 0x05, 0xB8, 0xB3, 0x45, 0x06, 0xD0, 0x2C, 0x1E, 0x8F, 0xCA, 0x3F, 0x0F, 0x02, 0xC1, 0xAF, 0xBD, 0x03, 0x01, 0x13, 0x8A, 0x6B, 0x3A, 0x91, 0x11, 0x41, 0x4F, 0x67, 0xDC, 0xEA, 0x97, 0xF2, 0xCF, 0xCE, 0xF0, 0xB4, 0xE6, 0x73, 0x96, 0xAC, 0x74, 0x22, 0xE7, 0xAD, 0x35, 0x85, 0xE2, 0xF9, 0x37, 0xE8, 0x1C, 0x75, 0xDF, 0x6E, 0x47, 0xF1, 0x1A, 0x71, 0x1D, 0x29, 0xC5, 0x89, 0x6F, 0xB7, 0x62, 0x0E, 0xAA, 0x18, 0xBE, 0x1B, 0xFC, 0x56, 0x3E, 0x4B, 0xC6, 0xD2, 0x79, 0x20, 0x9A, 0xDB, 0xC0, 0xFE, 0x78, 0xCD, 0x5A, 0xF4, 0x1F, 0xDD, 0xA8, 0x33, 0x88, 0x07, 0xC7, 0x31, 0xB1, 0x12, 0x10, 0x59, 0x27, 0x80, 0xEC, 0x5F, 0x60, 0x51, 0x7F, 0xA9, 0x19, 0xB5, 0x4A, 0x0D, 0x2D, 0xE5, 0x7A, 0x9F, 0x93, 0xC9, 0x9C, 0xEF, 0xA0, 0xE0, 0x3B, 0x4D, 0xAE, 0x2A, 0xF5, 0xB0, 0xC8, 0xEB, 0xBB, 0x3C, 0x83, 0x53, 0x99, 0x61, 0x17, 0x2B, 0x04, 0x7E, 0xBA, 0x77, 0xD6, 0x26, 0xE1, 0x69, 0x14, 0x63, 0x55, 0x21, 0x0C, 0x7D};

constant uchar fieldNine[] = {0x00, 0x09, 0x12, 0x1b, 0x24, 0x2d, 0x36, 0x3f, 0x48, 0x41, 0x5a, 0x53, 0x6c, 0x65, 0x7e, 0x77, 0x90, 0x99, 0x82, 0x8b, 0xb4, 0xbd, 0xa6, 0xaf, 0xd8, 0xd1, 0xca, 0xc3, 0xfc, 0xf5, 0xee, 0xe7, 0x3b, 0x32, 0x29, 0x20, 0x1f, 0x16, 0x0d, 0x04, 0x73, 0x7a, 0x61, 0x68, 0x57, 0x5e, 0x45, 0x4c, 0xab, 0xa2, 0xb9, 0xb0, 0x8f, 0x86, 0x9d, 0x94, 0xe3, 0xea, 0xf1, 0xf8, 0xc7, 0xce, 0xd5, 0xdc, 0x76, 0x7f, 0x64, 0x6d, 0x52, 0x5b, 0x40, 0x49, 0x3e, 0x37, 0x2c, 0x25, 0x1a, 0x13, 0x08, 0x01, 0xe6, 0xef, 0xf4, 0xfd, 0xc2, 0xcb, 0xd0, 0xd9, 0xae, 0xa7, 0xbc, 0xb5, 0x8a, 0x83, 0x98, 0x91, 0x4d, 0x44, 0x5f, 0x56, 0x69, 0x60, 0x7b, 0x72, 0x05, 0x0c, 0x17, 0x1e, 0x21, 0x28, 0x33, 0x3a, 0xdd, 0xd4, 0xcf, 0xc6, 0xf9, 0xf0, 0xeb, 0xe2, 0x95, 0x9c, 0x87, 0x8e, 0xb1, 0xb8, 0xa3, 0xaa, 0xec, 0xe5, 0xfe, 0xf7, 0xc8, 0xc1, 0xda, 0xd3, 0xa4, 0xad, 0xb6, 0xbf, 0x80, 0x89, 0x92, 0x9b, 0x7c, 0x75, 0x6e, 0x67, 0x58, 0x51, 0x4a, 0x43, 0x34, 0x3d, 0x26, 0x2f, 0x10, 0x19, 0x02, 0x0b, 0xd7, 0xde, 0xc5, 0xcc, 0xf3, 0xfa, 0xe1, 0xe8, 0x9f, 0x96, 0x8d, 0x84, 0xbb, 0xb2, 0xa9, 0xa0, 0x47, 0x4e, 0x55, 0x5c, 0x63, 0x6a, 0x71, 0x78, 0x0f, 0x06, 0x1d, 0x14, 0x2b, 0x22, 0x39, 0x30, 0x9a, 0x93, 0x88, 0x81, 0xbe, 0xb7, 0xac, 0xa5, 0xd2, 0xdb, 0xc0, 0xc9, 0xf6, 0xff, 0xe4, 0xed, 0x0a, 0x03, 0x18, 0x11, 0x2e, 0x27, 0x3c, 0x35, 0x42, 0x4b, 0x50, 0x59, 0x66, 0x6f, 0x74, 0x7d, 0xa1, 0xa8, 0xb3, 0xba, 0x85, 0x8c, 0x97, 0x9e, 0xe9, 0xe0, 0xfb, 0xf2, 0xcd, 0xc4, 0xdf, 0xd6, 0x31, 0x38, 0x23, 0x2a, 0x15, 0x1c, 0x07, 0x0e, 0x79, 0x70, 0x6b, 0x62, 0x5d, 0x54, 0x4f, 0x46};

constant uchar fieldEleven[] = {0x00, 0x0b, 0x16, 0x1d, 0x2c, 0x27, 0x3a, 0x31, 0x58, 0x53, 0x4e, 0x45, 0x74, 0x7f, 0x62, 0x69, 0xb0, 0xbb, 0xa6, 0xad, 0x9c, 0x97, 0x8a, 0x81, 0xe8, 0xe3, 0xfe, 0xf5, 0xc4, 0xcf, 0xd2, 0xd9, 0x7b, 0x70, 0x6d, 0x66, 0x57, 0x5c, 0x41, 0x4a, 0x23, 0x28, 0x35, 0x3e, 0x0f, 0x04, 0x19, 0x12, 0xcb, 0xc0, 0xdd, 0xd6, 0xe7, 0xec, 0xf1, 0xfa, 0x93, 0x98, 0x85, 0x8e, 0xbf, 0xb4, 0xa9, 0xa2, 0xf6, 0xfd, 0xe0, 0xeb, 0xda, 0xd1, 0xcc, 0xc7, 0xae, 0xa5, 0xb8, 0xb3, 0x82, 0x89, 0x94, 0x9f, 0x46, 0x4d, 0x50, 0x5b, 0x6a, 0x61, 0x7c, 0x77, 0x1e, 0x15, 0x08, 0x03, 0x32, 0x39, 0x24, 0x2f, 0x8d, 0x86, 0x9b, 0x90, 0xa1, 0xaa, 0xb7, 0xbc, 0xd5, 0xde, 0xc3, 0xc8, 0xf9, 0xf2, 0xef, 0xe4, 0x3d, 0x36, 0x2b, 0x20, 0x11, 0x1a, 0x07, 0x0c, 0x65, 0x6e, 0x73, 0x78, 0x49, 0x42, 0x5f, 0x54, 0xf7, 0xfc, 0xe1, 0xea, 0xdb, 0xd0, 0xcd, 0xc6, 0xaf, 0xa4, 0xb9, 0xb2, 0x83, 0x88, 0x95, 0x9e, 0x47, 0x4c, 0x51, 0x5a, 0x6b, 0x60, 0x7d, 0x76, 0x1f, 0x14, 0x09, 0x02, 0x33, 0x38, 0x25, 0x2e, 0x8c, 0x87, 0x9a, 0x91, 0xa0, 0xab, 0xb6, 0xbd, 0xd4, 0xdf, 0xc2, 0xc9, 0xf8, 0xf3, 0xee, 0xe5, 0x3c, 0x37, 0x2a, 0x21, 0x10, 0x1b, 0x06, 0x0d, 0x64, 0x6f, 0x72, 0x79, 0x48, 0x43, 0x5e, 0x55, 0x01, 0x0a, 0x17, 0x1c, 0x2d, 0x26, 0x3b, 0x30, 0x59, 0x52, 0x4f, 0x44, 0x75, 0x7e, 0x63, 0x68, 0xb1, 0xba, 0xa7, 0xac, 0x9d, 0x96, 0x8b, 0x80, 0xe9, 0xe2, 0xff, 0xf4, 0xc5, 0xce, 0xd3, 0xd8, 0x7a, 0x71, 0x6c, 0x67, 0x56, 0x5d, 0x40, 0x4b, 0x22, 0x29, 0x34, 0x3f, 0x0e, 0x05, 0x18, 0x13, 0xca, 0xc1, 0xdc, 0xd7, 0xe6, 0xed, 0xf0, 0xfb, 0x92, 0x99, 0x84, 0x8f, 0xbe, 0xb5, 0xa8, 0xa3};

constant uchar fieldThirteen[] = {0x00, 0x0d, 0x1a, 0x17, 0x34, 0x39, 0x2e, 0x23, 0x68, 0x65, 0x72, 0x7f, 0x5c, 0x51, 0x46, 0x4b, 0xd0, 0xdd, 0xca, 0xc7, 0xe4, 0xe9, 0xfe, 0xf3, 0xb8, 0xb5, 0xa2, 0xaf, 0x8c, 0x81, 0x96, 0x9b, 0xbb, 0xb6, 0xa1, 0xac, 0x8f, 0x82, 0x95, 0x98, 0xd3, 0xde, 0xc9, 0xc4, 0xe7, 0xea, 0xfd, 0xf0, 0x6b, 0x66, 0x71, 0x7c, 0x5f, 0x52, 0x45, 0x48, 0x03, 0x0e, 0x19, 0x14, 0x37, 0x3a, 0x2d, 0x20, 0x6d, 0x60, 0x77, 0x7a, 0x59, 0x54, 0x43, 0x4e, 0x05, 0x08, 0x1f, 0x12, 0x31, 0x3c, 0x2b, 0x26, 0xbd, 0xb0, 0xa7, 0xaa, 0x89, 0x84, 0x93, 0x9e, 0xd5, 0xd8, 0xcf, 0xc2, 0xe1, 0xec, 0xfb, 0xf6, 0xd6, 0xdb, 0xcc, 0xc1, 0xe2, 0xef, 0xf8, 0xf5, 0xbe, 0xb3, 0xa4, 0xa9, 0x8a, 0x87, 0x90, 0x9d, 0x06, 0x0b, 0x1c, 0x11, 0x32, 0x3f, 0x28, 0x25, 0x6e, 0x63, 0x74, 0x79, 0x5a, 0x57, 0x40, 0x4d, 0xda, 0xd7, 0xc0, 0xcd, 0xee, 0xe3, 0xf4, 0xf9, 0xb2, 0xbf, 0xa8, 0xa5, 0x86, 0x8b, 0x9c, 0x91, 0x0a, 0x07, 0x10, 0x1d, 0x3e, 0x33, 0x24, 0x29, 0x62, 0x6f, 0x78, 0x75, 0x56, 0x5b, 0x4c, 0x41, 0x61, 0x6c, 0x7b, 0x76, 0x55, 0x58, 0x4f, 0x42, 0x09, 0x04, 0x13, 0x1e, 0x3d, 0x30, 0x27, 0x2a, 0xb1, 0xbc, 0xab, 0xa6, 0x85, 0x88, 0x9f, 0x92, 0xd9, 0xd4, 0xc3, 0xce, 0xed, 0xe0, 0xf7, 0xfa, 0xb7, 0xba, 0xad, 0xa0, 0x83, 0x8e, 0x99, 0x94, 0xdf, 0xd2, 0xc5, 0xc8, 0xeb, 0xe6, 0xf1, 0xfc, 0x67, 0x6a, 0x7d, 0x70, 0x53, 0x5e, 0x49, 0x44, 0x0f, 0x02, 0x15, 0x18, 0x3b, 0x36, 0x21, 0x2c, 0x0c, 0x01, 0x16, 0x1b, 0x38, 0x35, 0x22, 0x2f, 0x64, 0x69, 0x7e, 0x73, 0x50, 0x5d, 0x4a, 0x47, 0xdc, 0xd1, 0xc6, 0xcb, 0xe8, 0xe5, 0xf2, 0xff, 0xb4, 0xb9, 0xae, 0xa3, 0x80, 0x8d, 0x9a, 0x97};

constant uchar fieldFourteen[] = {
    0x00, 0x0e, 0x1c, 0x12, 0x38, 0x36, 0x24, 0x2a, 0x70, 0x7e, 0x6c, 0x62, 0x48, 0x46, 0x54, 0x5a, 0xe0, 0xee, 0xfc, 0xf2, 0xd8, 0xd6, 0xc4, 0xca, 0x90, 0x9e, 0x8c, 0x82, 0xa8, 0xa6, 0xb4, 0xba, 0xdb, 0xd5, 0xc7, 0xc9, 0xe3, 0xed, 0xff, 0xf1, 0xab, 0xa5, 0xb7, 0xb9, 0x93, 0x9d, 0x8f, 0x81, 0x3b, 0x35, 0x27, 0x29, 0x03, 0x0d, 0x1f, 0x11, 0x4b, 0x45, 0x57, 0x59, 0x73, 0x7d, 0x6f, 0x61, 0xad, 0xa3, 0xb1, 0xbf, 0x95, 0x9b, 0x89, 0x87, 0xdd, 0xd3, 0xc1, 0xcf, 0xe5, 0xeb, 0xf9, 0xf7, 0x4d, 0x43, 0x51, 0x5f, 0x75, 0x7b, 0x69, 0x67, 0x3d, 0x33, 0x21, 0x2f, 0x05, 0x0b, 0x19, 0x17, 0x76, 0x78, 0x6a, 0x64, 0x4e, 0x40, 0x52, 0x5c, 0x06, 0x08, 0x1a, 0x14, 0x3e, 0x30, 0x22, 0x2c, 0x96, 0x98, 0x8a, 0x84, 0xae, 0xa0, 0xb2, 0xbc, 0xe6, 0xe8, 0xfa, 0xf4, 0xde, 0xd0, 0xc2, 0xcc, 0x41, 0x4f, 0x5d, 0x53, 0x79, 0x77, 0x65, 0x6b, 0x31, 0x3f, 0x2d, 0x23, 0x09, 0x07, 0x15, 0x1b, 0xa1, 0xaf, 0xbd, 0xb3, 0x99, 0x97, 0x85, 0x8b, 0xd1, 0xdf, 0xcd, 0xc3, 0xe9, 0xe7, 0xf5, 0xfb, 0x9a, 0x94, 0x86, 0x88, 0xa2, 0xac, 0xbe, 0xb0, 0xea, 0xe4, 0xf6, 0xf8, 0xd2, 0xdc, 0xce, 0xc0, 0x7a, 0x74, 0x66, 0x68, 0x42, 0x4c, 0x5e, 0x50, 0x0a, 0x04, 0x16, 0x18, 0x32, 0x3c, 0x2e, 0x20, 0xec, 0xe2, 0xf0, 0xfe, 0xd4, 0xda, 0xc8, 0xc6, 0x9c, 0x92, 0x80, 0x8e, 0xa4, 0xaa, 0xb8, 0xb6, 0x0c, 0x02, 0x10, 0x1e, 0x34, 0x3a, 0x28, 0x26, 0x7c, 0x72, 0x60, 0x6e, 0x44, 0x4a, 0x58, 0x56, 0x37, 0x39, 0x2b, 0x25, 0x0f, 0x01, 0x13, 0x1d, 0x47, 0x49, 0x5b, 0x55, 0x7f, 0x71, 0x63, 0x6d, 0xd7, 0xd9, 0xcb, 0xc5, 0xef, 0xe1, 0xf3, 0xfd, 0xa7, 0xa9, 0xbb, 0xb5, 0x9f, 0x91, 0x83, 0x8d,
};

void ComputeRoundKeys(uchar* roundKeys, unsigned int rounds, uchar* key) {
  uchar rotWord[4];

  for (unsigned int k = 0; k < 32; k++) {
    roundKeys[hook(15, k)] = key[hook(16, k)];
  }

  for (int k = 1; k < (rounds); k++) {
    size_t offset = 32 + (k - 1) * 16;

    if (k & 1) {
      rotWord[hook(17, 0)] = AES_SBox[hook(18, roundKeys[ohook(15, offset - 3))] ^ Rcon[hook(19, (k + 1) >> 1)];
      rotWord[hook(17, 1)] = AES_SBox[hook(18, roundKeys[ohook(15, offset - 2))];
      rotWord[hook(17, 2)] = AES_SBox[hook(18, roundKeys[ohook(15, offset - 1))];
      rotWord[hook(17, 3)] = AES_SBox[hook(18, roundKeys[ohook(15, offset - 4))];
    } else {
      rotWord[hook(17, 0)] = AES_SBox[hook(18, roundKeys[ohook(15, offset - 4))];
      rotWord[hook(17, 1)] = AES_SBox[hook(18, roundKeys[ohook(15, offset - 3))];
      rotWord[hook(17, 2)] = AES_SBox[hook(18, roundKeys[ohook(15, offset - 2))];
      rotWord[hook(17, 3)] = AES_SBox[hook(18, roundKeys[ohook(15, offset - 1))];
    }

    roundKeys[hook(15, offset + 0)] = roundKeys[hook(15, offset - 32)] ^ rotWord[hook(17, 0)];
    roundKeys[hook(15, offset + 1)] = roundKeys[hook(15, offset - 31)] ^ rotWord[hook(17, 1)];
    roundKeys[hook(15, offset + 2)] = roundKeys[hook(15, offset - 30)] ^ rotWord[hook(17, 2)];
    roundKeys[hook(15, offset + 3)] = roundKeys[hook(15, offset - 29)] ^ rotWord[hook(17, 3)];

    ((unsigned int*)roundKeys)[hook(20, offset / 4 + 1)] = ((unsigned int*)roundKeys)[hook(20, offset / 4 + 0)] ^ ((unsigned int*)roundKeys)[hook(20, offset / 4 - 7)];
    ((unsigned int*)roundKeys)[hook(20, offset / 4 + 2)] = ((unsigned int*)roundKeys)[hook(20, offset / 4 + 1)] ^ ((unsigned int*)roundKeys)[hook(20, offset / 4 - 6)];
    ((unsigned int*)roundKeys)[hook(20, offset / 4 + 3)] = ((unsigned int*)roundKeys)[hook(20, offset / 4 + 2)] ^ ((unsigned int*)roundKeys)[hook(20, offset / 4 - 5)];
  }
}

void AddRoundKey(uchar* rkey, uchar* block, const unsigned int round) {
  for (unsigned int i = 0; i < 16; i++)
    block[hook(21, i)] ^= rkey[hook(22, round * 16 + i)];
}

void InverseShiftRows(uchar* block) {
  uchar temp[16];
  for (unsigned int i = 0; i < 16; i++)
    temp[hook(23, i)] = block[hook(21, i)];

  for (unsigned int i = 0; i < 16; i++) {
    unsigned int k = (i - (i % 4 * 4)) % 16;
    block[hook(21, i)] = temp[hook(23, k)];
  }
}

void InverseSubBytes(uchar* block) {
  for (unsigned int i = 0; i < 16; i++)
    block[hook(21, i)] = InvSBox[hook(24, block[ihook(21, i))];
}

void InverseMixColumn(uchar* column, unsigned int pos) {
  const uchar a = fieldFourteen[hook(25, column[phook(26, pos + 0))] ^ fieldNine[hook(27, column[phook(26, pos + 3))] ^ fieldThirteen[hook(28, column[phook(26, pos + 2))] ^ fieldEleven[hook(29, column[phook(26, pos + 1))];
  const uchar b = fieldFourteen[hook(25, column[phook(26, pos + 1))] ^ fieldNine[hook(27, column[phook(26, pos + 0))] ^ fieldThirteen[hook(28, column[phook(26, pos + 3))] ^ fieldEleven[hook(29, column[phook(26, pos + 2))];
  const uchar c = fieldFourteen[hook(25, column[phook(26, pos + 2))] ^ fieldNine[hook(27, column[phook(26, pos + 1))] ^ fieldThirteen[hook(28, column[phook(26, pos + 0))] ^ fieldEleven[hook(29, column[phook(26, pos + 3))];
  const uchar d = fieldFourteen[hook(25, column[phook(26, pos + 3))] ^ fieldNine[hook(27, column[phook(26, pos + 2))] ^ fieldThirteen[hook(28, column[phook(26, pos + 1))] ^ fieldEleven[hook(29, column[phook(26, pos + 0))];

  column[hook(26, pos + 0)] = a;
  column[hook(26, pos + 1)] = b;
  column[hook(26, pos + 2)] = c;
  column[hook(26, pos + 3)] = d;
}

void InverseMixColumns(uchar* block) {
  InverseMixColumn(block, 0);
  InverseMixColumn(block, 4);
  InverseMixColumn(block, 8);
  InverseMixColumn(block, 12);
}

kernel void func_pbkdf2(constant const ulong* pwstart, constant const unsigned int* salt, constant const uchar* iv, constant const uchar* oridata, global bool* result) {
  ulong idx = get_global_id(0);

  ulong pwidx = idx + *pwstart;
  uchar pw[7] = {0};
  for (ulong i = 0; i <= 7 - 1; i++) {
    ulong val = pwidx % 16;
    if (val >= 10) {
      pw[hook(30, 7 - 1 - i)] = val + 87;
    } else {
      pw[hook(30, 7 - 1 - i)] = val + 48;
    }
    pwidx = pwidx / 16;
  }

  unsigned int hash[32 / 4] = {0};
  pbkdf((unsigned int*)pw, 7, salt, 16, hash);

  uchar* key = (uchar*)hash;
  uchar data[16] = {0};

  for (unsigned int i = 0; i < 16; i++) {
    data[hook(31, i)] = oridata[hook(3, i)];
  }

  uchar rkey[256] = {0};

  unsigned int rounds = 0;
  switch (32) {
    case 16:
      rounds = 11;
      break;
    case 24:
      rounds = 12;
      break;
    case 32:
      rounds = 15;
      break;
  }

  ComputeRoundKeys(rkey, rounds, key);

  AddRoundKey(rkey, data, rounds - 1);

  for (unsigned int j = 1; j < rounds - 1; ++j) {
    const unsigned int round = rounds - 1 - j;
    InverseShiftRows(data);
    InverseSubBytes(data);
    AddRoundKey(rkey, data, round);
    InverseMixColumns(data);
  }
  InverseSubBytes(data);
  InverseShiftRows(data);
  AddRoundKey(rkey, data, 0);

  if (((unsigned int)(data[hook(31, 0)] ^ iv[hook(2, 0)]) == 4) && ((unsigned int)(data[hook(31, 1)] ^ iv[hook(2, 1)]) == 0) && ((unsigned int)(data[hook(31, 2)] ^ iv[hook(2, 2)]) == 1) && ((unsigned int)(data[hook(31, 3)] ^ iv[hook(2, 3)]) == 1)) {
    result[hook(4, idx)] = true;
  }
}
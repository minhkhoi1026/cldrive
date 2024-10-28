//{"INDEX":9,"found":6,"loop_count":8,"mid_high":2,"mid_low":1,"min_weight_magnitude":5,"nonce_probe":7,"sp_high":11,"sp_low":10,"state_high":4,"state_low":3,"trit_hash":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant size_t INDEX[3 * 243 + 1] = {0, 364, 728, 363, 727, 362, 726, 361, 725, 360, 724, 359, 723, 358, 722, 357, 721, 356, 720, 355, 719, 354, 718, 353, 717, 352, 716, 351, 715, 350, 714, 349, 713, 348, 712, 347, 711, 346, 710, 345, 709, 344, 708, 343, 707, 342, 706, 341, 705, 340, 704, 339, 703, 338, 702, 337, 701, 336, 700, 335, 699, 334, 698, 333, 697, 332, 696, 331, 695, 330, 694, 329, 693, 328, 692, 327, 691, 326, 690, 325, 689, 324, 688, 323, 687, 322, 686, 321, 685, 320, 684, 319, 683, 318, 682, 317, 681, 316, 680, 315, 679, 314, 678, 313, 677, 312, 676, 311, 675, 310, 674, 309, 673, 308, 672, 307, 671, 306, 670, 305, 669, 304, 668, 303, 667, 302, 666, 301, 665, 300, 664, 299, 663, 298, 662, 297, 661, 296, 660, 295, 659, 294, 658, 293, 657, 292, 656, 291, 655, 290, 654, 289, 653, 288, 652, 287, 651, 286, 650, 285, 649, 284, 648, 283, 647, 282, 646, 281, 645, 280, 644, 279, 643, 278, 642, 277, 641, 276, 640, 275, 639, 274, 638, 273, 637, 272, 636, 271, 635, 270, 634, 269, 633, 268, 632, 267, 631, 266, 630, 265, 629, 264, 628, 263, 627, 262, 626, 261, 625, 260, 624, 259, 623, 258, 622, 257, 621, 256, 620, 255, 619, 254, 618, 253, 617, 252, 616, 251, 615, 250, 614, 249, 613, 248, 612, 247, 611, 246, 610, 245, 609, 244, 608, 243, 607, 242, 606, 241, 605, 240, 604, 239, 603, 238, 602, 237, 601, 236, 600, 235, 599, 234, 598, 233, 597, 232, 596, 231, 595, 230, 594, 229, 593, 228, 592, 227, 591, 226, 590, 225, 589, 224, 588, 223, 587, 222, 586, 221, 585, 220, 584, 219, 583, 218, 582, 217, 581, 216, 580, 215, 579, 214, 578, 213, 577, 212, 576, 211, 575, 210, 574, 209, 573, 208, 572, 207, 571, 206, 570, 205, 569, 204, 568, 203, 567, 202, 566, 201, 565, 200, 564, 199, 563, 198, 562, 197, 561, 196, 560, 195, 559, 194, 558, 193, 557, 192, 556, 191, 555, 190, 554, 189, 553, 188, 552, 187, 551, 186, 550, 185, 549, 184, 548, 183, 547, 182, 546, 181, 545, 180, 544, 179, 543, 178, 542, 177, 541, 176, 540, 175, 539, 174, 538, 173, 537, 172, 536, 171, 535, 170, 534, 169, 533, 168, 532, 167, 531, 166, 530, 165, 529, 164, 528, 163, 527, 162, 526, 161, 525, 160, 524, 159, 523, 158, 522, 157, 521, 156, 520, 155, 519, 154, 518, 153, 517, 152, 516, 151, 515, 150, 514, 149, 513, 148, 512, 147, 511, 146, 510, 145, 509, 144, 508, 143, 507, 142, 506, 141, 505, 140, 504, 139, 503, 138, 502, 137, 501, 136, 500, 135, 499, 134, 498, 133, 497, 132, 496, 131, 495, 130, 494, 129, 493, 128, 492, 127, 491, 126, 490, 125, 489, 124, 488, 123, 487, 122, 486, 121, 485, 120, 484, 119, 483, 118, 482, 117, 481, 116, 480, 115, 479, 114, 478, 113, 477, 112, 476, 111, 475, 110, 474, 109, 473, 108, 472, 107, 471, 106, 470, 105, 469, 104, 468, 103, 467, 102, 466, 101, 465, 100, 464, 99, 463, 98, 462, 97, 461, 96, 460, 95, 459, 94, 458, 93, 457, 92, 456, 91, 455, 90, 454, 89, 453, 88, 452, 87, 451, 86, 450, 85, 449, 84, 448, 83, 447, 82, 446, 81, 445, 80, 444, 79, 443, 78, 442, 77, 441, 76, 440, 75, 439, 74, 438, 73, 437, 72, 436, 71, 435, 70, 434, 69, 433, 68, 432, 67, 431, 66, 430, 65, 429, 64, 428, 63, 427, 62, 426, 61, 425, 60, 424, 59, 423, 58, 422, 57, 421, 56, 420, 55, 419, 54, 418, 53, 417, 52, 416, 51, 415, 50, 414, 49, 413, 48, 412, 47, 411, 46, 410, 45, 409, 44, 408, 43, 407, 42, 406, 41, 405, 40, 404, 39, 403, 38, 402, 37, 401, 36, 400, 35, 399, 34, 398, 33, 397, 32, 396, 31, 395, 30, 394, 29, 393, 28, 392, 27, 391, 26, 390, 25, 389, 24, 388, 23, 387, 22, 386, 21, 385, 20, 384, 19, 383, 18, 382, 17, 381, 16, 380, 15, 379, 14, 378, 13, 377, 12, 376, 11, 375, 10, 374, 9, 373, 8, 372, 7, 371, 6, 370, 5, 369, 4, 368, 3, 367, 2, 366, 1, 365, 0};

typedef long long;

void increment(global long* mid_low, global long* mid_high, private size_t from_index, private size_t to_index);
void copy_mid_to_state(global long* mid_low, global long* mid_high, global long* state_low, global long* state_high, private size_t id, private size_t l_size, private size_t l_trits);
void transform(global long* state_low, global long* state_high, private size_t id, private size_t l_size, private size_t l_trits);
void check(global long* state_low, global long* state_high, global volatile char* found, constant size_t* min_weight_magnitude, global long* nonce_probe, private size_t gr_id);
void setup_ids(private size_t* id, private size_t* gid, private size_t* gr_id, private size_t* l_size, private size_t* n_trits);

void increment(global long* mid_low, global long* mid_high, private size_t from_index, private size_t to_index) {
  size_t i;
  long carry = 1;
  long low, hi;
  for (i = from_index; i < to_index && carry != 0; i++) {
    low = mid_low[hook(1, i)];
    hi = mid_high[hook(2, i)];
    mid_low[hook(1, i)] = hi ^ low;
    mid_high[hook(2, i)] = low;
    carry = hi & (~low);
  }
}

void copy_mid_to_state(global long* mid_low, global long* mid_high, global long* state_low, global long* state_high, private size_t id, private size_t l_size, private size_t n_trits) {
  size_t i, j;
  for (i = 0; i < n_trits; i++) {
    j = id + i * l_size;
    state_low[hook(3, j)] = mid_low[hook(1, j)];
    state_high[hook(4, j)] = mid_high[hook(2, j)];
  }
}

void transform(global long* state_low, global long* state_high, private size_t id, private size_t l_size, private size_t n_trits) {
 private
  size_t round, i, j, k;
 private
  long alpha, beta, gamma, delta, sp_low[3], sp_high[3];
  for (round = 0; round < 81; round++) {
    for (i = 0; i < n_trits; i++) {
      j = id + i * l_size;
      k = j + 1;
      alpha = state_low[hook(3, INDEX[jhook(9, j))];
      beta = state_high[hook(4, INDEX[jhook(9, j))];
      gamma = state_high[hook(4, INDEX[khook(9, k))];
      delta = (alpha | (~gamma)) & (state_low[hook(3, INDEX[khook(9, k))] ^ beta);

      sp_low[hook(10, i)] = ~delta;
      sp_high[hook(11, i)] = (alpha ^ gamma) | delta;
    }
    barrier(0x01);
    for (i = 0; i < n_trits; i++) {
      j = id + i * l_size;
      state_low[hook(3, j)] = sp_low[hook(10, i)];
      state_high[hook(4, j)] = sp_high[hook(11, i)];
    }
    barrier(0x01);
  }
}

void check(global long* state_low, global long* state_high, global volatile char* found, constant size_t* min_weight_magnitude, global long* nonce_probe, private size_t gr_id) {
  int i;
  *nonce_probe = 0xFFFFFFFFFFFFFFFF;
  for (i = 243 - *min_weight_magnitude; i < 243; i++) {
    *nonce_probe &= ~(state_low[hook(3, i)] ^ state_high[hook(4, i)]);
    if (*nonce_probe == 0)
      return;
  }
  if (*nonce_probe != 0) {
    *found = gr_id + 1;
  }
}

void setup_ids(private size_t* id, private size_t* gid, private size_t* gr_id, private size_t* l_size, private size_t* n_trits) {
 private
  size_t l_rem;
  *id = get_local_id(0);
  *l_size = get_local_size(0);
  *gr_id = get_global_id(0) / *l_size;
  *gid = *gr_id * 3 * 243;
  l_rem = 3 * 243 % *l_size;
  *n_trits = 3 * 243 / *l_size;
  *n_trits += l_rem == 0 ? 0 : 1;
  *n_trits -= (*n_trits) * (*id) < 3 * 243 ? 0 : 1;
}

kernel void search(global char* trit_hash, global long* mid_low, global long* mid_high, global long* state_low, global long* state_high, constant size_t* min_weight_magnitude, global volatile char* found, global long* nonce_probe, constant size_t* loop_count) {
 private
  size_t i, id, gid, gr_id, l_size, n_trits;
  setup_ids(&id, &gid, &gr_id, &l_size, &n_trits);

  for (i = 0; i < *loop_count; i++) {
    if (id == 0)
      increment(&(mid_low[hook(1, gid)]), &(mid_high[hook(2, gid)]), 243 - 243 / 3 + 4 + 243 / 3 / 3, 243);

    barrier(0x01);
    copy_mid_to_state(&(mid_low[hook(1, gid)]), &(mid_high[hook(2, gid)]), &(state_low[hook(3, gid)]), &(state_high[hook(4, gid)]), id, l_size, n_trits);

    barrier(0x01);
    transform(&(state_low[hook(3, gid)]), &(state_high[hook(4, gid)]), id, l_size, n_trits);

    barrier(0x01);
    if (id == 0)
      check(&(state_low[hook(3, gid)]), &(state_high[hook(4, gid)]), found, min_weight_magnitude, &(nonce_probe[hook(7, gr_id)]), gr_id);

    barrier(0x01);
    if (*found != 0)
      break;
  }
}
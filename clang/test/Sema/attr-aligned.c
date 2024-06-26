// RUN: %clang_cc1 -triple x86_64-apple-darwin9 -fsyntax-only -verify %s
// RUN: %clang_cc1 -triple i586-intel-elfiamcu -fsyntax-only -verify %s

int x __attribute__((aligned(3))); // expected-error {{requested alignment is not a power of 2}}
int y __attribute__((aligned(1ull << 33))); // expected-error {{requested alignment must be 4294967296 bytes or smaller}}
int y __attribute__((aligned(1ull << 32)));

// PR26444
int y __attribute__((aligned(1 << 29)));
int y __attribute__((aligned(1 << 28)));

// PR3254
short g0[3] __attribute__((aligned));
#ifdef __iamcu
short g0_chk[__alignof__(g0) == 4 ? 1 : -1];
#else
short g0_chk[__alignof__(g0) == 16 ? 1 : -1];

// GH50534
int z __attribute__((aligned((__int128_t)0x1234567890abcde0ULL << 64))); // expected-error {{requested alignment must be 4294967296 bytes or smaller}}
#endif

typedef char ueber_aligned_char __attribute__((aligned(8)));

struct struct_with_ueber_char {
  ueber_aligned_char c;
};

char a = 0;

char a0[__alignof__(ueber_aligned_char) == 8? 1 : -1] = { 0 };
char a1[__alignof__(struct struct_with_ueber_char) == 8? 1 : -1] = { 0 };
char a2[__alignof__(a) == 1? : -1] = { 0 };
char a3[sizeof(a) == 1? : -1] = { 0 };

typedef long long __attribute__((aligned(1))) underaligned_longlong;
char a4[__alignof__(underaligned_longlong) == 1 ?: -1] = {0};

typedef long long __attribute__((aligned(1))) underaligned_complex_longlong;
char a5[__alignof__(underaligned_complex_longlong) == 1 ?: -1] = {0};

int b __attribute__((aligned(2)));
char b1[__alignof__(b) == 2 ?: -1] = {0};

struct C { int member __attribute__((aligned(2))); } c;
char c1[__alignof__(c) == 4 ?: -1] = {0};
char c2[__alignof__(c.member) == 4 ?: -1] = {0};

struct D { int member __attribute__((aligned(2))) __attribute__((packed)); } d;
char d1[__alignof__(d) == 2 ?: -1] = {0};
char d2[__alignof__(d.member) == 2 ?: -1] = {0};

struct E { int member __attribute__((aligned(2))); } __attribute__((packed));
struct E e;
char e1[__alignof__(e) == 2 ?: -1] = {0};
char e2[__alignof__(e.member) == 2 ?: -1] = {0};

typedef struct { char c[16]; } S;
typedef S overaligned_struct __attribute__((aligned(16)));
typedef overaligned_struct array_with_overaligned_struct[11];
typedef char array_with_align_attr[11] __attribute__((aligned(16)));

char f0[__alignof__(array_with_overaligned_struct) == 16 ? 1 : -1] = { 0 };
char f1[__alignof__(array_with_align_attr) == 16 ? 1 : -1] = { 0 };
array_with_overaligned_struct F2;
char f2[__alignof__(F2) == 16 ? 1 : -1] = { 0 };
array_with_align_attr F3;
char f3[__alignof__(F3) == 16 ? 1 : -1] = { 0 };

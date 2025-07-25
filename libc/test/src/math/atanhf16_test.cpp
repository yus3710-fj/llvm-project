//===-- Unittests for atanhf16 --------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "hdr/stdint_proxy.h"
#include "src/math/atanhf16.h"
#include "test/UnitTest/FPMatcher.h"
#include "test/UnitTest/Test.h"
#include "utils/MPFRWrapper/MPFRUtils.h"

using LlvmLibcAtanhf16Test = LIBC_NAMESPACE::testing::FPTest<float16>;
namespace mpfr = LIBC_NAMESPACE::testing::mpfr;

// Range for positive numbers: [0, +Inf]
static constexpr uint16_t POS_START = 0x0000U;
static constexpr uint16_t POS_STOP = 0x7C00U;

// Range for negative numbers: [-Inf, 0]
static constexpr uint16_t NEG_START = 0x8000U;
static constexpr uint16_t NEG_STOP = 0xFC00U;

TEST_F(LlvmLibcAtanhf16Test, PositiveRange) {
  for (uint16_t v = POS_START; v <= POS_STOP; ++v) {
    float16 x = FPBits(v).get_val();
    EXPECT_MPFR_MATCH_ALL_ROUNDING(mpfr::Operation::Atanh, x,
                                   LIBC_NAMESPACE::atanhf16(x), 0.5);
  }
}

TEST_F(LlvmLibcAtanhf16Test, NegativeRange) {
  for (uint16_t v = NEG_START; v <= NEG_STOP; ++v) {
    float16 x = FPBits(v).get_val();
    EXPECT_MPFR_MATCH_ALL_ROUNDING(mpfr::Operation::Atanh, x,
                                   LIBC_NAMESPACE::atanhf16(x), 0.5);
  }
}

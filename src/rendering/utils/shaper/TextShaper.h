/////////////////////////////////////////////////////////////////////////////////////////////////
//
//  Tencent is pleased to support the open source community by making libpag available.
//
//  Copyright (C) 2021 Tencent. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file
//  except in compliance with the License. You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  unless required by applicable law or agreed to in writing, software distributed under the
//  license is distributed on an "as is" basis, without warranties or conditions of any kind,
//  either express or implied. see the license for the specific language governing permissions
//  and limitations under the license.
//
/////////////////////////////////////////////////////////////////////////////////////////////////

#pragma once

#include "ShapedGlyph.h"
#include "tgfx/core/Typeface.h"

namespace pag {
/**
 * TextShaper is a utility class for shaping text.
 */
class TextShaper {
 public:
  /**
   * Shapes the given text using the specified typeface.
   */
  static std::vector<ShapedGlyph> Shape(const std::string& text,
                                        std::shared_ptr<tgfx::Typeface> typeface);

  /**
   * Purges the caches used by the text shaper.
   */
  static void PurgeCaches();
};
}  // namespace pag

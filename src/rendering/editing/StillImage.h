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

#include "pag/pag.h"
#include "rendering/graphics/Graphic.h"
#include "tgfx/core/ImageCodec.h"

namespace pag {

class StillImage : public PAGImage {
 public:
  static std::shared_ptr<StillImage> MakeFrom(std::shared_ptr<tgfx::Image> image);

 protected:
  std::shared_ptr<Graphic> getGraphic(int64_t) const override {
    return graphic;
  }

  bool isStill() const override {
    return true;
  }

  Frame getContentFrame(int64_t) const override {
    return 0;
  }

 private:
  StillImage(int width, int height) : PAGImage(width, height) {
  }

  std::shared_ptr<Graphic> graphic = nullptr;

  friend class PAGImage;
};
}  // namespace pag

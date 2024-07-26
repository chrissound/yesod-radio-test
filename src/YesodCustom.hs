{-# LANGUAGE ConstraintKinds #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE CPP #-}

module YesodCustom where

import Yesod
import Yesod.Form.Types
import Yesod.Form.Fields
import Text.Shakespeare.I18N
import Yesod.Core.Handler

-- TODO: Improve, and upstream
--
-- The original implementation in the yesod-form library has two problems.
--
-- 1. The markup it produces is awkward to work with, and doesn't actually work
--    together with the `byLabelExact` function from the yesod-test library.
--    This custom implementation is better for actual use (like with CSS), and
--    also works with the `byLabelExact` function.
--
-- 2. The type signature specialises this function to `HandlerFor site a`, which
--    means it's awkward to use this field (and also checkbox or select fields)
--    in a subsite; you need to lift the entire form into the master site. It's
--    not enough to change the type signature here; this function is implemented
--    in terms of `withRadioField`, which also specialises. And, of course, the
--    `withRadioField` function is implemented in terms of `selectFieldHelp`,
--    which also specialises… ಠ_ಠ
radioField' :: (Eq a, RenderMessage site FormMessage)
           => HandlerFor site (OptionList a)
           -> Field (HandlerFor site) a
radioField' = withRadioField
    (\theId optionWidget -> [whamlet|
$newline never
<.radio>
  ^{optionWidget}
  <label for=#{theId}-none>
    _{MsgSelectNone}
|])
    (\theId value _isSel text optionWidget -> [whamlet|
$newline never
<.radio>
  ^{optionWidget}
  <label for=#{theId}-#{value}>
    \#{text}
|])

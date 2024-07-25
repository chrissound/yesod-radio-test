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

-- | Creates an input with @type="radio"@ for selecting one option.
radioField' :: (Eq a, RenderMessage site FormMessage)
           => HandlerFor site (OptionList a)
           -> Field (HandlerFor site) a
radioField' = withRadioField
    (\theId optionWidget -> [whamlet|
$newline never
<div .radio>
    <label for=#{theId}-none>
        <div>
            ^{optionWidget}
            _{MsgSelectNone}
|])
    (\theId value _isSel text optionWidget -> [whamlet|
$newline never
<div .radio>
    <label for=#{theId}-#{value}>
        <div>
            ^{optionWidget}
            \#{text}
|])

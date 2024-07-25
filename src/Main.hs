{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}
{-# LANGUAGE TemplateHaskell   #-}
{-# LANGUAGE TypeFamilies      #-}
{-# LANGUAGE ViewPatterns      #-}
{-# LANGUAGE MultiParamTypeClasses #-}

import Yesod
import Yesod.Form
import Yesod.Form.Fields (radioField)
import Data.Text (Text)
import Data.String.Conversions
import Debug.Trace

data App = App

mkYesod "App" [parseRoutes|
/ HomeR GET POST
|]

instance Yesod App

instance RenderMessage App FormMessage where
    renderMessage _ _ = defaultFormMessage

data Color = Red | Green | Blue
    deriving (Show, Eq, Read)

colorOptions :: OptionList Color
colorOptions = OptionList
    [ Option { optionDisplay = "Red", optionInternalValue = Red, optionExternalValue = "Red" }
    , Option { optionDisplay = "Green", optionInternalValue = Green, optionExternalValue = "Green" }
    , Option { optionDisplay = "Blue", optionInternalValue = Blue, optionExternalValue = "Blue" }
    ]
    ((Just . read . cs . traceShowId) :: Text -> Maybe Color)

data ColorForm = ColorForm
    { colorChoice :: Color
    } deriving Show

colorForm :: AForm Handler ColorForm
colorForm = ColorForm
    <$> areq (radioField (pure colorOptions)) "Choose a color" Nothing

getHomeR :: Handler Html
getHomeR = do
    (widget, enctype) <- generateFormPost (renderDivs colorForm)
    defaultLayout [whamlet|
        <form method=post action=@{HomeR} enctype=#{enctype}>
            ^{widget}
            <button type=submit>Submit
    |]

postHomeR :: Handler Html
postHomeR = do
    ((result, widget), enctype) <- runFormPost (renderDivs colorForm)
    case result of
        FormSuccess form -> defaultLayout [whamlet|
            <p>You chose: #{show $ colorChoice form}
        |]
        _ -> defaultLayout [whamlet|
            <p>Invalid input, try again:
            <form method=post action=@{HomeR} enctype=#{enctype}>
                ^{widget}
                <button type=submit>Submit
        |]

main :: IO ()
main = warp 3000 App

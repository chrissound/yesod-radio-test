{-# LANGUAGE OverloadedStrings #-}
module Test where

import Test.Hspec
import Test.Hspec
import Test.Hspec.Wai
import Yesod.Test
import Main
import Yesod

withApp :: SpecWith (TestApp App) -> Spec
withApp = before $ do
  pure (App, id)

main = do
  print "testing..."
  hspec spec

spec :: Spec
spec = withApp $ do
  describe "Homepage" $ do
    it "loads the homepage with a valid status code" $ do
      Yesod.Test.get HomeR
      statusIs 200
  describe "Radio select" $ do
    it "Selects radio button" $ do
      Yesod.Test.get HomeR
      statusIs 200

      htmlAnyContain "form" "Blue"

      -- Using byLabelExact
      Yesod.Test.request $ do
        setMethod "POST"
        setUrl HomeR
        byLabelExact "Choose a color" "Blue"

      statusIs 200
      htmlAnyContain "div" "You chose: Blue"


      --get DashboardR
      --statusIs 401

      --get HomeR
      ---- Assert a <p> tag exists on the page
      --htmlAnyContain "p" "Login"

      ---- yesod-test provides a RequestBuilder monad for building up HTTP requests
      --request $ do
        ---- Lookup the HTML <label> with the text Username, and set a POST parameter for that field with the value Felipe
        --byLabelExact "Username" "Felipe"
        --byLabelExact "Password" "pass"
        --setMethod "POST"
        --setUrl SignupR
      --statusIs 200

{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE NoImplicitPrelude #-}

module Handler.Loginn where

import Import

getLoginnR :: Handler Html
getLoginnR = do
  defaultLayout $ do
    setTitle "Login"
    $(widgetFile "login")

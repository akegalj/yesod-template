{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}

import Yesod

data App = App

mkYesod
  "App"
  [parseRoutes|
/ HomeR GET
|]

myLayout :: Widget -> Handler Html
myLayout widget = do
  pc <- widgetToPageContent widget
  withUrlRenderer
    [hamlet|
            $doctype 5
            <html lang="en">
              <head>
                <meta charset=utf-8>
                <meta name=viewport content="width=device-width, initial-scale=1">
                <title>#{pageTitle pc}
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-4bw+/aepP/YC94hEpVNVgiZdgIC5+VKNBQNGCHeKRQN+PtmoHDEXuppvnDJzQIu9" crossorigin="anonymous">
                ^{pageHead pc}
              <body>
                <div>
                  ^{pageBody pc}
                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/js/bootstrap.bundle.min.js" integrity="sha384-HwwvtgBNo3bZJJLYd8oVXjrBZt8cqVSpeBNS5n7C8IVInixGAoxmnlMuBnhbgrkm" crossorigin="anonymous">
        |]

instance Yesod App where
  defaultLayout = myLayout

getHomeR :: Handler Html
getHomeR =
  defaultLayout
    [whamlet|
<div class="login-form">
    <form action="/examples/actions/confirmation.php" method="post">
        <h2 class="text-center">Log in
        <div class="form-group">
            <input type="text" class="form-control" placeholder="Username" required="required">
        <div class="form-group">
            <input type="password" class="form-control" placeholder="Password" required="required">
        <div class="form-group">
            <button type="submit" class="btn btn-primary btn-block">Log in
        <div class="clearfix">
            <label class="float-left form-check-label"><input type="checkbox"> Remember me
            <a href="#" class="float-right">Forgot Password?
    <p class="text-center"><a href="#">Create an Account
|]

main :: IO ()
main = warp 3000 App

{-# LANGUAGE OverloadedStrings #-}

import Hakyll

config :: Configuration
config = defaultConfiguration
         { providerDirectory = "content"}

rules :: Rules ()
rules = do

  match "index.md" $ do
    route   $ setExtension "html"
    compile defaultCompiler

---------------------- Default compilers ---------------------------

defaultCompiler = pandocCompiler >>= relativizeUrls


main :: IO ()
main = hakyllWith config rules

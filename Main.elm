module Main where

import Todo exposing (..)
import StartApp.Simple exposing (start)

main =
  start
    { model = init "Buy groceries" False
    , update = update
    , view = view
    }

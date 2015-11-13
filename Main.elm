module Main where

import TodoList exposing (..)
import StartApp.Simple exposing (start)

main =
  start
    { model = init
    , update = update
    , view = view
    }

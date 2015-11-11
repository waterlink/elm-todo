module Todo ( Model, init, Action, update, view ) where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (on, targetChecked)

-- MODEL

type alias Model =
  { title : String
  , done : Bool
  }

init : String -> Bool -> Model
init title done =
  { title = title
  , done = done
  }

-- UPDATE

type Action
  = Toggle
  | Rename String

update : Action -> Model -> Model
update action model =
  case action of
    Toggle ->
      { model |
                done <- not model.done
      }

    Rename title ->
      { model |
                title <- title
      }

-- VIEW

(=>) = (,)

view : Signal.Address Action -> Model -> Html
view address model =
  div []
    (todoCheckbox address model.done Toggle model.title)

todoCheckbox : Signal.Address Action -> Bool -> Action -> String -> List Html
todoCheckbox address done action name =
  [ input
        [ type' "checkbox"
        , checked done
        , on "change" targetChecked (\_ -> Signal.message address action)
        ]
        []
  , span [ todoTitleStyle done ] [ text name ]
  , br [] []
  ]

todoTitleStyle : Bool -> Attribute
todoTitleStyle done =
  let
    textDecoration =
      if done
         then "line-through"
         else "inherit"
  in
    style
      [ "text-decoration" => textDecoration ]

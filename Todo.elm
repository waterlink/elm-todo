module Todo ( Model, init, Action, update, view, Context, viewWithContext, removeView ) where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (on, targetChecked, onClick, targetValue)

-- MODEL

type alias Model =
  { title : String
  , done : Bool
  , editing : Bool
  }

init : String -> Bool -> Model
init title done =
  { title = title
  , done = done
  , editing = False
  }

-- UPDATE

type Action
  = Toggle
  | Rename String
  | ToggleEdit

update : Action -> Model -> Model
update action model =
  case action of
    Toggle ->
      { model | done <- not model.done }

    Rename title ->
      { model | title <- title }

    ToggleEdit ->
      { model | editing <- not model.editing }

-- VIEW

(=>) = (,)

view : Signal.Address Action -> Model -> Html
view address model =
  div []
    (todoCheckbox address model Toggle [])

type alias Context =
  { actions : Signal.Address Action
  , remove : Signal.Address ()
  }

removeView : Context -> Html
removeView context =
  button [ onClick context.remove () ] [ text "remove" ]

viewWithContext : Context -> Model -> List (Context -> Html) -> Html
viewWithContext context model views =
  let contextual = List.map (\v -> v context) views
  in
     div []
       (todoCheckbox context.actions model Toggle contextual)

todoCheckbox : Signal.Address Action -> Model -> Action -> List Html -> List Html
todoCheckbox address model action contextual =
  [ input
        [ type' "checkbox"
        , checked model.done
        , on "change" targetChecked (\_ -> Signal.message address action)
        ]
        []
  , todoText address model
  , span [] [ text " " ]
  , todoEdit address model.editing
  ] ++ contextual ++ [ br [] [] ]

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

todoEdit : Signal.Address Action -> Bool -> Html
todoEdit address editing =
  if editing
     then a [ href "#", onClick address ToggleEdit ] [ text "done" ]
     else a [ href "#", onClick address ToggleEdit ] [ text "edit" ]

todoText : Signal.Address Action -> Model -> Html
todoText address model =
  if model.editing
     then input
       [ type' "text"
       , value model.title
       , on "input" targetValue (Signal.message address << Rename)
       ]
       [ ]
     else span [ todoTitleStyle model.done ] [ text model.title ]

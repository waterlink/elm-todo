module TodoList where

import Todo
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (on, targetChecked, onClick)

-- MODEL

type alias Model =
  { items : List ( ID, Todo.Model )
  , nextID : ID
  }

type alias ID = Int

init : Model
init =
  { items = []
  , nextID = 1
  }

-- UPDATE

type Action
  = Add
  | Remove ID
  | Modify ID Todo.Action

update : Action -> Model -> Model
update action model =
  case action of
    Add ->
      let
          todo = Todo.init "What do you want to do?" False
      in
         { model | items <- [ (model.nextID, todo) ] ++ model.items
         , nextID <- model.nextID + 1
         }

    Remove id ->
      let stays (itsID, _) = id /= itsID
      in { model | items <- List.filter stays model.items }

    Modify id itsAction ->
      let updateTodo (itsID, itsModel) =
        if id == itsID
           then (itsID, Todo.update itsAction itsModel)
           else (itsID, itsModel)
      in
         { model | items <- List.map updateTodo model.items }

-- VIEW

view : Signal.Address Action -> Model -> Html
view address model =
  let todos = List.map (viewTodo address) model.items
      add = button [ onClick address Add ] [ text "Add" ]
  in
     div [] ([ add ] ++ todos)

viewTodo : Signal.Address Action -> (ID, Todo.Model) -> Html
viewTodo address (id, model) =
  let
      context =
        Todo.Context
          (Signal.forwardTo address (Modify id))
          (Signal.forwardTo address (always (Remove id)))
  in
     Todo.viewWithContext context model [ Todo.removeView ]

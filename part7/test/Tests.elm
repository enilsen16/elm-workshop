module Tests (..) where

import ElmTest exposing (..)
import ElmHub exposing (responseDecoder)
import Json.Decode exposing (decodeString)


all : Test
all =
  suite
    "Decoding responses from GitHub"
    [ test "they can decode empty responses"
        <| let
            emptyResponse =
              """{ "items": [] }"""
           in
            assertEqual
              (Ok [])
              (decodeString responseDecoder emptyResponse)
    , test "they can decode responses with results in them"
        <| let
            response =
              """{ "items": [
                  { "id": 5, "full_name": "foo", "stargazers": 42 }
                , { "id": 3, "full_name": "bar", "stargazers": 77 }
                ] }"""
           in
            assertEqual
              (Ok
                [ { id = 5, name = "foo", stars = 42 }
                , { id = 3, name = "bar", stars = 77 }
                ]
              )
              (decodeString responseDecoder response)
    , test "they result in an error for invalid JSON"
        <| let
            response =
              """{ "pizza": [] }"""

            isErrorResult result =
              -- TODO return True if the given Result is an Err of some sort,
              -- and False if it is an Ok of some sort.
              --
              -- Result docs: http://package.elm-lang.org/packages/elm-lang/core/3.0.0/Result
              case result of
                Ok _ ->
                  False

                Err _ ->
                  True
           in
            assertEqual
              True
              (isErrorResult (decodeString responseDecoder response))
    ]

module Test.Main where

import Effect (Effect)
import Prelude (Unit)

import Test.Assert (assertEqual)
import Yoga.Next.Fastify (allMethods)

main :: Effect Unit
main =
  assertEqual
    { actual: allMethods
    , expected: [ "GET", "POST", "PUT", "DELETE", "PATCH", "HEAD", "OPTIONS", "QUERY" ]
    }

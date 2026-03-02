module Yoga.Next.Fastify
  ( NextApp
  , createNextApp
  , nextRequestHandler
  , registerNextHandler
  ) where

import Prelude

import Data.HTTP.Method as Method
import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Uncurried (EffectFn1, EffectFn3, runEffectFn1, runEffectFn3)
import Promise (Promise)
import Promise.Aff as Promise
import Yoga.Fastify.Fastify (Fastify, HttpRequest, HttpResponse, HttpServer)
import Yoga.Fastify.Fastify as F

foreign import data NextApp :: Type

foreign import createNextAppImpl :: EffectFn3 HttpServer String Int (Promise NextApp)

createNextApp :: HttpServer -> String -> Int -> Aff NextApp
createNextApp server hostname port = runEffectFn3 createNextAppImpl server hostname port # Promise.toAffE

foreign import nextRequestHandlerImpl :: EffectFn1 NextApp (HttpRequest -> HttpResponse -> Effect Unit)

nextRequestHandler :: NextApp -> Effect (HttpRequest -> HttpResponse -> Effect Unit)
nextRequestHandler = runEffectFn1 nextRequestHandlerImpl

registerNextHandler :: NextApp -> Fastify -> Effect Unit
registerNextHandler app server = do
  handler <- nextRequestHandler app
  F.rawRoute allMethods handler server
  where
  allMethods = show <$>
    [ Method.GET, Method.POST, Method.PUT, Method.DELETE
    , Method.PATCH, Method.HEAD, Method.OPTIONS
    ]

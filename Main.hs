module Main where

import Config
import IHP.FrameworkConfig
import IHP.Job.Types
import IHP.Prelude
import IHP.RouterSupport
import qualified IHP.Server
import Web.FrontController
import Web.Types
import Web.Worker

instance FrontController RootApplication where
  controllers =
    [ mountFrontController WebApplication
    ]

instance Worker RootApplication where
  workers _ = workers WebApplication

main :: IO ()
main = IHP.Server.run config
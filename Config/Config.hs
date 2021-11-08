module Config where

import IHP.Prelude
import IHP.Environment
import IHP.FrameworkConfig
import Web.View.CustomCSSFramework
import IHP.Mail

config :: ConfigBuilder
config = do
    option Development
    option (AppHostname "localhost")
    option customTailwind
    option $
        SMTP
            { host = "127.0.1.1"
            , port = 1025
            , credentials = Nothing
            }
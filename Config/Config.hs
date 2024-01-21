module Config where

import IHP.Prelude
import IHP.Environment
import IHP.FrameworkConfig
import Web.View.CustomCSSFramework
import IHP.Mail
import qualified IHP.Log as Log
import IHP.Log.Types

config :: ConfigBuilder
config = do
    option customTailwind

    -- SMTP to work with MailHog.
    option $
        SMTP
            { host = "127.0.0.1" -- On some computers may need `127.0.1.1` instead.
            , port = 1025
            , credentials = Nothing
            , encryption = Unencrypted
            }

    -- Less verbose logs.
    logger <- liftIO $ newLogger def
      { level = Warn
      , formatter = withTimeFormatter
      }
    option logger
module Web.FrontController where

import IHP.RouterPrelude
import Web.Controller.Prelude
import Web.View.Layout (defaultLayout)

-- Controller Imports
import Web.Controller.Events
import Web.Controller.Venues
import Web.Controller.Reservations


instance FrontController WebApplication where
    controllers =
        [ startPage VenuesAction
        -- Generator Marker
        , parseRoute @EventsController
        , parseRoute @VenuesController
        , parseRoute @ReservationsController
        ]

instance InitControllerContext WebApplication where
    initContext = do
        setLayout defaultLayout
        initAutoRefresh

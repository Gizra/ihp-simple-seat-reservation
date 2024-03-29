module Test.Controller.ReservationsSpec where

import Network.HTTP.Types.Status

import IHP.Prelude
import IHP.QueryBuilder (query)
import IHP.Test.Mocking
import IHP.Fetch
import IHP.Controller.RequestContext

import IHP.FrameworkConfig
import IHP.HaskellSupport
import Test.Hspec
import Config

import Generated.Types
import Web.Routes
import Web.Types
import Web.Controller.Reservations (personIdentifierResult)
import Web.FrontController ()
import Network.Wai
import IHP.ControllerPrelude
import Application.Script.Prelude (JobStatus(JobStatusNotStarted))
import IHP.MailPrelude (JobStatus(JobStatusSucceeded))
import Web.Job.Reservation
import Generated.Types (Reservation'(seatNumber))

tests :: Spec
tests = aroundAll (withIHPApp WebApplication config) do
        describe "ReservationsController" $ do
            it "has no existing reservations" $ withContext do
                count <- query @Reservation |> fetchCount
                count `shouldBe` 0

            it "has no existing reservations jobs" $ withContext do
                count <- query @ReservationJob |> fetchCount
                count `shouldBe` 0

            it "creates two new reservations" $ withContext do
                -- Create Venue.
                venue <- newRecord @Venue
                        |> set #title "Venue 1"
                        |> set #totalNumberOfSeats 3
                        |> create

                -- Create Event.
                event <- newRecord @Event
                        |> set #venueId venue.id
                        |> create

                let eventId = cs $ tshow $ event.id

                let params =
                        [ ("personIdentifier", "1234")
                        , ("eventId", eventId)
                        ]

                response <- callActionWithParams CreateReservationAction params

                -- Only one Reservation and Reservation Job should exist.
                count <- query @Reservation |> fetchCount
                count `shouldBe` 1

                count <- query @ReservationJob |> fetchCount
                count `shouldBe` 1

                reservationJob <- query @ReservationJob |> orderByDesc #createdAt |> fetchOne
                reservation <- fetch reservationJob.reservationId
                -- Seat not assigned yet.
                reservation.seatNumber `shouldBe` 0


                -- Process job.
                let frameworkConfig = ?context.frameworkConfig
                let ?context = frameworkConfig in perform reservationJob

                -- Reload Reservation from it.
                reservation <- fetch reservationJob.reservationId
                reservation.seatNumber `shouldBe` 1


        it "accepts valid person identifiers" $ withContext do
            let ids =
                    [ "0012"
                    , "1245"
                    , "9999999"
                    ]
            forEach ids (\id -> personIdentifierResult id `shouldBe` Right ())

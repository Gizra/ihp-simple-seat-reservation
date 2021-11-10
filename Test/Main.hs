module Main where

import Test.Hspec
import IHP.Prelude

import Test.Controller.ReservationsSpec

main :: IO ()
main = hspec do
    Test.Controller.ReservationsSpec.tests
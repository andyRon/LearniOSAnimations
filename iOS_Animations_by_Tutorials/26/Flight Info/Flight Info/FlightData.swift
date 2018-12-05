//
//  ViewController.swift
//  BeginnerCook
//
//  Created by [Andy Ron](https://github.com/andyRon)  on 2018/12/4.
//  Copyright © 2018 [Andy Ron](https://github.com/andyRon) . All rights reserved.
//



import Foundation

//
// Flight model
//

struct FlightData {
  let summary: String
  let flightNr: String
  let gateNr: String
  let departingFrom: String
  let arrivingTo: String
  let weatherImageName: String
  let showWeatherEffects: Bool
  let isTakingOff: Bool
  let flightStatus: String
}

//
// Pre- defined flights
//

let londonToParis = FlightData(
  summary: "01 Apr 2015 09:42",
  flightNr: "ZY 2014",
  gateNr: "T1 A33",
  departingFrom: "LGW",
  arrivingTo: "CDG",
  weatherImageName: "bg-snowy",
  showWeatherEffects: true,
  isTakingOff: true,
  flightStatus: "Boarding")

let parisToRome = FlightData(
  summary: "01 Apr 2015 17:05",
  flightNr: "AE 1107",
  gateNr: "045",
  departingFrom: "CDG",
  arrivingTo: "FCO",
  weatherImageName: "bg-sunny",
  showWeatherEffects: false,
  isTakingOff: false,
  flightStatus: "Delayed")


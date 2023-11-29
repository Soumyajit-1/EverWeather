
import Foundation

struct WeatherForecastData: Codable{
    let list : [List]
    let city : City
}

struct City : Codable{
    let name : String
}

struct List : Codable{
    let dt_txt : String
    let weather : [Weather]
}



import Foundation
import CoreLocation

protocol WeatherForecastManagerDelegate {
    func didUpdateWeatherForecast(_ weatherForecastManager: WeatherForecastManager,weatherForecast: WeatherForecastModel)
    func didFailWithError(error: Error)
}

struct WeatherForecastManager {
    let weatherForecastURL = "api.openweathermap.org/data/2.5/forecast?appid=414ae910036e88e3958ddccbd80b91c3&units=metric&cnt=8"
    var delegate : WeatherForecastManagerDelegate?
    func fetchWeatherForecast(cityName: String) {
        let urlString = "\(weatherForecastURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func fetchWeatherForecast(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(weatherForecastURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let weatherForecast = self.parseJSON(safeData) {
                        self.delegate?.didUpdateWeatherForecast(self, weatherForecast: weatherForecast)
                    }
                }
            }
            task.resume()
        }
    }
    func parseJSON(_ weatherForecastData: Data) -> WeatherForecastModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherForecastData.self, from: weatherForecastData)
            let list = decodedData.list
            let city = decodedData.city
            let weatherForecast = WeatherForecastModel(list: list, cityName: city)
            return weatherForecast
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}

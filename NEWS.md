# alphavantager 0.1.2

* `av_get()` - Add support for ForEx using `symbol = "EUR/USD"` format

* Potentially Breaking Changes - Changed `av_fun = "SECTOR"` returned data column names to "change" for the value of change during the performance period. 

# alphavantager 0.1.1

* Move `timetk` into Imports

* Remove `tidyquant` and `tidyverse` from Suggests

* Remove `lubridate` and `devtools` as Imports

* Simplify internal API key retrieval

* Fix API rate limited tests

* Fix JSON performance

* Reduce R version dependency to 3.3.0


# alphavantager 0.1.0

Intial release of `alphavantager`, a R interface to the Alpha Vantage API. Learn more at https://www.alphavantage.co. 

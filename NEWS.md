# alphavantager 0.1.3

* `av_get()` - Improve function details in help manual and ReadMe. 

* `av_fun = "SECTOR"` - Fix bug where the same values were being returned. 

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

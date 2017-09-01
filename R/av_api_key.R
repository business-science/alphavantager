#' Set the Alpha Vantage API Key
#'
#' @name av_api_key
#'
#' @param api_key A character string with your Alpha Vantage API Key.
#'
#' @return Invisibly returns API key once set. Use print method to view.
#'
#' @details
#' The Alpha Vantage API key must be set prior to using [av_get()]. You can obtain
#' an API key at the [Alpha Vantage Website](https://www.alphavantage.co/).
#'
#' @seealso [av_get()]
#'
#' @examples
#' \dontrun{
#' av_api_key("YOUR_API_KEY")
#' av_get(symbol = "MSFT", av_fun = "TIME_SERIES_INTRADAY", interval = "15min", outputsize = "full")
#' }
#'
#' @export
av_api_key <- function(api_key) {
    if (!missing(api_key)) {
        options(av_api_key = api_key)
    }
    invisible(getOption('av_api_key'))
}

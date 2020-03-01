#' Get financial data from the Alpha Vantage API
#'
#' @name av_get
#'
#' @param symbol A character string of an appropriate stock or fund.
#' See parameter "symbol" in [Alpha Vantage API documentation](https://www.alphavantage.co/documentation/).
#' @param av_fun A character string matching an appropriate Alpha Vantage "function".
#' See parameter "function" in [Alpha Vantage API documentation](https://www.alphavantage.co/documentation/).
#' @param ... Additional parameters passed to the Alpha Vantage API.
#' For a list of parameters, visit the [Alpha Vantage API documentation](https://www.alphavantage.co/documentation/).
#'
#' @return Returns a tibble of financial data
#'
#' @seealso [av_api_key()]
#'
#' @details
#' __Get more than one symbol.__ The Alpha Vantage API is setup to return one symbol
#' per API call. Use the `tidyquant::tq_get()` API to get multiple symbols.
#'
#' @examples
#' \dontrun{
#'
#' # SETUP API KEY
#' av_api_key("YOUR_API_KEY")
#'
#' # ---- 1.0 STOCK TIME SERIES ----
#'
#' # 1.1 TIME SERIES INTRADAY
#' av_get("MSFT", av_fun = "TIME_SERIES_INTRADAY", interval = "5min")
#'
#' # 1.2 TIME SERIES DAILY ADJUSTED
#' av_get("MSFT", av_fun = "TIME_SERIES_DAILY_ADJUSTED")
#'
#' # 1.3 QUOTE ENDPOINTS
#' av_get("MSFT", av_fun = "GLOBAL_QUOTE")
#'
#' # ---- 2.0 FOREX ----
#'
#' # 2.1 CURRENCY EXCHANGE RATES
#' data <- av_get("EUR/USD", av_fun = "CURRENCY_EXCHANGE_RATE")
#'
#' # 2.2 FX INTRADAY
#' av_get("EUR/USD", av_fun = "FX_INTRADAY", interval = "5min")
#'
#' # 2.3. FX DAILY
#' av_get("EUR/USD", av_fun = "FX_DAILY")
#'
#' # ---- 3.0 TECHNICAL INDICATORS ----
#'
#' # 3.1 SMA
#' av_get("MSFT", av_fun = "SMA", interval = "weekly", time_period = 10, series_type = "open")
#'
#' # ---- 4.0 SECTOR PERFORMANCE ----
#'
#' # 4.1 Sector Performance
#' av_get(av_fun = "SECTOR")
#' }
#'
#'
#'
#' @export
av_get <- function(symbol, av_fun, ...) {

    if (missing(symbol)) symbol <- NULL

    # Checks
    if (is.null(av_api_key())) {
        stop("Set API key using av_api_key(). If you do not have an API key, please claim your free API key on (https://www.alphavantage.co/support/#api-key). It should take less than 20 seconds, and is free permanently.",
             call. = FALSE)
    }

    # Setup
    dots <- list(...)
    ua   <- httr::user_agent("https://github.com/business-science")

    # Overides
    dots$symbol      <- symbol
    dots$apikey      <- av_api_key()
    dots$datatype    <- "csv"

    # Forex
    is_forex <- FALSE
    if (!is.null(symbol)) is_forex <- stringr::str_detect(symbol, "\\/")
    if (is_forex) {
        currencies  <- symbol %>% stringr::str_split_fixed("\\/", 2) %>% as.vector()
        dots$symbol <- NULL
        dots$from_currency <- currencies[[1]]
        dots$to_currency   <- currencies[[2]]
        dots$from_symbol   <- currencies[[1]]
        dots$to_symbol     <- currencies[[2]]
    }

    # Generate URL
    url_params <- stringr::str_c(names(dots), dots, sep = "=", collapse = "&")
    url <- glue::glue("https://www.alphavantage.co/query?function={av_fun}&{url_params}")

    # Alpha Advantage API call
    response <- httr::GET(url, ua)

    # Handle bad status codes errors
    if (!(httr::status_code(response) >= 200 && httr::status_code(response) < 300)) {
        stop(httr::content(response, as="text"), call. = FALSE)
    }

    # # Clean data
    content_type <- httr::http_type(response)
    if (content_type == "application/json") {
        # JSON returned

        content <- httr::content(response, as = "text", encoding = "UTF-8")

        content_list <- content %>% jsonlite::fromJSON()

        # Detect good/bad call
        if (content_list[1] %>% names() == "Meta Data") {
            # Good call

            if (av_fun == "SECTOR") {
                # Sector Performance Cleanup ----
                content <- content_list %>%
                    tibble::enframe() %>%
                    dplyr::slice(-1) %>%
                    dplyr::mutate(val = purrr::map(value, tibble::enframe)) %>%
                    tidyr::unnest(val, .drop =T) %>%
                    dplyr::mutate(val = purrr::map_chr(value, ~ .x[[1]] )) %>%
                    dplyr::select(-value1) %>%
                    dplyr::mutate(change = stringr::str_replace(val, "%", "") %>% as.numeric()) %>%
                    dplyr::mutate(change = change / 100) %>%
                    dplyr::select(-val, -value) %>%
                    dplyr::rename(sector = name1, rank.group = name)
            } else {
                # Technical Indicator Cleanup ----
                content <- do.call(rbind, lapply(content_list[[2]], unlist)) %>%
                    timetk::tk_tbl(rename_index = "timestamp") %>%
                    dplyr::mutate_if(is.factor, as.character) %>%
                    dplyr::mutate_if(is.character, as.numeric)

            }

        } else if (is_forex) {
            # ForEx Cleanup ----
            content <- content_list %>%
                purrr::flatten_dfc() %>%
                purrr::map_dfc(readr::parse_guess)
        } else {
            # Bad Call

            if (is.null(symbol)) {
                symbol <- "NULL"
            }

            params_list <- list(symbol = symbol, av_fun = av_fun)
            dots$symbol <- NULL
            params_list <- c(params_list, dots)
            params_list$apikey = "HIDDEN_FOR_YOUR_SAFETY"
            params_list$datatype = NULL
            params <- stringr::str_c(names(params_list), params_list, sep = "=", collapse = ", ") %>%
                stringr::str_replace("av_fun", "function")
            content <- content %>%
                jsonlite::fromJSON(flatten = T)  %>%
                stringr::str_c(". API parameters used: ", params)
            stop(content, call. = F)
        }

    } else {
        # CSV Returned - Good Call - Time Series CSV file
        content <- httr::content(response, as = "text", encoding = "UTF-8") %>%
            readr::read_csv()

    }

    # Fix names
    names(content) <- names(content) %>%
        stringr::str_replace_all("[0-9]+\\. ", "") %>%
        make.names() %>%
        stringr::str_replace_all("\\.", "_") %>%
        tolower()

    # Return desc
    if ("timestamp" %in% names(content)) content <- content %>% dplyr::arrange(timestamp)

    return(content)

}



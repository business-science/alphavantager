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
#' @examples
#' \dontrun{
#' av_api_key("YOUR_API_KEY")
#' av_get(symbol = "MSFT", av_fun = "TIME_SERIES_INTRADAY", interval = "15min", outputsize = "full")
#' }
#'
#'
#' @export
av_get <- function(symbol = NULL, av_fun, ...) {

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

    # Generate URL
    url_params <- stringr::str_c(names(dots), dots, sep = "=", collapse = "&")
    url <- glue::glue("https://www.alphavantage.co/query?function={av_fun}&{url_params}")

    # Alpha Advantage API call
    response <- httr::GET(url, ua)

    # Handle bad status codes errors
    if (!(httr::status_code(response) >= 200 && httr::status_code(response) < 300)) {
        stop(httr::content(response, as="text"), call. = FALSE)
    }

    # Clean data
    content_type <- httr::http_type(response)
    if (content_type == "application/json") {
        # JSON returned

        content <- httr::content(response, as = "text", encoding = "UTF-8")

        content_list <- content %>% jsonlite::fromJSON()

        # Detect good/bad call
        if (content_list[1] %>% names() == "Meta Data") {
            # Good call

            if (av_fun == "SECTOR") {
                # Sector Performance Cleanup
                content <- content_list %>%
                    tibble::enframe() %>%
                    dplyr::slice(-1) %>%
                    dplyr::mutate(val = purrr::map(value, tibble::enframe)) %>%
                    tidyr::unnest(val, .drop =T) %>%
                    dplyr::mutate(val = purrr::map_chr(value, ~ .x[[1]] )) %>%
                    dplyr::mutate(value = stringr::str_replace(val, "%", "") %>% as.numeric()) %>%
                    dplyr::select(-val) %>%
                    dplyr::rename(sector = name1, rank.group = name)
            } else {
                # Technical Indicator Cleanup
                content <- do.call(rbind, lapply(content_list[[2]], unlist)) %>%
                    timetk::tk_tbl(rename_index = "timestamp") %>%
                    dplyr::mutate_if(is.factor, as.character) %>%
                    dplyr::mutate_if(is.character, as.numeric)

            }

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
        stringr::str_replace("[0-9]+\\. ", "") %>%
        make.names() %>%
        tolower()

    # Return desc
    if ("timestamp" %in% names(content)) content <- content %>% dplyr::arrange(timestamp)

    return(content)

}



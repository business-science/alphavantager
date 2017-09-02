# Auth helpers

paths <- c("~/api_key.txt", "./tests/testthat/api_key.txt", "./api_key.txt")
has_file <- unlist(purrr::map(paths, file.exists))
path <- if (any(has_file)) {
    paths[has_file][[1]]
} else {
    ""
}

has_auth <- file.exists(path)

skip_if_no_auth <- function() {
    if (!has_auth) {
        skip("Authentication not available")
    }
}

if (has_auth) av_api_key(readLines(path))

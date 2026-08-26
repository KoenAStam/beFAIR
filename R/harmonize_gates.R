#' Takes a vector of gate strings, splits them into components, harmonizes the marker names,
#' and reconstructs the gate strings with standardized marker names using `harmonizeMarkers`.
#'
#' @param gates A character vector where each element is a gate string (e.g., "HLA-DR_+_OR_CD7_-").
#' @return A character vector of harmonized gate strings. Each output corresponds to one input gate.
#' @examples
#' harmonizeGates(c("HLA-DR_+_OR_CD7_-", "CD3_+", "CD16_-_AND_CD56_++"))
#' @export
#' @import dplyr

harmonizeGates <- function(gates) {
  gatesSplit <- strsplit(gates, "_")
  gatesFrame <- lapply(gatesSplit, function(x) {
    c(x, rep(NA, 5))[1:5]
  })
  gatesFrame2 <- data.frame(do.call("rbind", gatesFrame))

  # Harmonize X1 and X4
  gatesFrame2$X1_harmonized <- ifelse(
    is.na(gatesFrame2$X1),
    NA,
    harmonizeMarkers(gatesFrame2$X1)
  )
  gatesFrame2$X4_harmonized <- ifelse(
    is.na(gatesFrame2$X4),
    NA,
    harmonizeMarkers(gatesFrame2$X4)
  )

  output <- gatesFrame2 %>%
    mutate(output = case_when(
      is.na(X1) ~ NA,
      is.na(X1_harmonized) | X1_harmonized == "" ~ paste("No Match in", X1),
      is.na(X4) ~ paste(X1_harmonized, X2, sep = "_"),
      is.na(X4_harmonized) | X4_harmonized == "" ~ paste("No Match in", X4),
      TRUE ~ paste(X1_harmonized, X2, X3, X4_harmonized, X5, sep = "_")
    )) %>%
    pull(output)

  return(output)
}

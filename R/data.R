#' HUGO Gene Nomenclature Committee (HGNC) data
#'
#' Data frame that contains three columns from the current (August 2023)
#' hgnc_complete_set database. These data are the second reference for
#' naming the cellular markers
#'
#'
#' @format ## `HGNC`
#' A data frame with 43667 rows and 2 columns:
#' \describe{
#'  \item{hgnc_id}{character HGNC ID, a unique ID created by the HGNC for every approved symbol}
#'  \item{symbol}{character The HGNC approved gene symbol}
#'  \item{cd}{character Symbol used within the Human Cell Differentiation Molecule (HCDM) database}
#'  }
#'
#'@source <https://www.genenames.org/download/archive/>
"HGNC"


#' LUCID Nomenclature (LUNC) data
#'
#' Data frame with nomenclature used at our department. This is basically a list
#' of parameter descriptions that come from .fcs files that not have a CD label
#' or HGNC label. We use these data to convert our nomenclature
#' to (if able) `HCDM` nomenclature, or else to `HGNC`.
#'
#'
#' @format ## `LUNC`
#' A data frame with 35 rows and 3 columns:
#' \describe{
#'  \item{fcs_parameters_desc}{character the parameters description we get from fcs}
#'  \item{source}{character some information on how we got this symbol}
#'  \item{symbol}{character symbol we've chosen as standard label, this should preferably be from `HCDM` or `HGNC`}
#'  \item{symbol_database}{character name of the database where we got the symbol from,
#'  department means that we kind of made up the name ourselves. Note that e.g. CD3 is not in HCDM but CD8A is}
#'  }
"LUNC"

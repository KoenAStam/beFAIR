#' Harmonize cellular marker labels
#'
#' Maps raw marker labels (e.g. from FCS files) to standardised symbols using
#' a three-step lookup cascade:
#'
#' 1. **HGNC CD column** ([HGNC]): exact match against CD annotations from the
#'    Human Cell Differentiation Molecule (HCDM) database. When no exact match
#'    is found, a CD pattern (e.g. `"CD8"` from `"CD8-APC"`) is extracted and
#'    looked up instead. Markers containing `";"` are skipped in this step as
#'    they likely represent double-stained channels.
#' 2. **HGNC gene symbol** ([HGNC]): case-insensitive match against approved
#'    HGNC gene symbols. If the initial match fails, special characters are
#'    stripped and the lookup is retried (e.g. `"IL-5"` → `"IL5"`). `"B2M"` is
#'    handled as a special case (common barcoding marker). When a match is
#'    found, the CD annotation is returned if one exists; otherwise the HGNC
#'    symbol is returned.
#' 3. **LUNC department lookup** ([LUNC]): case-insensitive match against the
#'    internal FCS parameter description table used at LUMC.
#'
#' If no match is found in any step, an empty string (`""`) is returned for
#' that element and a message is printed to the console.
#'
#' @param markers A character vector of marker labels to harmonize
#'   (e.g. `c("CD3-FITC", "IL-5", "HLA-DR")`).
#'
#' @return A character vector of the same length as `markers`. Each element is
#'   the standardised symbol, or `""` when no match was found in any lookup.
#'
#' @seealso [HGNC], [LUNC], [harmonizeGates()]
#'
#' @examples
#' \dontrun{
#' harmonizeMarkers(c("CD3-FITC", "IL-5", "HLA-DR", "FSC-A"))
#' }
#'
#' @keywords internal
harmonizeMarkers <- function(markers){
    HGNC <- beFAIR::HGNC
    LUNC <- beFAIR::LUNC

    new_markers <- character(length(markers))

    for(i in seq_along(markers)){
        message("Matching ", markers[i])

        ## First we match to CD symbol database
        m <- match(markers[i], HGNC$cd)

        # No perfect match, check CD* in label
        if(is.na(m)){
            if(grepl("CD[[:alnum:]]{1,7}", markers[i]) & !grepl(";", markers[i])){ # we skip markers with ;, because they could be double
                r <- regmatches(markers[i], regexpr("CD[[:alnum:]]{1,7}", markers[i]))
                m <- match(r, HGNC$cd)
            }
        }

        if(!is.na(m)){
            new_markers[i] <- HGNC$cd[m]
            message("-> ", new_markers[i], "\n", appendLF = FALSE)
            next
        }


        ## Second, match to HGNC symbol
        message("-> HGNC (symbol) ", appendLF=FALSE)
        m2 <- match(toupper(markers[i]), toupper(HGNC$symbol))

        # Check match if we remove special characters (IL-5 -> IL5)
        if(is.na(m2)){
          m2 <- match(toupper(gsub("[^a-zA-Z0-9\\s]", "", markers[i])), toupper(HGNC$symbol))
        }

        # Check for B2M (barcodes)
        if(grepl("B2M", markers[i]) & !grepl("B2MR", markers[i]) & !grepl("TFB2M", markers[i])){
          new_markers[i] <- "B2M"
          message("-> ", new_markers[i], "\n", appendLF = FALSE)
          next
        }

        if(!is.na(m2)){
            # add CD label if able else HGNC symbol
            if(HGNC$cd[m2] != ""){
                new_markers[i] <- HGNC$cd[m2]
            } else {
                new_markers[i] <- HGNC$symbol[m2]
            }
            message("-> ", new_markers[i], "\n", appendLF = FALSE)
            next
        }

        ## Lastly, match to department personal database
        message("-> Department ",appendLF = FALSE)
        m3 <- match(toupper(markers[i]), toupper(LUNC$fcs_parameters_desc))

        if(!is.na(m3)){
            new_markers[i] <- LUNC$symbol[m3]
            message("-> ", new_markers[i], "\n", appendLF=FALSE)
            next
        }

        # Still no match throw warning
        message("-> !No match!")
    }

    return(new_markers)
}

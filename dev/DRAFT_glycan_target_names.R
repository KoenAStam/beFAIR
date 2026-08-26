#' Function to generate target names give
#' @param data data frame containing the target_name etc of the glycanarray panel
#' @return A column with target names
#' @examples
#' glycanTargetNames(data)
#' @export

glycanTargetNames <- function(data) {
  # List of required columns to check
  requiredColumns <- c("source_organism", "source_lifestage", "glycan_type",
                        "hplc_normal_phase", "hplc_reverse_phase", "concentration")

  # Initialize the target_name column in the data frame (with NA)
  target_name <- data$target_name

  ### NATURAL

  # Create a logical vector for natural fractions
  natural_fractions <- data$derived == "natural"

  # Generate the target name for natural fractions
  data$target_name[natural_fractions] <- paste0(
    # derived F / S / C
    "F_",
    # source organism (SM), first 2 letters
    substr(data$source_organism[natural_fractions], 1, 2),
    # source life stage, first 4 letters
    substr(data$source_lifestage[natural_fractions], 1, 4),
    "_",
    # glycan type, first letter + enzyme (XX if NA)
    substr(data$glycan_type[natural_fractions], 1, 1),
    ifelse(is.na(data$enzym[natural_fractions]), "XX", data$enzym[natural_fractions]),
    "_",
    # normal phase, fill to two digits
    "N", sprintf("%02d", data$hplc_normal_phase[natural_fractions]),
    # reverse phase, fill to two digits
    "R", sprintf("%02d", data$hplc_reverse_phase[natural_fractions]),
    "_",
    # concentration, fill to two digits
    sprintf("%02d", data$concentration[natural_fractions])
  )
  print(data$target_name[natural_fractions])

  ### SYNTHETIC

  # synthetic
  synthetic_fractions <- data$derived == "synthetic"

  data$target_name[synthetic_fractions] <- paste0(
    # derived F / S / C
    "S_",
    # synthetic name
    glycanarraypanel$data$synthetic_name[synthetic_fractions],
    "_",
    sprintf("%03d", glycanarraypanel$data$concentration[synthetic_fractions])
  )

  ### CRUDE
  crude_fractions <- data$derived == "crude antigen"

  data$target_name[crude_fractions] <- paste0(
    # derived F / S / C
    "C_",
    # synthetic name
    glycanarraypanel$data$synthetic_name[crude_fractions],
    "_",
    sprintf("%03d", glycanarraypanel$data$concentration[crude_fractions])
  )

  ### PURIFIED ANTIGEN
  purified_fractions <- data$derived == "purified antigen"

  data$target_name[purified_fractions] <- paste0(
    # derived F / S / C
    "P_",
    # synthetic name
    glycanarraypanel$data$synthetic_name[purified_fractions],
    "_",
    sprintf("%03d", glycanarraypanel$data$concentration[purified_fractions])
  )

  return(data$target_name)
}

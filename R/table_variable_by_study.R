#' Summarise a codebook variable by study as a `gt` table
#'
#' Reads the named codebook to determine the variable type and produces a
#' colour-coded `gt` table summarising the variable grouped by `study_id`.
#' For `character` variables, the set of unique values and completeness are
#' reported. For `numeric` variables, mean, SD, median, min, max and
#' completeness are shown.
#'
#' @param var A character string specifying the variable to summarise. Must be
#'   defined in `codebook_name`.
#' @param data A data frame containing the data to summarise. Must include a
#'   `study_id` column and the variable specified by `var`.
#' @param codebook_name A character string specifying the codebook name
#'   (without `.yaml` extension).
#'
#' @return A `gt` table object with rows per `study_id`. Completeness is
#'   colour-coded on a red-yellow-green scale. Returns a placeholder `gt` table
#'   for unsupported variable types.
#'
#' @seealso [codebookToSummary()], [codebookRead()], [tableSummary()]
#'
#' @examples
#' \dontrun{
#' FAIRgroundConnect("LUCID_FAIRPOINT")
#' data <- DBI::dbReadTable(FAIRgroundConnection(), "participant")
#' tableVariableByStudy("sex", data, "participant")
#' }
#'
#' @import gt
#' @import dplyr
#'
#' @export
tableVariableByStudy <- function(var, data, codebook_name){
  codebook <- codebookRead(codebook_name=codebook_name)$variables

  if(codebook[[var]]$type %in% c("character")){
    tableData <-
      data %>%
      arrange(!!sym(var)) %>%
      group_by(study_id) %>%
      summarize(
        set = paste0("[", unique(!!sym(var)), collapse = "|", "]"),
        complete = 1 - sum(is.na(!!sym(var)) / n())
      ) %>%
      mutate(set = sub("\\|\\[NA\\]|\\[NA\\]", "", set))

    table <- tableData %>%
      mutate(color="") %>%
      gt() %>%
      fmt_percent(
        columns = complete,
        decimals = 0
      ) %>%

      cols_label(
        color= "",
        complete = "% Complete"
      ) %>%
      data_color(columns=complete,
                 target_columns=color,
                 method= "numeric",
                 palette = "RdYlGn",
                 domain=c(0,1)
        )
    return(table)
  }

  if(codebook[[var]]$type %in% c("numeric")){
    tableData <-
      data %>%
      filter(!(!!sym(var) %in% c(-999))) %>% #TODO don't hardcode missing in table, but extract from codebook
      group_by(study_id) %>%
      summarize(
        mean = round(mean(!!sym(var), na.rm = T), 1),
        sd = sd(!!sym(var), na.rm = T),
        m = do.call(sprintf, c("%.1f [%.1f, %.1f]", as.list(
          quantile(!!sym(var), c(0.5, 0, 1), na.rm = T)
        ))),
        complete = 1 - sum(is.na(!!sym(var)) / n())
      ) %>%
      mutate(
        mean = ifelse(is.nan(mean), "-", sprintf("%.1f", mean)),
        sd = ifelse(is.na(sd), "-", sprintf("%.1f", sd)),
        m = ifelse(m == "NA [NA, NA]", "-", m)
      )

    table <- tableData %>%
      mutate(color="") %>%
      gt() %>%
      fmt_percent(
        columns = complete,
        decimals = 0
      ) %>%
      tab_header(title=html(paste0("<b>",var,"</b>"))) %>%
      cols_label(
        color= "",
        complete = "% Complete",
        m = "Med [min, max]",
        mean = html("<i>&mu;</i>"),
        sd = html("<i>&sigma;</i>")
      ) %>%
      tab_style(
        style = cell_text(align="center"),
        locations = cells_column_labels(2:3)
      ) %>%
      data_color(columns=complete,
                 target_columns=color,
                 method= "numeric",
                 palette = "RdYlGn",
                 domain=c(0,1)
        )
    return(table)
  }

  ## dummy table style for type doesn't exist yet
  return(gt(data.frame(x=1)))
}

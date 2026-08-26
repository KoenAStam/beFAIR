#' View Codebook Relationship Map (ERD Style)
#'
#' Calls [collectTablesById()] to determine which tables are relevant for a
#' given ID, then renders an ERD-style diagram where each codebook appears as a
#' SQL table node listing its primary keys and foreign keys.
#'
#' The `id` can be any beFAIR identifier:
#' - Analysis ID (e.g. `"Ae0f301"`) — traces through experiments to studies
#' - Experiment ID (e.g. `"E4fe387"`) — traces through to studies
#' - Study ID (e.g. `"CHSI1"`) — shows study-level tables only
#'
#' @param id Character. A beFAIR ID to look up.
#' @param output Character or `NULL`. If `NULL` (default), the diagram is
#'   rendered in the RStudio Viewer. Supply a `.html` file path to save a
#'   self-contained HTML file instead.
#' @param con A DBI connection. If `NULL`, the default connection set by
#'   [FAIRgroundConnect()] is used.
#' @return Invisibly returns the `grViz` htmlwidget when saving; returns the
#'   widget visibly (auto-displays in Viewer) otherwise.
#'
#' @seealso [collectTablesById()], [searchId()]
#'
#' @examples
#' \dontrun{
#'   FAIRgroundConnect(dsn = "LUCID_FAIRPOINT")
#'   viewCodebookMap("Adf961e")
#'   viewCodebookMap("E133618", output = "codebook_map.html")
#' }
#' @export
viewCodebookMap <- function(id, output = NULL, con = NULL) {

  con <- FAIRgroundConnection(con)
  cb_root <- system.file("codebooks", package = "beFAIR")


  # ── Constants ────────────────────────────────────────────────────────────────

  TIER_COLORS <- c(
    study      = "#2C5F8A",
    experiment = "#C47A0A",
    analyses   = "#3A7A35",
    common     = "#555555",
    custom     = "#7B3F9E"
  )

  # ── Helpers ──────────────────────────────────────────────────────────────────

  .find_cb <- function(name) {
    # Search package (built-in) codebooks first
    all_paths <- list.files(cb_root, pattern = "\\.yaml$",
                            recursive = TRUE, full.names = TRUE)
    bases <- tools::file_path_sans_ext(basename(all_paths))
    idx   <- grepl(paste0("^", name, "$"), bases, ignore.case = TRUE)

    if (any(idx)) {
      path <- all_paths[which(idx)[1]]

      norm_root <- gsub("\\\\", "/", cb_root)
      norm_path <- gsub("\\\\", "/", path)
      rel       <- sub(paste0("^", norm_root, "/?"), "", norm_path)
      tier      <- strsplit(rel, "/")[[1]][1]
      if (is.na(tier) || tier == basename(path)) tier <- "common"

      return(list(path = path, tier = tier))
    }

    # Fall back to custom codebooks in the project's codebooks/ directory
    custom_root_dir <- file.path(getwd(), "codebooks")
    if (dir.exists(custom_root_dir)) {
      custom_paths <- list.files(custom_root_dir, pattern = "\\.yaml$",
                                 recursive = TRUE, full.names = TRUE)
      custom_bases <- tools::file_path_sans_ext(basename(custom_paths))
      custom_idx   <- grepl(paste0("^", name, "$"), custom_bases, ignore.case = TRUE)
      if (any(custom_idx)) {
        return(list(path = custom_paths[which(custom_idx)[1]], tier = "custom"))
      }
    }

    NULL
  }

  .fk_target <- function(description, var_name) {
    desc_lower <- tolower(description)
    m <- regmatches(desc_lower, regexec("foreign key to (?:the |a |an )?(\\w+)", desc_lower, perl = TRUE))[[1]]
    if (length(m) >= 2) return(m[2])
    if (grepl("_id$", var_name)) {
      tbl <- sub("_id$", "", var_name)
      if (tbl == "script") return("table_script")
      return(tbl)
    }
    NULL
  }

  .parse_keys <- function(cb) {
    pks <- character(0)
    fks <- list()

    for (var_name in names(cb$variables)) {
      var_info   <- cb$variables[[var_name]]
      desc       <- if (!is.null(var_info$description)) var_info$description else ""
      desc_lower <- tolower(desc)

      is_pk <- grepl("primary key", desc_lower)
      if (!is_pk && !is.null(var_info$validations)) {
        val_keys <- unlist(lapply(var_info$validations, names))
        is_pk    <- "rows_distinct" %in% val_keys
      }
      if (is_pk) pks <- c(pks, var_name)

      if (grepl("foreign key", desc_lower)) {
        target <- .fk_target(desc, var_name)
        if (!is.null(target) && !target %in% c("table_script", "table_codebook")) {
          fks[[var_name]] <- target
        }
      }
    }

    list(pks = pks, fks = fks)
  }

  .node_label <- function(name, info) {
    hdr_color <- TIER_COLORS[info$tier]
    if (is.na(hdr_color)) hdr_color <- "#555555"

    version <- if (!is.null(info$cb$version)) as.character(info$cb$version) else ""

    rows <- character(0)

    for (pk in info$pks) {
      rows <- c(rows, sprintf(
        '<TR><TD BGCOLOR="#FFF3CD" ALIGN="CENTER" WIDTH="28"><B>PK</B></TD><TD BGCOLOR="#FFF3CD" ALIGN="LEFT"> %s </TD></TR>',
        pk
      ))
    }

    for (var_name in names(info$fks)) {
      rows <- c(rows, sprintf(
        '<TR><TD BGCOLOR="#D1ECF1" ALIGN="CENTER" WIDTH="28"><B>FK</B></TD><TD BGCOLOR="#D1ECF1" ALIGN="LEFT"> %s &#8594; %s </TD></TR>',
        var_name, info$fks[[var_name]]
      ))
    }

    if (info$n_other > 0) {
      rows <- c(rows, sprintf(
        '<TR><TD COLSPAN="2" ALIGN="LEFT"><FONT POINT-SIZE="8"><I> &#8230; %d other column%s </I></FONT></TD></TR>',
        info$n_other, if (info$n_other == 1L) "" else "s"
      ))
    }

    if (length(rows) == 0L) {
      rows <- '<TR><TD COLSPAN="2" ALIGN="LEFT"><I>(no keys annotated)</I></TD></TR>'
    }

    version_cell <- if (nzchar(version)) {
      sprintf(' <FONT COLOR="#DDDDDD">v%s</FONT>', version)
    } else {
      ""
    }

    sprintf(
      '<<TABLE BORDER="0" CELLBORDER="1" CELLSPACING="0" BGCOLOR="white">
  <TR><TD COLSPAN="2" BGCOLOR="%s" ALIGN="CENTER"><FONT COLOR="white"><B>%s</B></FONT>%s</TD></TR>
%s
</TABLE>>',
      hdr_color, name, version_cell,
      paste(rows, collapse = "\n")
    )
  }

  # ── Main ─────────────────────────────────────────────────────────────────────

  # Resolve which tables are relevant for this ID (recursive: analysis → experiment → study)
  table_names <- collectTablesById(id, recursive = TRUE, namesOnly = TRUE, con = con)

  if (length(table_names) == 0L) {
    stop("No tables found for id '", id, "'. Check that the ID exists in the database.")
  }

  # Load the codebook for each table and parse its keys
  tree <- list()
  for (tbl in table_names) {
    cb_info <- .find_cb(tbl)
    if (is.null(cb_info)) next  # DB table exists but has no codebook — skip silently

    cb         <- yaml::read_yaml(cb_info$path)
    keys       <- .parse_keys(cb)
    pk_fk_vars <- unique(c(keys$pks, names(keys$fks)))

    tree[[tbl]] <- list(
      cb      = cb,
      tier    = cb_info$tier,
      pks     = keys$pks,
      fks     = keys$fks,
      n_other = max(0L, length(names(cb$variables)) - length(pk_fk_vars))
    )
  }

  if (length(tree) == 0L) {
    stop("No codebooks found for the tables returned by collectTablesById.")
  }

  # Node declarations
  node_decls <- vapply(names(tree), function(name) {
    id_safe <- gsub("[^A-Za-z0-9_]", "_", name)
    sprintf('  %s [label=%s, shape=plaintext]', id_safe, .node_label(name, tree[[name]]))
  }, character(1L))

  # Edge declarations — draw an edge for each FK whose target is also in the tree
  edge_decls <- character(0)
  for (from_name in names(tree)) {
    from_id      <- gsub("[^A-Za-z0-9_]", "_", from_name)
    seen_targets <- character(0)

    for (var_name in names(tree[[from_name]]$fks)) {
      target <- tree[[from_name]]$fks[[var_name]]

      if (target %in% names(tree) && !target %in% seen_targets) {
        to_id      <- gsub("[^A-Za-z0-9_]", "_", target)
        edge_decls <- c(edge_decls, sprintf(
          '  %s -> %s [label="%s", arrowhead=normal, fontsize=9, color="#555555", fontname="Helvetica"]',
          from_id, to_id, var_name
        ))
        seen_targets <- c(seen_targets, target)
      }
    }
  }

  dot <- sprintf(
'digraph erd {
  graph [rankdir=LR, fontname="Helvetica", nodesep=0.5, ranksep=2.0, splines=true]
  node  [fontname="Helvetica", fontsize=10]

%s

%s
}',
    paste(node_decls, collapse = "\n\n"),
    paste(edge_decls, collapse = "\n")
  )

  widget <- DiagrammeR::grViz(dot)

  if (!is.null(output)) {
    if (!requireNamespace("htmlwidgets", quietly = TRUE)) {
      stop(
        "Package 'htmlwidgets' is required to save to a file. ",
        "Install with: install.packages('htmlwidgets')"
      )
    }
    out_path <- normalizePath(output, mustWork = FALSE)
    htmlwidgets::saveWidget(widget, file = out_path, selfcontained = TRUE)
    message("Codebook map saved to: ", out_path)
    return(invisible(widget))
  }

  widget
}

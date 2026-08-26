#' Plot the dependency graph for a table produced by an analysis
#'
#' Queries `table_dependency` and draws a three-level directed graph:
#' \enumerate{
#'   \item The analysis node (root), labelled with `table_name` and `id`.
#'   \item Its `analysis_input` upstream scripts (the ETL scripts in other
#'         pillars that produce the data the analysis declared as dependencies).
#'   \item Each upstream script's own `datasource` and `script` dependencies
#'         (data files and id-mapping scripts).
#' }
#'
#' Node colours: blue = analysis, orange = script, green = datasource,
#' red = unresolved dependency (registered in meta.yaml but not yet in
#' `table_script`).
#'
#' Requires the \pkg{igraph} package.
#'
#' @param table_name Character. The codebook/table name produced by the
#'   analysis (e.g. `"som_clusterphenotype"`). Used as the root node label.
#' @param id Character. The `project_id` of the analysis (the 6-character
#'   hex `analysis_id` from `meta.yaml`).
#' @param con A DBI connection. If `NULL`, the default connection set by
#'   [FAIRgroundConnect()] is used.
#'
#' @return Invisibly returns the `igraph` graph object. Called primarily for
#'   its side effect of drawing a plot.
#'
#' @seealso [databasePrepareProjects()], [databasePrepareDependencies()]
#'
#' @examples
#' \dontrun{
#' FAIRgroundConnect("MY_DSN")
#' plotDependencies("som_clusterphenotype", "ab12cd")
#' }
#'
#' @export
plotDependencies <- function(table_name, id, con = NULL) {
  if (!requireNamespace("igraph", quietly = TRUE)) {
    stop("Package 'igraph' is required. Install it with: install.packages('igraph')")
  }

  con <- FAIRgroundConnection(con)

  # --- Fetch analysis_input rows for this analysis -------------------------

  ai_rows <- DBI::dbGetQuery(con,
    "SELECT project_id, codebook_name, external_id, resolved_script_id
     FROM table_dependency
     WHERE dependency_type = 'analysis_input' AND project_id = ?",
    params = list(id))

  # --- Fetch datasource/script rows for each resolved script ---------------

  resolved_scripts <- unique(ai_rows$resolved_script_id[!is.na(ai_rows$resolved_script_id)])

  sub_rows <- do.call(rbind, lapply(resolved_scripts, function(rsid) {
    DBI::dbGetQuery(con,
      "SELECT script_id, dependency_type, external_id
       FROM table_dependency
       WHERE dependency_type IN ('datasource', 'script') AND script_id = ?",
      params = list(rsid))
  }))
  if (is.null(sub_rows)) {
    sub_rows <- data.frame(script_id       = character(),
                           dependency_type = character(),
                           external_id     = character(),
                           stringsAsFactors = FALSE)
  }

  # --- Build node table ----------------------------------------------------

  root_id <- paste0("analysis::", id)

  nodes <- data.frame(
    id    = root_id,
    label = paste0(table_name, "\n(", id, ")"),
    type  = "analysis",
    stringsAsFactors = FALSE
  )

  .add_node <- function(node_id, label, type) {
    if (!node_id %in% nodes$id) {
      nodes <<- rbind(nodes,
        data.frame(id = node_id, label = label, type = type,
                   stringsAsFactors = FALSE))
    }
  }

  for (i in seq_len(nrow(ai_rows))) {
    rsid <- ai_rows$resolved_script_id[i]
    if (!is.na(rsid)) {
      .add_node(rsid, basename(rsid), "script")
    } else {
      uid <- paste0("unresolved::", ai_rows$codebook_name[i],
                    "::", ai_rows$external_id[i])
      .add_node(uid,
                paste0(ai_rows$codebook_name[i], "[", ai_rows$external_id[i], "]\n(unresolved)"),
                "unresolved")
    }
  }

  for (i in seq_len(nrow(sub_rows))) {
    .add_node(sub_rows$external_id[i], basename(sub_rows$external_id[i]),
              sub_rows$dependency_type[i])
  }

  # --- Build edge list ------------------------------------------------------

  edges <- data.frame(from = character(), to = character(),
                      stringsAsFactors = FALSE)

  for (i in seq_len(nrow(ai_rows))) {
    rsid  <- ai_rows$resolved_script_id[i]
    to_id <- if (!is.na(rsid)) rsid
             else paste0("unresolved::", ai_rows$codebook_name[i],
                         "::", ai_rows$external_id[i])
    edges <- rbind(edges,
      data.frame(from = root_id, to = to_id, stringsAsFactors = FALSE))
  }

  for (i in seq_len(nrow(sub_rows))) {
    edges <- rbind(edges,
      data.frame(from = sub_rows$script_id[i], to = sub_rows$external_id[i],
                 stringsAsFactors = FALSE))
  }

  if (nrow(edges) == 0) {
    message("No dependencies found for '", table_name, "' [", id, "].")
    return(invisible(NULL))
  }

  # --- Build and plot igraph -----------------------------------------------

  g <- igraph::graph_from_data_frame(edges, directed = TRUE, vertices = nodes)

  type_colors <- c(
    analysis   = "#4E79A7",   # blue
    script     = "#F28E2B",   # orange
    datasource = "#59A14F",   # green
    unresolved = "#E15759"    # red
  )
  vcol <- type_colors[igraph::V(g)$type]
  vcol[is.na(vcol)] <- "#BAB0AC"

  root_idx <- which(igraph::V(g)$name == root_id)
  layout   <- igraph::layout_as_tree(g, root = root_idx, flip.y = TRUE)

  old_par <- graphics::par(mar = c(3, 1, 3, 1))
  on.exit(graphics::par(old_par), add = TRUE)

  plot(g,
       vertex.color       = vcol,
       vertex.frame.color = NA,
       vertex.size        = 28,
       vertex.label       = igraph::V(g)$label,
       vertex.label.cex   = 0.65,
       vertex.label.color = "white",
       vertex.label.font  = 2L,
       edge.arrow.size    = 0.35,
       edge.color         = "grey55",
       layout             = layout,
       main               = paste0("Dependencies: ", table_name, " [", id, "]"))

  graphics::legend("bottomleft",
                   legend = c("analysis", "script", "datasource"),
                   fill   = c("#4E79A7", "#F28E2B", "#59A14F"),
                   border = NA, bty = "n", cex = 0.75)

  invisible(g)
}

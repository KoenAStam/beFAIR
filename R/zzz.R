.onLoad <- function(libname, pkgname) {
  reg.finalizer(
    .pkgenv,
    function(e) {
      if (!is.null(e$con) && DBI::dbIsValid(e$con)) {
        try(DBI::dbDisconnect(e$con), silent = TRUE)
      }
    },
    onexit = TRUE
  )
}

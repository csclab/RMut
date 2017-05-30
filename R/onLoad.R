.onLoad <- function(libname, pkgname) {
  #.jinit(parameters="-Xmx8000m")
  .jpackage(pkgname, lib.loc = libname)
}

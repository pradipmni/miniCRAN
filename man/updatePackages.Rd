% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/updatePackages.R
\name{updatePackages}
\alias{oldPackages}
\alias{updatePackages}
\title{Check for available package updates in a miniCRAN repo.}
\usage{
oldPackages(path = NULL, repos = getOption("repos"),
  availPkgs = pkgAvail(repos = repos, type = type, Rversion = Rversion),
  method, availableLocal = pkgAvail(repos = path, type = type, Rversion =
  Rversion), type = "source", Rversion = R.version)

updatePackages(path = NULL, repos = getOption("repos"), method,
  ask = TRUE, availPkgs = pkgAvail(repos = repos, type = type, Rversion =
  Rversion), oldPkgs = NULL, type = "source", Rversion = R.version,
  quiet = FALSE)
}
\arguments{
\item{path}{Destination download path. This path is the root folder of your new repository.}

\item{repos}{URL(s) of the 'contrib' sections of the repositories, e.g. \code{"http://cran.us.r-project.org"}. Passed to \code{\link{available.packages}}}

\item{availPkgs}{Vector of available packages.  Defaults to reading this list from CRAN, using \code{\link{available.packages}}}

\item{method}{Download method, see \code{\link{download.file}}.}

\item{availableLocal}{all packages hosted in the miniCRAN repo, as returned by \code{\link{pkgAvail}}. A subset can be specified; currently this must be in the same (character matrix) format as returned by \code{\link{pkgAvail}}.}

\item{type}{Possible values are (currently) "source", "mac.binary" and "win.binary": the binary types can be listed and downloaded but not installed on other platforms.  Passed to \code{\link{download.packages}}.}

\item{Rversion}{List with two named elements: `major` and `minor`. If not supplied, defaults to system version of R, using \code{\link{R.version}}.  Only used if \code{type} is not "source"}

\item{ask}{logical indicating whether to ask user before packages are actually downloaded and installed, or the character string "\code{graphics}", which brings up a widget to allow the user to (de-)select from the list of packages which could be updated or added. The latter value only works on systems with a GUI version of \code{\link{select.list}}, and is otherwise equivalent to \code{ask = TRUE}.}

\item{oldPkgs}{if specified as non-NULL, \code{updatePackages()} only considers these packages for updating. This may be a character vector of package names or a matrix as returned by \code{oldPackages()}.}

\item{quiet}{If TRUE, suppress status messages (if any), and the progress bar during download.}
}
\value{
\code{oldPackages} returns a matrix with one row per package and columns for "Package", "LocalVer", "ReposVer" and "Repository".  The matrix row names the package names.

\code{updatePackages} returns \code{NULL} invisibly.
}
\description{
\code{oldPackages} indicates packages which have a (suitable) later version on the repositories whereas \code{updatePackages} offers to download and install such packages.
}
\details{
These functions are based on \code{\link{update.packages}}.  However, rather than looking for locally installed packages they look for the package source and binaries in the miniCRAN repository.
}
\examples{
### `oldPackages` and `updatePackages` require an existing miniCRAN repo

# Specify list of packages to download
revolution <- c(CRAN = "http://mran.microsoft.com")
pkgs <- c("foreach")

pdb <- cranJuly2014

\dontrun{
  pdb <- pkgAvail(repos=revolution, type="source")
}

pkgList <- pkgDep(pkgs, availPkgs=pdb, repos=revolution, type="source", suggests=FALSE)
pkgList

\dontrun{
  # Create temporary folder for miniCRAN
  dir.create(pth <- file.path(tempdir(), "miniCRAN"))

  # create the miniCRAN directory structure but only add bin files
  makeRepo(pkgList, path=pth, repos=revolution, type="source", download=FALSE)
  makeRepo(pkgList, path=pth, repos=revolution, type="win.binary", download=TRUE)

  # download old source package version and create repo index
  oldVers <- data.frame(package=c("foreach", "codetools", "iterators"),
                        version=c("1.4.0", "0.2-7", "1.0.5"),
                        stringsAsFactors=FALSE)
  addOldPackage(pkgList, path=pth, repos=revolution, vers=oldVers$version, type="source")
  # NOTE: older binary versions would need to be build from source

  # Check if updated packages are available
  oldPackages(path=pth, repos=revolution, type="source") # should need update
  oldPackages(path=pth, repos=revolution, type="win.binary") # should be current

  # Update available packages
  updatePackages(path=pth, repos=revolution, type="source", ask=FALSE) # should need update
  updatePackages(path=pth, repos=revolution, type="win.binary") # should be current

  # Delete temporary folder
  unlink(pth, recursive=TRUE)
}
}
\seealso{
\code{\link{updatePackages}}, \code{\link{pkgAvail}}.

Other update repo functions: \code{\link{addOldPackage}},
  \code{\link{addPackage}}, \code{\link{checkVersions}},
  \code{\link{makeRepo}}
}


% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/tree_write.R
\name{as.Newick}
\alias{as.Newick}
\alias{as.Newick.phylo}
\alias{as.Newick.list}
\alias{as.Newick.multiPhylo}
\title{Write a phylogenetic tree in Newick format}
\usage{
as.Newick(x)

\method{as.Newick}{phylo}(x)

\method{as.Newick}{list}(x)

\method{as.Newick}{multiPhylo}(x)
}
\arguments{
\item{x}{Object to convert to Newick format.
See Usage section for supported classes.}
}
\value{
\code{as.Newick()} returns a character string representing \code{tree} in Newick
format.
}
\description{
\code{as.Newick()} creates a character string representation of a phylogenetic
tree, in the Newick format, using R's internal tip numbering.
Use \code{\link[=RenumberTips]{RenumberTips()}} to ensure that the internal numbering follows the
order you expect.
}
\examples{
trees <- list(BalancedTree(1:8), PectinateTree(8:1))
trees <- lapply(trees, RenumberTips, 1:8)
as.Newick(trees)

}
\seealso{
\itemize{
\item Retain leaf labels: \code{\link[=NewickTree]{NewickTree()}}
\item Change R's internal numbering of leaves: \code{\link[=RenumberTips]{RenumberTips()}}
\item Write tree to text or file: \code{\link[ape:write.tree]{ape::write.tree()}}
}
}
\author{
\href{https://orcid.org/0000-0001-5660-1727}{Martin R. Smith}
(\href{mailto:martin.smith@durham.ac.uk}{martin.smith@durham.ac.uk})
}

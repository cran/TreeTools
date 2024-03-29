% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/tree_generation.R
\name{.RandomParent}
\alias{.RandomParent}
\title{Random parent vector}
\usage{
.RandomParent(n, seed = sample.int(2147483647L, 1L))
}
\arguments{
\item{n}{Integer specifying number of leaves.}

\item{seed}{(Optional) Integer with which to seed Mersenne Twister random
number generator in C++.}
}
\value{
Integer vector corresponding to the "parent" entry of
\code{tree[["edge"]]}, where the "child" entry, i.e. column 2, is numbered
sequentially from \code{1:n}.
}
\description{
Random parent vector
}
\author{
\href{https://orcid.org/0000-0001-5660-1727}{Martin R. Smith}
(\href{mailto:martin.smith@durham.ac.uk}{martin.smith@durham.ac.uk})
}
\keyword{internal}

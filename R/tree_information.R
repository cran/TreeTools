#' Number of trees containing a tree
#'
#' `TreesMatchingTree()` calculates the number of unrooted binary trees that
#' are consistent with a tree topology on the same leaves.
#'
#' Remember to unroot a tree first if the position of its root is arbitrary.
#'
#' @template treeParam
#'
#' @return `TreesMatchingTree()` returns a numeric specifying the number of
#' unrooted binary trees that contain all the edges present in the input tree.
#'
#' `LnTreesMatchingTree()` gives the natural logarithm of this number.
#'
#'
#' @examples
#' partiallyResolvedTree <- CollapseNode(BalancedTree(8), 12:15)
#' TreesMatchingTree(partiallyResolvedTree)
#' LnTreesMatchingTree(partiallyResolvedTree)
#'
#' # Number of rooted trees:
#' rootedTree <- AddTip(partiallyResolvedTree, where = 0)
#' TreesMatchingTree(partiallyResolvedTree)
#' @template MRS
#'
#' @family tree information functions
#' @export
TreesMatchingTree <- function (tree) {
  prod(NUnrooted(NodeOrder(tree)))
}

#' @rdname TreesMatchingTree
#' @export
LnTreesMatchingTree <- function (tree) {
  sum(LnUnrooted(NodeOrder(tree)))
}

#' @rdname TreesMatchingTree
#' @export
Log2TreesMatchingTree <- function (tree) {
  sum(Log2Unrooted(NodeOrder(tree)))
}

#' Cladistic information content of a tree
#'
#' `CladisticInfo()` calculates the cladistic (phylogenetic) information
#' content of a phylogenetic object, _sensu_ Thorley _et al._ (1998).
#'
#' The \acronym{CIC} is the logarithm of the number of binary trees that include the
#' specified topology.  A base two logarithm gives an information content in
#' bits.
#'
#' The \acronym{CIC} was originally proposed by Rohlf (1982), and formalised,
#' with an information-theoretic justification, by Thorley _et al_. (1998).
#' Steel and Penny (2006) term the equivalent quantity 'phylogenetic information
#' content' in the context of individual characters.
#'
#' The number of binary trees consistent with a cladogram provides a more
#' satisfactory measure of the resolution of a tree than simply
#' counting the number of edges resolved (Page, 1992).
#'
#' @param x Tree of class `phylo`, or a list thereof.
#'
#' @return `CladisticInfo()` returns a numeric giving the cladistic information
#' content of the input tree(s), in bits.
#'
#' @references
#'
#' \insertRef{Page1992}{TreeTools}
#'
#' \insertRef{Rohlf1982}{TreeTools}
#'
#' \insertRef{Steel2006}{TreeTools}
#'
#' \insertRef{Thorley1998}{TreeTools}
#'
#' @family tree information functions
#' @family tree characterization functions
#'
#' @template MRS
#' @export
CladisticInfo <- function (x) UseMethod('CladisticInfo')

#' @rdname CladisticInfo
#' @export
PhylogeneticInfo <- function (x) {                                              # nocov start
  .Deprecated('CladisticInfo()')
  UseMethod('CladisticInfo')
}                                                                               # nocov end

#' @rdname CladisticInfo
#' @export
CladisticInfo.phylo <- function (x) {
  Log2Unrooted(NTip(x)) - Log2TreesMatchingTree(x)
}

#' @rdname CladisticInfo
#' @export
CladisticInfo.list <- function (x) vapply(x, CladisticInfo, 0)
#' @rdname CladisticInfo
#' @export
CladisticInfo.multiPhylo <- CladisticInfo.list


#' @rdname CladisticInfo
#' @export
PhylogeneticInformation <- PhylogeneticInfo
#' @rdname CladisticInfo
#' @export
CladisticInformation <- CladisticInfo

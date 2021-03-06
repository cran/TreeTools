#' Generate pectinate, balanced or random trees
#'
#' `RandomTree()`, `PectinateTree()`, `BalancedTree()` and `StarTree()`
#' generate trees with the specified shapes and leaf labels.
#'
#'
#' @template tipsForTreeGeneration
#'
#' @return
#' Each function returns an unweighted binary tree of class `phylo` with
#' the specified leaf labels. Trees are rooted unless `root = FALSE`.
#'
#' @family tree generation functions
#'
#' @template MRS
#' @name GenerateTree
NULL

#' @rdname GenerateTree
#'
#' @param root Character or integer specifying tip to use as root, if desired;
#' or `FALSE` for an unrooted tree.
#'
#' @return `RandomTree()` returns a topology drawn at random from the uniform
#' distribution (i.e. each binary tree is drawn with equal probability).
#' Trees are generated by inserting
#' each tip in term at a randomly selected edge in the tree.
#' Random numbers are generated using a Mersenne Twister.
#' If `root = FALSE`, the tree will be unrooted, with the first tip in a
#' basal position.  Otherwise, the tree will be rooted on `root`.
#'
#' @examples
#' RandomTree(LETTERS[1:10])
#'
#' data('Lobo')
#' RandomTree(Lobo.phy)
#'
#' @export
RandomTree <- function (tips, root = FALSE) {
  tips <- TipLabels(tips)
  nTips <- length(tips)
  edge <- do.call(cbind,
                  RenumberEdges(.RandomParent(nTips),
                                seq_len(nTips + nTips - 2L)))
  if (!is.logical(root) && !(length(root) == 1L && root == 1L)) {
    if (isTRUE(root)) root <- 1L
    if (is.character(root)) root <- which(tips == root)
    if (length(root) == 0L) stop ("No match found for `root`")
    if (!is.integer(root)) root <- as.integer(root)
    if (length(root) > 1L) {
      root <- root[1]
      warning("More than one entry in `root`; using ", root)
    }
    edge <- root_binary(edge, root)
  }
  tree <- structure(list(edge = edge,
                         Nnode = nTips - 1L,
                         tip.label = tips,
                         br = NULL),
                    class = 'phylo')
  # Until require R >= 3.5.0
  isFALSE <- function (x) is.logical(x) && length(x) == 1L && !is.na(x) && !x
  if (isFALSE(root)) {
    tree <- UnrootTree(tree)
  }

  # Return:
  tree
}

#' Random parent vector
#'
#' @param n Integer specifying number of leaves.
#' @param seed (Optional) Integer with which to seed Mersenne Twister random
#' number generator in C++.
#'
#' @return Integer vector corresponding to the 'parent' entry of `tree$edge`,
#' where the 'child' entry, i.e. column 2, is numbered sequentially from `1:n`.
#' @template MRS
#' @keywords internal
#' @importFrom stats runif
#' @export
.RandomParent <- function (n, seed = sample.int(2147483647L, 1L)) {
  random_parent(n, seed)
}

#' @rdname GenerateTree
#' @return `PectinateTree()` returns a pectinate (caterpillar) tree.
#' @examples
#' plot(PectinateTree(LETTERS[1:10]))
#'
#' @export
PectinateTree <- function (tips) {
  tips <- TipLabels(tips)
  nTips <- length(tips)

  nEdge <- nTips + nTips - 2L
  tipSeq <- seq_len(nTips - 1L)

  parent <- rep(seq_len(nTips - 1L) + nTips, each = 2L)

  child <- integer(nEdge)
  child[tipSeq + tipSeq - 1L] <- tipSeq
  child[tipSeq + tipSeq] <- tipSeq + nTips + 1L
  child[nEdge] <- nTips

  structure(list(
    edge = matrix(c(parent, child), ncol = 2L),
    Nnode = nTips - 1L,
    tip.label = tips
  ), order = 'cladewise', class = 'phylo')
}


#' @rdname GenerateTree
#'
#' @return `BalancedTree()` returns a balanced (symmetrical) tree.
#'
#' @examples
#' plot(BalancedTree(LETTERS[1:10]))
#' @export
BalancedTree <- function (tips) {
  tips <- TipLabels(tips)
  nTip <- length(tips)
  if (nTip < 2L) {
    return(if (nTip == 1L) SingleTaxonTree(tips) else NULL)
  }

  # Return:
  structure(list(edge = .BalancedBit(seq_len(nTip)), Nnode = nTip - 1L,
                       tip.label = as.character(tips)),
            order = 'cladewise', class = 'phylo') # Actually in preorder
}

#' @keywords internal
.BalancedBit <- function (tips, nTips = length(tips), rootNode = nTips + 1L) {
  if (nTips < 4L) {
    if (nTips == 2L) {
      matrix(c(rootNode, rootNode, tips), 2L, 2L)
    } else if (nTips == 3L) {
      matrix(c(rootNode + c(0L, 1L, 1L, 0L, 1L), tips), 4L, 2L)
    } else {
      tips
    }
  } else {
    # Recurse:
    firstN <- as.integer(ceiling(nTips / 2L))
    firstHalf <- seq_len(firstN)
    root2 <- rootNode + firstN
    rbind(rootNode + 0:1,
          .BalancedBit(tips[firstHalf], rootNode = rootNode + 1L),
          c(rootNode, root2),
          .BalancedBit(tips[-firstHalf], rootNode = root2))
  }
}

#' @rdname GenerateTree
#' @return `StarTree()` returns a completely unresolved (star) tree.
#' @examples
#' plot(StarTree(LETTERS[1:10]))
#'
#' @export
StarTree <- function (tips) {
  tips <- TipLabels(tips)
  nTips <- length(tips)

  parent <- rep(nTips + 1L, nTips)
  child <- seq_len(nTips)

  structure(list(
    edge = matrix(c(parent, child), ncol = 2L),
    Nnode = 1L,
    tip.label = tips
  ), order = 'cladewise', class = 'phylo')
}

#' Generate a neighbour joining tree
#'
#' `NJTree()` generates a rooted neighbour joining tree from a phylogenetic
#' dataset.
#'
#' @template datasetParam
#' @param edgeLengths Logical specifying whether to include edge lengths.
#'
#' @return `NJTree` returns an object of class \code{phylo}.
#'
#' @examples
#' data('Lobo')
#' NJTree(Lobo.phy)
#'
#' @template MRS
#' @importFrom ape nj root
#' @importFrom phangorn dist.hamming
#' @family tree generation functions
#' @export
NJTree <- function (dataset, edgeLengths = FALSE) {
  tree <- nj(dist.hamming(dataset))
  tree <- root(tree, names(dataset)[1], resolve.root = TRUE)
  if (!edgeLengths) tree$edge.length <- NULL
  tree
}

#' Generate a tree with a specific outgroup
#'
#' Given a tree or a list of taxa, `EnforceOutgroup()` rearranges the ingroup
#' and outgroup taxa such that the two are sister taxa across the root, without
#' changing the relationships within the ingroup or within the outgroup.
#'
#' @param tree Either a tree of class \code{phylo}; or (for `EnforceOutgroup()`)
#' a character vector listing the names of all the taxa in the tree, from which
#' a random tree will be generated.
#' @param outgroup Character vector containing the names of taxa to include in the
#' outgroup.
#'
#' @return `EnforceOutgroup()` returns a tree of class `phylo` where all outgroup
#' taxa are sister to all remaining taxa, without modifying the ingroup
#' topology.
#'
#' @examples
#' tree <- EnforceOutgroup(letters[1:9], letters[1:3])
#' plot(tree)
#'
#' @seealso For a more robust implementation, see [`RootTree()`], which will
#' eventually replace this function
#' ([#30](https://github.com/ms609/TreeTools/issues/30)).
#'
#' @template MRS
#' @family tree manipulation
#' @export
EnforceOutgroup <- function (tree, outgroup) UseMethod('EnforceOutgroup')

#' @importFrom ape root drop.tip bind.tree
.EnforceOutgroup <- function (tree, outgroup, taxa) {
  if (length(outgroup) == 1L) return (root(tree, outgroup, resolve.root = TRUE))

  ingroup <- taxa[!(taxa %in% outgroup)]
  if (!all(outgroup %in% taxa) || length(ingroup) + length(outgroup) != length(taxa)) {
    stop ("All outgroup taxa must occur in tree")
  }

  ingroup.branch <- drop.tip(tree, outgroup)
  outgroup.branch <- drop.tip(tree, ingroup)

  result <- root(bind.tree(outgroup.branch, ingroup.branch, 0, 1),
                 outgroup, resolve.root = TRUE)
  RenumberTips(Renumber(result), taxa)
}

#' @rdname EnforceOutgroup
#' @export
EnforceOutgroup.phylo <- function (tree, outgroup) {
  .EnforceOutgroup(tree, outgroup, tree$tip.label)
}

#' @rdname EnforceOutgroup
#' @importFrom ape root
#' @export
EnforceOutgroup.character <- function (tree, outgroup) {
  taxa <- tree
  .EnforceOutgroup(RandomTree(taxa, taxa[1]), outgroup, taxa)
}

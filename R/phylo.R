#' Renumber a tree's nodes and tips
#'
#' \code{Renumber} numbers the nodes and tips in a tree to conform with the
#' phylo standards.
#'
#' @template treeParam
#'
#' @examples
#' tree <- RandomTree(letters[1:10])
#' Renumber(tree)
#'
#' @return This function returns a tree of class \code{phylo}.
#'
#' @template MRS
#' @family tree manipulation
#' @export
Renumber <- function (tree) {
  tree   <- ApePostorder(tree)
  edge   <- tree$edge
  nTip   <- length(tree$tip.label)
  parent <- edge[, 1L]
  child  <- edge[, 2L]
  NODES  <- child > nTip
  TIPS   <- !NODES
  nNode  <- sum(NODES) + 1 # Root node has no edge leading to it, so add 1

  tip <- child[TIPS]
  name <- vector("character", length(tip))
  name[1:nTip] <- tree$tip.label[tip]
  tree$tip.label <- name
  child[TIPS] <- 1:nTip

  old.node.number <- unique(parent)
  new.node.number <- rev(nTip + seq_along(old.node.number))
  renumbering.schema <- integer(nNode)
  renumbering.schema[old.node.number - nTip] <- new.node.number
  child[NODES] <- renumbering.schema[child[NODES] - nTip]
  nodeseq <- (1L:nNode) * 2L
  parent <- renumbering.schema[parent - nTip]

  tree$edge[,1] <- parent
  tree$edge[,2] <- child
  Cladewise(tree)
}

#' SingleTaxonTree
#'
#' Single taxon tree
#'
#' Create a phylogenetic 'tree' that comprises a single taxon.
#'
#' @usage SingleTaxonTree(label)
#' @param  label a character vector specifying the label of the tip.
#' @return `SingleTaxonTree` returns a \code{phylo} object containing a single
#' tip with the specified label.
#'
#' @examples
#' SingleTaxonTree('Homo_sapiens')
#' plot(SingleTaxonTree('root') + BalancedTree(4))
#'
#' @keywords  tree
#' @family tree manipulation
#' @family tree generation functions
#' @export
SingleTaxonTree <- function (label) {
  structure(list(edge=matrix(c(2L,1L), 1, 2), tip.label=label, Nnode=1L),
            class = 'phylo')
}

#' Extract subtree
#'
#' @description Safely extracts a clade from a phylogenetic tree.
#' @usage Subtree(tree, node)
#'
#' @template preorderTreeParam
#' @param node The number of the node at the base of the clade to be extracted.
#'
#' @details
#' Modified from the \pkg{ape} function \code{\link{extract.clade}}, which
#' sometimes behaves erratically.
#' Unlike extract.clade, this function supports the extraction of 'clades'
#' that constitute a single tip.
#'
#' @return This function returns a tree of class \code{phylo} that represents a
#' clade extracted from the original tree.
#'
#' @examples
#' tree <- Preorder(BalancedTree(8))
#' plot(tree)
#' ape::nodelabels()
#' ape::nodelabels(13, 13, bg='yellow')
#'
#' plot(Subtree(tree, 13))
#'
#'
#' @template MRS
#' @family tree manipulation
#' @export
Subtree <- function (tree, node) {
  if (is.null(treeOrder <- attr(tree, 'order')) || treeOrder != 'preorder') {
    stop("Tree must be in preorder")
  }
  tipLabel <- tree$tip.label
  nTip <- length(tipLabel)
  if (node <= nTip) return(SingleTaxonTree(tipLabel[node]))
  if (node == nTip + 1L) return(tree)

  edge <- tree$edge
  parent <- edge[, 1]
  child <- edge[, 2]
  subtreeParentEdge <- match(node, child)
  keepEdge <- DescendantEdges(subtreeParentEdge, parent, child)
  keepEdge[subtreeParentEdge] <- FALSE

  edge <- edge[keepEdge, ]
  edge1 <- edge[, 1]
  edge2 <- edge[, 2]

  isTip <- edge2 <= nTip
  tips  <- edge2[isTip]
  new.nTip <- length(tips)
  name <- character(new.nTip)
  tipOrder <- order(tips, method='radix') # method='radix' typically a few % faster than 'auto'
  name[tipOrder] <- tipLabel[tips]
  edge2[isTip] <- tipOrder

  ## renumber nodes:
  nodeAdjust <- new.nTip + 1 - node
  edge2[!isTip] <- edge2[!isTip] + nodeAdjust
  edge[, 1] <- edge1 + nodeAdjust
  edge[, 2] <- edge2

  # Return:
  structure(list(
    tip.label = name,
    Nnode = dim(edge)[1] - new.nTip + 1L,
    edge = edge
  ), class = 'phylo')
}

#' Add a tip to a phylogenetic tree
#'
#' `AddTip` adds a tip to a phylogenetic tree at a specified location.
#'
#'`AddTip` extends \code{\link{bind.tree}}, which cannot handle
#'   single-taxon trees.
#'
#' @template treeParam
#' @param where The node or tip that should form the sister taxon to the new
#' node.  To add a new tip at the root, use `where = 0`.  By default, the
#' new tip is added to a random edge.
#' @param label Character string providing the label to apply to the new tip.
#'
#' @return `AddTip` returns a tree of class \code{phylo} with an additional tip
#' at the desired location.
#'
#' @template MRS
#'
#' @seealso \code{\link{bind.tree}}
#' @seealso \code{\link{nodelabels}}
#'
#' @examples
#'
#' plot(tree <- BalancedTree(10))
#' ape::nodelabels()
#' ape::nodelabels(15, 15, bg='green')
#'
#' plot(AddTip(tree, 15, 'NEW_TIP'))
#'
#' @keywords tree
#' @family tree manipulation
#'
#' @export
AddTip <- function (tree,
                    where = sample.int(tree$Nnode * 2 + 2L, size = 1) - 1L,
                    label = "New tip") {
  nTip <- length(tree$tip.label)
  nNode <- tree$Nnode
  ROOT <- nTip + 1L
  if (where < 1L) where <- ROOT
  new.tip.number <- nTip + 1L
  tree.edge <- tree$edge

  ## find the row of 'where' before renumbering
  if (where == ROOT) case <- 1L else {
      insertion.edge <- which(tree.edge[, 2] == where)
      case <- if (where <= nTip) 2L else 3L
  }
  ## case = 1 -> y is bound on the root of x
  ## case = 2 -> y is bound on a tip of x
  ## case = 3 -> y is bound on a node of x

### because in all situations internal nodes need to be
### renumbered, they are changed to negatives first, and
### nodes eventually added will be numbered sequentially
  nodes <- tree.edge > nTip
  tree.edge[nodes] <- -(tree.edge[nodes] - nTip)  # -1, ..., -nTip
  next.node <- -nNode - 1L
  ROOT <- -1L # This may change later

  switch(case, { # case = 1 -> y is bound on the root of x
      tree.edge <- rbind(c(next.node, tree.edge[1]), tree.edge, c(next.node, new.tip.number))
      ROOT <- next.node
    }, { # case = 2 -> y is bound on a tip of x
      tree.edge[insertion.edge, 2] <- next.node
      tree.edge <- rbind(tree.edge[1:insertion.edge, ], c(next.node, where), c(next.node, new.tip.number), tree.edge[-(1:insertion.edge), ])
    }, { # case = 3 -> y is bound on a node of x
      tree.edge <- rbind(tree.edge[1:insertion.edge, ], c(next.node, tree.edge[insertion.edge, 2]), tree.edge[-(1:insertion.edge), ])
      tree.edge[insertion.edge, 2] <- next.node
      insertion.edge <- insertion.edge + 1L
      tree.edge <- rbind(tree.edge[1:insertion.edge, ], c(next.node, new.tip.number), tree.edge[-(1:insertion.edge), ])
    }
  )
  tree$tip.label <- c(tree$tip.label, label)
  tree$Nnode <- nNode <- nNode + 1L

  ## renumber nodes:
  new.numbering <- integer(nNode)
  new.numbering[-ROOT] <- new.tip.number + 1L
  second.col.nodes <- tree.edge[, 2] < 0L
  ## executed from right to left, so newNb is modified before x$edge:
  tree.edge[second.col.nodes, 2] <- new.numbering[-tree.edge[second.col.nodes, 2]] <- new.tip.number + 2:nNode
  tree.edge[, 1] <- new.numbering[-tree.edge[, 1]]

  tree$edge <- tree.edge

  # Return:
  tree
}

#' @describeIn AddTip Add a tip to each edge in turn.
#' @param includeRoot Logical; if `TRUE`, the three positions adjacent
#' to the root edge are considered to represent distinct edges.
#' @return `AddTipEverywhere` returns a list of class `multiPhylo` containing
#' the trees produced by adding `label` to each edge of `tree` in turn.
#'
#' @examples
#' oldPar <- par(mfrow=c(2, 4), mar=rep(0.3, 4), cex=0.9)
#'
#' backbone <- BalancedTree(4)
#' additions <- AddTipEverywhere(backbone, includeRoot = TRUE)
#' xx <- lapply(additions, plot)
#'
#' par(mfrow=c(2, 3))
#' additions <- AddTipEverywhere(backbone, includeRoot = FALSE)
#' xx <- lapply(additions, plot)
#'
#' par(oldPar)
#'
#' @export
AddTipEverywhere <- function (tree, label = 'New tip', includeRoot = FALSE) {
  nTip <- length(tree$tip.label)
  whichNodes <- if (includeRoot) {
    seq_len(tree$Nnode * 2 + 1L)
  } else {
    c(seq_len(nTip), nTip + 2L + seq_len(tree$Nnode - 2L))
  }
  lapply(whichNodes, AddTip, tree = tree, label = label)
}

#' List all ancestral nodes
#'
#' \code{AllAncestors} lists ancestors of each parent node in a tree.
#'
#' Note that the tree's edges must be listed in an order whereby each entry in
#' \code{tr$edge[, 1]} (with the exception of the root) has appeared already in
#' \code{tr$edge[, 2]}.
#'
#' @template treeParent
#' @template treeChild
#'
#' @examples
#'   tr <- PectinateTree(4)
#'   plot(tr)
#'   ape::tiplabels()
#'   ape::nodelabels()
#'   edge <- tr$edge
#'   AllAncestors(edge[, 1], edge[, 2])
#'
#' @return `AllAncestors` returns a list. Entry _i_ contains a vector containing,
#' in order, the nodes encountered when traversing the tree from node _i_ to the
#' root node.
#' The last entry of each member of the list is therefore the root node,
#' with the exception of the entry for the root node itself, which is `NULL`.
#'
#' @template MRS
#' @family tree navigation
#' @export
AllAncestors <- function (parent, child) {
  res <- vector("list", max(parent))
  for (i in seq_along(parent)) {
    pa <- parent[i]
    res[[child[i]]] <- c(pa, res[[pa]])
  }
  res
}

#' Clade sizes
#'
#' @template treeParam
#' @param nodes whose descendants should be returned
#'
#' @return `CladeSizes` returns the number of nodes (including tips) that are
#' descended from each node.
#'
#' @examples
#' tree <- BalancedTree(6)
#' plot(tree)
#' ape::nodelabels()
#' CladeSizes(tree, c(8, 9))
#'
#' @importFrom phangorn allDescendants
#' @keywords internal
#' @export
CladeSizes <- function (tree, nodes) {
  tree <- Postorder(tree, force = FALSE)
  vapply(allDescendants(tree)[nodes], length, integer(1))
}
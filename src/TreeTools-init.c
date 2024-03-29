#define USE_RINTERNALS

#include <Rinternals.h>
#include <stdlib.h> /* for NULL */

#include "ape_reorder.h"

extern SEXP _TreeTools_as_newick(SEXP);
extern SEXP _TreeTools_ClusterTable_decode(SEXP);
extern SEXP _TreeTools_ClusterTable_matrix(SEXP);
extern SEXP _TreeTools_ClusterTable_new(SEXP);
extern SEXP _TreeTools_consensus_tree(SEXP, SEXP);
extern SEXP _TreeTools_cpp_edge_to_splits(SEXP, SEXP, SEXP);
extern SEXP _TreeTools_duplicated_splits(SEXP, SEXP);
extern SEXP _TreeTools_edge_to_mixed_base(SEXP, SEXP, SEXP);
extern SEXP _TreeTools_edge_to_num(SEXP, SEXP, SEXP);
extern SEXP _TreeTools_edge_to_rooted_shape(SEXP, SEXP, SEXP);
extern SEXP _TreeTools_keep_tip(SEXP, SEXP);
extern SEXP _TreeTools_kept_vertices(SEXP, SEXP);
extern SEXP _TreeTools_minimum_spanning_tree(SEXP);
extern SEXP _TreeTools_mixed_base_to_parent(SEXP, SEXP);
extern SEXP _TreeTools_num_to_parent(SEXP, SEXP);
extern SEXP _TreeTools_path_lengths(SEXP, SEXP);
extern SEXP _TreeTools_postorder_order(SEXP);
extern SEXP _TreeTools_preorder_edges_and_nodes(SEXP, SEXP);
extern SEXP _TreeTools_preorder_weighted(SEXP, SEXP, SEXP);
extern SEXP _TreeTools_random_parent(SEXP, SEXP);
extern SEXP _TreeTools_root_binary(SEXP, SEXP);
extern SEXP _TreeTools_root_on_node(SEXP, SEXP);
extern SEXP _TreeTools_rooted_shape_to_edge(SEXP, SEXP);
extern SEXP _TreeTools_splits_to_edge(SEXP, SEXP);
extern SEXP _TreeTools_thin_splits(SEXP, SEXP);
extern SEXP _TreeTools_tips_in_splits(SEXP);
extern SEXP _TreeTools_and_splits(SEXP, SEXP);
extern SEXP _TreeTools_xor_splits(SEXP, SEXP);
extern SEXP _TreeTools_or_splits(SEXP, SEXP);
extern SEXP _TreeTools_mask_splits(SEXP);
extern SEXP _TreeTools_not_splits(SEXP);

static const R_CMethodDef cMethods[] = {
  {"ape_neworder_phylo",       (DL_FUNC) &ape_neworder_phylo, 6, ape_neworder_phylo_t},
  {"ape_neworder_pruningwise", (DL_FUNC) &ape_neworder_pruningwise, 6, ape_neworder_pruningwise_t},
  {"ape_node_depth",           (DL_FUNC) &ape_node_depth, 7, ape_node_depth_t},
  {NULL, NULL, 0, NULL}
};

static const R_CallMethodDef callMethods[] = {
  {"_TreeTools_as_newick", (DL_FUNC) &_TreeTools_as_newick, 1},
  {"_TreeTools_ClusterTable_decode", (DL_FUNC) &_TreeTools_ClusterTable_decode, 1},
  {"_TreeTools_ClusterTable_matrix", (DL_FUNC) &_TreeTools_ClusterTable_matrix, 1},
  {"_TreeTools_ClusterTable_new", (DL_FUNC) &_TreeTools_ClusterTable_new, 1},
  {"_TreeTools_consensus_tree", (DL_FUNC) &_TreeTools_consensus_tree, 2},
  {"_TreeTools_cpp_edge_to_splits", (DL_FUNC) &_TreeTools_cpp_edge_to_splits, 3},
  {"_TreeTools_duplicated_splits", (DL_FUNC) &_TreeTools_duplicated_splits, 2},
  {"_TreeTools_edge_to_mixed_base", (DL_FUNC) &_TreeTools_edge_to_mixed_base, 3},
  {"_TreeTools_edge_to_num", (DL_FUNC) &_TreeTools_edge_to_num, 3},
  {"_TreeTools_edge_to_rooted_shape", (DL_FUNC) &_TreeTools_edge_to_rooted_shape, 3},
  {"_TreeTools_kept_vertices", (DL_FUNC) &_TreeTools_kept_vertices, 2},
  {"_TreeTools_keep_tip", (DL_FUNC) &_TreeTools_keep_tip, 2},
  {"_TreeTools_minimum_spanning_tree", (DL_FUNC) &_TreeTools_minimum_spanning_tree, 1},
  {"_TreeTools_mixed_base_to_parent", (DL_FUNC) &_TreeTools_mixed_base_to_parent, 2},
  {"_TreeTools_num_to_parent", (DL_FUNC) &_TreeTools_num_to_parent, 2},
  {"_TreeTools_path_lengths", (DL_FUNC) &_TreeTools_path_lengths, 2},
  {"_TreeTools_postorder_order", (DL_FUNC) &_TreeTools_postorder_order, 1},
  {"_TreeTools_preorder_edges_and_nodes", (DL_FUNC) &_TreeTools_preorder_edges_and_nodes, 2},
  {"_TreeTools_preorder_weighted", (DL_FUNC) &_TreeTools_preorder_weighted, 3},
  {"_TreeTools_random_parent", (DL_FUNC) &_TreeTools_random_parent, 2},
  {"_TreeTools_root_binary", (DL_FUNC) &_TreeTools_root_binary, 2},
  {"_TreeTools_root_on_node", (DL_FUNC) &_TreeTools_root_on_node, 2},
  {"_TreeTools_rooted_shape_to_edge", (DL_FUNC) &_TreeTools_rooted_shape_to_edge, 2},
  {"_TreeTools_splits_to_edge", (DL_FUNC) &_TreeTools_splits_to_edge, 2},
  {"_TreeTools_tips_in_splits", (DL_FUNC) &_TreeTools_tips_in_splits, 1},
  {"_TreeTools_thin_splits", (DL_FUNC) &_TreeTools_thin_splits, 2},
  {"_TreeTools_xor_splits", (DL_FUNC) &_TreeTools_xor_splits, 2},
  {"_TreeTools_and_splits", (DL_FUNC) &_TreeTools_and_splits, 2},
  {"_TreeTools_mask_splits", (DL_FUNC) &_TreeTools_mask_splits, 1},
  {"_TreeTools_or_splits", (DL_FUNC) &_TreeTools_or_splits, 2},
  {"_TreeTools_not_splits", (DL_FUNC) &_TreeTools_not_splits, 1},
  {NULL, NULL, 0}
};

void R_init_TreeTools(DllInfo *dll) {
  R_registerRoutines(dll, cMethods, callMethods, NULL, NULL);
  R_useDynamicSymbols(dll, FALSE);
  R_forceSymbols(dll, TRUE);
}

context("TreeNumber.R")

test_that("as.phylo.numeric()", {
  expect_equal(as.phylo(0:2, 6, letters[1:6])[[1]],
               PectinateTree(letters[c(1, 3:6, 2)]))
  expect_equal(as.phylo(0, tipLabels = letters[1:6]),
               PectinateTree(letters[c(1, 3:6, 2)]))
  expect_error(as.phylo(0))
  expect_equal(as.phylo(123, nTip = 8),
               as.phylo(123L, nTip = 8))
  expect_equal(as.phylo(123, nTip = 8),
               as.phylo(as.integer64(123), nTip = 8))
  expect_equal(as.phylo(123:124, nTip = 10),
               as.phylo(as.integer64(123:124), nTip = 10))
})

test_that("as.TreeNumber() error handling", {
  expect_error(as.phylo(integer64(1), NULL, NULL))
})

test_that("as.TreeNumber()", {
  expect_equal(SingleTaxonTree('t1'), as.phylo(integer64(1), 1, NULL))
  expect_equal(c("Phylogenetic tree number 0 of 105 ",
                 " 6 tips: t1 t2 t3 t4 t5 t6"),
               capture.output(print(as.TreeNumber(as.phylo(105, 6)))))
  expect_equal("Phylogenetic tree number 105 of 6332659870762850625 ",
               capture.output(print(as.TreeNumber(as.phylo(105, 19))))[1])
  expect_equal("Phylogenetic tree number 105 of 2.216431e+20 ",
               capture.output(print(as.TreeNumber(as.phylo(105, 20))))[1])
  expect_equal(unlist(lapply(1:3, as.integer64)),
               unlist(as.TreeNumber(as.phylo(1:3, 6))))

  tn6 <- as.TreeNumber(as.phylo(1, 6, letters[1:6]))
  expect_equal(as.phylo(1, 6), as.phylo(tn6, tipLabels = NULL))

  tn16 <- as.TreeNumber(as.phylo(1, 16, letters[1:16]))
  expect_equal(as.phylo(1, 16), as.phylo(tn16, tipLabels = NULL))

  bigNumber <- as.integer64(11 * 2^31 + 1234)
  tn16 <- as.TreeNumber(as.phylo(bigNumber, 16, letters[1:16]))
  expect_equal(as.phylo(bigNumber, 16), as.phylo(tn16, tipLabels = NULL))
})

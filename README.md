
<!-- README.md is generated from README.Rmd. Please edit that file -->
<!-- badges: start -->
<!-- badges: end -->
Overview
========

User-friendly and flexible algorithm for modeling, sampling, inference, and clustering heteregenous data with Robust of Mixture-of-Experts using the t distribution.

Installation
============

You can install the development version of tMoE from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("fchamroukhi/tMoE")
```

To build *vignettes* for examples of usage, type the command below instead:

``` r
# install.packages("devtools")
devtools::install_github("fchamroukhi/tMoE", 
                         build_opts = c("--no-resave-data", "--no-manual"), 
                         build_vignettes = TRUE)
```

Use the following command to display vignettes:

``` r
browseVignettes("tMoE")
```

Usage
=====

``` r
library(tMoE)
```

``` r
n <- 500 # Size of the sample
alphak <- matrix(c(0, 8), ncol = 1) # Parameters of the gating network
betak <- matrix(c(0, -2.5, 0, 2.5), ncol = 2) # Regression coefficients of the experts
sigmak <- c(0.5, 0.5) # Standard deviations of the experts
nuk <- c(5, 7) # Degrees of freedom of the experts network t densities
x <- seq.int(from = -1, to = 1, length.out = n) # Inputs (predictors)

# Generate sample of size n
sample <- sampleUnivTMoE(alphak = alphak, betak = betak, sigmak = sigmak, 
                         nuk = nuk, x = x)
y <- sample$y

K <- 2 # Number of regressors/experts
p <- 1 # Order of the polynomial regression (regressors/experts)
q <- 1 # Order of the logistic regression (gating network)

n_tries <- 1
max_iter <- 1500
threshold <- 1e-5
verbose <- TRUE
verbose_IRLS <- FALSE

tmoe <- emTMoE(X = x, Y = y, K, p, q, n_tries, max_iter, 
               threshold, verbose, verbose_IRLS)
#> EM - tMoE: Iteration: 1 | log-likelihood: -467.484207943383
#> EM - tMoE: Iteration: 2 | log-likelihood: -466.615417062891
#> EM - tMoE: Iteration: 3 | log-likelihood: -466.337042836754
#> EM - tMoE: Iteration: 4 | log-likelihood: -466.070457425424
#> EM - tMoE: Iteration: 5 | log-likelihood: -465.820097871588
#> EM - tMoE: Iteration: 6 | log-likelihood: -465.59172336557
#> EM - tMoE: Iteration: 7 | log-likelihood: -465.388858492026
#> EM - tMoE: Iteration: 8 | log-likelihood: -465.212841762827
#> EM - tMoE: Iteration: 9 | log-likelihood: -465.063206596746
#> EM - tMoE: Iteration: 10 | log-likelihood: -464.938176973375
#> EM - tMoE: Iteration: 11 | log-likelihood: -464.835059669474
#> EM - tMoE: Iteration: 12 | log-likelihood: -464.750955217815
#> EM - tMoE: Iteration: 13 | log-likelihood: -464.682634667636
#> EM - tMoE: Iteration: 14 | log-likelihood: -464.627122247056
#> EM - tMoE: Iteration: 15 | log-likelihood: -464.581708343698
#> EM - tMoE: Iteration: 16 | log-likelihood: -464.544008101863
#> EM - tMoE: Iteration: 17 | log-likelihood: -464.511973303813
#> EM - tMoE: Iteration: 18 | log-likelihood: -464.48388593876
#> EM - tMoE: Iteration: 19 | log-likelihood: -464.458333326098
#> EM - tMoE: Iteration: 20 | log-likelihood: -464.434166675474
#> EM - tMoE: Iteration: 21 | log-likelihood: -464.410451079609
#> EM - tMoE: Iteration: 22 | log-likelihood: -464.386385026039
#> EM - tMoE: Iteration: 23 | log-likelihood: -464.361176140826
#> EM - tMoE: Iteration: 24 | log-likelihood: -464.333866851588
#> EM - tMoE: Iteration: 25 | log-likelihood: -464.30316254427
#> EM - tMoE: Iteration: 26 | log-likelihood: -464.267394206326
#> EM - tMoE: Iteration: 27 | log-likelihood: -464.224367733289
#> EM - tMoE: Iteration: 28 | log-likelihood: -464.172112630194
#> EM - tMoE: Iteration: 29 | log-likelihood: -464.109815010866
#> EM - tMoE: Iteration: 30 | log-likelihood: -464.038736524052
#> EM - tMoE: Iteration: 31 | log-likelihood: -463.962315916051
#> EM - tMoE: Iteration: 32 | log-likelihood: -463.885450766327
#> EM - tMoE: Iteration: 33 | log-likelihood: -463.813572771726
#> EM - tMoE: Iteration: 34 | log-likelihood: -463.751554962499
#> EM - tMoE: Iteration: 35 | log-likelihood: -463.702323794321
#> EM - tMoE: Iteration: 36 | log-likelihood: -463.665771345812
#> EM - tMoE: Iteration: 37 | log-likelihood: -463.639379031063
#> EM - tMoE: Iteration: 38 | log-likelihood: -463.619418841704
#> EM - tMoE: Iteration: 39 | log-likelihood: -463.601964937016
#> EM - tMoE: Iteration: 40 | log-likelihood: -463.582863628625
#> EM - tMoE: Iteration: 41 | log-likelihood: -463.557060411394
#> EM - tMoE: Iteration: 42 | log-likelihood: -463.51811126831
#> EM - tMoE: Iteration: 43 | log-likelihood: -463.458979020015
#> EM - tMoE: Iteration: 44 | log-likelihood: -463.376006336921
#> EM - tMoE: Iteration: 45 | log-likelihood: -463.27338429431
#> EM - tMoE: Iteration: 46 | log-likelihood: -463.161815389988
#> EM - tMoE: Iteration: 47 | log-likelihood: -463.051950036624
#> EM - tMoE: Iteration: 48 | log-likelihood: -462.951095825399
#> EM - tMoE: Iteration: 49 | log-likelihood: -462.864922984443
#> EM - tMoE: Iteration: 50 | log-likelihood: -462.798775633338
#> EM - tMoE: Iteration: 51 | log-likelihood: -462.754928303606
#> EM - tMoE: Iteration: 52 | log-likelihood: -462.729936927635
#> EM - tMoE: Iteration: 53 | log-likelihood: -462.717421323998
#> EM - tMoE: Iteration: 54 | log-likelihood: -462.711616081403
#> EM - tMoE: Iteration: 55 | log-likelihood: -462.708946454606

tmoe$plot()
```

<img src="man/figures/README-unnamed-chunk-6-1.png" style="display: block; margin: auto;" /><img src="man/figures/README-unnamed-chunk-6-2.png" style="display: block; margin: auto;" /><img src="man/figures/README-unnamed-chunk-6-3.png" style="display: block; margin: auto;" /><img src="man/figures/README-unnamed-chunk-6-4.png" style="display: block; margin: auto;" />

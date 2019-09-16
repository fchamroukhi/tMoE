
<!-- README.md is generated from README.Rmd. Please edit that file -->
<!-- badges: start -->
<!-- badges: end -->
Overview
========

**TMoE** (t Mixture-of-Experts) provides a flexible and robust modelling framework for heterogenous data with possibly heavy-tailed distributions and corrupted by atypical observations. **TMoE** consists of a mixture of *K* t expert regressors network (of degree *p*) gated by a softmax gating network (of degree *q*) and is represented by:

-   The gating network parameters `alpha`'s of the softmax net.
-   The experts network parameters: The location parameters (regression coefficients) `beta`'s, scale parameters `sigma`'s, and the degree of freedom (robustness) parameters `nu`'s. **TMoE** thus generalises mixtures of (normal, t, and) distributions and mixtures of regressions with these distributions. For example, when *q* = 0, we retrieve mixtures of (t-, or normal) regressions, and when both *p* = 0 and *q* = 0, it is a mixture of (t-, or normal) distributions. It also reduces to the standard (normal, t) distribution when we only use a single expert (*K* = 1).

Model estimation/learning is performed by a dedicated expectation conditional maximization (ECM) algorithm by maximizing the observed data log-likelihood. We provide simulated examples to illustrate the use of the model in model-based clustering of heterogeneous regression data and in fitting non-linear regression functions.

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
# Application to a simulated data set

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
#> EM - tMoE: Iteration: 1 | log-likelihood: -492.670213386795
#> EM - tMoE: Iteration: 2 | log-likelihood: -489.915829292061
#> EM - tMoE: Iteration: 3 | log-likelihood: -489.586457591108
#> EM - tMoE: Iteration: 4 | log-likelihood: -489.327446970166
#> EM - tMoE: Iteration: 5 | log-likelihood: -489.081096659076
#> EM - tMoE: Iteration: 6 | log-likelihood: -488.849882479611
#> EM - tMoE: Iteration: 7 | log-likelihood: -488.637398834361
#> EM - tMoE: Iteration: 8 | log-likelihood: -488.446030915537
#> EM - tMoE: Iteration: 9 | log-likelihood: -488.27688295417
#> EM - tMoE: Iteration: 10 | log-likelihood: -488.129922249682
#> EM - tMoE: Iteration: 11 | log-likelihood: -488.004210279862
#> EM - tMoE: Iteration: 12 | log-likelihood: -487.898165292998
#> EM - tMoE: Iteration: 13 | log-likelihood: -487.809814404183
#> EM - tMoE: Iteration: 14 | log-likelihood: -487.737008622155
#> EM - tMoE: Iteration: 15 | log-likelihood: -487.677588822589
#> EM - tMoE: Iteration: 16 | log-likelihood: -487.629501724981
#> EM - tMoE: Iteration: 17 | log-likelihood: -487.590871707835
#> EM - tMoE: Iteration: 18 | log-likelihood: -487.560037395585
#> EM - tMoE: Iteration: 19 | log-likelihood: -487.53556246746
#> EM - tMoE: Iteration: 20 | log-likelihood: -487.516229161562
#> EM - tMoE: Iteration: 21 | log-likelihood: -487.50102131609
#> EM - tMoE: Iteration: 22 | log-likelihood: -487.489102046225
#> EM - tMoE: Iteration: 23 | log-likelihood: -487.479789592736
#> EM - tMoE: Iteration: 24 | log-likelihood: -487.472533616402
#> EM - tMoE: Iteration: 25 | log-likelihood: -487.466893266675
#> EM - tMoE: Iteration: 26 | log-likelihood: -487.46251768769

tmoe$plot()
```

<img src="man/figures/README-unnamed-chunk-6-1.png" style="display: block; margin: auto;" /><img src="man/figures/README-unnamed-chunk-6-2.png" style="display: block; margin: auto;" /><img src="man/figures/README-unnamed-chunk-6-3.png" style="display: block; margin: auto;" /><img src="man/figures/README-unnamed-chunk-6-4.png" style="display: block; margin: auto;" />

``` r
# Application to a real data set

library(MASS)
data("mcycle")
x <- mcycle$times
y <- mcycle$accel

K <- 4 # Number of regressors/experts
p <- 2 # Order of the polynomial regression (regressors/experts)
q <- 1 # Order of the logistic regression (gating network)

n_tries <- 1
max_iter <- 1500
threshold <- 1e-5
verbose <- TRUE
verbose_IRLS <- FALSE

tmoe <- emTMoE(X = x, Y = y, K, p, q, n_tries, max_iter, 
               threshold, verbose, verbose_IRLS)
#> EM - tMoE: Iteration: 1 | log-likelihood: -586.258511424199
#> EM - tMoE: Iteration: 2 | log-likelihood: -580.261916520597
#> EM - tMoE: Iteration: 3 | log-likelihood: -578.265257686099
#> EM - tMoE: Iteration: 4 | log-likelihood: -576.373943484357
#> EM - tMoE: Iteration: 5 | log-likelihood: -572.5828884707
#> EM - tMoE: Iteration: 6 | log-likelihood: -565.334422477621
#> EM - tMoE: Iteration: 7 | log-likelihood: -559.742026243344
#> EM - tMoE: Iteration: 8 | log-likelihood: -557.920165895962
#> EM - tMoE: Iteration: 9 | log-likelihood: -557.026750962574
#> EM - tMoE: Iteration: 10 | log-likelihood: -556.165685195073
#> EM - tMoE: Iteration: 11 | log-likelihood: -555.256178338343
#> EM - tMoE: Iteration: 12 | log-likelihood: -554.27281091465
#> EM - tMoE: Iteration: 13 | log-likelihood: -553.288997408045
#> EM - tMoE: Iteration: 14 | log-likelihood: -552.553612397043
#> EM - tMoE: Iteration: 15 | log-likelihood: -552.119165838412
#> EM - tMoE: Iteration: 16 | log-likelihood: -551.854152331833
#> EM - tMoE: Iteration: 17 | log-likelihood: -551.68382157495
#> EM - tMoE: Iteration: 18 | log-likelihood: -551.573687576638
#> EM - tMoE: Iteration: 19 | log-likelihood: -551.5026355973
#> EM - tMoE: Iteration: 20 | log-likelihood: -551.456762092582
#> EM - tMoE: Iteration: 21 | log-likelihood: -551.427005228698
#> EM - tMoE: Iteration: 22 | log-likelihood: -551.407560381911
#> EM - tMoE: Iteration: 23 | log-likelihood: -551.394734248294
#> EM - tMoE: Iteration: 24 | log-likelihood: -551.386179241115
#> EM - tMoE: Iteration: 25 | log-likelihood: -551.380398961129
#> EM - tMoE: Iteration: 26 | log-likelihood: -551.376435076552

tmoe$plot()
```

<img src="man/figures/README-unnamed-chunk-7-1.png" style="display: block; margin: auto;" /><img src="man/figures/README-unnamed-chunk-7-2.png" style="display: block; margin: auto;" /><img src="man/figures/README-unnamed-chunk-7-3.png" style="display: block; margin: auto;" /><img src="man/figures/README-unnamed-chunk-7-4.png" style="display: block; margin: auto;" />

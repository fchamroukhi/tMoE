
<!-- README.md is generated from README.Rmd. Please edit that file -->

<!-- badges: start -->

<!-- badges: end -->

# Overview

User-friendly and flexible algorithm for modeling, sampling, inference,
and clustering heteregenous data with Robust of Mixture-of-Experts using
the t distribution.

# Installation

You can install the development version of tMoE from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("fchamroukhi/tMoE")
```

To build *vignettes* for examples of usage, type the command below
instead:

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

# Usage

``` r
library(tMoE)
```

``` r
n <- 500 # Size of the sample
K <- 2 # Number of regressors/experts
p <- 1 # Order of the polynomial regression (regressors/experts)
q <- 1 # Order of the logistic regression (gating network)

alphak <- matrix(c(0, 8), ncol = K - 1) # Parameters of the gating network
betak <- matrix(c(0, -2.5, 0, 2.5), ncol = K) # Regression coefficients of the experts
sigmak <- c(0.5, 0.5) # Standard deviations of the experts
nuk <- c(7, 9) # Degrees of freedom of the experts network t densities
x <- seq.int(from = -1, to = 1, length.out = n) # Inputs (predictors)

# Generate sample of size n
sample <- sampleUnivTMoE(alphak = alphak, betak = betak, sigmak = sigmak, 
                         nuk = nuk, x = x)

n_tries <- 1
max_iter <- 1500
threshold <- 1e-5
verbose <- TRUE
verbose_IRLS <- FALSE

tmoe <- emTMoE(x, matrix(sample$y), K, p, q, n_tries, max_iter, 
               threshold, verbose, verbose_IRLS)
#> EM: Iteration: 1 || log-likelihood: -704.913084619143
#> EM: Iteration: 2 || log-likelihood: -445.365402478332
#> EM: Iteration: 3 || log-likelihood: -440.439911621614
#> EM: Iteration: 4 || log-likelihood: -439.353912994085
#> EM: Iteration: 5 || log-likelihood: -439.088995950728
#> EM: Iteration: 6 || log-likelihood: -439.009795023498
#> EM: Iteration: 7 || log-likelihood: -438.976203392572
#> EM: Iteration: 8 || log-likelihood: -438.955677699258
#> EM: Iteration: 9 || log-likelihood: -438.939811235214
#> EM: Iteration: 10 || log-likelihood: -438.926028275246
#> EM: Iteration: 11 || log-likelihood: -438.913342757832
#> EM: Iteration: 12 || log-likelihood: -438.901290841173
#> EM: Iteration: 13 || log-likelihood: -438.889623183283
#> EM: Iteration: 14 || log-likelihood: -438.87819647437
#> EM: Iteration: 15 || log-likelihood: -438.86692590795
#> EM: Iteration: 16 || log-likelihood: -438.855760696599
#> EM: Iteration: 17 || log-likelihood: -438.844670288863
#> EM: Iteration: 18 || log-likelihood: -438.833636289501
#> EM: Iteration: 19 || log-likelihood: -438.822647641349
#> EM: Iteration: 20 || log-likelihood: -438.811697735401
#> EM: Iteration: 21 || log-likelihood: -438.800782668332
#> EM: Iteration: 22 || log-likelihood: -438.789900194073
#> EM: Iteration: 23 || log-likelihood: -438.779049092348
#> EM: Iteration: 24 || log-likelihood: -438.768228788172
#> EM: Iteration: 25 || log-likelihood: -438.757439122581
#> EM: Iteration: 26 || log-likelihood: -438.746680214491
#> EM: Iteration: 27 || log-likelihood: -438.735952377307
#> EM: Iteration: 28 || log-likelihood: -438.725256068451
#> EM: Iteration: 29 || log-likelihood: -438.714591858586
#> EM: Iteration: 30 || log-likelihood: -438.703960412651
#> EM: Iteration: 31 || log-likelihood: -438.693362477882
#> EM: Iteration: 32 || log-likelihood: -438.682798875979
#> EM: Iteration: 33 || log-likelihood: -438.672270497738
#> EM: Iteration: 34 || log-likelihood: -438.661778299077
#> EM: Iteration: 35 || log-likelihood: -438.651323297876
#> EM: Iteration: 36 || log-likelihood: -438.640906571257
#> EM: Iteration: 37 || log-likelihood: -438.630529253093
#> EM: Iteration: 38 || log-likelihood: -438.620192531634
#> EM: Iteration: 39 || log-likelihood: -438.609897647133
#> EM: Iteration: 40 || log-likelihood: -438.599645889507
#> EM: Iteration: 41 || log-likelihood: -438.589438595924
#> EM: Iteration: 42 || log-likelihood: -438.579277148352
#> EM: Iteration: 43 || log-likelihood: -438.569162971063
#> EM: Iteration: 44 || log-likelihood: -438.559097528061
#> EM: Iteration: 45 || log-likelihood: -438.549082320467
#> EM: Iteration: 46 || log-likelihood: -438.539118883835
#> EM: Iteration: 47 || log-likelihood: -438.529208785407
#> EM: Iteration: 48 || log-likelihood: -438.519353621301
#> EM: Iteration: 49 || log-likelihood: -438.509555013687
#> EM: Iteration: 50 || log-likelihood: -438.499814607849
#> EM: Iteration: 51 || log-likelihood: -438.490134069243
#> EM: Iteration: 52 || log-likelihood: -438.480515080491
#> EM: Iteration: 53 || log-likelihood: -438.470959338331
#> EM: Iteration: 54 || log-likelihood: -438.461468550536
#> EM: Iteration: 55 || log-likelihood: -438.45204443279
#> EM: Iteration: 56 || log-likelihood: -438.442688705532
#> EM: Iteration: 57 || log-likelihood: -438.433403090788
#> EM: Iteration: 58 || log-likelihood: -438.424189308976
#> EM: Iteration: 59 || log-likelihood: -438.41504907569
#> EM: Iteration: 60 || log-likelihood: -438.405984098473
#> EM: Iteration: 61 || log-likelihood: -438.396996073618
#> EM: Iteration: 62 || log-likelihood: -438.38808668294
#> EM: Iteration: 63 || log-likelihood: -438.379257590563
#> EM: Iteration: 64 || log-likelihood: -438.370510439752
#> EM: Iteration: 65 || log-likelihood: -438.361846849741
#> EM: Iteration: 66 || log-likelihood: -438.353268412606
#> EM: Iteration: 67 || log-likelihood: -438.344776690188
#> EM: Iteration: 68 || log-likelihood: -438.336373211044
#> EM: Iteration: 69 || log-likelihood: -438.328059467476
#> EM: Iteration: 70 || log-likelihood: -438.319836912606
#> EM: Iteration: 71 || log-likelihood: -438.311706957536
#> EM: Iteration: 72 || log-likelihood: -438.303670968577
#> EM: Iteration: 73 || log-likelihood: -438.29573026458
#> EM: Iteration: 74 || log-likelihood: -438.28788611434
#> EM: Iteration: 75 || log-likelihood: -438.280139734125
#> EM: Iteration: 76 || log-likelihood: -438.2724922853
#> EM: Iteration: 77 || log-likelihood: -438.264944872073
#> EM: Iteration: 78 || log-likelihood: -438.257498539355
#> EM: Iteration: 79 || log-likelihood: -438.250154270767
#> EM: Iteration: 80 || log-likelihood: -438.242912986767
#> EM: Iteration: 81 || log-likelihood: -438.235775542918
#> EM: Iteration: 82 || log-likelihood: -438.228742728305
#> EM: Iteration: 83 || log-likelihood: -438.22181526411
#> EM: Iteration: 84 || log-likelihood: -438.214993802327
#> EM: Iteration: 85 || log-likelihood: -438.208278924639
#> EM: Iteration: 86 || log-likelihood: -438.201671141463
#> EM: Iteration: 87 || log-likelihood: -438.195170891148
#> EM: Iteration: 88 || log-likelihood: -438.188778539346
#> EM: Iteration: 89 || log-likelihood: -438.18249437854
#> EM: Iteration: 90 || log-likelihood: -438.176318627749
#> EM: Iteration: 91 || log-likelihood: -438.170251432388
#> EM: Iteration: 92 || log-likelihood: -438.164292864305
#> EM: Iteration: 93 || log-likelihood: -438.158442921975
#> EM: Iteration: 94 || log-likelihood: -438.152701530862
#> EM: Iteration: 95 || log-likelihood: -438.147068543932
#> EM: Iteration: 96 || log-likelihood: -438.141543742333
#> EM: Iteration: 97 || log-likelihood: -438.136126836227
#> EM: Iteration: 98 || log-likelihood: -438.130817465758
#> EM: Iteration: 99 || log-likelihood: -438.12561520219
#> EM: Iteration: 100 || log-likelihood: -438.120519549154
#> EM: Iteration: 101 || log-likelihood: -438.11552994405
#> EM: Iteration: 102 || log-likelihood: -438.110645759572
#> EM: Iteration: 103 || log-likelihood: -438.105866305346
#> EM: Iteration: 104 || log-likelihood: -438.101190829683
#> EM: Iteration: 105 || log-likelihood: -438.096618521453
#> EM: Iteration: 106 || log-likelihood: -438.092148512037
#> EM: Iteration: 107 || log-likelihood: -438.087779877387

tmoe$plot()
```

<img src="man/figures/README-unnamed-chunk-6-1.png" style="display: block; margin: auto;" /><img src="man/figures/README-unnamed-chunk-6-2.png" style="display: block; margin: auto;" /><img src="man/figures/README-unnamed-chunk-6-3.png" style="display: block; margin: auto;" /><img src="man/figures/README-unnamed-chunk-6-4.png" style="display: block; margin: auto;" />

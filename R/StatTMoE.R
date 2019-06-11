#' @export
StatTMoE <- setRefClass(
  "StatTMoE",
  fields = list(
    piik = "matrix",
    z_ik = "matrix",
    klas = "matrix",
    Wik = "matrix",
    # Ex = "matrix",
    Ey_k = "matrix",
    Ey = "matrix",
    Var_yk = "matrix",
    Vary = "matrix",
    log_lik = "numeric",
    com_loglik = "numeric",
    stored_loglik = "list",
    BIC = "numeric",
    ICL = "numeric",
    AIC = "numeric",
    cpu_time = "numeric",
    log_piik_fik = "matrix",
    log_sum_piik_fik = "matrix",
    tik = "matrix"
  ),
  methods = list(
    initialize = function(paramTMoE = ParamTMoE(fData = FData(numeric(1), matrix(1)), K = 1, p = 2, q = 1)) {
      piik <<- matrix(NA, paramTMoE$fData$n, paramTMoE$K)
      z_ik <<- matrix(NA, paramTMoE$fData$n, paramTMoE$K)
      klas <<- matrix(NA, paramTMoE$fData$n, 1)
      Wik <<- matrix(0, paramTMoE$fData$n * paramTMoE$fData$m, paramTMoE$K)
      Ey_k <<- matrix(NA, paramTMoE$fData$n, paramTMoE$K)
      Ey <<- matrix(NA, paramTMoE$fData$n, 1)
      Var_yk <<- matrix(NA, 1, paramTMoE$K)
      Vary <<- matrix(NA, paramTMoE$fData$n, 1)
      log_lik <<- -Inf
      com_loglik <<- -Inf
      stored_loglik <<- list()
      BIC <<- -Inf
      ICL <<- -Inf
      AIC <<- -Inf
      cpu_time <<- Inf
      log_piik_fik <<- matrix(0, paramTMoE$fData$n, paramTMoE$K)
      log_sum_piik_fik <<- matrix(NA, paramTMoE$fData$n, 1)
      tik <<- matrix(0, paramTMoE$fData$n, paramTMoE$K)
    },

    MAP = function() {
      "
      calcule une partition d'un echantillon par la regle du Maximum A Posteriori ?? partir des probabilites a posteriori
      Entrees : post_probas , Matrice de dimensions [n x K] des probabibiltes a posteriori (matrice de la partition floue)
      n : taille de l'echantillon
      K : nombres de classes
      klas(i) = arg   max (post_probas(i,k)) , for all i=1,...,n
      1<=k<=K
      = arg   max  p(zi=k|xi;theta)
      1<=k<=K
      = arg   max  p(zi=k;theta)p(xi|zi=k;theta)/sum{l=1}^{K}p(zi=l;theta) p(xi|zi=l;theta)
      1<=k<=K
      Sorties : classes : vecteur collones contenant les classe (1:K)
      Z : Matrice de dimension [nxK] de la partition dure : ses elements sont zik, avec zik=1 si xi
      appartient ?? la classe k (au sens du MAP) et zero sinon.
      "
      N <- nrow(piik)
      K <- ncol(piik)
      ikmax <- max.col(piik)
      ikmax <- matrix(ikmax, ncol = 1)
      z_ik <<- ikmax %*% ones(1, K) == ones(N, 1) %*% (1:K) # partition_MAP
      klas <<- ones(N, 1)
      for (k in 1:K) {
        klas[z_ik[, k] == 1] <<- k
      }
    },
    #######
    # compute loglikelihood
    #######
    computeLikelihood = function(reg_irls) {
      log_lik <<- sum(log_sum_piik_fik) + reg_irls

    },
    #######
    #
    #######
    #######
    # compute the final solution stats
    #######
    computeStats = function(paramTMoE, cpu_time_all) {
      cpu_time <<- mean(cpu_time_all)

      # E[yi|zi=k]
      Ey_k <<- paramTMoE$phiBeta$XBeta[1:paramTMoE$fData$n, ] %*% paramTMoE$beta

      # E[yi]
      Ey <<- matrix(apply(piik * Ey_k, 1, sum))

      # Var[yi|zi=k]
      Var_yk <<- paramTMoE$delta/(paramTMoE$delta - 2) * paramTMoE$sigma

      # Var[yi]
      Vary <<- apply(piik * (Ey_k ^ 2 + ones(paramTMoE$fData$n, 1) %*% Var_yk), 1, sum) - Ey ^ 2


      ### BIC AIC et ICL

      BIC <<- log_lik - (paramTMoE$nu * log(paramTMoE$fData$n * paramTMoE$fData$m) / 2)
      AIC <<- log_lik - paramTMoE$nu
      ## CL(theta) : complete-data loglikelihood
      zik_log_piik_fk <- (repmat(z_ik, paramTMoE$fData$m, 1)) * log_piik_fik
      sum_zik_log_fik <- apply(zik_log_piik_fk, 1, sum)
      com_loglik <<- sum(sum_zik_log_fik)

      ICL <<- com_loglik - (paramTMoE$nu * log(paramTMoE$fData$n * paramTMoE$fData$m) / 2)
      # solution.XBeta = XBeta(1:m,:);
      # solution.XAlpha = XAlpha(1:m,:);
    },
    #######
    # EStep
    #######
    EStep = function(paramTMoE) {
      piik <<- multinomialLogit(paramTMoE$alpha, paramTMoE$phiAlpha$XBeta, ones(paramTMoE$fData$n, paramTMoE$K), ones(paramTMoE$fData$n, 1))$piik
      piik_fik <- zeros(paramTMoE$fData$m * paramTMoE$fData$n, paramTMoE$K)

      for (k in (1:paramTMoE$K)) {
        muk <- paramTMoE$phiBeta$XBeta %*% paramTMoE$beta[, k]

        sigma2k <- paramTMoE$sigma[k]
        sigmak <- sqrt(sigma2k)
        dik <- (paramTMoE$fData$Y - muk) / sigmak


        nuk <- paramTMoE$delta[k]
        Wik[,k] <<- (nuk + 1)/(nuk + dik^2)


        # weighted t linear expert likelihood

        piik_fik[, k] <- piik[, k] *  (1/sigmak * dt((paramTMoE$fData$Y - muk)/sigmak, nuk)) #pdf('tlocationscale', y, muk, sigmak, nuk);
      }

      log_piik_fik <<- log(piik_fik)

      log_sum_piik_fik <<- matrix(log(rowSums(piik_fik)))

      tik <<- piik_fik / (rowSums(piik_fik) %*% ones(1, paramTMoE$K))
    }
  )
)

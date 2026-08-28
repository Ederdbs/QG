#!/usr/bin/env Rscript
# =============================================================================
#  maize_wide_cross_sim.R
#
#  Simulacao de um cruzamento amplo (grupos heteroticos divergentes) em milho,
#  conduzido F1 -> F2 -> F3 -> F4 por SSD / bulk / intercruzamento (Syn),
#  para dimensionar o numero de plantas necessario em cada geracao.
#
#  Autor: gerado para dimensionamento de populacao em pre-melhoramento.
#  Dependencias: NENHUMA (base R >= 3.6). Graficos em base graphics.
#
#  Uso:
#    Rscript maize_wide_cross_sim.R              # roda o experimento completo
#    Rscript maize_wide_cross_sim.R --quick      # versao rapida (3 repeticoes)
#    Rscript maize_wide_cross_sim.R --test       # apenas a bateria de testes
#    Rscript maize_wide_cross_sim.R --out=DIR    # diretorio de saida
#
# =============================================================================
#  PASSO A PASSO DAS PREMISSAS (leia antes de confiar em qualquer numero)
# =============================================================================
#
#  P1. ESPACO SIMULADO = ANCESTRALIDADE, NAO ALELOS.
#      Cada posicao do genoma e codificada como 0 (vem do parental P1) ou
#      1 (vem do parental P2). Isso e o correto para um cruzamento biparental
#      amplo: como os dois parentais sao de grupos heteroticos distintos,
#      praticamente todo locus polimorfico entre eles e biallelico e a
#      ancestralidade e uma estatistica suficiente. "Frequencia alelica" no
#      script sempre significa "frequencia de ancestralidade P1".
#
#  P2. PARENTAIS 100% HOMOZIGOTOS E FIXADOS PARA ALELOS ALTERNATIVOS.
#      Consequencia: TODAS as plantas F1 sao geneticamente identicas e o
#      Ne genetico da F1 e 1. O dimensionamento da F1 e portanto logistico,
#      nao genetico -- ver a funcao f1_sizing() para o caso realista de
#      heterozigose residual nos parentais (F ~ 0.95).
#
#  P3. MAPA GENETICO. 10 cromossomos, comprimentos aproximados de um mapa
#      composto classico de milho (total ~1670 cM ~ 17 Morgans). NAO use
#      comprimentos de mapas tipo IBM (RILs intermatadas), que sao inflados
#      ~5-10x por construcao. Os comprimentos sao parametrizaveis em
#      DEFAULT_CHR_LEN. Marcadores em grade regular (default 2 cM).
#
#  P4. RECOMBINACAO: MODELO DE HALDANE, SEM INTERFERENCIA.
#      A probabilidade de troca de haplotipo entre marcadores adjacentes
#      separados por d cM e r = 0.5*(1 - exp(-2d/100)). O primeiro marcador
#      de cada cromossomo recebe r = 0.5, o que produz segregacao
#      independente entre cromossomos automaticamente.
#      LIMITACAO: sem interferencia, a variancia do numero de crossovers e
#      inflada (Poisson). Em milho ha interferencia positiva forte; o efeito
#      pratico e que a distribuicao de comprimento de blocos simulada tem
#      cauda um pouco mais longa que a real. As MEDIAS de comprimento de
#      bloco e as frequencias alelicas nao sao afetadas.
#      LIMITACAO: recombinacao identica em macho e femea (em milho ha
#      heteroquiasmia moderada). Nao afeta as conclusoes de dimensionamento.
#
#  P5. DISTORCAO DE SEGREGACAO. Dois mecanismos, ambos por amostragem por
#      rejeicao (portanto exatos, nao aproximacoes):
#        (a) GAMETOFITICA (tipo ga1/Ga1-s, incompatibilidade de polen):
#            atua SO no gameta masculino. Parametro k = probabilidade de
#            transmissao do alelo P1 por um heterozigoto (k=0.5 -> neutro).
#            Como a rejeicao atua sobre o gameta INTEIRO, a regiao ligada ao
#            distorcedor e arrastada junto -- que e exatamente o fenomeno
#            que queremos ver.
#        (b) ZIGOTICA (letalidade/subvitalidade de hibrido): fitness
#            (w00, w01, w11) por genotipo no locus.
#      Os locus default sao PLAUSIVEIS, nao medidos: bin 4.05 (ga1),
#      bin 1.10 e bin 5.03. Substitua pelos seus se voce tiver dados de
#      genotipagem da F2.
#
#  P6. ESQUEMAS DE CONDUCAO.
#        ssd        : 1 semente por planta por geracao. Sem selecao, sem
#                     deriva alem da meiotica. Referencia neutra.
#        ssd_attr   : SSD com perda aleatoria de plantas por geracao
#                     (default 15%): vigor, esterilidade parcial,
#                     assincronia de florescimento -- comum em cruzamento
#                     amplo com material exotico.
#        bulk       : contribuicao diferencial de sementes. Modelo Wright-
#                     Fisher com pesos w_i = exp(beta*(z_i - z_bar)), onde
#                     z_i = proporcao do genoma vinda de P1 (o parental
#                     adaptado). E um modelo FENOMENOLOGICO de selecao
#                     natural poligenica, nao um modelo de loci de adaptacao.
#                     beta = 6 no default corresponde a uma pressao moderada.
#        syn1/syn2  : 1 ou 2 ciclos de intercruzamento aleatorio na F2
#                     (polen composto, cruzamentos par-a-par aleatorios sem
#                     autofecundacao) ANTES de autofecundar duas vezes.
#                     Tamanho do painel mantido constante para comparabilidade.
#      Em todos os esquemas o painel final tem H = 0.125 (2 autofecundacoes
#      apos o estado F2-equivalente), logo sao diretamente comparaveis.
#
#  P7. O PAINEL F4 NAO E UM PAINEL DE RILs. A heterozigose residual esperada
#      e H = 0.125. Isso muda as expectativas teoricas:
#        Var(dosagem por linha) = (1 - H)/4
#        Var(p_hat)             = (1 - H)/(4N)
#        EP(p_hat)              = 0.5*sqrt((1-H)/N)  = 0.468/sqrt(N) na F4
#                                 (o valor 0.5/sqrt(N) so vale em F_infinito)
#        Diversidade retida D   = 1 - (1-H)/N        = 1 - 0.875/N na F4
#      Todas essas identidades sao verificadas em run_tests().
#
#  P8. METRICAS.
#        D (diversidade retida) = mean(2 p (1-p)) / 0.5, sobre marcadores.
#           E a diversidade genica de Nei do painel relativa ao maximo
#           possivel (p = 0.5 em todo o genoma).
#        EP(p_hat): estimado como o desvio-padrao ENTRE REPETICOES por
#           marcador, e nao entre marcadores dentro de uma repeticao. Isso e
#           essencial: marcadores ligados sao fortemente autocorrelacionados
#           e o desvio entre marcadores nao e um estimador do erro amostral.
#        Fracao fixada: proporcao de marcadores com p < 0.05 ou p > 0.95.
#        Bloco parental: comprimento em cM de segmentos contiguos de mesma
#           ancestralidade, com fronteiras no ponto medio entre marcadores.
#        Recuperacao multilocus: P(pelo menos 1 linha do painel homozigota
#           P2 em k loci escolhidos ao acaso, 1 por cromossomo).
#
#  P9. O QUE O SCRIPT **NAO** MODELA (e portanto nao responda com ele):
#      - selecao artificial deliberada (o objetivo aqui e diversidade retida);
#      - efeitos de QTL / arquitetura de caracteres quantitativos;
#      - depressao por endogamia no sentido fenotipico;
#      - mutacao (irrelevante nesta escala de tempo);
#      - variacao estrutural / inversoes entre grupos heteroticos, que
#        suprimem recombinacao localmente. Se voce sabe que existe uma
#        inversao grande entre seus parentais, zere a taxa de recombinacao
#        naquele intervalo em build_map().
#
# =============================================================================

# ----------------------------------------------------------------------------
# 1. CONFIGURACAO PADRAO
# ----------------------------------------------------------------------------

DEFAULT_CHR_LEN <- c(240, 200, 190, 180, 175, 150, 145, 140, 130, 120)  # cM

DEFAULT_DISTORTERS <- data.frame(
  chr    = c(4,          1,         5),
  pos_cM = c(75,         160,       60),
  type   = c("gametic",  "zygotic", "gametic"),
  k      = c(0.80,       NA,        0.68),   # transmissao do alelo P1 (macho)
  w00    = c(NA,         1.00,      NA),     # fitness P1P1
  w01    = c(NA,         1.00,      NA),     # fitness heterozigoto
  w11    = c(NA,         0.45,      NA),     # fitness P2P2 (subvital)
  label  = c("ga1-like (4.05)", "letal parcial (1.10)", "gam. fraco (5.03)"),
  stringsAsFactors = FALSE
)

DEFAULT_OPT <- list(
  spacing_cM   = 2,
  n_grid       = seq(10, 400, by = 20),
  schemes      = c("ssd", "ssd_attr", "bulk", "syn1", "syn2"),
  n_rep        = 10,     # repeticoes de referencia (em N grande)
  rep_max_mult = 4,      # teto de repeticoes = n_rep * rep_max_mult
  rep_pivot    = 200,    # N em que reps == n_rep
  attrition    = 0.15,   # usado apenas em ssd_attr
  beta_bulk    = 6,      # intensidade da selecao natural no bulk
  k_multilocus = c(3, 5, 8, 10),
  n_ref_block  = 300,    # N usado para blocos / genotipo grafico
  n_ref_small  = 20,     # N pequeno de referencia para contraste
  n_block_lines = 40,
  seed         = 20260828
)

# ----------------------------------------------------------------------------
# 2. MAPA GENETICO
# ----------------------------------------------------------------------------

build_map <- function(chr_len_cM = DEFAULT_CHR_LEN, spacing_cM = 2) {
  chr <- integer(0); pos <- numeric(0)
  for (i in seq_along(chr_len_cM)) {
    p <- seq(0, chr_len_cM[i], by = spacing_cM)
    if (p[length(p)] < chr_len_cM[i] - 1e-9) p <- c(p, chr_len_cM[i])
    chr <- c(chr, rep.int(i, length(p)))
    pos <- c(pos, p)
  }
  m <- length(pos)
  first <- c(TRUE, chr[-1] != chr[-m])
  d <- c(0, diff(pos))
  r <- ifelse(first, 0.5, 0.5 * (1 - exp(-2 * d / 100)))

  # fronteiras (ponto medio) para converter runs de marcadores em cM
  edges <- vector("list", length(chr_len_cM))
  for (i in seq_along(chr_len_cM)) {
    p <- pos[chr == i]
    edges[[i]] <- c(0, (p[-1] + p[-length(p)]) / 2, chr_len_cM[i])
  }

  list(chr = chr, pos = pos, r = r, m = m, first = first,
       chr_len = chr_len_cM, total_cM = sum(chr_len_cM), edges = edges,
       spacing = spacing_cM)
}

# indice do marcador mais proximo de (cromossomo, posicao)
marker_index <- function(map, chr, pos_cM) {
  w <- which(map$chr == chr)
  w[which.min(abs(map$pos[w] - pos_cM))]
}

# ----------------------------------------------------------------------------
# 3. MOTOR DE MEIOSE (vetorizado)
# ----------------------------------------------------------------------------

# soma cumulativa por coluna, sem apply (gargalo de performance)
col_cumsum <- function(M) {
  m <- nrow(M); n <- ncol(M)
  cv <- cumsum(M); dim(cv) <- c(m, n)
  if (n > 1) cv <- cv - rep(c(0, cv[m, 1:(n - 1)]), each = m)
  cv
}

# Uma meiose por individuo (coluna). Retorna matriz m x n de gametas.
# O caminho de ancestralidade e uma cadeia de Markov ao longo dos marcadores:
# troca de haplotipo parental com probabilidade r[j] no intervalo j.
meiosis <- function(H1, H2, r) {
  m <- nrow(H1); n <- ncol(H1)
  if (n == 0) return(H1)
  sw <- runif(m * n) < r          # r tem comprimento m, reciclado por coluna
  dim(sw) <- c(m, n)
  path <- col_cumsum(sw) %% 2     # 0 -> usa H1, 1 -> usa H2
  H1 * (1 - path) + H2 * path
}

# Meiose com selecao gametofitica (amostragem por rejeicao no gameta inteiro)
meiosis_sel <- function(H1, H2, map, dist, max_try = 60) {
  n <- ncol(H1)
  if (n == 0) return(H1)
  if (length(dist$gam_idx) == 0) return(meiosis(H1, H2, map$r))
  out  <- matrix(NA_real_, nrow(H1), n)
  need <- seq_len(n); tries <- 0
  while (length(need) > 0 && tries < max_try) {
    G  <- meiosis(H1[, need, drop = FALSE], H2[, need, drop = FALSE], map$r)
    wt <- rep(1, length(need))
    for (j in seq_along(dist$gam_idx)) {
      a  <- G[dist$gam_idx[j], ]
      wt <- wt * ((1 - a) * dist$gam_w0[j] + a * dist$gam_w1[j])
    }
    acc <- runif(length(need)) < wt
    if (any(acc)) {
      out[, need[acc]] <- G[, acc, drop = FALSE]
      need <- need[!acc]
    }
    tries <- tries + 1
  }
  if (length(need) > 0)  # fallback: aceita sem selecao (evita loop infinito)
    out[, need] <- meiosis(H1[, need, drop = FALSE], H2[, need, drop = FALSE], map$r)
  out
}

# fitness zigotica dos descendentes propostos
zyg_fitness <- function(Gf, Gm, dist) {
  n <- ncol(Gf)
  w <- rep(1, n)
  if (length(dist$zyg_idx) == 0) return(w)
  for (j in seq_along(dist$zyg_idx)) {
    g <- Gf[dist$zyg_idx[j], ] + Gm[dist$zyg_idx[j], ]   # 0,1,2 doses de P2
    w <- w * ifelse(g == 0, dist$zyg_w[j, 1],
             ifelse(g == 1, dist$zyg_w[j, 2], dist$zyg_w[j, 3]))
  }
  w
}

# Cruzamento generico. mo/fa sao vetores de indices de coluna (mo==fa -> autofec.)
cross_indices <- function(pop, mo, fa, map, dist, max_try = 60) {
  n <- length(mo); m <- map$m
  H1 <- matrix(NA_real_, m, n); H2 <- matrix(NA_real_, m, n)
  need <- seq_len(n); tries <- 0
  while (length(need) > 0 && tries < max_try) {
    i  <- need
    gf <- meiosis(pop$H1[, mo[i], drop = FALSE], pop$H2[, mo[i], drop = FALSE], map$r)
    gm <- meiosis_sel(pop$H1[, fa[i], drop = FALSE], pop$H2[, fa[i], drop = FALSE], map, dist)
    acc <- runif(length(i)) < zyg_fitness(gf, gm, dist)
    if (any(acc)) {
      H1[, i[acc]] <- gf[, acc, drop = FALSE]
      H2[, i[acc]] <- gm[, acc, drop = FALSE]
      need <- need[!acc]
    }
    tries <- tries + 1
  }
  if (length(need) > 0) {
    gf <- meiosis(pop$H1[, mo[need], drop = FALSE], pop$H2[, mo[need], drop = FALSE], map$r)
    gm <- meiosis_sel(pop$H1[, fa[need], drop = FALSE], pop$H2[, fa[need], drop = FALSE], map, dist)
    H1[, need] <- gf; H2[, need] <- gm
  }
  list(H1 = H1, H2 = H2)
}

make_F1 <- function(map, n) {
  list(H1 = matrix(0, map$m, n), H2 = matrix(1, map$m, n))
}

# ----------------------------------------------------------------------------
# 4. DISTORCAO DE SEGREGACAO
# ----------------------------------------------------------------------------

make_distortion <- function(map, spec = DEFAULT_DISTORTERS, active = TRUE) {
  out <- list(gam_idx = integer(0), gam_w0 = numeric(0), gam_w1 = numeric(0),
              zyg_idx = integer(0), zyg_w = matrix(numeric(0), 0, 3),
              spec = if (active) spec else spec[0, , drop = FALSE])
  if (!active || is.null(spec) || nrow(spec) == 0) return(out)
  for (i in seq_len(nrow(spec))) {
    idx <- marker_index(map, spec$chr[i], spec$pos_cM[i])
    if (spec$type[i] == "gametic") {
      k  <- spec$k[i]
      w  <- c(k, 1 - k); w <- w / max(w)   # escala para que max = 1
      out$gam_idx <- c(out$gam_idx, idx)
      out$gam_w0  <- c(out$gam_w0, w[1])   # gameta com ancestralidade P1 (=0)
      out$gam_w1  <- c(out$gam_w1, w[2])
    } else {
      w <- c(spec$w00[i], spec$w01[i], spec$w11[i]); w <- w / max(w)
      out$zyg_idx <- c(out$zyg_idx, idx)
      out$zyg_w   <- rbind(out$zyg_w, w)
    }
  }
  out
}

# ----------------------------------------------------------------------------
# 5. ESQUEMAS DE CONDUCAO
# ----------------------------------------------------------------------------

# Repeticoes por ponto da grade. O custo de uma repeticao e ~proporcional a N,
# entao gastar mais repeticoes em N pequeno e quase de graca -- e e exatamente
# onde a variancia entre repeticoes e maior. Isso da curvas suaves na faixa
# pequena sem multiplicar o tempo total.
reps_for_N <- function(N, opt) {
  pmin(opt$n_rep * opt$rep_max_mult,
       pmax(opt$n_rep, round(opt$n_rep * opt$rep_pivot / N)))
}

bulk_weights <- function(pop, beta) {
  z <- 1 - colMeans((pop$H1 + pop$H2) / 2)  # proporcao do genoma vinda de P1
  w <- exp(beta * (z - mean(z)))
  w / sum(w)
}

# Retorna o painel F4 (ou equivalente) e o tamanho efetivo de painel final.
run_scheme <- function(scheme, n_F2, map, dist, opt = DEFAULT_OPT) {
  F1  <- make_F1(map, n_F2)
  pop <- cross_indices(F1, seq_len(n_F2), seq_len(n_F2), map, dist)  # F2

  if (scheme %in% c("syn1", "syn2")) {
    n_syn <- as.integer(sub("syn", "", scheme))
    for (cy in seq_len(n_syn)) {
      n  <- ncol(pop$H1)
      mo <- sample.int(n); fa <- sample.int(n)
      bad <- mo == fa
      if (any(bad)) fa[bad] <- (fa[bad] %% n) + 1L      # evita autofecundacao
      pop <- cross_indices(pop, mo, fa, map, dist)
    }
  }

  for (g in 1:2) {                      # duas autofecundacoes -> H = 0.125
    n <- ncol(pop$H1)
    if (scheme == "bulk") {
      idx <- sample.int(n, n, replace = TRUE, prob = bulk_weights(pop, opt$beta_bulk))
    } else {
      idx <- seq_len(n)
    }
    pop <- cross_indices(pop, idx, idx, map, dist)
    if (scheme == "ssd_attr") {
      keep <- which(runif(ncol(pop$H1)) > opt$attrition)
      if (length(keep) < 2) keep <- 1:2
      pop <- list(H1 = pop$H1[, keep, drop = FALSE],
                  H2 = pop$H2[, keep, drop = FALSE])
    }
  }
  pop
}

# ----------------------------------------------------------------------------
# 6. METRICAS
# ----------------------------------------------------------------------------

# ATENCAO: a codificacao interna e 0 = P1, 1 = P2. panel_freq retorna a
# frequencia de ancestralidade *P1*, portanto 1 - dosagem media.
panel_freq <- function(pop) 1 - rowMeans((pop$H1 + pop$H2) / 2)

panel_het <- function(pop) mean(pop$H1 != pop$H2)

diversity_retained <- function(p) mean(2 * p * (1 - p)) / 0.5

fixed_fraction <- function(p, thr = 0.10) mean(p < thr | p > 1 - thr)

# fracao do genoma com ancestralidade substancialmente desviada de 0.5
skew_fraction <- function(p, thr = 0.15) mean(abs(p - 0.5) > thr)

# Ancestralidade minoritaria minima no genoma inteiro: quao perto o painel
# chegou de perder completamente uma regiao. Metrica-chave em N pequeno.
min_minor_freq <- function(p) min(pmin(p, 1 - p))

# "N equivalente" do painel: quantas linhas F4 SEM distorcao dariam a mesma
# diversidade retida observada.  D = 1 - (1-H)/N  =>  N_eq = (1-H)/(1-D).
# APROXIMACAO -- e um artificio de comunicacao, NAO um Ne no sentido de
# Wright: converte um vies deterministico (distorcao) em um equivalente de
# deriva. Use para comparar cenarios, nunca como parametro em formula de Ne.
n_equivalent <- function(D, H = 0.125) (1 - H) / pmax(1 - D, 1e-9)

# comprimento (cM) dos blocos de ancestralidade parental
block_lengths <- function(pop, map, n_lines = 40) {
  n   <- ncol(pop$H1)
  sel <- if (n <= n_lines) seq_len(n) else sample.int(n, n_lines)
  res <- list(); z <- 1L
  for (i in sel) for (h in 1:2) {
    hap <- if (h == 1) pop$H1[, i] else pop$H2[, i]
    for (cc in seq_along(map$chr_len)) {
      k  <- which(map$chr == cc)
      rr <- rle(hap[k])
      en <- cumsum(rr$lengths)
      st <- c(1L, head(en, -1) + 1L)
      e  <- map$edges[[cc]]
      res[[z]] <- e[en + 1] - e[st]; z <- z + 1L
    }
  }
  unlist(res)
}

# numero medio de junctions por haplotipo (para checar expansao de mapa)
junctions_per_hap <- function(pop, map, n_lines = 40) {
  n   <- ncol(pop$H1)
  sel <- if (n <= n_lines) seq_len(n) else sample.int(n, n_lines)
  tot <- 0; cnt <- 0
  for (i in sel) for (h in 1:2) {
    hap <- if (h == 1) pop$H1[, i] else pop$H2[, i]
    ch  <- sum(hap[-1] != hap[-length(hap)] & !map$first[-1])
    tot <- tot + ch; cnt <- cnt + 1
  }
  tot / cnt
}

# Expectativa teorica de junctions por haplotipo e de bloco medio.
# Recursao (teoria de junctions): A_{t+1} = A_t + L*H_t, onde L = comprimento
# do mapa em Morgans e H_t = heterozigose do parental. Autofecundacao faz
# H -> H/2; intercruzamento aleatorio mantem H.
# Consequencia importante: cada ciclo de Syn adiciona apenas 0.5*L junctions
# (nao 1.0*L), porque a meiose extra so cria junction onde o parental e
# heterozigoto (H = 0.5 no estagio F2/Syn).
expected_junctions <- function(scheme, map) {
  L <- map$total_cM / 100
  A <- L; H <- 0.5                       # individuo F2
  n_syn <- if (grepl("^syn", scheme)) as.integer(sub("syn", "", scheme)) else 0
  for (i in seq_len(n_syn)) A <- A + L * H          # H inalterado
  for (i in 1:2) { A <- A + L * H; H <- H / 2 }     # duas autofecundacoes
  c(junctions = A, bloco_medio_cM = map$total_cM / (A + length(map$chr_len)))
}

# P(pelo menos uma linha homozigota P2 em k loci, 1 por cromossomo)
multilocus_recovery <- function(pop, map, k, n_draw = 300) {
  chrs_all <- seq_along(map$chr_len)
  hit <- 0
  for (d in seq_len(n_draw)) {
    cs  <- sample(chrs_all, k, replace = k > length(chrs_all))
    idx <- vapply(cs, function(cc) {
      w <- which(map$chr == cc); w[sample.int(length(w), 1)]
    }, integer(1))
    ok <- colSums(pop$H1[idx, , drop = FALSE] == 1 &
                  pop$H2[idx, , drop = FALSE] == 1) == k
    hit <- hit + any(ok)
  }
  hit / n_draw
}

# ----------------------------------------------------------------------------
# 7. DIMENSIONAMENTO DA F1 (modulo analitico separado -- ver premissa P2)
# ----------------------------------------------------------------------------
# Se os parentais nao sao 100% homozigotos (F real ~0.95 e comum em linhagens
# de programa), cada parental segrega em uma fracao h_res dos locus. Cada
# planta F1 recebe um gameta ao acaso de cada parental, entao num locus
# segregante a chance de perder um dos dois alelos parentais com n plantas F1
# e 2*(1/2)^n. Numero esperado de locus segregantes perdidos:
f1_sizing <- function(n_F1 = 1:30, h_res = 0.05, n_loci_eff = 5000) {
  data.frame(
    n_F1 = n_F1,
    p_perda_por_locus = 2 * 0.5^n_F1,
    locus_perdidos_esp = h_res * n_loci_eff * 2 * 0.5^n_F1
  )
}

# ----------------------------------------------------------------------------
# 8. EXPERIMENTO
# ----------------------------------------------------------------------------

run_experiment <- function(opt = DEFAULT_OPT, verbose = TRUE) {
  set.seed(opt$seed)
  map  <- build_map(DEFAULT_CHR_LEN, opt$spacing_cM)
  dist <- make_distortion(map, DEFAULT_DISTORTERS, active = TRUE)
  distN <- make_distortion(map, NULL, active = FALSE)   # cenario neutro

  n_ref  <- opt$n_grid[which.min(abs(opt$n_grid - opt$n_ref_block))]
  n_sml  <- opt$n_grid[which.min(abs(opt$n_grid - opt$n_ref_small))]
  rows   <- list(); z <- 1L
  pmat   <- list()   # p por marcador x repeticao, para EP correto
  blocks <- list()   # distribuicao de blocos (N de referencia)
  example <- list()  # populacoes-exemplo para o genotipo grafico
  ml     <- list()

  for (sch in opt$schemes) {
    for (N in opt$n_grid) {
      nrep <- reps_for_N(N, opt)
      P <- matrix(NA_real_, map$m, nrep)
      acc <- list()
      for (rep in seq_len(nrep)) {
        pop <- run_scheme(sch, N, map, dist, opt)
        p   <- panel_freq(pop)
        P[, rep] <- p
        acc[[rep]] <- c(
          div     = diversity_retained(p),
          fixed   = fixed_fraction(p),
          skew    = skew_fraction(p),
          pmin    = min_minor_freq(p),
          het     = panel_het(pop),
          n_final = ncol(pop$H1),
          junc    = junctions_per_hap(pop, map, 20)
        )
        if (rep == 1 && N == n_ref) {
          blocks[[sch]] <- block_lengths(pop, map, opt$n_block_lines)
        }
        if (rep == 1 && N %in% c(n_ref, n_sml)) {
          kk <- 1:min(30, ncol(pop$H1))
          example[[paste(sch, N)]] <- list(H1 = pop$H1[, kk, drop = FALSE],
                                           H2 = pop$H2[, kk, drop = FALSE])
        }
        if (rep == 1 && sch == "ssd") {
          for (kk in opt$k_multilocus)
            ml[[paste(N, kk)]] <- data.frame(N = N, k = kk,
                                             P = multilocus_recovery(pop, map, kk))
        }
      }
      A <- do.call(rbind, acc)
      se_p <- mean(apply(P, 1, sd))         # EP correto: entre repeticoes
      rows[[z]] <- data.frame(
        scheme = sch, N = N, n_rep = nrep,
        div = mean(A[, "div"]),   div_sd = sd(A[, "div"]),
        fixed = mean(A[, "fixed"]), skew = mean(A[, "skew"]),
        pmin = mean(A[, "pmin"]), pmin_sd = sd(A[, "pmin"]),
        het = mean(A[, "het"]),
        n_final = mean(A[, "n_final"]),
        junc = mean(A[, "junc"]),
        se_p = se_p,
        n_eq = n_equivalent(mean(A[, "div"]))
      ); z <- z + 1L
      pmat[[paste(sch, N)]] <- rowMeans(P)
      if (verbose) cat(sprintf("  %-9s N=%-3d r=%-2d  D=%.4f  N_eq=%5.0f  EP(p)=%.4f  min(minor)=%.3f\n",
                               sch, N, nrep, mean(A[, "div"]), n_equivalent(mean(A[, "div"])),
                               se_p, mean(A[, "pmin"])))
    }
  }
  list(res = do.call(rbind, rows), map = map, dist = dist, n_ref = n_ref,
       n_sml = n_sml, pmat = pmat, blocks = blocks, example = example,
       ml = do.call(rbind, ml), opt = opt)
}

# ----------------------------------------------------------------------------
# 9. GRAFICOS  (cada figura e uma closure, renderizada em PDF e PNG)
# ----------------------------------------------------------------------------

SCH_COL <- c(ssd = "#1b6ca8", ssd_attr = "#7fb3d5", bulk = "#c0392b",
             syn1 = "#27ae60", syn2 = "#145a32")
SCH_LAB <- c(ssd = "SSD (neutro)", ssd_attr = "SSD + 15% atrito/ger.",
             bulk = "Bulk (selecao natural)", syn1 = "Syn-1 + SSD",
             syn2 = "Syn-2 + SSD")
H_F4 <- 0.125

build_figures <- function(E) {
  res <- E$res; map <- E$map; opt <- E$opt
  schs <- unique(res$scheme)
  nn <- seq(min(opt$n_grid), max(opt$n_grid), length.out = 400)
  ax <- function() axis(1, at = seq(0, max(opt$n_grid), by = 40))
  lg <- function(pos, extra = NULL, extra_lty = 2)
    legend(pos, c(SCH_LAB[schs], extra), col = c(SCH_COL[schs], rep("grey30", length(extra))),
           lty = c(rep(1, length(schs)), rep(extra_lty, length(extra))), lwd = 2,
           bty = "n", cex = 0.8)
  F <- list()

  F$fig1 <- list(w = 9.5, h = 6.2, title = "Fig 1. Diversidade genica retida no painel F4",
    cap = paste("Diversidade retida D = mean(2p(1-p))/0.5, onde p e a frequencia de",
      "ancestralidade P1 por marcador. A linha tracejada e a expectativa teorica",
      "1-(1-H)/N para um painel neutro com heterozigose residual H = 0.125.",
      "A distancia entre cada curva e a teorica e o custo da distorcao de segregacao",
      "(nas curvas SSD) ou da distorcao + selecao natural (bulk)."),
    f = function() {
      par(mar = c(4.6, 4.8, 3.2, 1.4))
      plot(NA, xlim = c(0, max(opt$n_grid)), ylim = c(min(res$div) - 0.01, 1.001),
           xaxt = "n", xlab = "Numero de plantas F2",
           ylab = "Diversidade retida  D", main = "")
      ax(); grid(col = "grey92", lty = 1)
      lines(nn, 1 - (1 - H_F4) / nn, lty = 2, col = "grey30", lwd = 2)
      for (s in schs) { d <- res[res$scheme == s, ]
        arrows(d$N, d$div - d$div_sd, d$N, d$div + d$div_sd, angle = 90, code = 3,
               length = 0.02, col = SCH_COL[s])
        lines(d$N, d$div, col = SCH_COL[s], lwd = 2.2, type = "b", pch = 19, cex = 0.7) }
      lg("bottomright", "teorico 1-(1-H)/N")
    })

  F$fig2 <- list(w = 9.5, h = 6.2, title = "Fig 2. Precisao da frequencia alelica do painel",
    cap = paste("Erro-padrao de p estimado ENTRE repeticoes independentes da simulacao,",
      "marcador a marcador. Nao use o desvio entre marcadores dentro de uma unica",
      "repeticao: marcadores ligados sao fortemente autocorrelacionados. A linha",
      "tracejada e 0.5*sqrt((1-H)/N) = 0.468/sqrt(N) na F4."),
    f = function() {
      par(mar = c(4.6, 4.8, 3.2, 1.4))
      plot(NA, xlim = range(opt$n_grid), ylim = range(res$se_p) * c(0.85, 1.12),
           log = "xy", xlab = "Numero de plantas F2 (log)",
           ylab = "EP( freq. de ancestralidade )", main = "")
      grid(col = "grey92", lty = 1, equilogs = FALSE)
      lines(nn, 0.5 * sqrt((1 - H_F4) / nn), lty = 2, col = "grey30", lwd = 2)
      for (s in schs) { d <- res[res$scheme == s, ]
        lines(d$N, d$se_p, col = SCH_COL[s], lwd = 2.2, type = "b", pch = 19, cex = 0.7) }
      lg("topright", "teorico 0.468/sqrt(N)")
    })

  F$fig3 <- list(w = 11, h = 6.4, title = "Fig 3. Perfil de ancestralidade ao longo do genoma",
    cap = paste("Frequencia de ancestralidade P1 marcador a marcador, media de 10",
      "repeticoes, esquema SSD. Os picos coincidem com os distorcedores e tem a MESMA",
      "altura em N pequeno e N grande: a distorcao e um vies deterministico, nao some",
      "com mais plantas. O que muda com N e a amplitude do ruido em volta de 0.5."),
    f = function() {
      par(mar = c(4.4, 4.8, 3.2, 1.2))
      Nlo <- E$n_sml; Nhi <- max(opt$n_grid)
      off <- c(0, cumsum(map$chr_len)[-length(map$chr_len)]) + (seq_along(map$chr_len) - 1) * 25
      x <- map$pos + off[map$chr]
      plot(NA, xlim = range(x), ylim = c(0, 1), xaxt = "n",
           xlab = "Genoma (cromossomos 1-10)", ylab = "Frequencia de ancestralidade P1", main = "")
      rect(par("usr")[1], 0.45, par("usr")[2], 0.55, col = "#f0f0f0", border = NA)
      abline(h = 0.5, col = "grey55", lty = 2)
      for (i in seq_along(map$chr_len))
        axis(1, at = off[i] + map$chr_len[i] / 2, labels = i, tick = FALSE)
      for (i in seq_along(map$chr_len)) { k <- map$chr == i
        lines(x[k], E$pmat[[paste("ssd", Nlo)]][k], col = "#e67e22", lwd = 1.4)
        lines(x[k], E$pmat[[paste("ssd", Nhi)]][k], col = "#1b6ca8", lwd = 2.0) }
      sp <- E$dist$spec
      for (i in seq_len(nrow(sp))) { xx <- sp$pos_cM[i] + off[sp$chr[i]]
        abline(v = xx, col = "#c0392b", lty = 3)
        text(xx, 0.04, sp$label[i], srt = 90, adj = c(0, -0.3), cex = 0.62, col = "#c0392b") }
      legend("topleft", c(paste("N =", Nlo), paste("N =", Nhi), "distorcedor"),
             col = c("#e67e22", "#1b6ca8", "#c0392b"), lty = c(1, 1, 3), lwd = 2,
             bty = "n", cex = 0.82, horiz = TRUE)
    })

  F$fig4 <- list(w = 11.5, h = 5.6, multi = TRUE, title = "Fig 4. Regioes do genoma em risco",
    cap = paste("Esquerda: fracao do genoma com ancestralidade desbalanceada",
      "(|p-0.5| > 0.15). Direita: a frequencia MINORITARIA MINIMA observada em todo o",
      "genoma -- o ponto do genoma mais proximo de ser perdido. Essa segunda metrica e",
      "a que realmente discrimina populacoes pequenas: com N = 20 existe sempre alguma",
      "regiao do genoma em que uma das ancestralidades esta abaixo de 10-15%."),
    f = function() {
      par(mfrow = c(1, 2), mar = c(4.6, 4.8, 3.4, 1.2))
      plot(NA, xlim = c(0, max(opt$n_grid)), ylim = c(0, max(res$skew) * 1.15), xaxt = "n",
           xlab = "Numero de plantas F2", ylab = "fracao com |p - 0.5| > 0.15",
           main = "4a. Genoma desbalanceado"); ax(); grid(col = "grey92", lty = 1)
      for (s in schs) { d <- res[res$scheme == s, ]
        lines(d$N, d$skew, col = SCH_COL[s], lwd = 2.2, type = "b", pch = 19, cex = 0.7) }
      lg("topright")
      plot(NA, xlim = c(0, max(opt$n_grid)), ylim = c(0, max(res$pmin) * 1.15), xaxt = "n",
           xlab = "Numero de plantas F2", ylab = "min( p , 1-p ) no genoma inteiro",
           main = "4b. Regiao mais proxima de ser perdida"); ax(); grid(col = "grey92", lty = 1)
      abline(h = 0.10, col = "grey50", lty = 3)
      for (s in schs) { d <- res[res$scheme == s, ]
        lines(d$N, d$pmin, col = SCH_COL[s], lwd = 2.2, type = "b", pch = 19, cex = 0.7) }
    })

  F$fig5 <- list(w = 9.5, h = 6.2, title = "Fig 5. Tamanho dos segmentos parentais",
    cap = paste("Distribuicao do comprimento dos blocos de ancestralidade contigua nas",
      "linhas F4 (N =", E$n_ref, "). O tamanho do bloco NAO depende de N -- depende",
      "so do numero de meioses. E por isso que ciclos de intercruzamento, e nao mais",
      "plantas, sao o instrumento contra linkage drag."),
    f = function() {
      par(mar = c(4.6, 4.8, 3.2, 1.4))
      bl <- E$blocks
      dens <- lapply(bl, function(v) density(v[v > 0], from = 0, to = 240, bw = 8))
      ymax <- max(vapply(dens, function(d) max(d$y), 0))
      plot(NA, xlim = c(0, 200), ylim = c(0, ymax * 1.05),
           xlab = "Comprimento do bloco parental (cM)", ylab = "Densidade", main = "")
      grid(col = "grey92", lty = 1)
      for (s in names(dens)) lines(dens[[s]], col = SCH_COL[s], lwd = 2.2)
      legend("topright", vapply(names(bl), function(s)
             sprintf("%s  (media %.0f cM)", SCH_LAB[s], mean(bl[[s]])), ""),
             col = SCH_COL[names(bl)], lty = 1, lwd = 2, bty = "n", cex = 0.8)
    })

  F$fig6 <- list(w = 9.5, h = 6.2, title = "Fig 6. Recuperacao de combinacoes multilocus",
    cap = paste("Probabilidade de existir pelo menos UMA linha no painel homozigota para",
      "o alelo de P2 em k loci sorteados (1 por cromossomo). Como na F4 H = 0.125, a",
      "probabilidade por locus e (1-H)/2 = 0.4375 e nao 0.5. Pontos = simulacao (SSD),",
      "tracejado = 1-(1-0.4375^k)^N."),
    f = function() {
      par(mar = c(4.6, 4.8, 3.2, 1.4))
      q <- (1 - H_F4) / 2; ml <- E$ml
      cols <- c("#1b6ca8", "#27ae60", "#e67e22", "#c0392b")
      plot(NA, xlim = c(0, max(opt$n_grid)), ylim = c(0, 1), xaxt = "n",
           xlab = "Numero de plantas F2 (= linhas no painel)",
           ylab = "P( >= 1 linha com o genotipo alvo )", main = "")
      ax(); grid(col = "grey92", lty = 1); abline(h = 0.95, col = "grey45", lty = 3)
      for (j in seq_along(opt$k_multilocus)) { kk <- opt$k_multilocus[j]
        d <- ml[ml$k == kk, ]
        lines(nn, 1 - (1 - q^kk)^nn, col = cols[j], lty = 2, lwd = 1.5)
        lines(d$N, d$P, col = cols[j], lwd = 2, type = "b", pch = 19, cex = 0.7) }
      legend("right", paste0("k = ", opt$k_multilocus, " loci"), col = cols,
             lty = 1, lwd = 2, pch = 19, bty = "n", cex = 0.82,
             title = "tracejado = teorico")
    })

  F$fig7 <- list(w = 11, h = 8.4, multi = TRUE, title = "Fig 7. Genotipo grafico das linhas F4",
    cap = paste("Cada linha horizontal e uma linha F4; azul = ancestralidade P1,",
      "vermelho = P2, branco = heterozigoto residual. Compare o painel 1 (N pequeno) com",
      "o painel 2: o TAMANHO dos blocos e identico; o que muda e a variedade de",
      "combinacoes disponiveis. O painel 3 mostra o efeito de dois ciclos de Syn:",
      "blocos visivelmente mais curtos, mesmo numero de linhas."),
    f = function() {
      keys <- c(paste("ssd", E$n_sml), paste("ssd", E$n_ref), paste("syn2", E$n_ref))
      keys <- keys[keys %in% names(E$example)]
      par(mfrow = c(length(keys), 1), mar = c(2.8, 4.4, 2.4, 1))
      for (kkey in keys) {
        ex <- E$example[[kkey]]; D <- 1 - (ex$H1 + ex$H2) / 2
        sc <- strsplit(kkey, " ")[[1]]
        image(x = seq_len(nrow(D)), y = seq_len(ncol(D)), z = D,
              col = colorRampPalette(c("#c0392b", "#f7f7f7", "#1b6ca8"))(64),
              zlim = c(0, 1), xlab = "", ylab = "linhas F4", axes = FALSE,
              main = sprintf("%s  --  N_F2 = %s", SCH_LAB[sc[1]], sc[2]))
        box(); ch <- which(map$first); abline(v = ch, col = "white", lwd = 1.5)
        axis(1, at = (ch + c(ch[-1], map$m)) / 2, labels = seq_along(map$chr_len), tick = FALSE)
        axis(2, las = 1, cex.axis = 0.7)
      }
    })

  F$fig8 <- list(w = 9.5, h = 6.2, title = "Fig 8. N equivalente do painel",
    cap = paste("Quantas linhas F4 SEM distorcao dariam a mesma diversidade retida",
      "observada: N_eq = (1-H)/(1-D). ATENCAO -- e um artificio de comunicacao, nao um",
      "Ne no sentido de Wright: converte um vies deterministico (distorcao de segregacao)",
      "em um equivalente de deriva. A saturacao da curva mostra o teto imposto pela",
      "distorcao: acima dele, mais plantas F2 nao compram mais diversidade."),
    f = function() {
      par(mar = c(4.6, 4.8, 3.2, 1.4))
      plot(NA, xlim = c(0, max(opt$n_grid)), ylim = c(0, max(res$n_eq) * 1.1), xaxt = "n",
           xlab = "Numero de plantas F2 conduzidas", ylab = "N equivalente do painel", main = "")
      ax(); grid(col = "grey92", lty = 1)
      abline(0, 1, col = "grey40", lty = 2, lwd = 2)
      for (s in schs) { d <- res[res$scheme == s, ]
        lines(d$N, d$n_eq, col = SCH_COL[s], lwd = 2.2, type = "b", pch = 19, cex = 0.7) }
      lg("topleft", "identidade N_eq = N")
    })

  F$fig9 <- list(w = 9.5, h = 6.2, title = "Fig 9. Dimensionamento da F1",
    cap = paste("Premissa P2 diz que com parentais 100% homozigotos todas as F1 sao",
      "identicas e o numero de plantas F1 e questao de logistica. Se os parentais tem",
      "heterozigose residual (F ~ 0.95, comum em linhagem de programa), cada F1 recebe",
      "um gameta ao acaso de cada parental e a chance de perder um alelo em um locus",
      "segregante e 2*(1/2)^n. Com 12 plantas F1 o esperado de locus perdidos ja e < 1."),
    f = function() {
      par(mar = c(4.6, 4.8, 3.2, 1.4))
      f1 <- f1_sizing(1:25, h_res = 0.05, n_loci_eff = 5000)
      plot(f1$n_F1, pmax(f1$locus_perdidos_esp, 1e-3), type = "b", pch = 19, log = "y",
           col = "#1b6ca8", lwd = 2, xlab = "Numero de plantas F1 autofecundadas",
           ylab = "Locus segregantes perdidos (esperado)", main = "")
      grid(col = "grey92", lty = 1)
      abline(h = 1, col = "#c0392b", lty = 2, lwd = 2)
      text(19, 1.8, "1 locus perdido", col = "#c0392b", cex = 0.85)
    })
  F
}

render_figures <- function(E, outdir) {
  figs <- build_figures(E)
  png_ok <- isTRUE(capabilities("png"))
  imgs <- list()
  for (nm in names(figs)) {
    g <- figs[[nm]]
    draw <- function() { g$f(); if (!isTRUE(g$multi)) title(main = g$title, cex.main = 1.15) }
    pdf(file.path(outdir, paste0(nm, ".pdf")), width = g$w, height = g$h)
    draw(); dev.off()
    if (png_ok) {
      fp <- file.path(outdir, paste0(nm, ".png"))
      png(fp, width = round(g$w * 115), height = round(g$h * 115), res = 115)
      draw(); dev.off()
      imgs[[nm]] <- b64_file(fp)
    }
  }
  list(figs = figs, imgs = imgs, png_ok = png_ok)
}

# ----------------------------------------------------------------------------
# 9b. RELATORIO HTML AUTOCONTIDO
# ----------------------------------------------------------------------------

# base64 em R puro (evita dependencia de base64enc / jsonlite)
b64_raw <- function(raw) {
  chars <- c(LETTERS, letters, 0:9, "+", "/")
  n <- length(raw); pad <- (3 - n %% 3) %% 3
  raw <- c(raw, rep(as.raw(0), pad))
  m <- matrix(as.integer(raw), nrow = 3)
  out <- rbind(chars[m[1, ] %/% 4 + 1],
               chars[(m[1, ] %% 4) * 16 + m[2, ] %/% 16 + 1],
               chars[(m[2, ] %% 16) * 4 + m[3, ] %/% 64 + 1],
               chars[m[3, ] %% 64 + 1])
  s <- paste(out, collapse = "")
  if (pad > 0) s <- paste0(substr(s, 1, nchar(s) - pad), strrep("=", pad))
  s
}
b64_file <- function(path) b64_raw(readBin(path, "raw", file.info(path)$size))

json_df <- function(d) {
  f <- function(v) if (is.numeric(v)) paste(signif(v, 6), collapse = ",")
                   else paste0('"', v, '"', collapse = ",")
  paste0("{", paste0('"', names(d), '":[', vapply(d, f, ""), "]", collapse = ","), "}")
}

html_table <- function(d, digits = 4) {
  hd <- paste0("<th>", names(d), "</th>", collapse = "")
  bd <- apply(d, 1, function(r) paste0("<td>", r, "</td>", collapse = ""))
  dd <- as.data.frame(lapply(d, function(v) if (is.numeric(v)) signif(v, digits) else v),
                      stringsAsFactors = FALSE)
  bd <- apply(dd, 1, function(r) paste0("<td>", r, "</td>", collapse = ""))
  paste0("<table><thead><tr>", hd, "</tr></thead><tbody><tr>",
         paste(bd, collapse = "</tr><tr>"), "</tr></tbody></table>")
}

write_html <- function(E, R, outdir, file = "relatorio.html") {
  res <- E$res; opt <- E$opt; map <- E$map
  th <- as.data.frame(t(vapply(opt$schemes, function(s) expected_junctions(s, map), c(0, 0))))
  th$esquema <- SCH_LAB[rownames(th)]
  obs <- tapply(res$junc, res$scheme, mean)[rownames(th)]
  th$junctions_obs <- round(obs, 2)
  th$bloco_obs_cM <- round(map$total_cM / (obs + length(map$chr_len)), 1)
  th <- th[, c("esquema", "junctions", "bloco_medio_cM", "junctions_obs", "bloco_obs_cM")]

  fig_block <- function(nm) {
    g <- R$figs[[nm]]
    src <- if (R$png_ok) paste0("data:image/png;base64,", R$imgs[[nm]]) else paste0(nm, ".pdf")
    paste0('<figure><img src="', src, '" alt="', g$title, '">',
           '<figcaption><b>', g$title, '.</b> ', g$cap, '</figcaption></figure>')
  }

  ssd <- res[res$scheme == "ssd", ]
  knee <- ssd$N[which(ssd$div >= max(ssd$div) - 0.002)[1]]

  html <- paste0('<!DOCTYPE html><html lang="pt-BR"><head><meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>Dimensionamento F1-F4 &mdash; cruzamento amplo de milho</title>
<style>
:root{--ink:#16202b;--mut:#5d6b7a;--line:#dfe5ec;--bg:#fbfcfd;--acc:#1b6ca8}
*{box-sizing:border-box}
body{margin:0;background:var(--bg);color:var(--ink);
 font:16px/1.65 -apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,Helvetica,sans-serif}
.wrap{max-width:980px;margin:0 auto;padding:0 22px 90px}
header{background:linear-gradient(160deg,#12395c,#1b6ca8);color:#fff;padding:52px 22px 40px;margin-bottom:38px}
header .wrap{padding-bottom:0}
h1{font-size:31px;margin:0 0 8px;font-weight:650;letter-spacing:-.02em}
header p{margin:0;opacity:.86;font-size:15px}
h2{font-size:22px;margin:52px 0 14px;padding-bottom:8px;border-bottom:2px solid var(--line)}
h3{font-size:17px;margin:30px 0 8px;color:#22303f}
p{margin:0 0 14px}
figure{margin:26px 0;background:#fff;border:1px solid var(--line);border-radius:9px;padding:14px}
figure img{width:100%;height:auto;display:block;border-radius:4px}
figcaption{font-size:13.5px;color:var(--mut);margin-top:11px;line-height:1.55}
table{border-collapse:collapse;width:100%;font-size:13.5px;margin:16px 0;background:#fff}
th,td{border:1px solid var(--line);padding:6px 9px;text-align:right}
th{background:#eef3f8;font-weight:600;text-align:right}
td:first-child,th:first-child{text-align:left}
tbody tr:nth-child(even){background:#f7fafc}
.card{background:#fff;border:1px solid var(--line);border-left:4px solid var(--acc);
 border-radius:7px;padding:15px 18px;margin:18px 0}
.warn{border-left-color:#c0392b}
.kpis{display:flex;flex-wrap:wrap;gap:13px;margin:22px 0}
.kpi{flex:1 1 168px;background:#fff;border:1px solid var(--line);border-radius:9px;padding:14px 16px}
.kpi .v{font-size:26px;font-weight:660;color:var(--acc);line-height:1.15}
.kpi .l{font-size:12.5px;color:var(--mut);margin-top:3px}
code{background:#eef2f6;padding:1px 5px;border-radius:4px;font-size:13.5px}
.ctl{background:#fff;border:1px solid var(--line);border-radius:9px;padding:15px 18px;margin:18px 0}
.ctl label{font-size:13.5px;margin-right:15px;cursor:pointer;white-space:nowrap;display:inline-block}
select{font:inherit;font-size:14px;padding:4px 7px;border:1px solid var(--line);border-radius:5px}
#chart{width:100%;height:390px}
small.note{color:var(--mut);font-size:12.5px}
</style></head><body>
<header><div class="wrap"><h1>Dimensionamento de popula&ccedil;&atilde;o F1 &rarr; F4</h1>
<p>Cruzamento amplo entre grupos heter&oacute;ticos divergentes de milho &middot; ',
format(Sys.Date(), "%d/%m/%Y"), ' &middot; ', nrow(res), ' cen&aacute;rios &times; ',
min(res$n_rep), '&ndash;', max(res$n_rep), ' repeti&ccedil;&otilde;es (mais onde N &eacute; pequeno)</p></div></header><div class="wrap">

<h2>1. A pergunta</h2>
<p>Quantas plantas em cada gera&ccedil;&atilde;o para representar bem a diversidade criada por um
cruzamento entre dois grupos heter&oacute;ticos distintos, conduzido at&eacute; F4?
A grade simulada vai de <b>', min(opt$n_grid), '</b> a <b>', max(opt$n_grid),
'</b> plantas F2, em passos de ', diff(opt$n_grid)[1], ', com resolu&ccedil;&atilde;o fina na
faixa pequena &mdash; que &eacute; onde as decis&otilde;es realmente doem.</p>

<div class="kpis">
<div class="kpi"><div class="v">', round(subset(ssd, N == min(opt$n_grid))$div, 3),
'</div><div class="l">Diversidade retida, SSD, N = ', min(opt$n_grid), '</div></div>
<div class="kpi"><div class="v">', round(max(ssd$div), 3),
'</div><div class="l">Diversidade retida, SSD, N = ', max(opt$n_grid), '</div></div>
<div class="kpi"><div class="v">', round(max(ssd$n_eq)),
'</div><div class="l">Teto de N equivalente (SSD)</div></div>
<div class="kpi"><div class="v">', knee,
'</div><div class="l">Joelho da curva (2&permil; do m&aacute;ximo)</div></div>
</div>

<h2>2. As premissas, uma a uma</h2>
<p>Nenhum n&uacute;mero abaixo faz sentido fora destas premissas. Elas est&atilde;o todas
document&aacute;veis e parametriz&aacute;veis no cabe&ccedil;alho do script.</p>

<h3>P1 &mdash; O espa&ccedil;o simulado &eacute; ancestralidade, n&atilde;o alelos</h3>
<p>Cada posi&ccedil;&atilde;o do genoma &eacute; 0 (vem de P1) ou 1 (vem de P2). Em um biparental
amplo praticamente todo locus polim&oacute;rfico entre os parentais &eacute; bial&eacute;lico, ent&atilde;o a
ancestralidade &eacute; estat&iacute;stica suficiente. &ldquo;Frequ&ecirc;ncia al&eacute;lica&rdquo;
aqui sempre significa frequ&ecirc;ncia de ancestralidade P1.</p>

<h3>P2 &mdash; Parentais 100% homozigotos</h3>
<p>Consequ&ecirc;ncia direta: <b>todas as plantas F1 s&atilde;o geneticamente id&ecirc;nticas
e Ne(F1) = 1</b>. O dimensionamento da F1 &eacute; log&iacute;stico, n&atilde;o gen&eacute;tico.
A Fig 9 trata o caso realista de heterozigose residual nos parentais.</p>

<h3>P3 &mdash; Mapa gen&eacute;tico</h3>
<p>10 cromossomos, ', map$total_cM, ' cM (~', round(map$total_cM/100, 1),
' Morgans), marcador a cada ', opt$spacing_cM, ' cM. N&atilde;o use comprimentos de mapas
tipo IBM (RILs intermatadas): eles s&atilde;o inflados por constru&ccedil;&atilde;o.</p>

<h3>P4 &mdash; Recombina&ccedil;&atilde;o de Haldane, sem interfer&ecirc;ncia</h3>
<p>Troca de hapl&oacute;tipo entre marcadores adjacentes a <i>d</i> cM com probabilidade
<code>r = 0.5(1 - exp(-2d/100))</code>. O primeiro marcador de cada cromossomo recebe
<code>r = 0.5</code>, o que produz segrega&ccedil;&atilde;o independente entre cromossomos
automaticamente. <b>Limita&ccedil;&atilde;o:</b> sem interfer&ecirc;ncia a vari&acirc;ncia do n&uacute;mero
de crossovers &eacute; Poisson e portanto inflada; em milho h&aacute; interfer&ecirc;ncia positiva
forte. O efeito pr&aacute;tico &eacute; uma cauda um pouco longa demais na distribui&ccedil;&atilde;o de
blocos (Fig 5). As m&eacute;dias n&atilde;o s&atilde;o afetadas.</p>

<h3>P5 &mdash; Distor&ccedil;&atilde;o de segrega&ccedil;&atilde;o</h3>
<p>Dois mecanismos, ambos por <b>amostragem por rejei&ccedil;&atilde;o</b> (exatos, n&atilde;o
aproxima&ccedil;&otilde;es). <i>Gametof&iacute;tica</i> (tipo <i>ga1</i>): atua s&oacute; no gameta
masculino, par&acirc;metro <i>k</i> = probabilidade de transmiss&atilde;o do alelo P1 por um
heterozigoto. <i>Zig&oacute;tica</i>: fitness por gen&oacute;tipo no locus. Como a rejei&ccedil;&atilde;o
atua sobre o gameta <i>inteiro</i>, toda a regi&atilde;o ligada &eacute; arrastada junto &mdash;
que &eacute; exatamente o fen&ocirc;meno real.</p>
<div class="card warn"><b>Os locus default s&atilde;o plaus&iacute;veis, n&atilde;o medidos.</b>
Este &eacute; o par&acirc;metro que mais move os resultados. Substitua
<code>DEFAULT_DISTORTERS</code> pelos seus dados de genotipagem F2 antes de usar
qualquer n&uacute;mero deste relat&oacute;rio para decidir &aacute;rea.</div>

<h3>P6 &mdash; Esquemas de condu&ccedil;&atilde;o</h3>
<p><b>SSD</b>: uma semente por planta por gera&ccedil;&atilde;o, refer&ecirc;ncia neutra.
<b>SSD + atrito</b>: perda aleat&oacute;ria de ', round(opt$attrition*100),
'% das plantas por gera&ccedil;&atilde;o (vigor, esterilidade parcial, assincronia de
florescimento). <b>Bulk</b>: contribui&ccedil;&atilde;o diferencial de sementes, modelo
Wright-Fisher com peso <code>w = exp(&beta;(z - z&#772;))</code> onde <i>z</i> &eacute; a
propor&ccedil;&atilde;o do genoma vinda do parental adaptado &mdash; modelo fenomenol&oacute;gico de
sele&ccedil;&atilde;o natural poligenica, com &beta; = ', opt$beta_bulk, '.
<b>Syn-1 / Syn-2</b>: 1 ou 2 ciclos de intercruzamento aleat&oacute;rio antes de
autofecundar duas vezes. Todos os esquemas terminam com H = 0.125, logo s&atilde;o
diretamente compar&aacute;veis.</p>

<h3>P7 &mdash; O painel F4 n&atilde;o &eacute; um painel de RILs</h3>
<p>A heterozigose residual esperada &eacute; H = 0.125, e isso muda as f&oacute;rmulas:</p>
<table><thead><tr><th>Quantidade</th><th>F&oacute;rmula geral</th><th>Valor na F4</th></tr></thead>
<tbody>
<tr><td>Var(dosagem por linha)</td><td>(1 &minus; H)/4</td><td>0,21875</td></tr>
<tr><td>EP(p&#770;)</td><td>0,5&middot;&radic;((1&minus;H)/N)</td><td><b>0,468/&radic;N</b></td></tr>
<tr><td>Diversidade retida D</td><td>1 &minus; (1&minus;H)/N</td><td>1 &minus; 0,875/N</td></tr>
<tr><td>P(homozigoto P2 por locus)</td><td>(1 &minus; H)/2</td><td>0,4375</td></tr>
<tr><td>Junctions por hapl&oacute;tipo</td><td>A&#8322;=L; A&#8341;&#8330;&#8321;=A&#8341;+L&middot;H&#8341;</td><td>1,75&middot;L</td></tr>
</tbody></table>
<p>O valor 0,5/&radic;N que se costuma citar vale s&oacute; em F&infin;. Todas essas
identidades s&atilde;o verificadas na bateria <code>--test</code>.</p>

<h3>P8 &mdash; Como o erro-padr&atilde;o &eacute; estimado</h3>
<p>EP(p&#770;) &eacute; calculado <b>entre repeti&ccedil;&otilde;es independentes</b> da
simula&ccedil;&atilde;o, marcador a marcador. Marcadores ligados s&atilde;o fortemente
autocorrelacionados, ent&atilde;o o desvio entre marcadores dentro de uma repeti&ccedil;&atilde;o
n&atilde;o &eacute; um estimador do erro amostral.</p>

<h3>P9 &mdash; O que o script n&atilde;o modela</h3>
<p>Sele&ccedil;&atilde;o artificial deliberada, arquitetura de QTL, depress&atilde;o por endogamia
fenot&iacute;pica, muta&ccedil;&atilde;o, e varia&ccedil;&atilde;o estrutural entre os grupos heter&oacute;ticos.
Se voc&ecirc; sabe que existe uma invers&atilde;o grande entre seus parentais, zere a taxa de
recombina&ccedil;&atilde;o naquele intervalo em <code>build_map()</code>.</p>

<div class="card"><b>Vi&eacute;s conhecido da grade.</b> Com marcador a cada ',
opt$spacing_cM, ' cM, crossovers duplos dentro de um intervalo n&atilde;o s&atilde;o contados.
O vi&eacute;s &eacute; de <b>&minus;2%</b> no n&uacute;mero de junctions e sempre para baixo
(teste T9, anal&iacute;tico). Use <code>spacing_cM = 1</code> se precisar de contagem de
blocos mais fiel.</div>

<h2>3. Explorador de resultados</h2>
<p>Selecione a m&eacute;trica e ligue/desligue esquemas. Os dados s&atilde;o os mesmos do CSV.</p>
<div class="ctl">
<div style="margin-bottom:11px"><b>M&eacute;trica:</b>
<select id="metric">
<option value="div">Diversidade retida (D)</option>
<option value="se_p">EP da frequ&ecirc;ncia</option>
<option value="n_eq">N equivalente do painel</option>
<option value="skew">Fra&ccedil;&atilde;o do genoma desbalanceada</option>
<option value="pmin">Frequ&ecirc;ncia minorit&aacute;ria m&iacute;nima</option>
<option value="junc">Junctions por hapl&oacute;tipo</option>
</select></div>
<div id="toggles"></div></div>
<svg id="chart"></svg>
<p><small class="note">Passe o cursor sobre os pontos para ler os valores.</small></p>

<h2>4. Figuras</h2>',
paste0(vapply(names(R$figs), fig_block, ""), collapse = "\n"), '

<h2>5. Estrutura de blocos: teoria e observado</h2>
<p>Recurs&atilde;o da teoria de junctions: <code>A&#8322; = L</code> e
<code>A&#8341;&#8330;&#8321; = A&#8341; + L&middot;H&#8341;</code>. Uma consequ&ecirc;ncia contra-intuitiva:
<b>cada ciclo de Syn adiciona apenas 0,5&middot;L junctions, n&atilde;o 1,0&middot;L</b>, porque a
meiose extra s&oacute; cria junction onde o parental &eacute; heterozigoto (H = 0,5 no est&aacute;gio
F2/Syn). Verificado no teste T10.</p>',
html_table(th, 4), '
<p><small class="note">A pequena diferen&ccedil;a entre teoria e observado &eacute; o vi&eacute;s de
grade de &minus;2% descrito acima.</small></p>

<h2>6. Tabela completa</h2>',
html_table(res, 4), '

<h2>7. Leitura e recomenda&ccedil;&atilde;o</h2>
<p>Tr&ecirc;s coisas que a simula&ccedil;&atilde;o mostra e a &aacute;lgebra sozinha n&atilde;o mostrava:</p>
<div class="card"><b>1. A curva de diversidade satura.</b> O SSD n&atilde;o converge para
D = 1; ele encosta em ', round(max(ssd$div), 3), ' e para. A dist&acirc;ncia at&eacute; a curva
te&oacute;rica &eacute; distor&ccedil;&atilde;o de segrega&ccedil;&atilde;o, que &eacute; um vi&eacute;s determin&iacute;stico
e n&atilde;o encolhe com mais plantas. Na Fig 3 os picos t&ecirc;m a mesma altura com N = ',
E$n_sml, ' e com N = ', max(opt$n_grid), '.</div>
<div class="card"><b>2. O bulk &eacute; o pior esquema em toda a faixa.</b> Com um parental
menos adaptado, a sele&ccedil;&atilde;o natural no bulk elimina justamente o germoplasma que
voc&ecirc; quer introduzir. Essa separa&ccedil;&atilde;o entre curvas &eacute; maior que qualquer efeito
de N na faixa testada.</div>
<div class="card"><b>3. O tamanho do bloco n&atilde;o depende de N.</b> Depende s&oacute; do
n&uacute;mero de meioses. Contra linkage drag o instrumento &eacute; ciclo de
intercruzamento, n&atilde;o &aacute;rea.</div>

<h3>N&uacute;meros de trabalho</h3>
<table><thead><tr><th>Gera&ccedil;&atilde;o</th><th>Plantas</th><th>Racional</th></tr></thead><tbody>
<tr><td>F1</td><td>8&ndash;15 autofecundadas</td><td>Ne = 1, decis&atilde;o log&iacute;stica.
Com heterozigose residual de 5% nos parentais, 12 plantas j&aacute; deixam o esperado de
locus perdidos abaixo de 1 (Fig 9)</td></tr>
<tr><td><b>F2</b></td><td><b>', knee, '&ndash;', max(opt$n_grid), '</b></td>
<td>Joelho da curva de diversidade. Abaixo de 100 a perda &eacute; vis&iacute;vel em todas as
m&eacute;tricas; acima do joelho o ganho &eacute; marginal</td></tr>
<tr><td>F3</td><td>mesmo N (SSD)</td><td>N&atilde;o cria diversidade, s&oacute; evita perd&ecirc;-la</td></tr>
<tr><td>F4</td><td>linhas &times; 3&ndash;8 plantas</td><td>Multiplica&ccedil;&atilde;o de semente.
M&uacute;ltiplas plantas da mesma linha n&atilde;o s&atilde;o r&eacute;plicas independentes:
compartilham 87,5% do genoma</td></tr>
</tbody></table>

<p><small class="note">Gerado por <code>maize_wide_cross_sim.R</code>. Reproduza com
<code>Rscript maize_wide_cross_sim.R --out=', basename(outdir), '</code> e valide com
<code>--test</code> (16 verifica&ccedil;&otilde;es num&eacute;ricas).</small></p>
</div>
<script>
const DATA = ', json_df(res), ';
const COL = {ssd:"#1b6ca8",ssd_attr:"#7fb3d5",bulk:"#c0392b",syn1:"#27ae60",syn2:"#145a32"};
const LAB = {ssd:"SSD (neutro)",ssd_attr:"SSD + atrito",bulk:"Bulk",syn1:"Syn-1 + SSD",syn2:"Syn-2 + SSD"};
const MLAB = {div:"Diversidade retida D",se_p:"EP da frequencia",n_eq:"N equivalente",
 skew:"Fracao |p-0.5|>0.15",pmin:"min(p,1-p) no genoma",junc:"Junctions por haplotipo"};
const schemes=[...new Set(DATA.scheme)];
const on={}; schemes.forEach(s=>on[s]=true);
const tg=document.getElementById("toggles");
schemes.forEach(s=>{const l=document.createElement("label");
 l.innerHTML=`<input type="checkbox" checked data-s="${s}"> <span style="color:${COL[s]};font-weight:600">&#9632;</span> ${LAB[s]}`;
 l.querySelector("input").addEventListener("change",e=>{on[s]=e.target.checked;draw();});
 tg.appendChild(l);});
document.getElementById("metric").addEventListener("change",draw);
const NS="http://www.w3.org/2000/svg";
function el(t,a){const e=document.createElementNS(NS,t);for(const k in a)e.setAttribute(k,a[k]);return e;}
function draw(){
 const m=document.getElementById("metric").value, svg=document.getElementById("chart");
 while(svg.firstChild)svg.removeChild(svg.firstChild);
 const W=svg.clientWidth||900,H=390,P={t:18,r:16,b:46,l:66};
 svg.setAttribute("viewBox",`0 0 ${W} ${H}`);
 const rows=DATA.scheme.map((s,i)=>({s,N:DATA.N[i],v:DATA[m][i]})).filter(d=>on[d.s]);
 if(!rows.length)return;
 const xs=rows.map(d=>d.N),ys=rows.map(d=>d.v);
 const x0=0,x1=Math.max(...xs),y0=Math.min(...ys),y1=Math.max(...ys);
 const pad=(y1-y0)*0.09||0.01, ylo=y0-pad, yhi=y1+pad;
 const X=v=>P.l+(v-x0)/(x1-x0)*(W-P.l-P.r), Y=v=>H-P.b-(v-ylo)/(yhi-ylo)*(H-P.t-P.b);
 for(let i=0;i<=5;i++){const v=ylo+(yhi-ylo)*i/5;
  svg.appendChild(el("line",{x1:P.l,x2:W-P.r,y1:Y(v),y2:Y(v),stroke:"#e6ecf2"}));
  const t=el("text",{x:P.l-9,y:Y(v)+4,"text-anchor":"end","font-size":11,fill:"#5d6b7a"});
  t.textContent=(Math.abs(v)>=100?v.toFixed(0):v.toFixed(3));svg.appendChild(t);}
 const step=x1>200?80:40;
 for(let v=0;v<=x1;v+=step){svg.appendChild(el("line",{x1:X(v),x2:X(v),y1:P.t,y2:H-P.b,stroke:"#f0f4f8"}));
  const t=el("text",{x:X(v),y:H-P.b+19,"text-anchor":"middle","font-size":11,fill:"#5d6b7a"});
  t.textContent=v;svg.appendChild(t);}
 const xl=el("text",{x:(P.l+W-P.r)/2,y:H-9,"text-anchor":"middle","font-size":12.5,fill:"#16202b"});
 xl.textContent="Numero de plantas F2";svg.appendChild(xl);
 const yl=el("text",{x:15,y:H/2,"text-anchor":"middle","font-size":12.5,fill:"#16202b",
  transform:`rotate(-90 15 ${H/2})`});yl.textContent=MLAB[m];svg.appendChild(yl);
 schemes.filter(s=>on[s]).forEach(s=>{
  const d=rows.filter(r=>r.s===s).sort((a,b)=>a.N-b.N);
  svg.appendChild(el("path",{d:d.map((p,i)=>(i?"L":"M")+X(p.N)+" "+Y(p.v)).join(" "),
   fill:"none",stroke:COL[s],"stroke-width":2.1}));
  d.forEach(p=>{const c=el("circle",{cx:X(p.N),cy:Y(p.v),r:3.4,fill:COL[s]});
   const ti=el("title");ti.textContent=`${LAB[s]} | N=${p.N} | ${MLAB[m]}=${(+p.v).toPrecision(4)}`;
   c.appendChild(ti);svg.appendChild(c);});});
}
draw();window.addEventListener("resize",draw);
</script></body></html>')
  writeLines(html, file.path(outdir, file), useBytes = TRUE)
  invisible(file.path(outdir, file))
}

# ----------------------------------------------------------------------------
# 10. BATERIA DE TESTES (--test)
# ----------------------------------------------------------------------------

.ok <- function(name, obs, exp, tol, extra = "") {
  pass <- abs(obs - exp) <= tol
  cat(sprintf("  [%s] %-48s obs=%9.5f  esp=%9.5f  tol=%.4f %s\n",
              if (pass) "OK " else "FAIL", name, obs, exp, tol, extra))
  pass
}

run_tests <- function() {
  cat("\n=== BATERIA DE TESTES ===\n")
  set.seed(11)
  pass <- logical(0)

  # T0: col_cumsum contra apply()
  M <- matrix(rbinom(60, 1, .5), 12, 5)
  pass <- c(pass, .ok("T0 col_cumsum == apply(cumsum)",
                      max(abs(col_cumsum(M) - apply(M, 2, cumsum))), 0, 1e-12))

  # mapa pequeno para testes rapidos
  tmap <- build_map(c(100), spacing_cM = 1)
  dnull <- make_distortion(tmap, NULL, FALSE)

  # T1: Haldane -- fracao de recombinacao entre marcadores a 20 cM
  F1 <- make_F1(tmap, 20000)
  G  <- meiosis(F1$H1, F1$H2, tmap$r)
  i1 <- marker_index(tmap, 1, 40); i2 <- marker_index(tmap, 1, 60)
  robs <- mean(G[i1, ] != G[i2, ]); rexp <- 0.5 * (1 - exp(-2 * 20 / 100))
  pass <- c(pass, .ok("T1 recombinacao Haldane a 20 cM", robs, rexp, 0.008))

  # T2: frequencias genotipicas na F2
  F2 <- cross_indices(F1, 1:20000, 1:20000, tmap, dnull)
  g  <- F2$H1[i1, ] + F2$H2[i1, ]
  pass <- c(pass, .ok("T2 F2: freq. homozigoto P1", mean(g == 0), 0.25, 0.010))
  pass <- c(pass, .ok("T2 F2: freq. heterozigoto",  mean(g == 1), 0.50, 0.012))

  # T3: heterozigose cai pela metade a cada autofecundacao
  F3 <- cross_indices(F2, 1:20000, 1:20000, tmap, dnull)
  F4 <- cross_indices(F3, 1:20000, 1:20000, tmap, dnull)
  pass <- c(pass, .ok("T3 H(F2)", panel_het(F2), 0.500, 0.008))
  pass <- c(pass, .ok("T3 H(F3)", panel_het(F3), 0.250, 0.008))
  pass <- c(pass, .ok("T3 H(F4)", panel_het(F4), 0.125, 0.006))

  # T4/T5: diversidade retida e EP em painel F4 neutro
  map2 <- build_map(DEFAULT_CHR_LEN, 5)
  H4 <- 0.125; N <- 150; R <- 30
  P <- matrix(NA_real_, map2$m, R); dv <- numeric(R)
  for (r in 1:R) {
    pp <- run_scheme("ssd", N, map2, dnull, DEFAULT_OPT)
    P[, r] <- panel_freq(pp); dv[r] <- diversity_retained(P[, r])
  }
  pass <- c(pass, .ok("T4 D(F4) == 1-(1-H)/N", mean(dv), 1 - (1 - H4) / N, 0.0015))
  pass <- c(pass, .ok("T5 EP(p) == 0.5*sqrt((1-H)/N)", mean(apply(P, 1, sd)),
                      0.5 * sqrt((1 - H4) / N), 0.0035))

  # T6: expansao de mapa. Teoria (junction theory, Fisher/Stam):
  #   A_2 = L ; A_{t+1} = A_t + L * H_t  ->  A_2:A_3:A_4 = 1 : 1.5 : 1.75
  # Exige grade fina: com marcador a 2 cM ha subcontagem de ~1% dos crossovers
  # e a razao lida cai para ~1.70 (ver T9).
  map1 <- build_map(DEFAULT_CHR_LEN[1:3], 1)
  L1 <- sum(DEFAULT_CHR_LEN[1:3]) / 100
  q2 <- cross_indices(make_F1(map1, 1000), 1:1000, 1:1000, map1, dnull)
  q3 <- cross_indices(q2, 1:1000, 1:1000, map1, dnull)
  q4 <- cross_indices(q3, 1:1000, 1:1000, map1, dnull)
  j2 <- junctions_per_hap(q2, map1, 1000)
  j3 <- junctions_per_hap(q3, map1, 1000)
  j4 <- junctions_per_hap(q4, map1, 1000)
  # a expectativa exata na grade discreta e sum(r) sobre intervalos internos,
  # e nao L: r = 0.5(1-exp(-2d/100)) < d/100 subconta crossovers duplos.
  j2_exp <- sum(map1$r[!map1$first])
  pass <- c(pass, .ok("T6a junctions na F2 == sum(r) da grade", j2, j2_exp, 0.15))
  pass <- c(pass, .ok("T6b expansao F3/F2 == 1.50", j3 / j2, 1.50, 0.05))
  pass <- c(pass, .ok("T6c expansao F4/F2 == 1.75", j4 / j2, 1.75, 0.06,
                      sprintf("(junc/hap F2=%.2f F4=%.2f)", j2, j4)))
  pF4 <- q4

  # T7: distorcao gametofitica -- recursao exata de frequencias
  k <- 0.80
  spec <- data.frame(chr = 1, pos_cM = 50, type = "gametic", k = k,
                     w00 = NA, w01 = NA, w11 = NA, label = "t", stringsAsFactors = FALSE)
  tm <- build_map(c(100), 5); dg <- make_distortion(tm, spec, TRUE)
  idx <- marker_index(tm, 1, 50)
  # recursao: het -> 00 com prob 0.5k, 11 com 0.5(1-k), 01 com 0.5
  f <- c(0, 1, 0)   # (00, 01, 11) na F1
  for (gg in 1:3) f <- c(f[1] + f[2] * 0.5 * k, f[2] * 0.5, f[3] + f[2] * 0.5 * (1 - k))
  p_exp <- f[1] + f[2] / 2
  pop <- make_F1(tm, 12000)
  for (gg in 1:3) pop <- cross_indices(pop, 1:12000, 1:12000, tm, dg)
  p_obs <- mean((pop$H1[idx, ] == 0) + (pop$H2[idx, ] == 0)) / 2
  pass <- c(pass, .ok("T7 distorcao gametofitica (p na F4)", p_obs, p_exp, 0.012))

  # T8: os blocos particionam exatamente o mapa (5 linhas x 2 haplotipos)
  bl <- block_lengths(pF4, map1, 5)
  pass <- c(pass, .ok("T8 blocos particionam o mapa",
                      sum(bl) / (5 * 2), map1$total_cM, 1e-6))

  # T9: vies de discretizacao da grade default (analitico, sem simulacao).
  # Crossovers duplos dentro de um intervalo nao sao contados; o vies e
  # pequeno e SEMPRE para baixo no numero de junctions.
  mapc <- build_map(DEFAULT_CHR_LEN, DEFAULT_OPT$spacing_cM)
  bias <- 1 - sum(mapc$r[!mapc$first]) / (mapc$total_cM / 100)
  pass <- c(pass, .ok("T9 vies analitico da grade default < 2%", bias, 0, 0.02,
                      sprintf("(grade %g cM)", DEFAULT_OPT$spacing_cM)))

  # T0b: base64 em R puro contra vetores de referencia (RFC 4648)
  b64ok <- all(c(b64_raw(charToRaw("Man")) == "TWFu",
                 b64_raw(charToRaw("Ma"))  == "TWE=",
                 b64_raw(charToRaw("M"))   == "TQ==",
                 b64_raw(charToRaw("light work.")) == "bGlnaHQgd29yay4="))
  pass <- c(pass, .ok("T0b base64 puro-R (RFC 4648)", as.numeric(b64ok), 1, 0))

  # T10: recursao de junctions com intercruzamento (Syn-1 -> 2.25 L)
  mapS <- build_map(DEFAULT_CHR_LEN[1:3], 1)
  ps <- cross_indices(make_F1(mapS, 800), 1:800, 1:800, mapS, dnull)   # F2
  mo <- sample.int(800); fa <- sample.int(800)
  fa[mo == fa] <- (fa[mo == fa] %% 800) + 1L
  ps <- cross_indices(ps, mo, fa, mapS, dnull)                          # Syn-1
  ps <- cross_indices(ps, 1:800, 1:800, mapS, dnull)
  ps <- cross_indices(ps, 1:800, 1:800, mapS, dnull)
  LS <- mapS$total_cM / 100
  pass <- c(pass, .ok("T10 junctions Syn-1 == 2.25 L", junctions_per_hap(ps, mapS, 800) / LS,
                      2.25, 0.10))

  cat(sprintf("\n  %d/%d testes aprovados\n\n", sum(pass), length(pass)))
  invisible(all(pass))
}

# ----------------------------------------------------------------------------
# 11. MAIN
# ----------------------------------------------------------------------------

main <- function() {
  args   <- commandArgs(trailingOnly = TRUE)
  outdir <- sub("^--out=", "", grep("^--out=", args, value = TRUE))
  if (length(outdir) == 0) outdir <- "sim_out"
  dir.create(outdir, showWarnings = FALSE, recursive = TRUE)

  if ("--test" %in% args) { ok <- run_tests(); quit(status = if (isTRUE(ok)) 0 else 1) }

  opt <- DEFAULT_OPT
  if ("--quick" %in% args) { opt$n_rep <- 3; opt$n_grid <- seq(20, 400, by = 60) }

  cat("=== Simulacao cruzamento amplo de milho F1->F4 ===\n")
  cat(sprintf("Mapa: %d cromossomos, %.0f cM totais, marcador a cada %g cM\n",
              length(DEFAULT_CHR_LEN), sum(DEFAULT_CHR_LEN), opt$spacing_cM))
  cat(sprintf("Grid: N_F2 = %d..%d passo %d (%d pontos) x %d esquemas\n",
              min(opt$n_grid), max(opt$n_grid), diff(opt$n_grid)[1],
              length(opt$n_grid), length(opt$schemes)))
  cat(sprintf("Repeticoes: %d em N=%d ate %d em N=%d (total %d execucoes)\n\n",
              reps_for_N(max(opt$n_grid), opt), max(opt$n_grid),
              reps_for_N(min(opt$n_grid), opt), min(opt$n_grid),
              length(opt$schemes) * sum(reps_for_N(opt$n_grid, opt))))

  t0 <- Sys.time()
  E  <- run_experiment(opt)
  cat(sprintf("\nTempo: %.1f s\n", as.numeric(difftime(Sys.time(), t0, units = "secs"))))

  write.csv(E$res, file.path(outdir, "resultados.csv"), row.names = FALSE)
  write.csv(E$ml,  file.path(outdir, "recuperacao_multilocus.csv"), row.names = FALSE)
  R <- render_figures(E, outdir)
  hf <- write_html(E, R, outdir)

  cat("\n--- TABELA RESUMO ---\n")
  print(format(E$res, digits = 4), row.names = FALSE)
  cat("\n--- EXPECTATIVA TEORICA DE ESTRUTURA DE BLOCOS ---\n")
  th <- t(sapply(opt$schemes, function(s) expected_junctions(s, E$map)))
  obs <- tapply(E$res$junc, E$res$scheme, mean)[rownames(th)]
  print(round(cbind(th, junctions_obs = obs,
                    bloco_obs_cM = E$map$total_cM / (obs + length(E$map$chr_len))), 2))

  cat(sprintf("\nArquivos gravados em: %s\n", normalizePath(outdir)))
  cat(sprintf("Relatorio HTML autocontido: %s\n", normalizePath(hf)))
  invisible(E)
}

if (sys.nframe() == 0L && !interactive()) main()

